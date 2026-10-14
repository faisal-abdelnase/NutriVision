import '../models/meal_analysis_request_model.dart';
import '../models/meal_analysis_result_model.dart';

abstract class MealAnalysisRemoteDataSource {
  Future<MealAnalysisResultModel> analyzeMealFromText({
    required MealAnalysisRequestModel request,
  });

  Future<MealAnalysisResultModel> analyzeMealFromImage({
    required MealAnalysisRequestModel request,
  });

  Future<MealAnalysisResultModel?> fetchMealAnalysisById({
    required String analysisId,
    required String userId,
  });

  Future<MealAnalysisResultModel> saveMealAnalysis({
    required MealAnalysisResultModel result,
  });

  Future<List<MealAnalysisResultModel>> fetchMealAnalysisHistory({
    required String userId,
    required int page,
    required int pageSize,
  });
}