import 'recipe_ingredient.dart';

class Recipe {
  final String id;
  final String? createdByUserId;

  final String title;
  final String description;
  final String? imageUrl;

  final List<RecipeIngredient> ingredients;
  final List<String> instructions;
  final List<String> tags;

  final int preparationMinutes;
  final int cookingMinutes;
  final int servings;

  final double caloriesPerServing;
  final double proteinGramsPerServing;
  final double carbohydrateGramsPerServing;
  final double fatGramsPerServing;

  final String? dietaryCategory;
  final bool isAiGenerated;
  final bool isSaved;

  final DateTime createdAt;
  final DateTime? updatedAt;

  const Recipe({
    required this.id,
    this.createdByUserId,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.ingredients,
    required this.instructions,
    this.tags = const [],
    required this.preparationMinutes,
    required this.cookingMinutes,
    required this.servings,
    required this.caloriesPerServing,
    required this.proteinGramsPerServing,
    required this.carbohydrateGramsPerServing,
    required this.fatGramsPerServing,
    this.dietaryCategory,
    this.isAiGenerated = false,
    this.isSaved = false,
    required this.createdAt,
    this.updatedAt,
  });
}
