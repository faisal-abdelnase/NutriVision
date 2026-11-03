class DailyNutritionSummary {
  final DateTime date;

  final double consumedCalories;
  final double calorieTarget;
  final double proteinTargetGrams;
  final double carbohydrateTargetGrams;
  final double fatTargetGrams;

  final double consumedProteinGrams;
  final double consumedCarbohydrateGrams;
  final double consumedFatGrams;

  final int mealCount;

  const DailyNutritionSummary({
    required this.date,
    required this.consumedCalories,
    required this.calorieTarget,
    this.proteinTargetGrams = 0,
    this.carbohydrateTargetGrams = 0,
    this.fatTargetGrams = 0,
    required this.consumedProteinGrams,
    required this.consumedCarbohydrateGrams,
    required this.consumedFatGrams,
    required this.mealCount,
  });
}
