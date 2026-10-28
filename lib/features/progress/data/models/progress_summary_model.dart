import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory ProgressSummaryModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);

      throw FormatException('Invalid date value: $value');
    }

    double? parseDouble(dynamic value) =>
        value == null ? null : (value as num).toDouble();

    return ProgressSummaryModel(
      userId: json['userId'] as String,
      currentWeightKg: parseDouble(json['currentWeightKg']),
      startingWeightKg: parseDouble(json['startingWeightKg']),
      weightChangeKg: parseDouble(json['weightChangeKg']),
      currentBodyFatPercentage: parseDouble(json['currentBodyFatPercentage']),
      startingBodyFatPercentage: parseDouble(json['startingBodyFatPercentage']),
      bodyFatChangePercentage: parseDouble(json['bodyFatChangePercentage']),
      totalEntries: (json['totalEntries'] as num?)?.toInt() ?? 0,
      firstRecordedAt: parseDate(json['firstRecordedAt']),
      lastRecordedAt: parseDate(json['lastRecordedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentWeightKg': currentWeightKg,
      'startingWeightKg': startingWeightKg,
      'weightChangeKg': weightChangeKg,
      'currentBodyFatPercentage': currentBodyFatPercentage,
      'startingBodyFatPercentage': startingBodyFatPercentage,
      'bodyFatChangePercentage': bodyFatChangePercentage,
      'totalEntries': totalEntries,
      'firstRecordedAt': firstRecordedAt == null
          ? null
          : Timestamp.fromDate(firstRecordedAt!),
      'lastRecordedAt': lastRecordedAt == null
          ? null
          : Timestamp.fromDate(lastRecordedAt!),
    };
  }
}
