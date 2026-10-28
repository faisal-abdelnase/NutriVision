import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/nutrition_trend_point_model.dart';
import '../models/progress_entry_model.dart';
import '../models/progress_summary_model.dart';
import 'progress_remote_data_source.dart';

class ProgressRemoteDataSourceImpl implements ProgressRemoteDataSource {
  final FirebaseFirestore firestore;

  ProgressRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> _entries(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('progress_entries');
  }

  CollectionReference<Map<String, dynamic>> _mealLogs(String userId) {
    return firestore.collection('users').doc(userId).collection('meal_logs');
  }

  @override
  Future<ProgressEntryModel> createProgressEntry({
    required ProgressEntryModel entry,
  }) async {
    final collection = _entries(entry.userId);

    final reference = entry.id.trim().isEmpty
        ? collection.doc()
        : collection.doc(entry.id);

    final now = DateTime.now();

    final savedEntry = ProgressEntryModel(
      id: reference.id,
      userId: entry.userId,
      weightKg: entry.weightKg,
      bodyFatPercentage: entry.bodyFatPercentage,
      waistCircumferenceCm: entry.waistCircumferenceCm,
      recordedAt: entry.recordedAt,
      notes: entry.notes,
      createdAt: entry.createdAt,
      updatedAt: now,
    );

    await reference.set(savedEntry.toJson());

    return savedEntry;
  }

  @override
  Future<ProgressEntryModel> updateProgressEntry({
    required ProgressEntryModel entry,
  }) async {
    final reference = _entries(entry.userId).doc(entry.id);

    final updatedEntry = ProgressEntryModel(
      id: entry.id,
      userId: entry.userId,
      weightKg: entry.weightKg,
      bodyFatPercentage: entry.bodyFatPercentage,
      waistCircumferenceCm: entry.waistCircumferenceCm,
      recordedAt: entry.recordedAt,
      notes: entry.notes,
      createdAt: entry.createdAt,
      updatedAt: DateTime.now(),
    );

    await reference.update(updatedEntry.toJson());

    return updatedEntry;
  }

  @override
  Future<void> deleteProgressEntry({
    required String userId,
    required String entryId,
  }) async {
    await _entries(userId).doc(entryId).delete();
  }

  @override
  Future<List<ProgressEntryModel>> fetchProgressHistory({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required int page,
    required int pageSize,
  }) async {
    _validateDateRange(startDate, endDate);

    if (page < 1) {
      throw ArgumentError.value(page, 'page', 'Must be at least 1');
    }

    if (pageSize < 1) {
      throw ArgumentError.value(pageSize, 'pageSize', 'Must be at least 1');
    }

    final query = _entries(userId)
        .where(
          'recordedAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where('recordedAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('recordedAt', descending: true)
        .limit(page * pageSize);

    final snapshot = await query.get();

    final models = snapshot.docs
        .map(
          (doc) => ProgressEntryModel.fromJson(doc.data(), documentId: doc.id),
        )
        .toList();

    final startIndex = (page - 1) * pageSize;

    if (startIndex >= models.length) {
      return [];
    }

    return models.skip(startIndex).take(pageSize).toList();
  }

  @override
  Future<ProgressSummaryModel> fetchProgressSummary({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _validateDateRange(startDate, endDate);

    final snapshot = await _entries(userId)
        .where(
          'recordedAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where('recordedAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('recordedAt')
        .get();

    final entries =
        snapshot.docs
            .map(
              (doc) =>
                  ProgressEntryModel.fromJson(doc.data(), documentId: doc.id),
            )
            .toList()
          ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    if (entries.isEmpty) {
      return ProgressSummaryModel(userId: userId, totalEntries: 0);
    }

    final first = entries.first;
    final last = entries.last;

    final firstWeight = _firstNonNullWeight(entries);
    final lastWeight = _lastNonNullWeight(entries);
    final firstBodyFat = _firstNonNullBodyFat(entries);
    final lastBodyFat = _lastNonNullBodyFat(entries);

    return ProgressSummaryModel(
      userId: userId,
      currentWeightKg: lastWeight,
      startingWeightKg: firstWeight,
      weightChangeKg: firstWeight != null && lastWeight != null
          ? lastWeight - firstWeight
          : null,
      currentBodyFatPercentage: lastBodyFat,
      startingBodyFatPercentage: firstBodyFat,
      bodyFatChangePercentage: firstBodyFat != null && lastBodyFat != null
          ? lastBodyFat - firstBodyFat
          : null,
      totalEntries: entries.length,
      firstRecordedAt: first.recordedAt,
      lastRecordedAt: last.recordedAt,
    );
  }

  @override
  Future<List<NutritionTrendPointModel>> fetchNutritionTrends({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _validateDateRange(startDate, endDate);

    final snapshot = await _mealLogs(userId)
        .where(
          'recordedAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where('recordedAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('recordedAt')
        .get();

    final dailyTotals = <DateTime, Map<String, double>>{};

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final recordedAt = _parseDate(data['recordedAt']);
      final day = DateTime(recordedAt.year, recordedAt.month, recordedAt.day);

      final totals = dailyTotals.putIfAbsent(
        day,
        () => {
          'calories': 0,
          'proteinGrams': 0,
          'carbohydrateGrams': 0,
          'fatGrams': 0,
        },
      );

      totals['calories'] = totals['calories']! + _number(data['calories']);
      totals['proteinGrams'] =
          totals['proteinGrams']! + _number(data['proteinGrams']);
      totals['carbohydrateGrams'] =
          totals['carbohydrateGrams']! + _number(data['carbohydrateGrams']);
      totals['fatGrams'] = totals['fatGrams']! + _number(data['fatGrams']);
    }

    final dates = dailyTotals.keys.toList()..sort();

    return dates.map((date) {
      final totals = dailyTotals[date]!;

      return NutritionTrendPointModel(
        date: date,
        calories: totals['calories']!,
        proteinGrams: totals['proteinGrams']!,
        carbohydrateGrams: totals['carbohydrateGrams']!,
        fatGrams: totals['fatGrams']!,
      );
    }).toList();
  }

  void _validateDateRange(DateTime startDate, DateTime endDate) {
    if (endDate.isBefore(startDate)) {
      throw ArgumentError('endDate must be on or after startDate.');
    }
  }

  double _number(dynamic value) {
    if (value is num) return value.toDouble();
    return 0;
  }

  DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;

    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }

    throw FormatException('Invalid recordedAt date: $value');
  }

  double? _firstNonNullWeight(List<ProgressEntryModel> entries) {
    for (final entry in entries) {
      if (entry.weightKg != null) return entry.weightKg;
    }
    return null;
  }

  double? _lastNonNullWeight(List<ProgressEntryModel> entries) {
    for (final entry in entries.reversed) {
      if (entry.weightKg != null) return entry.weightKg;
    }
    return null;
  }

  double? _firstNonNullBodyFat(List<ProgressEntryModel> entries) {
    for (final entry in entries) {
      if (entry.bodyFatPercentage != null) {
        return entry.bodyFatPercentage;
      }
    }
    return null;
  }

  double? _lastNonNullBodyFat(List<ProgressEntryModel> entries) {
    for (final entry in entries.reversed) {
      if (entry.bodyFatPercentage != null) {
        return entry.bodyFatPercentage;
      }
    }
    return null;
  }
}
