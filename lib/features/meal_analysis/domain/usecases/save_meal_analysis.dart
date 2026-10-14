

import '../entities/meal_analysis_result.dart';
import '../repositories/meal_analysis_repository.dart';

abstract class SaveMealAnalysis {
  final MealAnalysisRepository repository;

  SaveMealAnalysis(this.repository);

  Future<MealAnalysisResult> call({
    required MealAnalysisResult result,
  });
}