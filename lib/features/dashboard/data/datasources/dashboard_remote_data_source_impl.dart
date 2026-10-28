import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/daily_nutrition_summary_model.dart';
import '../models/recent_meal_summary_model.dart';
import 'dashboard_remote_data_source.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final FirebaseFirestore firestore;

  DashboardRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> _mealsCollection(String userId) {
    return firestore.collection('users').doc(userId).collection('meals');
  }

  @override
  Future<DailyNutritionSummaryModel> fetchDailyNutritionSummary({
    required String userId,
    required DateTime date,
  }) async {
    // بداية اليوم ونهاية اليوم حسب توقيت الجهاز.
    final startOfDay = DateTime(date.year, date.month, date.day);
    final startOfNextDay = DateTime(date.year, date.month, date.day + 1);

    // جلب جميع وجبات اليوم فقط.
    final mealsSnapshot = await _mealsCollection(userId)
        .where(
          'eatenAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('eatenAt', isLessThan: Timestamp.fromDate(startOfNextDay))
        .get();

    double consumedCalories = 0;
    double consumedProtein = 0;
    double consumedCarbohydrates = 0;
    double consumedFat = 0;

    for (final document in mealsSnapshot.docs) {
      final meal = document.data();

      consumedCalories += _toDouble(meal['calories']);
      consumedProtein += _toDouble(meal['proteinGrams']);
      consumedCarbohydrates += _toDouble(meal['carbohydrateGrams']);
      consumedFat += _toDouble(meal['fatGrams']);
    }

    // قراءة هدف السعرات من مستند المستخدم.
    final userSnapshot = await firestore.collection('users').doc(userId).get();

    final userData = userSnapshot.data() ?? {};

    final calorieTarget = _toDouble(userData['dailyCalorieTarget']);

    return DailyNutritionSummaryModel(
      date: startOfDay,
      consumedCalories: consumedCalories,
      calorieTarget: calorieTarget,
      consumedProteinGrams: consumedProtein,
      consumedCarbohydrateGrams: consumedCarbohydrates,
      consumedFatGrams: consumedFat,
      mealCount: mealsSnapshot.docs.length,
    );
  }

  @override
  Future<List<RecentMealSummaryModel>> fetchRecentMealsSummary({
    required String userId,
    required int limit,
  }) async {
    if (limit <= 0) {
      return [];
    }

    final snapshot = await _mealsCollection(
      userId,
    ).orderBy('eatenAt', descending: true).limit(limit).get();

    return snapshot.docs.map((document) {
      final meal = document.data();

      final eatenAt = meal['eatenAt'];

      if (eatenAt is! Timestamp) {
        throw const FormatException(
          'Meal eatenAt must be a Firestore Timestamp.',
        );
      }

      return RecentMealSummaryModel(
        mealId: document.id,
        name: meal['name'] as String? ?? 'Unnamed meal',
        calories: _toDouble(meal['calories']),
        eatenAt: eatenAt.toDate(),
      );
    }).toList();
  }

  double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return 0.0;
  }
}
