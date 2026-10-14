
import '../../domain/entities/meal_analysis_request.dart';
import '../../domain/entities/meal_analysis_result.dart';
import '../../domain/repositories/meal_analysis_repository.dart';
import '../datasources/meal_analysis_remote_data_source.dart';
import '../datasources/meal_analysis_local_data_source.dart';

abstract class MealAnalysisRepositoryImpl
    implements MealAnalysisRepository {
  final MealAnalysisRemoteDataSource remoteDataSource;
  final MealAnalysisLocalDataSource localDataSource;

  MealAnalysisRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<MealAnalysisResult> analyzeMealFromText({
    required MealAnalysisRequest request,
  });

  @override
  Future<MealAnalysisResult> analyzeMealFromImage({
    required MealAnalysisRequest request,
  });

  @override
  Future<MealAnalysisResult?> getMealAnalysisById({
    required String analysisId,
    required String userId,
  });

  @override
  Future<MealAnalysisResult> saveMealAnalysis({
    required MealAnalysisResult result,
  });

  @override
  Future<List<MealAnalysisResult>>
      getMealAnalysisHistory({
    required String userId,
    required int page,
    required int pageSize,
  });
}