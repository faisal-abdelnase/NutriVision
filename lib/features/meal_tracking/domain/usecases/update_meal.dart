
import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

abstract class UpdateMeal {
  final MealRepository repository;

  UpdateMeal(this.repository);

  Future<Meal> call({
    required Meal meal,
  });
}