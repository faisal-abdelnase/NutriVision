
import '../repositories/recipes_repository.dart';

class SaveRecipe {
  SaveRecipe(this.repository);

  final RecipesRepository repository;

  Future<void> call({
    required String userId,
    required String recipeId,
  }) {
    return repository.saveRecipe(
      userId: userId,
      recipeId: recipeId,
    );
  }
}
