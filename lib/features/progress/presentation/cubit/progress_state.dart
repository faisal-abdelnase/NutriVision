
import '../../domain/entities/nutrition_trend_point.dart';
import '../../domain/entities/progress_entry.dart';
import '../../domain/entities/progress_summary.dart';

sealed class ProgressState {
  const ProgressState();
}

final class ProgressInitial extends ProgressState {
  const ProgressInitial();
}

final class ProgressLoading extends ProgressState {
  const ProgressLoading();
}

final class ProgressSuccess extends ProgressState {
  final List<ProgressEntry> entries;
  final ProgressSummary summary;
  final List<NutritionTrendPoint> nutritionTrends;

  const ProgressSuccess({
    required this.entries,
    required this.summary,
    required this.nutritionTrends,
  });
}

final class ProgressFailure extends ProgressState {
  final String message;

  const ProgressFailure(this.message);
}

final class ProgressSaving extends ProgressState {
  final ProgressSuccess? previousData;

  const ProgressSaving({this.previousData});
}

final class ProgressOperationSuccess extends ProgressState {
  final String message;
  final ProgressSuccess? updatedData;

  const ProgressOperationSuccess({
    required this.message,
    this.updatedData,
  });
}
