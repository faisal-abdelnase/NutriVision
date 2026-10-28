import '../entities/recipe.dart';
import '../repositories/recipes_repository.dart';

class GeneratePersonalizedRecipe {
  GeneratePersonalizedRecipe(this.repository);

  final RecipesRepository repository;

  Future<Recipe> call({
    required String userId,
    required List<String> availableIngredients,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required String? goal,
    required int servings,
  }) {
    return repository.generatePersonalizedRecipe(
      userId: userId,
      availableIngredients: availableIngredients,
      dietaryPreferences: dietaryPreferences,
      allergies: allergies,
      goal: goal,
      servings: servings,
    );
  }
}
