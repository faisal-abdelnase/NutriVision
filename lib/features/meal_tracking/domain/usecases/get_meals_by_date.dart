

import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

abstract class GetMealsByDate {
  final MealRepository repository;

  GetMealsByDate(this.repository);

  Future<List<Meal>> call({
    required String userId,
    required DateTime date,
  });
}