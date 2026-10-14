

import '../entities/nutrition_profile.dart';
import '../repositories/nutrition_profile_repository.dart';

abstract class GetNutritionProfile {
  final NutritionProfileRepository repository;

  GetNutritionProfile(this.repository);

  Future<NutritionProfile?> call({
    required String userId,
  });
}