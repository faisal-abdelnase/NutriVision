import '../repositories/meal_repository.dart';

class DeleteMeal {
  final MealRepository repository;

  DeleteMeal(this.repository);

  Future<void> call({required String mealId, required String userId}) {
    return repository.deleteMeal(mealId: mealId, userId: userId);
  }
}
