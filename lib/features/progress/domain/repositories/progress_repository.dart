import '../entities/nutrition_trend_point.dart';
import '../entities/progress_entry.dart';
import '../entities/progress_summary.dart';

abstract class ProgressRepository {
  Future<ProgressEntry> recordProgressEntry({
    required ProgressEntry entry,
  });

  Future<ProgressEntry> updateProgressEntry({
    required ProgressEntry entry,
  });

  Future<void> deleteProgressEntry({
    required String userId,
    required String entryId,
  });

  Future<List<ProgressEntry>> getProgressHistory({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required int page,
    required int pageSize,
  });

  Future<ProgressSummary> getProgressSummary({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<NutritionTrendPoint>> getNutritionTrends({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });
}