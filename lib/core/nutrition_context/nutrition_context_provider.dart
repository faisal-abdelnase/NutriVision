import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Reads the app's existing nutrition profile and meal schema for the signed-in
/// user. The provider never accepts a user ID from a prompt or caller.
class NutritionContextProvider {
  NutritionContextProvider({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<Map<String, dynamic>> fetchForQuestion(String question) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('Sign in to use personalized nutrition.');
    debugPrint('[NUTRITION_CONTEXT] Retrieval started.');
    try {
      final profileFuture = _firestore
          .collection('nutrition_profiles')
          .doc(uid)
          .get();
      final userFuture = _firestore.collection('users').doc(uid).get();
      final today = _dayRange(DateTime.now());
      final todayFuture = _meals(uid)
          .where(
            'eatenAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(today.$1),
          )
          .where('eatenAt', isLessThan: Timestamp.fromDate(today.$2))
          .orderBy('eatenAt', descending: true)
          .get();
      final results = await Future.wait([
        profileFuture,
        userFuture,
        todayFuture,
      ]);
      final profileSnapshot =
          results[0] as DocumentSnapshot<Map<String, dynamic>>;
      final userSnapshot = results[1] as DocumentSnapshot<Map<String, dynamic>>;
      final profile = profileSnapshot.data() ?? <String, dynamic>{};
      final user = userSnapshot.data() ?? <String, dynamic>{};
      final todayDocs =
          (results[2] as QuerySnapshot<Map<String, dynamic>>).docs;
      final todayMeals = todayDocs.map(_mealMap).toList();
      final totals = calculateTotals(todayMeals);
      final profileContext = <String, dynamic>{
        'userId': uid,
        if (profile['age'] != null) 'age': profile['age'],
        if (user['gender'] != null) 'gender': user['gender'],
        if (profile['heightCm'] != null) 'heightCm': profile['heightCm'],
        if (profile['weightKg'] != null) 'weightKg': profile['weightKg'],
        if (profile['goal'] != null) 'goal': profile['goal'],
        if (profile['dietaryPreferences'] != null)
          'dietaryPreferences': profile['dietaryPreferences'],
        if (profile['allergies'] != null) 'allergies': profile['allergies'],
        for (final key in [
          'dailyCalorieTarget',
          'proteinTargetGrams',
          'carbohydrateTargetGrams',
          'fatTargetGrams',
        ])
          if (profile[key] != null) key: profile[key],
      };
      final context = <String, dynamic>{
        'profile': profileContext,
        'profileAvailable': profile.isNotEmpty,
        'userProfileAvailable': user.isNotEmpty,
        'today': {
          'meals': todayMeals,
          'totals': totals,
          'mealCount': todayMeals.length,
          'remainingTargets': remainingTargets(profile, totals),
        },
      };
      if (requiresHistoricalMeals(question)) {
        final range = historyRangeForQuestion(question, DateTime.now());
        final query = await _meals(uid)
            .where(
              'eatenAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(range.$1),
            )
            .where('eatenAt', isLessThan: Timestamp.fromDate(range.$2))
            .orderBy('eatenAt', descending: true)
            .limit(50)
            .get();
        context['historicalMeals'] = query.docs.map(_mealMap).toList();
        context['historyRange'] = {
          'from': range.$1.toIso8601String(),
          'to': range.$2.toIso8601String(),
        };
      }
      debugPrint(
        '[NUTRITION_CONTEXT] Profile available: ${context['profileAvailable']}; meals today: ${todayMeals.length}; totals: $totals',
      );
      return context;
    } catch (error, stackTrace) {
      debugPrint(
        '[NUTRITION_CONTEXT] Firestore retrieval failed: $error\n$stackTrace',
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchForMealAnalysis() async {
    final context = await fetchForQuestion('meal analysis');
    return context;
  }

  CollectionReference<Map<String, dynamic>> _meals(String uid) =>
      _firestore.collection('users').doc(uid).collection('meals');

  Map<String, dynamic> _mealMap(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return {
      'mealId': doc.id,
      for (final key in [
        'name',
        'description',
        'mealType',
        'ingredients',
        'calories',
        'proteinGrams',
        'carbohydrateGrams',
        'fatGrams',
      ])
        if (data[key] != null) key: data[key],
      if (data['eatenAt'] is Timestamp)
        'eatenAt': (data['eatenAt'] as Timestamp).toDate().toIso8601String(),
    };
  }

  static Map<String, double> calculateTotals(
    Iterable<Map<String, dynamic>> meals,
  ) {
    var calories = 0.0, protein = 0.0, carbs = 0.0, fat = 0.0;
    for (final meal in meals) {
      calories += _number(meal['calories']);
      protein += _number(meal['proteinGrams']);
      carbs += _number(meal['carbohydrateGrams']);
      fat += _number(meal['fatGrams']);
    }
    return {
      'calories': calories,
      'proteinGrams': protein,
      'carbohydrateGrams': carbs,
      'fatGrams': fat,
    };
  }

  static Map<String, double?> remainingTargets(
    Map<String, dynamic> profile,
    Map<String, double> totals,
  ) => {
    'calories': _remaining(profile['dailyCalorieTarget'], totals['calories']),
    'proteinGrams': _remaining(
      profile['proteinTargetGrams'],
      totals['proteinGrams'],
    ),
    'carbohydrateGrams': _remaining(
      profile['carbohydrateTargetGrams'],
      totals['carbohydrateGrams'],
    ),
    'fatGrams': _remaining(profile['fatTargetGrams'], totals['fatGrams']),
  };

  static double? _remaining(dynamic target, double? intake) {
    if (target is! num) return null;
    return target.toDouble() - (intake ?? 0);
  }

  static double _number(dynamic value) => value is num ? value.toDouble() : 0;
  static (DateTime, DateTime) _dayRange(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    return (start, start.add(const Duration(days: 1)));
  }

  static bool requiresHistoricalMeals(String question) =>
      RegExp(
        r'yesterday|last\s+(meal|breakfast|week)|this\s+week|before|previous|compare|similar|how many times|saved yesterday',
        caseSensitive: false,
      ).hasMatch(question) ||
      _containsAny(question, [
        [0x0623, 0x0645, 0x0633],
        [0x0627, 0x0645, 0x0628, 0x0627, 0x0631, 0x062d],
        [0x0622, 0x062E, 0x0631, 0x0020, 0x0648, 0x062C, 0x0628, 0x0629],
        [0x0627, 0x0644, 0x0623, 0x0633, 0x0628, 0x0648, 0x0639],
        [0x0642, 0x0627, 0x0631, 0x0646],
      ]);

  static (DateTime, DateTime) historyRangeForQuestion(
    String question,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    if (RegExp(r'yesterday', caseSensitive: false).hasMatch(question) ||
        _containsAny(question, [
          [0x0623, 0x0645, 0x0633],
          [0x0627, 0x0645, 0x0628, 0x0627, 0x0631, 0x062d],
        ])) {
      return (today.subtract(const Duration(days: 1)), today);
    }
    final week =
        RegExp(
          r'this\s+week|how many times',
          caseSensitive: false,
        ).hasMatch(question) ||
        _containsAny(question, [
          [0x0627, 0x0644, 0x0623, 0x0633, 0x0628, 0x0648, 0x0639],
          [0x0643, 0x0645, 0x0020, 0x0645, 0x0631, 0x0629],
        ]);
    return (today.subtract(Duration(days: week ? 6 : 30)), today);
  }

  Future<String> promptContext(String question) async =>
      jsonEncode(await fetchForQuestion(question));

  static bool _containsAny(String text, List<List<int>> terms) =>
      terms.any((term) => text.contains(String.fromCharCodes(term)));
}
