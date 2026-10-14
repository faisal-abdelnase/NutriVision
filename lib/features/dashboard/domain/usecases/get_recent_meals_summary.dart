

import '../entities/recent_meal_summary.dart';
import '../repositories/dashboard_repository.dart';

abstract class GetRecentMealsSummary {
  final DashboardRepository repository;

  GetRecentMealsSummary(this.repository);

  Future<List<RecentMealSummary>> call({
    required String userId,
    required int limit,
  });
}