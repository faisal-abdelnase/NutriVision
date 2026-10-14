import '../../domain/entities/progress_entry.dart';

class ProgressEntryModel extends ProgressEntry {
  const ProgressEntryModel({
    required super.id,
    required super.userId,
    super.weightKg,
    super.bodyFatPercentage,
    super.waistCircumferenceCm,
    required super.recordedAt,
    super.notes,
    required super.createdAt,
    super.updatedAt,
  });
}

abstract class ProgressEntryModelMapper {
  ProgressEntryModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    ProgressEntryModel model,
  );

  
}