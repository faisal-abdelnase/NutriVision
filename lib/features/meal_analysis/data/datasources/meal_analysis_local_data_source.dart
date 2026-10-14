import '../models/meal_analysis_result_model.dart';

abstract class MealAnalysisLocalDataSource {
  Future<void> cacheMealAnalysis({
    required MealAnalysisResultModel result,
  });

  Future<MealAnalysisResultModel?> getCachedMealAnalysis({
    required String analysisId,
  });

  Future<List<MealAnalysisResultModel>> getCachedMealAnalysisHistory({
    required String userId,
  });

  Future<void> removeCachedMealAnalysis({
    required String analysisId,
  });

  Future<void> clearCachedMealAnalysisHistory({
    required String userId,
  });
}