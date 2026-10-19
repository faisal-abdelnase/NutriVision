
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/progress_entry.dart';
import '../../domain/usecases/delete_progress_entry.dart';
import '../../domain/usecases/get_nutrition_trends.dart';
import '../../domain/usecases/get_progress_history.dart';
import '../../domain/usecases/get_progress_summary.dart';
import '../../domain/usecases/record_progress_entry.dart';
import '../../domain/usecases/update_progress_entry.dart';
import 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final RecordProgressEntry recordProgressEntry;
  final UpdateProgressEntry updateProgressEntry;
  final DeleteProgressEntry deleteProgressEntry;
  final GetProgressHistory getProgressHistory;
  final GetProgressSummary getProgressSummary;
  final GetNutritionTrends getNutritionTrends;

  ProgressCubit({
    required this.recordProgressEntry,
    required this.updateProgressEntry,
    required this.deleteProgressEntry,
    required this.getProgressHistory,
    required this.getProgressSummary,
    required this.getNutritionTrends,
  }) : super(const ProgressInitial());

  ProgressSuccess? get _currentData {
    final current = state;

    if (current is ProgressSuccess) return current;
    if (current is ProgressSaving) return current.previousData;
    if (current is ProgressOperationSuccess) {
      return current.updatedData;
    }

    return null;
  }

  Future<void> loadProgress({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    int page = 1,
    int pageSize = 20,
  }) async {
    emit(const ProgressLoading());

    try {
      final results = await Future.wait<dynamic>([
        getProgressHistory(
          userId: userId,
          startDate: startDate,
          endDate: endDate,
          page: page,
          pageSize: pageSize,
        ),
        getProgressSummary(
          userId: userId,
          startDate: startDate,
          endDate: endDate,
        ),
        getNutritionTrends(
          userId: userId,
          startDate: startDate,
          endDate: endDate,
        ),
      ]);

      emit(
        ProgressSuccess(
          entries: results[0] as List<ProgressEntry>,
          summary: results[1],
          nutritionTrends: results[2],
        ),
      );
    } catch (error) {
      emit(ProgressFailure(error.toString()));
    }
  }

  Future<bool> recordEntry({
    required ProgressEntry entry,
  }) async {
    final previousData = _currentData;
    emit(ProgressSaving(previousData: previousData));

    try {
      await recordProgressEntry(entry: entry);

      emit(
        ProgressOperationSuccess(
          message: 'Progress entry created successfully.',
          updatedData: previousData,
        ),
      );

      return true;
    } catch (error) {
      emit(ProgressFailure(error.toString()));
      return false;
    }
  }

  Future<bool> updateEntry({
    required ProgressEntry entry,
  }) async {
    final previousData = _currentData;
    emit(ProgressSaving(previousData: previousData));

    try {
      await updateProgressEntry(entry: entry);

      emit(
        ProgressOperationSuccess(
          message: 'Progress entry updated successfully.',
          updatedData: previousData,
        ),
      );

      return true;
    } catch (error) {
      emit(ProgressFailure(error.toString()));
      return false;
    }
  }

  Future<bool> deleteEntry({
    required String userId,
    required String entryId,
  }) async {
    final previousData = _currentData;
    emit(ProgressSaving(previousData: previousData));

    try {
      await deleteProgressEntry(
        userId: userId,
        entryId: entryId,
      );

      final updatedData = previousData == null
          ? null
          : ProgressSuccess(
              entries: previousData.entries
                  .where((entry) => entry.id != entryId)
                  .toList(),
              summary: previousData.summary,
              nutritionTrends: previousData.nutritionTrends,
            );

      emit(
        ProgressOperationSuccess(
          message: 'Progress entry deleted successfully.',
          updatedData: updatedData,
        ),
      );

      return true;
    } catch (error) {
      emit(ProgressFailure(error.toString()));
      return false;
    }
  }
}
