import '../entities/meal_analysis_request.dart';
import '../entities/meal_analysis_result.dart';

abstract class MealAnalysisRepository {
  Future<MealAnalysisResult> analyzeMealFromText({
    required MealAnalysisRequest request,
  });

  Future<MealAnalysisResult> analyzeMealFromImage({
    required MealAnalysisRequest request,
  });

  Future<MealAnalysisResult?> getMealAnalysisById({
    required String analysisId,
    required String userId,
  });

  Future<MealAnalysisResult> saveMealAnalysis({
    required MealAnalysisResult result,
  });

  Future<List<MealAnalysisResult>> getMealAnalysisHistory({
    required String userId,
    required int page,
    required int pageSize,
  });
}
