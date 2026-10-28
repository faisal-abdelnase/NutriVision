import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/daily_nutrition_summary.dart';
import '../../domain/entities/recent_meal_summary.dart';
import '../../domain/usecases/get_daily_nutrition_summary.dart';
import '../../domain/usecases/get_recent_meals_summary.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDailyNutritionSummary _getDailyNutritionSummary;
  final GetRecentMealsSummary _getRecentMealsSummary;

  DashboardCubit({
    required GetDailyNutritionSummary getDailyNutritionSummary,
    required GetRecentMealsSummary getRecentMealsSummary,
  })  : _getDailyNutritionSummary = getDailyNutritionSummary,
        _getRecentMealsSummary = getRecentMealsSummary,
        super(const DashboardInitial());

  Future<void> loadDashboard({
    required String userId,
    DateTime? date,
    int recentMealsLimit = 5,
  }) async {
    if (userId.trim().isEmpty) {
      emit(const DashboardError('User ID is required.'));
      return;
    }

    if (recentMealsLimit < 0) {
      emit(const DashboardError('Recent meals limit cannot be negative.'));
      return;
    }

    emit(const DashboardLoading());

    try {
      final selectedDate = date ?? DateTime.now();

      // ✅ Cast للنوع الصح بدل dynamic
      final results = await Future.wait<Object>([
        _getDailyNutritionSummary(
          userId: userId,
          date: selectedDate,
        ),
        _getRecentMealsSummary(
          userId: userId,
          limit: recentMealsLimit,
        ),
      ]);

      final dailySummary = results[0] as DailyNutritionSummary;
      final recentMeals = results[1] as List<RecentMealSummary>;

      emit(
        DashboardLoaded(
          dailySummary: dailySummary,
          recentMeals: recentMeals,
        ),
      );
    } catch (error) {
      emit(DashboardError(_mapError(error)));
    }
  }

  Future<void> refreshDashboard({
    required String userId,
    DateTime? date,
    int recentMealsLimit = 5,
  }) {
    return loadDashboard(
      userId: userId,
      date: date,
      recentMealsLimit: recentMealsLimit,
    );
  }

  String _mapError(Object error) {
    // لو عندك استثناءات مخصصة، حطها هنا
    return 'Failed to load dashboard. Please try again.';
  }
}