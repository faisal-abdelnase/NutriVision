import 'package:nutri_vision/features/meal_analysis/domain/entities/analyzed_food_item.dart';
import 'package:nutri_vision/features/meal_analysis/domain/entities/meal_analysis_result.dart';

import '../../domain/entities/recipe.dart';

class RecipeMealAnalysisMapper {
  const RecipeMealAnalysisMapper._();

  static MealAnalysisResult map(Recipe recipe, String userId) {
    final servings = recipe.servings < 1 ? 1 : recipe.servings;
    return MealAnalysisResult(
      id: recipe.id,
      userId: userId,
      sourceDescription: recipe.title,
      foodItems: recipe.ingredients
          .map(
            (ingredient) => AnalyzedFoodItem(
              name: ingredient.name,
              estimatedQuantity: ingredient.quantity / servings,
              quantityUnit: ingredient.unit,
              calories: 0,
              proteinGrams: 0,
              carbohydrateGrams: 0,
              fatGrams: 0,
            ),
          )
          .toList(),
      totalCalories: recipe.caloriesPerServing,
      totalProteinGrams: recipe.proteinGramsPerServing,
      totalCarbohydrateGrams: recipe.carbohydrateGramsPerServing,
      totalFatGrams: recipe.fatGramsPerServing,
      analysisSummary: recipe.description,
      nutritionInsights: recipe.nutritionInsights,
      warnings: recipe.warnings,
      analyzedAt: DateTime.now(),
      recipeDifficulty: recipe.difficulty,
      recipePreparationMinutes: recipe.preparationMinutes,
      recipeCookingMinutes: recipe.cookingMinutes,
      recipeServings: recipe.servings,
      recipeInstructions: recipe.instructions,
      recipeSubstitutions: recipe.substitutions,
      totalFiberGrams: recipe.fiberGramsPerServing,
      isGeneratedRecipe: true,
    );
  }
}
