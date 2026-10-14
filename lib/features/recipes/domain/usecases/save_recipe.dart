

import '../repositories/recipes_repository.dart';

abstract class SaveRecipe {
  final RecipesRepository repository;

  SaveRecipe(this.repository);

  Future<void> call({
    required String userId,
    required String recipeId,
  });
}