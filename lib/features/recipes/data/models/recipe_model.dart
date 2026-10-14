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
    super.dietaryCategory,
    super.isAiGenerated,
    super.isSaved,
    required super.createdAt,
    super.updatedAt,
  }) : super(ingredients: ingredients);
}

abstract class RecipeModelMapper {
  RecipeModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    RecipeModel model,
  );

  

  List<RecipeIngredientModel> ingredientsToModels(
    List<RecipeIngredient> ingredients,
  );
}