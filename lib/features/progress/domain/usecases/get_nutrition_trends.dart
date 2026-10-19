

import '../entities/nutrition_trend_point.dart';
import '../repositories/progress_repository.dart';

class GetNutritionTrends {
  final ProgressRepository repository;

  GetNutritionTrends(this.repository);

  Future<List<NutritionTrendPoint>> call({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return repository.getNutritionTrends(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
