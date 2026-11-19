import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_ingredient.dart';
import 'recipe_ingredient_model.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    super.createdByUserId,
    required super.title,
    required super.description,
    super.imageUrl,
    required List<RecipeIngredientModel> ingredients,
    required super.instructions,
    super.tags,
    required super.preparationMinutes,
    required super.cookingMinutes,
    required super.servings,
    required super.caloriesPerServing,
    required super.proteinGramsPerServing,
    required super.carbohydrateGramsPerServing,
    required super.fatGramsPerServing,
    super.difficulty,
    super.fiberGramsPerServing,
    super.nutritionInsights,
    super.warnings,
    super.substitutions,
    super.dietaryCategory,
    super.isAiGenerated,
    super.isSaved,
    required super.createdAt,
    super.updatedAt,
  }) : super(ingredients: ingredients);

  static DateTime _dateFromJson(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }
    throw FormatException('Invalid date value: $value');
  }

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final rawIngredients = json['ingredients'] as List<dynamic>? ?? [];

    return RecipeModel(
      id: json['id'] as String,
      createdByUserId: json['createdByUserId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      ingredients: rawIngredients.map((item) {
        return RecipeIngredientModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList(),
      instructions: List<String>.from(json['instructions'] as List? ?? []),
      tags: List<String>.from(json['tags'] as List? ?? []),
      preparationMinutes: (json['preparationMinutes'] as num).toInt(),
      cookingMinutes: (json['cookingMinutes'] as num).toInt(),
      servings: (json['servings'] as num).toInt(),
      caloriesPerServing: (json['caloriesPerServing'] as num).toDouble(),
      proteinGramsPerServing: (json['proteinGramsPerServing'] as num)
          .toDouble(),
      carbohydrateGramsPerServing: (json['carbohydrateGramsPerServing'] as num)
          .toDouble(),
      fatGramsPerServing: (json['fatGramsPerServing'] as num).toDouble(),
      difficulty: json['difficulty'] as String?,
      fiberGramsPerServing: (json['fiberGramsPerServing'] as num?)?.toDouble(),
      nutritionInsights: List<String>.from(
        json['nutritionInsights'] ?? const [],
      ),
      warnings: List<String>.from(json['warnings'] ?? const []),
      substitutions: List<String>.from(json['substitutions'] ?? const []),
      dietaryCategory: json['dietaryCategory'] as String?,
      isAiGenerated: json['isAiGenerated'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
      createdAt: _dateFromJson(json['createdAt']),
      updatedAt: json['updatedAt'] == null
          ? null
          : _dateFromJson(json['updatedAt']),
    );
  }

  factory RecipeModel.fromEntity(Recipe recipe) {
    return RecipeModel(
      id: recipe.id,
      createdByUserId: recipe.createdByUserId,
      title: recipe.title,
      description: recipe.description,
      imageUrl: recipe.imageUrl,
      ingredients: recipe.ingredients.map((ingredient) {
        return RecipeIngredientModel(
          id: ingredient.id,
          name: ingredient.name,
          quantity: ingredient.quantity,
          unit: ingredient.unit,
          isOptional: ingredient.isOptional,
          foodDatabaseId: ingredient.foodDatabaseId,
        );
      }).toList(),
      instructions: recipe.instructions,
      tags: recipe.tags,
      preparationMinutes: recipe.preparationMinutes,
      cookingMinutes: recipe.cookingMinutes,
      servings: recipe.servings,
      caloriesPerServing: recipe.caloriesPerServing,
      proteinGramsPerServing: recipe.proteinGramsPerServing,
      carbohydrateGramsPerServing: recipe.carbohydrateGramsPerServing,
      fatGramsPerServing: recipe.fatGramsPerServing,
      difficulty: recipe.difficulty,
      fiberGramsPerServing: recipe.fiberGramsPerServing,
      nutritionInsights: recipe.nutritionInsights,
      warnings: recipe.warnings,
      substitutions: recipe.substitutions,
      dietaryCategory: recipe.dietaryCategory,
      isAiGenerated: recipe.isAiGenerated,
      isSaved: recipe.isSaved,
      createdAt: recipe.createdAt,
      updatedAt: recipe.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdByUserId': createdByUserId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'ingredients': ingredients.map((ingredient) {
        return (ingredient as RecipeIngredientModel).toJson();
      }).toList(),
      'instructions': instructions,
      'tags': tags,
      'preparationMinutes': preparationMinutes,
      'cookingMinutes': cookingMinutes,
      'servings': servings,
      'caloriesPerServing': caloriesPerServing,
      'proteinGramsPerServing': proteinGramsPerServing,
      'carbohydrateGramsPerServing': carbohydrateGramsPerServing,
      'fatGramsPerServing': fatGramsPerServing,
      'difficulty': difficulty,
      'fiberGramsPerServing': fiberGramsPerServing,
      'nutritionInsights': nutritionInsights,
      'warnings': warnings,
      'substitutions': substitutions,
      'dietaryCategory': dietaryCategory,
      'isAiGenerated': isAiGenerated,
      'isSaved': isSaved,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    };
  }

  List<RecipeIngredientModel> ingredientsToModels(
    List<RecipeIngredient> ingredients,
  ) {
    return ingredients.map((ingredient) {
      if (ingredient is RecipeIngredientModel) return ingredient;

      return RecipeIngredientModel(
        id: ingredient.id,
        name: ingredient.name,
        quantity: ingredient.quantity,
        unit: ingredient.unit,
        isOptional: ingredient.isOptional,
        foodDatabaseId: ingredient.foodDatabaseId,
      );
    }).toList();
  }
}
