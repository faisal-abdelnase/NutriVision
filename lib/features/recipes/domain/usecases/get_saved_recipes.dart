
import '../entities/recipe.dart';
import '../repositories/recipes_repository.dart';

abstract class GetSavedRecipes {
  final RecipesRepository repository;

  GetSavedRecipes(this.repository);

  Future<List<Recipe>> call({
    required String userId,
    required int page,
    required int pageSize,
  });
}