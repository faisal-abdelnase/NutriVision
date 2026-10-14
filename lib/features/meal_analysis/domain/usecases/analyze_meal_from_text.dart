

import '../entities/meal_analysis_request.dart';
import '../entities/meal_analysis_result.dart';
import '../repositories/meal_analysis_repository.dart';

abstract class AnalyzeMealFromText {
  final MealAnalysisRepository repository;

  AnalyzeMealFromText(this.repository);

  Future< MealAnalysisResult> call({
    required MealAnalysisRequest request,
  });
}