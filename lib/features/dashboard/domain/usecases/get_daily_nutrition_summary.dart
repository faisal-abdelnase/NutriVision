import '../entities/daily_nutrition_summary.dart';
import '../repositories/dashboard_repository.dart';

class GetDailyNutritionSummary {
  final DashboardRepository repository;

  GetDailyNutritionSummary(this.repository);

  Future<DailyNutritionSummary> call({
    required String userId,
    required DateTime date,
  }) {
    return repository.getDailyNutritionSummary(
      userId: userId,
      date: date,
    );
  }
}