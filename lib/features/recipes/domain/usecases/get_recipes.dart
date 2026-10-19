
import '../entities/recipe.dart';
import '../repositories/recipes_repository.dart';

class GetRecipes {
  GetRecipes(this.repository);

  final RecipesRepository repository;

  Future<List<Recipe>> call({
    required int page,
    required int pageSize,
    String? searchQuery,
    List<String>? tags,
    String? dietaryCategory,
  }) {
    return repository.getRecipes(
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      tags: tags,
      dietaryCategory: dietaryCategory,
    );
  }
}
