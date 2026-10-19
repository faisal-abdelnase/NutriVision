
import '../../domain/entities/recipe.dart';

abstract class RecipesState {
  const RecipesState();
}

class RecipesInitial extends RecipesState {
  const RecipesInitial();
}

class RecipesLoading extends RecipesState {
  const RecipesLoading();
}

class RecipesLoaded extends RecipesState {
  const RecipesLoaded(this.recipes);

  final List<Recipe> recipes;
}

class RecipeDetailsLoaded extends RecipesState {
  const RecipeDetailsLoaded(this.recipe);

  final Recipe recipe;
}

class SavedRecipesLoaded extends RecipesState {
  const SavedRecipesLoaded(this.recipes);

  final List<Recipe> recipes;
}

class RecipeGenerated extends RecipesState {
  const RecipeGenerated(this.recipe);

  final Recipe recipe;
}

class RecipesOperationSuccess extends RecipesState {
  const RecipesOperationSuccess(this.message);

  final String message;
}

class RecipesError extends RecipesState {
  const RecipesError(this.message);

  final String message;
}
