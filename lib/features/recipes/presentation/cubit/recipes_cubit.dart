import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/recipes_repository.dart';
import 'recipes_state.dart';

class RecipesCubit extends Cubit<RecipesState> {
  RecipesCubit(this._repository) : super(const RecipesInitial());

  final RecipesRepository _repository;

  Future<void> fetchRecipes({
    int page = 1,
    int pageSize = 20,
    String? searchQuery,
    List<String>? tags,
    String? dietaryCategory,
  }) async {
    emit(const RecipesLoading());

    try {
      final recipes = await _repository.getRecipes(
        page: page,
        pageSize: pageSize,
        searchQuery: searchQuery,
        tags: tags,
        dietaryCategory: dietaryCategory,
      );

      emit(RecipesLoaded(recipes));
    } catch (error) {
      emit(RecipesError('Failed to load recipes: $error'));
    }
  }

  Future<void> fetchRecipeById({required String recipeId}) async {
    emit(const RecipesLoading());

    try {
      final recipe = await _repository.getRecipeById(recipeId: recipeId);

      if (recipe == null) {
        emit(const RecipesError('Recipe not found.'));
        return;
      }

      emit(RecipeDetailsLoaded(recipe));
    } catch (error) {
      emit(RecipesError('Failed to load recipe: $error'));
    }
  }

  Future<void> generateRecipe({
    required String userId,
    required List<String> availableIngredients,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required String? goal,
    required int servings,
  }) async {
    if (servings < 1) {
      emit(const RecipesError('Servings must be at least 1.'));
      return;
    }

    emit(const RecipesLoading());

    try {
      final recipe = await _repository.generatePersonalizedRecipe(
        userId: userId,
        availableIngredients: availableIngredients,
        dietaryPreferences: dietaryPreferences,
        allergies: allergies,
        goal: goal,
        servings: servings,
      );

      emit(RecipeGenerated(recipe));
    } catch (error) {
      emit(RecipesError('Failed to generate recipe: $error'));
    }
  }

  Future<void> fetchSavedRecipes({
    required String userId,
    int page = 1,
    int pageSize = 20,
  }) async {
    emit(const RecipesLoading());

    try {
      final recipes = await _repository.getSavedRecipes(
        userId: userId,
        page: page,
        pageSize: pageSize,
      );

      emit(SavedRecipesLoaded(recipes));
    } catch (error) {
      emit(RecipesError('Failed to load saved recipes: $error'));
    }
  }

  Future<void> saveRecipe({
    required String userId,
    required String recipeId,
  }) async {
    try {
      await _repository.saveRecipe(userId: userId, recipeId: recipeId);

      emit(const RecipesOperationSuccess('Recipe saved successfully.'));
    } catch (error) {
      emit(RecipesError('Failed to save recipe: $error'));
    }
  }

  Future<void> removeSavedRecipe({
    required String userId,
    required String recipeId,
  }) async {
    try {
      await _repository.removeSavedRecipe(userId: userId, recipeId: recipeId);

      emit(const RecipesOperationSuccess('Saved recipe removed.'));
    } catch (error) {
      emit(RecipesError('Failed to remove saved recipe: $error'));
    }
  }
}
