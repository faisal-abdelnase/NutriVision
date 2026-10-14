
import '../repositories/meal_repository.dart';

abstract class DeleteMeal {
  final MealRepository repository;

  DeleteMeal(this.repository);

  Future<void> call({
    required String mealId,
    required String userId,
  });
}