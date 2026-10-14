

import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

abstract class GetMealById {
  final MealRepository repository;

  GetMealById(this.repository);

  Future<Meal?> call({
    required String mealId,
    required String userId,
  });
}