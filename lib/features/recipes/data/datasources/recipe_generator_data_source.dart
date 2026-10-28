import 'package:dio/dio.dart';

import '../models/recipe_model.dart';

abstract interface class RecipeGeneratorDataSource {
  Future<RecipeModel> generate({
    required String userId,
    required List<String> availableIngredients,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required String? goal,
    required int servings,
  });
}

class RecipeGeneratorDataSourceImpl implements RecipeGeneratorDataSource {
  RecipeGeneratorDataSourceImpl({
    required Dio dio,
    this.endpoint = '/recipes/generate',
  }) : _dio = dio;

  final Dio _dio;
  final String endpoint;

  @override
  Future<RecipeModel> generate({
    required String userId,
    required List<String> availableIngredients,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required String? goal,
    required int servings,
  }) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError('userId cannot be empty.');
    }

    if (servings < 1) {
      throw ArgumentError('servings must be at least 1.');
    }

    if (availableIngredients.isEmpty) {
      throw ArgumentError('At least one available ingredient is required.');
    }

    final response = await _dio.post<Map<String, dynamic>>(
      endpoint,
      data: {
        'userId': userId,
        'availableIngredients': availableIngredients,
        'dietaryPreferences': dietaryPreferences,
        'allergies': allergies,
        'goal': goal,
        'servings': servings,
      },
    );

    final responseData = response.data;
    if (responseData == null) {
      throw const FormatException('AI response is empty.');
    }

    // Supports either:
    // { "recipe": { ... } }
    // or { ...recipe fields... }
    final rawRecipe = responseData['recipe'] ?? responseData;

    if (rawRecipe is! Map) {
      throw const FormatException(
        'AI response does not contain a valid recipe object.',
      );
    }

    final recipeJson = Map<String, dynamic>.from(rawRecipe);

    // Accept either ISO-8601 dates or Firestore-compatible dates.
    // AI responses normally should return ISO-8601 dates.
    recipeJson.putIfAbsent(
      'id',
      () => 'ai-${DateTime.now().microsecondsSinceEpoch}',
    );
    recipeJson['createdByUserId'] ??= userId;
    recipeJson['isAiGenerated'] = true;
    recipeJson['isSaved'] = false;
    recipeJson.putIfAbsent('createdAt', () => DateTime.now().toIso8601String());
    recipeJson.putIfAbsent('updatedAt', () => null);

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
}
