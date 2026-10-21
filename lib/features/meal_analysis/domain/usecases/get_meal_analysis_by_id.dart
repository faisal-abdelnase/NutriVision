import '../entities/meal_analysis_result.dart';
import '../repositories/meal_analysis_repository.dart';

class GetMealAnalysisById {
  final MealAnalysisRepository repository;

  GetMealAnalysisById(this.repository);

  Future<MealAnalysisResult?> call({
    required String analysisId,
    required String userId,
  }) {
    return repository.getMealAnalysisById(
      analysisId: analysisId,
      userId: userId,
    );
  }
}