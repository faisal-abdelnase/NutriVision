class NutritionTrendPoint {
  final DateTime date;

  final double calories;
  final double proteinGrams;
  final double carbohydrateGrams;
  final double fatGrams;

  final double? calorieTarget;
  final double? proteinTargetGrams;
  final double? carbohydrateTargetGrams;
  final double? fatTargetGrams;
  final int mealCount;

  const NutritionTrendPoint({
    required this.date,
    required this.calories,
    required this.proteinGrams,
    required this.carbohydrateGrams,
    required this.fatGrams,
    this.calorieTarget,
    this.proteinTargetGrams,
    this.carbohydrateTargetGrams,
    this.fatTargetGrams,
    this.mealCount = 0,
  });
}
