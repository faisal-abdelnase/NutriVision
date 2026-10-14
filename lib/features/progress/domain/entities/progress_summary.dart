class ProgressSummary {
  final String userId;

  final double? currentWeightKg;
  final double? startingWeightKg;
  final double? weightChangeKg;

  final double? currentBodyFatPercentage;
  final double? startingBodyFatPercentage;
  final double? bodyFatChangePercentage;

  final int totalEntries;

  final DateTime? firstRecordedAt;
  final DateTime? lastRecordedAt;

  const ProgressSummary({
    required this.userId,
    this.currentWeightKg,
    this.startingWeightKg,
    this.weightChangeKg,
    this.currentBodyFatPercentage,
    this.startingBodyFatPercentage,
    this.bodyFatChangePercentage,
    required this.totalEntries,
    this.firstRecordedAt,
    this.lastRecordedAt,
  });
}