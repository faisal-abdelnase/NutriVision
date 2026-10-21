

import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

class GetMealById {
  final MealRepository repository;

  GetMealById(this.repository);

  Future<Meal?> call({
    required String mealId,
    required String userId,
  }){
    return repository.getMealById(mealId: mealId, userId: userId);
  }
}