import '../../domain/entities/progress_summary.dart';

class ProgressSummaryModel extends ProgressSummary {
  const ProgressSummaryModel({
    required super.userId,
    super.currentWeightKg,
    super.startingWeightKg,
    super.weightChangeKg,
    super.currentBodyFatPercentage,
    super.startingBodyFatPercentage,
    super.bodyFatChangePercentage,
    required super.totalEntries,
    super.firstRecordedAt,
    super.lastRecordedAt,
  });
}

abstract class ProgressSummaryModelMapper {
  ProgressSummaryModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    ProgressSummaryModel model,
  );

  
}