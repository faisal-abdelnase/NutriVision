import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/recipe_model.dart';

abstract interface class RecipeGeneratorDataSource {
  Future<RecipeModel> generate({
    required String userId,
    required List<String> availableIngredients,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required String? goal,
    required int servings,
    String languageCode = 'en',
  });
}

class RecipeGeneratorDataSourceImpl implements RecipeGeneratorDataSource {
  RecipeGeneratorDataSourceImpl({
    required GenerativeModel model,
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _model = model,
       _firestore = firestore,
       _auth = auth;

  final GenerativeModel _model;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<RecipeModel> generate({
    required String userId,
    required List<String> availableIngredients,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required String? goal,
    required int servings,
    String languageCode = 'en',
  }) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError('userId cannot be empty.');
    }

    if (servings < 1) {
      throw ArgumentError('servings must be at least 1.');
    }

    if (_auth.currentUser?.uid != userId) {
      throw StateError('The authenticated user could not be verified.');
    }

    // Profile document is the existing source of nutrition targets and
    // dietary safeguards: nutrition_profiles/{uid}.
    final profileSnapshot = await _firestore
        .collection('nutrition_profiles')
        .doc(userId)
        .get();
    final profile = profileSnapshot.data() ?? <String, dynamic>{};
    final profileAllergies = _stringList(profile['allergies']);
    final profileDiets = _stringList(profile['dietaryPreferences']);
    final allAllergies = {...profileAllergies, ...allergies}.toList();
    final allDiets = {...profileDiets, ...dietaryPreferences}.toList();
    final language = languageCode == 'ar' ? 'Arabic' : 'English';
    final prompt =
        '''Create one practical, personalized recipe and return ONLY valid JSON.
Respond in $language. Nutrition values must be estimates per serving. Use user ingredients where practical.
Never include declared allergens or restricted ingredients. If the requested ingredients conflict with these safety rules, return {"error":"safety_conflict","message":"..."} and do not provide a recipe.
User request: ${availableIngredients.isEmpty ? 'Suggest a balanced meal' : availableIngredients.join(', ')}
Dietary preferences: ${allDiets.isEmpty ? 'none specified' : allDiets.join(', ')}
Allergies (must exclude): ${allAllergies.isEmpty ? 'none specified' : allAllergies.join(', ')}
Goal: ${goal ?? 'no goal specified'}
Servings: $servings
Nutrition profile (only provided values are known): ${jsonEncode({
          for (final key in ['goal', 'dailyCalorieTarget', 'proteinTargetGrams', 'carbohydrateTargetGrams', 'fatTargetGrams', 'dietaryPreferences', 'allergies'])
            if (profile[key] != null) key: profile[key],
        })}
Return keys: title, description, ingredients (array of {name,quantity,unit}), instructions (string array), preparationMinutes, cookingMinutes, servings, difficulty, nutrition ({calories,protein,carbs,fat,fiber}), insights (string array), warnings (string array), substitutions (string array). Calories and macros are per serving. Use numeric quantities and nutrition values. Do not include markdown.''';
    final response = await _model.generateContent([Content.text(prompt)]);
    final text = response.text?.trim();
    if (text == null || text.isEmpty) {
      throw const FormatException('AI response is empty.');
    }
    final jsonText = text
        .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
        .replaceFirst(RegExp(r'\s*```$'), '');
    final decoded = jsonDecode(jsonText);
    if (decoded is! Map) {
      throw const FormatException('AI response is not a JSON object.');
    }
    final raw = Map<String, dynamic>.from(decoded);
    if (raw['error'] == 'safety_conflict') {
      throw StateError(
        raw['message']?.toString() ??
            'Recipe conflicts with dietary safety rules.',
      );
    }
    final nutrition = raw['nutrition'];
    if (nutrition is! Map) {
      throw const FormatException('Recipe nutrition is missing.');
    }
    for (final key in ['calories', 'protein', 'carbs', 'fat']) {
      if (nutrition[key] is! num) {
        throw FormatException('Recipe nutrition is missing numeric $key.');
      }
    }
    final recipeIngredients = raw['ingredients'];
    if (recipeIngredients is! List || recipeIngredients.isEmpty) {
      throw const FormatException('Recipe ingredients are missing.');
    }
    for (final item in recipeIngredients) {
      if (item is Map &&
          _matchesAllergy(item['name']?.toString() ?? '', allAllergies)) {
        throw StateError(
          'The generated recipe conflicts with a declared allergy. Please retry.',
        );
      }
    }
    final ingredients = recipeIngredients.map((item) {
      if (item is! Map)
        throw const FormatException('Invalid recipe ingredient.');
      return {
        'id': 'ingredient-${recipeIngredients.indexOf(item)}',
        'name': item['name'],
        'quantity': item['quantity'],
        'unit': item['unit'],
      };
    }).toList();
    final recipeJson = <String, dynamic>{
      'id': 'ai-${DateTime.now().microsecondsSinceEpoch}',
      'createdByUserId': userId,
      'title': raw['title'],
      'description': raw['description'],
      'ingredients': ingredients,
      'instructions': raw['instructions'],
      'tags': raw['insights'] ?? const [],
      'preparationMinutes': raw['preparationMinutes'],
      'cookingMinutes': raw['cookingMinutes'],
      'servings': raw['servings'] ?? servings,
      'caloriesPerServing': nutrition['calories'],
      'proteinGramsPerServing': nutrition['protein'],
      'carbohydrateGramsPerServing': nutrition['carbs'],
      'fatGramsPerServing': nutrition['fat'],
      'difficulty': raw['difficulty'],
      'fiberGramsPerServing': nutrition['fiber'],
      'nutritionInsights': raw['insights'] ?? const [],
      'warnings': raw['warnings'] ?? const [],
      'substitutions': raw['substitutions'] ?? const [],
      'isAiGenerated': true,
      'isSaved': false,
      'createdAt': DateTime.now().toIso8601String(),
    };

    final recipe = RecipeModel.fromJson(recipeJson);

    if (recipe.title.trim().isEmpty ||
        recipe.ingredients.isEmpty ||
        recipe.instructions.isEmpty) {
      throw const FormatException(
        'Generated recipe is missing required information.',
      );
    }

    return recipe;
  }

