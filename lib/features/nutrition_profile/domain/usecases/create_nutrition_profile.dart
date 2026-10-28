import '../entities/nutrition_profile.dart';
import '../repositories/nutrition_profile_repository.dart';

class CreateNutritionProfile {
  final NutritionProfileRepository repository;

  CreateNutritionProfile(this.repository);

  Future<NutritionProfile> call({required NutritionProfile profile}) {
    return repository.createNutritionProfile(profile: profile);
  }
}
