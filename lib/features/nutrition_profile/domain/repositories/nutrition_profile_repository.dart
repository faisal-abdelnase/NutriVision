

import '../entities/nutrition_profile.dart';

abstract class NutritionProfileRepository {
  Future<NutritionProfile?> getNutritionProfile({
    required String userId,
  });

  Future<NutritionProfile> createNutritionProfile({
    required NutritionProfile profile,
  });

  Future<NutritionProfile> updateNutritionProfile({
    required NutritionProfile profile,
  });

  Future<NutritionProfile> updateNutritionGoals({
    required String userId,
    required double dailyCalorieTarget,
    required double proteinTargetGrams,
    required double carbohydrateTargetGrams,
    required double fatTargetGrams,
  });

  Future<NutritionProfile> updateDietaryPreferences({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
  });
}