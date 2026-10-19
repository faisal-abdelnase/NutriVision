
import '../../domain/entities/grocery_item.dart';
import '../../domain/entities/grocery_list.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipes_repository.dart';

import '../datasources/grocery_list_local_data_source.dart';
import '../datasources/recipes_remote_data_source.dart';
import '../models/grocery_item_model.dart';
import '../models/grocery_list_model.dart';

class RecipesRepositoryImpl implements RecipesRepository {
  RecipesRepositoryImpl({
    required this.remoteDataSource,
    required this.groceryListLocalDataSource,
  });

  final RecipesRemoteDataSource remoteDataSource;
  final GroceryListLocalDataSource groceryListLocalDataSource;

  @override
  Future<List<Recipe>> getRecipes({
    required int page,
    required int pageSize,
    String? searchQuery,
    List<String>? tags,
    String? dietaryCategory,
  }) {
    return remoteDataSource.fetchRecipes(
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      tags: tags,
      dietaryCategory: dietaryCategory,
    );
  }

  @override
  Future<Recipe?> getRecipeById({
    required String recipeId,
  }) {
    return remoteDataSource.fetchRecipeById(
      recipeId: recipeId,
    );
  }

  @override
  Future<Recipe> generatePersonalizedRecipe({
    required String userId,
    required List<String> availableIngredients,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required String? goal,
    required int servings,
  }) {
    return remoteDataSource.generatePersonalizedRecipe(
      userId: userId,
      availableIngredients: availableIngredients,
      dietaryPreferences: dietaryPreferences,
      allergies: allergies,
      goal: goal,
      servings: servings,
    );
  }

  @override
  Future<void> saveRecipe({
    required String userId,
    required String recipeId,
  }) {
    return remoteDataSource.saveRecipe(
      userId: userId,
      recipeId: recipeId,
    );
  }

  @override
  Future<void> removeSavedRecipe({
    required String userId,
    required String recipeId,
  }) {
    return remoteDataSource.removeSavedRecipe(
      userId: userId,
      recipeId: recipeId,
    );
  }

  @override
  Future<List<Recipe>> getSavedRecipes({
    required String userId,
    required int page,
    required int pageSize,
  }) {
    return remoteDataSource.fetchSavedRecipes(
      userId: userId,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<GroceryList> getGroceryList({
    required String userId,
  }) async {
    final list = await groceryListLocalDataSource.readGroceryList(
      userId: userId,
    );

    return list ??
        GroceryListModel(
          userId: userId,
          items: const [],
          updatedAt: DateTime.now(),
        );
  }

  @override
  Future<GroceryItem> addGroceryItem({
    required GroceryItem item,
  }) {
    return groceryListLocalDataSource.addGroceryItem(
      item: _toItemModel(item),
    );
  }

  @override
  Future<GroceryItem> updateGroceryItem({
    required GroceryItem item,
  }) {
    return groceryListLocalDataSource.updateGroceryItem(
      item: _toItemModel(item),
    );
  }

  @override
  Future<void> removeGroceryItem({
    required String userId,
    required String itemId,
  }) {
    return groceryListLocalDataSource.removeGroceryItem(
      userId: userId,
      itemId: itemId,
    );
  }

  @override
  Future<void> clearGroceryList({
    required String userId,
  }) {
    return groceryListLocalDataSource.clearGroceryList(
      userId: userId,
    );
  }

  GroceryItemModel _toItemModel(GroceryItem item) {
    if (item is GroceryItemModel) return item;

    return GroceryItemModel(
      id: item.id,
      userId: item.userId,
      name: item.name,
      quantity: item.quantity,
      unit: item.unit,
      isChecked: item.isChecked,
      recipeId: item.recipeId,
      recipeTitle: item.recipeTitle,
      category: item.category,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }
}
