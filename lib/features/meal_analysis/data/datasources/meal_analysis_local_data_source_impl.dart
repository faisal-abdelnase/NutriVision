import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal_analysis_result_model.dart';
import 'meal_analysis_local_data_source.dart';

class MealAnalysisLocalDataSourceImpl
    implements MealAnalysisLocalDataSource {
  final SharedPreferences preferences;

  MealAnalysisLocalDataSourceImpl({
    required this.preferences,
  });

  String _key(String analysisId) =>
      'meal_analysis_$analysisId';

  String _historyKey(String userId) =>
      'meal_analysis_history_$userId';

  @override
Future<void> cacheMealAnalysis({
  required MealAnalysisResultModel result,
}) async {
  final json = result.toJson();

  json['analyzedAt'] = result.analyzedAt.toIso8601String();

  await preferences.setString(
    _key(result.id),
    jsonEncode(json),
  );

  final historyIds =
      preferences.getStringList(_historyKey(result.userId)) ??
          <String>[];

  if (!historyIds.contains(result.id)) {
    historyIds.insert(0, result.id);

    await preferences.setStringList(
      _historyKey(result.userId),
      historyIds,
    );
  }
}
  @override
  Future<MealAnalysisResultModel?> getCachedMealAnalysis({
    required String analysisId,
  }) async {
    final jsonString = preferences.getString(_key(analysisId));

    if (jsonString == null) return null;

    return MealAnalysisResultModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(jsonString) as Map),
    );
  }

  @override
  Future<List<MealAnalysisResultModel>>
      getCachedMealAnalysisHistory({
    required String userId,
  }) async {
    final ids = preferences.getStringList(_historyKey(userId)) ??
        <String>[];

    final results = <MealAnalysisResultModel>[];

    for (final id in ids) {
      final result = await getCachedMealAnalysis(
        analysisId: id,
      );

      if (result != null && result.userId == userId) {
        results.add(result);
      }
    }

    return results;
  }

  @override
  Future<void> removeCachedMealAnalysis({
    required String analysisId,
  }) async {
    final result = await getCachedMealAnalysis(
      analysisId: analysisId,
    );

    await preferences.remove(_key(analysisId));

    if (result == null) return;

    final historyKey = _historyKey(result.userId);
    final ids = preferences.getStringList(historyKey) ?? <String>[];

    ids.remove(analysisId);

    await preferences.setStringList(historyKey, ids);
  }

  @override
  Future<void> clearCachedMealAnalysisHistory({
    required String userId,
  }) async {
    final ids = preferences.getStringList(_historyKey(userId)) ??
        <String>[];

    for (final id in ids) {
      await preferences.remove(_key(id));
    }

    await preferences.remove(_historyKey(userId));
  }
}