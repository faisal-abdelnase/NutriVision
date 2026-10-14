class DailyNutritionSummary {
  final DateTime date;

  final double consumedCalories;
  final double calorieTarget;

  final double consumedProteinGrams;
  final double consumedCarbohydrateGrams;
  final double consumedFatGrams;

  final int mealCount;

  const DailyNutritionSummary({
    required this.date,
    required this.consumedCalories,
    required this.calorieTarget,
    required this.consumedProteinGrams,
    required this.consumedCarbohydrateGrams,
    required this.consumedFatGrams,
    required this.mealCount,
  });
}