import '../entities/recipe.dart';
import '../entities/grocery_list.dart';
import '../entities/grocery_item.dart';

abstract class RecipesRepository {
  Future<List<Recipe>> getRecipes({
    required int page,
    required int pageSize,
    String? searchQuery,
    List<String>? tags,
    String? dietaryCategory,
  });

  Future<Recipe?> getRecipeById({required String recipeId});

  Future<Recipe> generatePersonalizedRecipe({
    required String userId,
    required List<String> availableIngredients,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required String? goal,
    required int servings,
  });

  Future<void> saveRecipe({required String userId, required String recipeId});

  Future<void> removeSavedRecipe({
    required String userId,
    required String recipeId,
  });

  Future<List<Recipe>> getSavedRecipes({
    required String userId,
    required int page,
    required int pageSize,
  });

  Future<GroceryList> getGroceryList({required String userId});

  Future<GroceryItem> addGroceryItem({required GroceryItem item});

  Future<GroceryItem> updateGroceryItem({required GroceryItem item});

  Future<void> removeGroceryItem({
    required String userId,
    required String itemId,
  });

  Future<void> clearGroceryList({required String userId});
}
