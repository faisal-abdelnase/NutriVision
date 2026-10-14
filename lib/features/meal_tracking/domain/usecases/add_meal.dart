

import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

abstract class AddMeal {
  final MealRepository repository;

  AddMeal(this.repository);

  Future<Meal> call({
    required Meal meal,
  });
}