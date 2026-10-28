import '../repositories/recipes_repository.dart';

class RemoveSavedRecipe {
  RemoveSavedRecipe(this.repository);

  final RecipesRepository repository;

  Future<void> call({required String userId, required String recipeId}) {
    return repository.removeSavedRecipe(userId: userId, recipeId: recipeId);
  }
}
