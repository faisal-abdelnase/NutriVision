

import '../entities/meal.dart';
import '../repositories/meal_repository.dart';
class GetMealHistory {
  final MealRepository repository;

  GetMealHistory(this.repository);

  Future<List<Meal>> call({
    required String userId,
    required int page,
    required int pageSize,
  }){
    return repository.getMealHistory(userId: userId, page: page, pageSize: pageSize);
  }
}