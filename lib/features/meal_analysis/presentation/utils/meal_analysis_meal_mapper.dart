import 'package:nutri_vision/features/meal_analysis/domain/entities/meal_analysis_result.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/utils/meal_analysis_summary.dart';
import 'package:nutri_vision/features/meal_tracking/domain/entities/meal.dart';
import 'package:nutri_vision/features/meal_tracking/domain/entities/meal_ingredient.dart';

/// Builds a meal_tracking [Meal] from an analysis so "Confirm & Log" can use
/// the existing `MealCubit.addMeal`. Empty id => the data source generates it.
class MealAnalysisMealMapper {
  MealAnalysisMealMapper._();

  static Meal toMeal(MealAnalysisResult result) {
    final summary = MealAnalysisSummary.fromResult(result);
    return Meal(
      id: '',
      userId: result.userId,
      name: summary.title ?? 'Analyzed meal',
      description: result.analysisSummary ?? result.sourceDescription,
      mealType: summary.mealType,
      ingredients: [
        for (final item in result.foodItems)
          MealIngredient(
            name: item.name,
            quantity: item.estimatedQuantity,
            unit: item.quantityUnit,
            foodId: item.foodDatabaseId,
          ),
      ],
      calories: result.totalCalories,
      proteinGrams: result.totalProteinGrams,
      carbohydrateGrams: result.totalCarbohydrateGrams,
      fatGrams: result.totalFatGrams,
      eatenAt: result.analyzedAt,
      createdAt: DateTime.now(),
    );
  }
}
