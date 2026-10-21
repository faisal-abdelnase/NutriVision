import '../entities/meal_analysis_request.dart';
import '../entities/meal_analysis_result.dart';
import '../repositories/meal_analysis_repository.dart';

class AnalyzeMealFromImage {
  final MealAnalysisRepository repository;

  AnalyzeMealFromImage(this.repository);

  Future<MealAnalysisResult> call({
    required MealAnalysisRequest request,
  }) {
    return repository.analyzeMealFromImage(request: request);
  }
}