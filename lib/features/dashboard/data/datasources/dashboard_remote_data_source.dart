import '../models/daily_nutrition_summary_model.dart';
import '../models/recent_meal_summary_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DailyNutritionSummaryModel> fetchDailyNutritionSummary({
    required String userId,
    required DateTime date,
  });

  Future<List<RecentMealSummaryModel>> fetchRecentMealsSummary({
    required String userId,
    required int limit,
  });
}