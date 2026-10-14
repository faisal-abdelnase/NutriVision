
import '../../domain/entities/progress_entry.dart';
import '../../domain/entities/progress_summary.dart';
import '../../domain/entities/nutrition_trend_point.dart';
import '../../domain/repositories/progress_repository.dart';

import '../datasources/progress_remote_data_source.dart';

abstract class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource remoteDataSource;

  ProgressRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<ProgressEntry> recordProgressEntry({
    required ProgressEntry entry,
  });

  @override
  Future<ProgressEntry> updateProgressEntry({
    required ProgressEntry entry,
  });

  @override
  Future<void> deleteProgressEntry({
    required String userId,
    required String entryId,
  });

  @override
  Future<List<ProgressEntry>> getProgressHistory({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required int page,
    required int pageSize,
  });

  @override
  Future<ProgressSummary> getProgressSummary({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  @override
  Future<List<NutritionTrendPoint>> getNutritionTrends({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });
}