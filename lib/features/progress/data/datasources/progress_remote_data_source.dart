import '../models/nutrition_trend_point_model.dart';
import '../models/progress_entry_model.dart';
import '../models/progress_summary_model.dart';

abstract class ProgressRemoteDataSource {
  Future<ProgressEntryModel> createProgressEntry({
    required ProgressEntryModel entry,
  });

  Future<ProgressEntryModel> updateProgressEntry({
    required ProgressEntryModel entry,
  });

  Future<void> deleteProgressEntry({
    required String userId,
    required String entryId,
  });

  Future<List<ProgressEntryModel>> fetchProgressHistory({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required int page,
    required int pageSize,
  });

  Future<ProgressSummaryModel> fetchProgressSummary({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<NutritionTrendPointModel>> fetchNutritionTrends({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });
}