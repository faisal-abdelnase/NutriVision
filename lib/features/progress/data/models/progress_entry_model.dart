import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory ProgressEntryModel.fromJson(
    Map<String, dynamic> json, {
    String? documentId,
  }) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);

      throw FormatException('Invalid date value: $value');
    }

    double? parseDouble(dynamic value) {
      if (value == null) return null;
      return (value as num).toDouble();
    }

    return ProgressEntryModel(
      id: documentId ?? json['id'] as String,
      userId: json['userId'] as String,
      weightKg: parseDouble(json['weightKg']),
      bodyFatPercentage: parseDouble(json['bodyFatPercentage']),
      waistCircumferenceCm: parseDouble(json['waistCircumferenceCm']),
      recordedAt: parseDate(json['recordedAt']),
      notes: json['notes'] as String?,
      createdAt: parseDate(json['createdAt']),
      updatedAt: json['updatedAt'] == null
          ? null
          : parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'weightKg': weightKg,
      'bodyFatPercentage': bodyFatPercentage,
      'waistCircumferenceCm': waistCircumferenceCm,
      'recordedAt': Timestamp.fromDate(recordedAt),
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    };
  }
}
