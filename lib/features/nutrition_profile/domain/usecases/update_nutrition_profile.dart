import '../entities/nutrition_profile.dart';
import '../repositories/nutrition_profile_repository.dart';

class UpdateNutritionProfile {
  final NutritionProfileRepository repository;

  UpdateNutritionProfile(this.repository);

  Future<NutritionProfile> call({required NutritionProfile profile}) {
    return repository.updateNutritionProfile(profile: profile);
  }
}
