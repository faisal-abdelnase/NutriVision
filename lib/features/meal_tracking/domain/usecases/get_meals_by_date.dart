import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

class GetMealsByDate {
  final MealRepository repository;

  GetMealsByDate(this.repository);

  Future<List<Meal>> call({required String userId, required DateTime date}) {
    return repository.getMealsByDate(userId: userId, date: date);
  }
}
