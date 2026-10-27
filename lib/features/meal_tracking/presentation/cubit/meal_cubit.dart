
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/meal.dart';
import '../../domain/usecases/add_meal.dart';
import '../../domain/usecases/delete_meal.dart';
import '../../domain/usecases/get_meal_by_id.dart';
import '../../domain/usecases/get_meal_history.dart';
import '../../domain/usecases/get_meals_by_date.dart';
import '../../domain/usecases/update_meal.dart';
import 'meal_state.dart';

class MealCubit extends Cubit<MealState> {
  final AddMeal addMealUseCase;
  final UpdateMeal updateMealUseCase;
  final DeleteMeal deleteMealUseCase;
  final GetMealById getMealByIdUseCase;
  final GetMealHistory getMealHistoryUseCase;
  final GetMealsByDate getMealsByDateUseCase;

  MealCubit({
    required this.addMealUseCase,
    required this.updateMealUseCase,
    required this.deleteMealUseCase,
    required this.getMealByIdUseCase,
    required this.getMealHistoryUseCase,
    required this.getMealsByDateUseCase,
  }) : super(const MealInitial());

  Future<void> addMeal({
    required Meal meal,
  }) async {
    emit(const MealLoading());

    try {
      final savedMeal = await addMealUseCase(meal: meal);
      emit(
        MealOperationSuccess(
          'Meal added successfully.',
          meal: savedMeal,
        ),
      );
    } catch (error) {
      emit(MealError(_errorMessage(error)));
    }
  }

  Future<void> updateMeal({
    required Meal meal,
  }) async {
    emit(const MealLoading());

    try {
      await updateMealUseCase(meal: meal);
      emit(const MealOperationSuccess('Meal updated successfully.'));
    } catch (error) {
      emit(MealError(_errorMessage(error)));
    }
  }

  Future<void> deleteMeal({
    required String mealId,
    required String userId,
  }) async {
    emit(const MealLoading());

    try {
      await deleteMealUseCase(
        mealId: mealId,
        userId: userId,
      );

      emit(const MealOperationSuccess('Meal deleted successfully.'));
    } catch (error) {
      emit(MealError(_errorMessage(error)));
    }
  }

  Future<void> getMealById({
    required String mealId,
    required String userId,
  }) async {
    emit(const MealLoading());

    try {
      final meal = await getMealByIdUseCase(
        mealId: mealId,
        userId: userId,
      );

      if (meal == null) {
        emit(const MealError('Meal not found.'));
        return;
      }

      emit(MealDetailsLoaded(meal));
    } catch (error) {
      emit(MealError(_errorMessage(error)));
    }
  }

  Future<void> getMealHistory({
    required String userId,
    int page = 0,
    int pageSize = 20,
  }) async {
    emit(const MealLoading());

    try {
      final meals = await getMealHistoryUseCase(
        userId: userId,
        page: page,
        pageSize: pageSize,
      );

      emit(
        MealHistoryLoaded(
          meals: meals,
          page: page,
          hasMore: meals.length == pageSize,
        ),
      );
    } catch (error) {
      emit(MealError(_errorMessage(error)));
    }
  }

  Future<void> getMealsByDate({
    required String userId,
    required DateTime date,
  }) async {
    emit(const MealLoading());

    try {
      final meals = await getMealsByDateUseCase(
        userId: userId,
        date: date,
      );

      emit(
        MealsByDateLoaded(
          meals: meals,
          date: date,
        ),
      );
    } catch (error) {
      emit(MealError(_errorMessage(error)));
    }
  }

  String _errorMessage(Object error) {
    // Replace this with your shared Firebase error mapper
    // when its interface is available in core.
    return error.toString();
  }
}
