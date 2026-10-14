class NutritionProfile {
  final String userId;

  final int? age;
  final double? heightCm;
  final double? weightKg;

  final String? goal;

  final double? dailyCalorieTarget;
  final double? proteinTargetGrams;
  final double? carbohydrateTargetGrams;
  final double? fatTargetGrams;

  final List<String> dietaryPreferences;
  final List<String> allergies;

  final DateTime? updatedAt;

  const NutritionProfile({
    required this.userId,
    this.age,
    this.heightCm,
    this.weightKg,
    this.goal,
    this.dailyCalorieTarget,
    this.proteinTargetGrams,
    this.carbohydrateTargetGrams,
    this.fatTargetGrams,
    this.dietaryPreferences = const [],
    this.allergies = const [],
    this.updatedAt,
  });
}