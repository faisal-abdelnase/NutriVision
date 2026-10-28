import '../../domain/entities/meal.dart';
import '../../domain/repositories/meal_repository.dart';
import '../datasources/meal_remote_data_source.dart';
import '../models/meal_model.dart';

class MealRepositoryImpl implements MealRepository {
  final MealRemoteDataSource remoteDataSource;

  MealRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Meal> addMeal({required Meal meal}) async {
    final model = MealModel.fromEntity(meal);

    return remoteDataSource.createMeal(meal: model);
  }

  @override
  Future<Meal> updateMeal({required Meal meal}) async {
    final model = MealModel.fromEntity(meal);

    return remoteDataSource.updateMeal(meal: model);
  }

  @override
  Future<void> deleteMeal({required String mealId, required String userId}) {
    return remoteDataSource.deleteMeal(mealId: mealId, userId: userId);
  }

  @override
  Future<Meal?> getMealById({required String mealId, required String userId}) {
    return remoteDataSource.fetchMealById(mealId: mealId, userId: userId);
  }

  @override
  Future<List<Meal>> getMealHistory({
    required String userId,
    required int page,
    required int pageSize,
  }) async {
    return remoteDataSource.fetchMealHistory(
      userId: userId,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<List<Meal>> getMealsByDate({
    required String userId,
    required DateTime date,
  }) async {
    return remoteDataSource.fetchMealsByDate(userId: userId, date: date);
  }
}
