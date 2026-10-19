
import '../../domain/entities/nutrition_profile.dart';
import '../../domain/repositories/nutrition_profile_repository.dart';
import '../datasources/nutrition_profile_remote_data_source.dart';
import '../models/nutrition_profile_model.dart';

class NutritionProfileRepositoryImpl
    implements NutritionProfileRepository {
  final NutritionProfileRemoteDataSource remoteDataSource;

  NutritionProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<NutritionProfile?> getNutritionProfile({
    required String userId,
  }) {
    return remoteDataSource.fetchNutritionProfile(
      userId: userId,
    );
  }

  @override
  Future<NutritionProfile> createNutritionProfile({
    required NutritionProfile profile,
  }) {
    return remoteDataSource.createNutritionProfile(
      profile: NutritionProfileModel.fromEntity(profile),
    );
  }

  @override
  Future<NutritionProfile> updateNutritionProfile({
    required NutritionProfile profile,
  }) {
    return remoteDataSource.updateNutritionProfile(
      profile: NutritionProfileModel.fromEntity(profile),
    );
  }

  @override
  Future<NutritionProfile> updateNutritionGoals({
    required String userId,
    required double dailyCalorieTarget,
    required double proteinTargetGrams,
    required double carbohydrateTargetGrams,
    required double fatTargetGrams,
  }) {
    return remoteDataSource.updateNutritionGoals(
      userId: userId,
      goals: {
        'dailyCalorieTarget': dailyCalorieTarget,
        'proteinTargetGrams': proteinTargetGrams,
        'carbohydrateTargetGrams': carbohydrateTargetGrams,
        'fatTargetGrams': fatTargetGrams,
      },
    );
  }

  @override
  Future<NutritionProfile> updateDietaryPreferences({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
  }) {
    return remoteDataSource.updateDietaryPreferences(
      userId: userId,
      dietaryPreferences: dietaryPreferences,
      allergies: allergies,
    );
  }
}
