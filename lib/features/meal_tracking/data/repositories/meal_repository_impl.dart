

import '../../domain/entities/meal.dart';
import '../../domain/repositories/meal_repository.dart';
import '../datasources/meal_remote_data_source.dart';

abstract class MealRepositoryImpl implements MealRepository {
  final MealRemoteDataSource remoteDataSource;

  MealRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Meal> addMeal({
    required Meal meal,
  });

  @override
  Future<Meal> updateMeal({
    required Meal meal,
  });

  @override
  Future<void> deleteMeal({
    required String mealId,
    required String userId,
  });

  @override
  Future<Meal?> getMealById({
    required String mealId,
    required String userId,
  });

  @override
  Future<List<Meal>> getMealHistory({
    required String userId,
    required int page,
    required int pageSize,
  });

  @override
  Future<List<Meal>> getMealsByDate({
    required String userId,
    required DateTime date,
  });
}