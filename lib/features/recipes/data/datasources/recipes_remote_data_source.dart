import '../models/recipe_model.dart';

abstract class RecipesRemoteDataSource {
  Future<List<RecipeModel>> fetchRecipes({
    required int page,
    required int pageSize,
    String? searchQuery,
    List<String>? tags,
    String? dietaryCategory,
  });

  Future<RecipeModel?> fetchRecipeById({
    required String recipeId,
  });

  Future<RecipeModel> generatePersonalizedRecipe({
    required String userId,
    required List<String> availableIngredients,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required String? goal,
    required int servings,
  });

  Future<void> saveRecipe({
    required String userId,
    required String recipeId,
  });

  Future<void> removeSavedRecipe({
    required String userId,
    required String recipeId,
  });

  Future<List<RecipeModel>> fetchSavedRecipes({
    required String userId,
    required int page,
    required int pageSize,
  });
}