import '../entities/meal_analysis_request.dart';
import '../entities/meal_analysis_result.dart';
import '../repositories/meal_analysis_repository.dart';

class AnalyzeMealFromText {
  final MealAnalysisRepository repository;

  AnalyzeMealFromText(this.repository);

  Future<MealAnalysisResult> call({required MealAnalysisRequest request}) {
    return repository.analyzeMealFromText(request: request);
  }
}
