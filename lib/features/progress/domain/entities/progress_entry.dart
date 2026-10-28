class ProgressEntry {
  final String id;
  final String userId;

  final double? weightKg;
  final double? bodyFatPercentage;
  final double? waistCircumferenceCm;

  final DateTime recordedAt;
  final String? notes;

  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProgressEntry({
    required this.id,
    required this.userId,
    this.weightKg,
    this.bodyFatPercentage,
    this.waistCircumferenceCm,
    required this.recordedAt,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });
}
