

import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

abstract class GetMealHistory {
  final MealRepository repository;

  GetMealHistory(this.repository);

  Future<List<Meal>> call({
    required String userId,
    required int page,
    required int pageSize,
  });
}