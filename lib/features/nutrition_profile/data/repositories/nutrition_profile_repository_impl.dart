

import '../../domain/entities/nutrition_profile.dart';
import '../../domain/repositories/nutrition_profile_repository.dart';
import '../datasources/nutrition_profile_remote_data_source.dart';

abstract class NutritionProfileRepositoryImpl
    implements NutritionProfileRepository {
  final NutritionProfileRemoteDataSource remoteDataSource;

  NutritionProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<NutritionProfile?> getNutritionProfile({
    required String userId,
  });

  @override
  Future<NutritionProfile> createNutritionProfile({
    required NutritionProfile profile,
  });

  @override
  Future<NutritionProfile> updateNutritionProfile({
    required NutritionProfile profile,
  });

  @override
  Future<NutritionProfile> updateNutritionGoals({
    required String userId,
    required double dailyCalorieTarget,
    required double proteinTargetGrams,
    required double carbohydrateTargetGrams,
    required double fatTargetGrams,
  });

  @override
  Future<NutritionProfile> updateDietaryPreferences({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
  });
}