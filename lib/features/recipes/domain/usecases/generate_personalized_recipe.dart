
import '../entities/recipe.dart';
import '../repositories/recipes_repository.dart';

abstract class GeneratePersonalizedRecipe {
  final RecipesRepository repository;

  GeneratePersonalizedRecipe(this.repository);

  Future<Recipe> call({
    required String userId,
    required List<String> availableIngredients,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required String? goal,
    required int servings,
  });
}