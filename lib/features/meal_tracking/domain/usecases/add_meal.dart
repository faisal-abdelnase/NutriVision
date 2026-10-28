import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

class AddMeal {
  final MealRepository repository;

  AddMeal(this.repository);

  Future<Meal> call({required Meal meal}) {
    return repository.addMeal(meal: meal);
  }
}
