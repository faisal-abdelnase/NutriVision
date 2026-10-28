import '../../domain/entities/nutrition_profile.dart';
import '../../domain/repositories/nutrition_profile_repository.dart';
import '../datasources/nutrition_profile_local_data_source.dart';
import '../datasources/nutrition_profile_remote_data_source.dart';
import '../models/nutrition_profile_model.dart';

class NutritionProfileRepositoryImpl implements NutritionProfileRepository {
  final NutritionProfileRemoteDataSource remoteDataSource;
  final NutritionProfileLocalDataSource? localDataSource;

  NutritionProfileRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
  });

  @override
  Future<NutritionProfile?> getNutritionProfile({
    required String userId,
  }) async {
    final cached = localDataSource?.getCachedNutritionProfile(userId: userId);

    try {
      final remote = await remoteDataSource.fetchNutritionProfile(
        userId: userId,
      );
      if (remote != null) {
        await localDataSource?.cacheNutritionProfile(remote);
        return remote;
      }
    } catch (_) {}

    return cached;
  }

  @override
  Future<NutritionProfile> createNutritionProfile({
    required NutritionProfile profile,
  }) async {
    final model = NutritionProfileModel.fromEntity(profile);
    await localDataSource?.cacheNutritionProfile(model);

    try {
      final created = await remoteDataSource.createNutritionProfile(
        profile: model,
      );
      await localDataSource?.cacheNutritionProfile(created);
      return created;
    } catch (_) {
      return model;
    }
  }

  @override
  Future<NutritionProfile> updateNutritionProfile({
    required NutritionProfile profile,
  }) async {
    final model = NutritionProfileModel.fromEntity(profile);
    await localDataSource?.cacheNutritionProfile(model);

    try {
      final updated = await remoteDataSource.updateNutritionProfile(
        profile: model,
      );
      await localDataSource?.cacheNutritionProfile(updated);
      return updated;
    } catch (_) {
      return model;
    }
  }

  @override
  Future<NutritionProfile> updateNutritionGoals({
    required String userId,
    required double dailyCalorieTarget,
    required double proteinTargetGrams,
    required double carbohydrateTargetGrams,
    required double fatTargetGrams,
  }) async {
    try {
      final updated = await remoteDataSource.updateNutritionGoals(
        userId: userId,
        goals: {
          'dailyCalorieTarget': dailyCalorieTarget,
          'proteinTargetGrams': proteinTargetGrams,
          'carbohydrateTargetGrams': carbohydrateTargetGrams,
          'fatTargetGrams': fatTargetGrams,
        },
      );
      await localDataSource?.cacheNutritionProfile(updated);
      return updated;
    } catch (_) {
      final cached = localDataSource?.getCachedNutritionProfile(userId: userId);
      if (cached != null) {
        final updated = NutritionProfileModel(
          userId: cached.userId,
          age: cached.age,
          heightCm: cached.heightCm,
          weightKg: cached.weightKg,
          goal: cached.goal,
          dailyCalorieTarget: dailyCalorieTarget,
          proteinTargetGrams: proteinTargetGrams,
          carbohydrateTargetGrams: carbohydrateTargetGrams,
          fatTargetGrams: fatTargetGrams,
          dietaryPreferences: cached.dietaryPreferences,
          allergies: cached.allergies,
          updatedAt: DateTime.now(),
        );
        await localDataSource?.cacheNutritionProfile(updated);
        return updated;
      }
      rethrow;
    }
  }

  @override
  Future<NutritionProfile> updateDietaryPreferences({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
  }) async {
    try {
      final updated = await remoteDataSource.updateDietaryPreferences(
        userId: userId,
        dietaryPreferences: dietaryPreferences,
        allergies: allergies,
      );
      await localDataSource?.cacheNutritionProfile(updated);
      return updated;
    } catch (_) {
      final cached = localDataSource?.getCachedNutritionProfile(userId: userId);
      if (cached != null) {
        final updated = NutritionProfileModel(
          userId: cached.userId,
          age: cached.age,
          heightCm: cached.heightCm,
          weightKg: cached.weightKg,
          goal: cached.goal,
          dailyCalorieTarget: cached.dailyCalorieTarget,
          proteinTargetGrams: cached.proteinTargetGrams,
          carbohydrateTargetGrams: cached.carbohydrateTargetGrams,
          fatTargetGrams: cached.fatTargetGrams,
          dietaryPreferences: dietaryPreferences,
          allergies: allergies,
          updatedAt: DateTime.now(),
        );
        await localDataSource?.cacheNutritionProfile(updated);
        return updated;
      }
      rethrow;
    }
  }
}
