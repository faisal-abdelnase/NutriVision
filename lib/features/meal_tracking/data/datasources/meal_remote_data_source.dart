
import '../models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<MealModel> createMeal({
    required MealModel meal,
  });

  Future<MealModel> updateMeal({
    required MealModel meal,
  });

  Future<void> deleteMeal({
    required String mealId,
    required String userId,
  });

  Future<MealModel?> fetchMealById({
    required String mealId,
    required String userId,
  });

  Future<List<MealModel>> fetchMealHistory({
    required String userId,
    required int page,
    required int pageSize,
  });

  Future<List<MealModel>> fetchMealsByDate({
    required String userId,
    required DateTime date,
  });
}