  static List<String> _stringList(dynamic value) =>
      value is List ? value.map((item) => item.toString()).toList() : const [];

  static bool _matchesAllergy(String ingredient, List<String> allergies) {
    final name = ingredient.toLowerCase();
    return allergies.any((allergy) {
      final term = allergy.toLowerCase().trim();
      if (term.isEmpty) return false;
      final aliases = switch (term) {
        'peanuts' || 'peanut' => ['peanut', 'groundnut', 'فول سوداني'],
        'tree nuts' || 'tree_nuts' => [
          'almond',
          'walnut',
          'cashew',
          'pistachio',
          'hazelnut',
          'pecan',
          'مكسرات',
          'لوز',
          'جوز',
          'كاجو',
        ],
        'dairy' || 'milk' => [
          'milk',
          'cheese',
          'butter',
          'cream',
          'whey',
          'yogurt',
          'حليب',
          'جبن',
          'زبدة',
          'لبن',
        ],
        'eggs' || 'egg' => ['egg', 'albumin', 'بيض'],
        'gluten' || 'wheat' => [
          'wheat',
          'bread',
          'flour',
          'barley',
          'rye',
          'قمح',
          'خبز',
          'شعير',
        ],
        'soy' => ['soy', 'tofu', 'edamame', 'صويا', 'توفو'],
        'sesame' => ['sesame', 'tahini', 'سمسم', 'طحينة'],
        'seafood' || 'fish' => [
          'fish',
          'salmon',
          'shrimp',
          'shellfish',
          'tuna',
          'سمك',
          'جمبري',
        ],
        _ => [term],
      };
      return aliases.any((alias) => name.contains(alias)) ||
          name.contains(term);
    });
  }
}
