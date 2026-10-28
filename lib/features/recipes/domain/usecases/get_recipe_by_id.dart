import '../entities/recipe.dart';
import '../repositories/recipes_repository.dart';

class GetRecipeById {
  GetRecipeById(this.repository);

  final RecipesRepository repository;

  Future<Recipe?> call({required String recipeId}) {
    return repository.getRecipeById(recipeId: recipeId);
  }
}
