

import '../entities/meal.dart';

abstract class MealRepository {
  Future<Meal> addMeal({
    required Meal meal,
  });

  Future<Meal> updateMeal({
    required Meal meal,
  });

  Future<void> deleteMeal({
    required String mealId,
    required String userId,
  });

  Future< Meal?> getMealById({
    required String mealId,
    required String userId,
  });

  Future<List<Meal>> getMealHistory({
    required String userId,
    required int page,
    required int pageSize,
  });

  Future<List<Meal>> getMealsByDate({
    required String userId,
    required DateTime date,
  });
}