import '../../domain/entities/daily_nutrition_summary.dart';
import '../../domain/entities/recent_meal_summary.dart';

abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final DailyNutritionSummary dailySummary;
  final List<RecentMealSummary> recentMeals;

  const DashboardLoaded({
    required this.dailySummary,
    required this.recentMeals,
  });
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);
}
