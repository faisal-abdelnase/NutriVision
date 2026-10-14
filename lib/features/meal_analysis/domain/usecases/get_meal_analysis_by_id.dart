

import '../entities/meal_analysis_result.dart';
import '../repositories/meal_analysis_repository.dart';

abstract class GetMealAnalysisById {
  final MealAnalysisRepository repository;

  GetMealAnalysisById(this.repository);

  Future<MealAnalysisResult?> call({
    required String analysisId,
    required String userId,
  });
}