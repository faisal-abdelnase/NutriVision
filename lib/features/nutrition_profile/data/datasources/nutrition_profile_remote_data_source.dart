import '../models/nutrition_profile_model.dart';

abstract class NutritionProfileRemoteDataSource {
  Future<NutritionProfileModel?> fetchNutritionProfile({
    required String userId,
  });

  Future<NutritionProfileModel> createNutritionProfile({
    required NutritionProfileModel profile,
  });

  Future<NutritionProfileModel> updateNutritionProfile({
    required NutritionProfileModel profile,
  });

  Future<NutritionProfileModel> updateNutritionGoals({
    required String userId,
    required Map<String, dynamic> goals,
  });

  Future<NutritionProfileModel> updateDietaryPreferences({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
  });
}