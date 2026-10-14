

import '../../domain/entities/recipe.dart';
import '../../domain/entities/grocery_list.dart';
import '../../domain/entities/grocery_item.dart';
import '../../domain/repositories/recipes_repository.dart';

import '../datasources/recipes_remote_data_source.dart';
import '../datasources/grocery_list_local_data_source.dart';

abstract class RecipesRepositoryImpl implements RecipesRepository {
  final RecipesRemoteDataSource remoteDataSource;
  final GroceryListLocalDataSource groceryListLocalDataSource;

  RecipesRepositoryImpl({
    required this.remoteDataSource,
    required this.groceryListLocalDataSource,
  });

  @override
  Future<List<Recipe>> getRecipes({
    required int page,
    required int pageSize,
    String? searchQuery,
    List<String>? tags,
    String? dietaryCategory,
  });

  @override
  Future<Recipe?> getRecipeById({
    required String recipeId,
  });

  @override
  Future<Recipe> generatePersonalizedRecipe({
    required String userId,
    required List<String> availableIngredients,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required String? goal,
    required int servings,
  });

  @override
  Future<void> saveRecipe({
    required String userId,
    required String recipeId,
  });

  @override
  Future<void> removeSavedRecipe({
    required String userId,
    required String recipeId,
  });

  @override
  Future<List<Recipe>> getSavedRecipes({
    required String userId,
    required int page,
    required int pageSize,
  });

  @override
  Future<GroceryList> getGroceryList({
    required String userId,
  });

  @override
  Future<GroceryItem> addGroceryItem({
    required GroceryItem item,
  });

  @override
  Future<GroceryItem> updateGroceryItem({
    required GroceryItem item,
  });

  @override
  Future<void> removeGroceryItem({
    required String userId,
    required String itemId,
  });

  @override
  Future<void> clearGroceryList({
    required String userId,
  });
}