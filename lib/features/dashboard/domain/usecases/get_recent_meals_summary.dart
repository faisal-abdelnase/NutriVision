import '../entities/recent_meal_summary.dart';
import '../repositories/dashboard_repository.dart';

class GetRecentMealsSummary {
  final DashboardRepository repository;

  GetRecentMealsSummary(this.repository);

  Future<List<RecentMealSummary>> call({
    required String userId,
    required int limit,
  }) {
    return repository.getRecentMealsSummary(
      userId: userId,
      limit: limit,
    );
  }
}