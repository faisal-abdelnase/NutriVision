

import '../entities/nutrition_profile.dart';
import '../repositories/nutrition_profile_repository.dart';

abstract class UpdateDietaryPreferences {
  final NutritionProfileRepository repository;

  UpdateDietaryPreferences(this.repository);

  Future<NutritionProfile> call({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
  });
}