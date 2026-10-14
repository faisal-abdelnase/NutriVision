

import '../entities/nutrition_profile.dart';
import '../repositories/nutrition_profile_repository.dart';

abstract class UpdateNutritionGoals {
  final NutritionProfileRepository repository;

  UpdateNutritionGoals(this.repository);

  Future<NutritionProfile> call({
    required String userId,
    required double dailyCalorieTarget,
    required double proteinTargetGrams,
    required double carbohydrateTargetGrams,
    required double fatTargetGrams,
  });
}