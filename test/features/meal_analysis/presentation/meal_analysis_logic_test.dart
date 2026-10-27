import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_vision/features/meal_analysis/domain/entities/analyzed_food_item.dart';
import 'package:nutri_vision/features/meal_analysis/domain/entities/meal_analysis_result.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/utils/meal_analysis_insights.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/utils/meal_analysis_meal_mapper.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/utils/meal_analysis_summary.dart';

void main() {
  final analyzedAt = DateTime(2026, 10, 27, 12, 30);
  final result = MealAnalysisResult(
    id: 'analysis-123',
    userId: 'user-456',
    sourceDescription: 'Chicken and rice',
    foodItems: const [
      AnalyzedFoodItem(
        name: 'Chicken',
        estimatedQuantity: 100,
        quantityUnit: 'g',
        calories: 165,
        proteinGrams: 31,
        carbohydrateGrams: 0,
        fatGrams: 3.6,
        confidenceScore: 0.9,
      ),
      AnalyzedFoodItem(
        name: 'Rice',
        estimatedQuantity: 150,
        quantityUnit: 'g',
        calories: 195,
        proteinGrams: 4,
        carbohydrateGrams: 42,
        fatGrams: 0.4,
      ),
    ],
    totalCalories: 400,
    totalProteinGrams: 20,
    totalCarbohydrateGrams: 40,
    totalFatGrams: 10,
    confidenceScore: 0.84,
    analyzedAt: analyzedAt,
  );

  test('summary derives totals and confidence from the analysis result', () {
    final summary = MealAnalysisSummary.fromResult(result);

    expect(summary.title, 'Chicken and rice');
    expect(summary.shortId, 'ANALYS');
    expect(summary.confidencePercent, 84);
    expect(summary.totalWeightGrams, 250);
    expect(summary.proteinEnergyPercent, 20);
    expect(summary.carbEnergyPercent, 40);
    expect(summary.fatEnergyPercent, 23);
  });

  test('insights do not invent content when the backend returned none', () {
    expect(buildMealInsights(result), isEmpty);

    final withBackendInsights = MealAnalysisResult(
      id: result.id,
      userId: result.userId,
      sourceDescription: result.sourceDescription,
      foodItems: result.foodItems,
      totalCalories: result.totalCalories,
      totalProteinGrams: result.totalProteinGrams,
      totalCarbohydrateGrams: result.totalCarbohydrateGrams,
      totalFatGrams: result.totalFatGrams,
      nutritionInsights: const ['Protein source detected.'],
      warnings: const ['Check the serving size.'],
      analyzedAt: result.analyzedAt,
    );

    final insights = buildMealInsights(withBackendInsights);
    expect(insights.map((insight) => insight.text), [
      'Protein source detected.',
      'Check the serving size.',
    ]);
    expect(insights.map((insight) => insight.isWarning), [false, true]);
  });

  test('meal mapper preserves analyzed food and nutrient values', () {
    final meal = MealAnalysisMealMapper.toMeal(result);

    expect(meal.userId, result.userId);
    expect(meal.name, result.sourceDescription);
    expect(meal.mealType, 'lunch');
    expect(meal.calories, result.totalCalories);
    expect(meal.ingredients, hasLength(2));
    expect(meal.ingredients.first.name, 'Chicken');
    expect(meal.ingredients.first.quantity, 100);
    expect(meal.ingredients.first.foodId, isNull);
  });
}
