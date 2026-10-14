

import '../entities/recipe.dart';
import '../repositories/recipes_repository.dart';

abstract class GetRecipes {
  final RecipesRepository repository;

  GetRecipes(this.repository);

  Future<List<Recipe>> call({
    required int page,
    required int pageSize,
    String? searchQuery,
    List<String>? tags,
    String? dietaryCategory,
  });
}