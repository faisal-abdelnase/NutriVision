import '../../domain/entities/nutrition_trend_point.dart';
import '../../domain/entities/progress_entry.dart';
import '../../domain/entities/progress_summary.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_remote_data_source.dart';
import '../models/progress_entry_model.dart';


class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource remoteDataSource;

  ProgressRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<ProgressEntry> recordProgressEntry({
    required ProgressEntry entry,
  }) {
    return remoteDataSource.createProgressEntry(
      entry: _toEntryModel(entry),
    );
  }

  @override
  Future<ProgressEntry> updateProgressEntry({
    required ProgressEntry entry,
  }) {
    return remoteDataSource.updateProgressEntry(
      entry: _toEntryModel(entry),
    );
  }

  @override
  Future<void> deleteProgressEntry({
    required String userId,
    required String entryId,
  }) {
    return remoteDataSource.deleteProgressEntry(
      userId: userId,
      entryId: entryId,
    );
  }

  @override
  Future<List<ProgressEntry>> getProgressHistory({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required int page,
    required int pageSize,
  }) async {
    return remoteDataSource.fetchProgressHistory(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<ProgressSummary> getProgressSummary({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return remoteDataSource.fetchProgressSummary(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<List<NutritionTrendPoint>> getNutritionTrends({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return remoteDataSource.fetchNutritionTrends(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  ProgressEntryModel _toEntryModel(ProgressEntry entry) {
    return ProgressEntryModel(
      id: entry.id,
      userId: entry.userId,
      weightKg: entry.weightKg,
      bodyFatPercentage: entry.bodyFatPercentage,
      waistCircumferenceCm: entry.waistCircumferenceCm,
      recordedAt: entry.recordedAt,
      notes: entry.notes,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }
}