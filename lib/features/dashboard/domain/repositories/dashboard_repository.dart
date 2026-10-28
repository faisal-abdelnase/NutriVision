import '../entities/daily_nutrition_summary.dart';
import '../entities/recent_meal_summary.dart';

abstract class DashboardRepository {
  Future<DailyNutritionSummary> getDailyNutritionSummary({
    required String userId,
    required DateTime date,
  });

  Future<List<RecentMealSummary>> getRecentMealsSummary({
    required String userId,
    required int limit,
  });
}
