import '../entities/recipe.dart';
import '../repositories/recipes_repository.dart';

class GetSavedRecipes {
  GetSavedRecipes(this.repository);

  final RecipesRepository repository;

  Future<List<Recipe>> call({
    required String userId,
    required int page,
    required int pageSize,
  }) {
    return repository.getSavedRecipes(
      userId: userId,
      page: page,
      pageSize: pageSize,
    );
  }
}
