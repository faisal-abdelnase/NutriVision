
import '../entities/nutrition_profile.dart';
import '../repositories/nutrition_profile_repository.dart';

abstract class UpdateNutritionProfile {
  final NutritionProfileRepository repository;

  UpdateNutritionProfile(this.repository);

  Future< NutritionProfile> call({
    required NutritionProfile profile,
  });
}