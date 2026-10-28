import '../../domain/entities/recent_meal_summary.dart';

class RecentMealSummaryModel extends RecentMealSummary {
  const RecentMealSummaryModel({
    required super.mealId,
    required super.name,
    required super.calories,
    required super.eatenAt,
  });
}
