
import '../repositories/recipes_repository.dart';

abstract class RemoveSavedRecipe {
  final RecipesRepository repository;

  RemoveSavedRecipe(this.repository);

  Future<void> call({
    required String userId,
    required String recipeId,
  });
}