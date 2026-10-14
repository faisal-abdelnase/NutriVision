

import '../entities/recipe.dart';
import '../repositories/recipes_repository.dart';

abstract class GetRecipeById {
  final RecipesRepository repository;

  GetRecipeById(this.repository);

  Future<Recipe?> call({
    required String recipeId,
  });
}