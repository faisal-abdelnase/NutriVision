import '../../domain/entities/nutrition_profile.dart';

class NutritionProfileModel extends NutritionProfile {
  const NutritionProfileModel({
    required super.userId,
    super.age,
    super.heightCm,
    super.weightKg,
    super.goal,
    super.dailyCalorieTarget,
    super.proteinTargetGrams,
    super.carbohydrateTargetGrams,
    super.fatTargetGrams,
    super.dietaryPreferences,
    super.allergies,
    super.updatedAt,
  });
}

abstract class NutritionProfileModelMapper {
  NutritionProfileModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    NutritionProfileModel model,
  );

  
}