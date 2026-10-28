import '../entities/meal_analysis_result.dart';
import '../repositories/meal_analysis_repository.dart';

class GetMealAnalysisHistory {
  final MealAnalysisRepository repository;

  GetMealAnalysisHistory(this.repository);

  Future<List<MealAnalysisResult>> call({
    required String userId,
    required int page,
    required int pageSize,
  }) {
    return repository.getMealAnalysisHistory(
      userId: userId,
      page: page,
      pageSize: pageSize,
    );
  }
}
