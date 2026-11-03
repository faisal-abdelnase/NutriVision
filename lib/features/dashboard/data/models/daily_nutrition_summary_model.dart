import '../../domain/entities/daily_nutrition_summary.dart';

class DailyNutritionSummaryModel extends DailyNutritionSummary {
  const DailyNutritionSummaryModel({
    required super.date,
    required super.consumedCalories,
    required super.calorieTarget,
    super.proteinTargetGrams,
    super.carbohydrateTargetGrams,
    super.fatTargetGrams,
    required super.consumedProteinGrams,
    required super.consumedCarbohydrateGrams,
    required super.consumedFatGrams,
    required super.mealCount,
  });
}
