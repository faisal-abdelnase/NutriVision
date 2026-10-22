import '../../domain/entities/meal_analysis_request.dart';
import '../../domain/entities/meal_analysis_result.dart';
import '../../domain/repositories/meal_analysis_repository.dart';
import '../datasources/meal_analysis_local_data_source.dart';
import '../datasources/meal_analysis_remote_data_source.dart';
import '../models/meal_analysis_request_model.dart';
import '../models/meal_analysis_result_model.dart';

class MealAnalysisRepositoryImpl implements MealAnalysisRepository {
  final MealAnalysisRemoteDataSource remoteDataSource;
  final MealAnalysisLocalDataSource localDataSource;

  MealAnalysisRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  MealAnalysisRequestModel _requestModel(
    MealAnalysisRequest request,
  ) {
    return MealAnalysisRequestModel(
      userId: request.userId,
      description: request.description,
      imagePath: request.imagePath,
      mealType: request.mealType,
      servingSizeGrams: request.servingSizeGrams,
      dietaryPreferences: request.dietaryPreferences,
      allergies: request.allergies,
    );
  }

  Future<MealAnalysisResult> _cacheResult(
    MealAnalysisResultModel result,
  ) async {
    await localDataSource.cacheMealAnalysis(result: result);
    return result;
  }

  @override
  Future<MealAnalysisResult> analyzeMealFromText({
    required MealAnalysisRequest request,
  }) async {
    final result = await remoteDataSource.analyzeMealFromText(
      request: _requestModel(request),
    );

    await remoteDataSource.saveMealAnalysis(result: result);
    return _cacheResult(result);
  }

  @override
  Future<MealAnalysisResult> analyzeMealFromImage({
    required MealAnalysisRequest request,
  }) async {
    final result = await remoteDataSource.analyzeMealFromImage(
      request: _requestModel(request),
    );

    await remoteDataSource.saveMealAnalysis(result: result);
    return _cacheResult(result);
  }

  @override
  Future<MealAnalysisResult?> getMealAnalysisById({
    required String analysisId,
    required String userId,
  }) async {
    try {
      final result = await remoteDataSource.fetchMealAnalysisById(
        analysisId: analysisId,
        userId: userId,
      );

      if (result != null) {
        await localDataSource.cacheMealAnalysis(result: result);
        return result;
      }

      return await localDataSource.getCachedMealAnalysis(
        analysisId: analysisId,
      );
    } catch (_) {
      final cached = await localDataSource.getCachedMealAnalysis(
        analysisId: analysisId,
      );

      if (cached != null && cached.userId == userId) {
        return cached;
      }

      rethrow;
    }
  }

  @override
  Future<MealAnalysisResult> saveMealAnalysis({
    required MealAnalysisResult result,
  }) async {
    final model = MealAnalysisResultModel.fromEntity(result);

    final saved = await remoteDataSource.saveMealAnalysis(
      result: model,
    );

    return _cacheResult(saved);
  }

  @override
  Future<List<MealAnalysisResult>> getMealAnalysisHistory({
    required String userId,
    required int page,
    required int pageSize,
  }) async {
    try {
      final results =
          await remoteDataSource.fetchMealAnalysisHistory(
        userId: userId,
        page: page,
        pageSize: pageSize,
      );

      for (final result in results) {
        await localDataSource.cacheMealAnalysis(result: result);
      }

      return results;
    } catch (_) {
      final cached =
          await localDataSource.getCachedMealAnalysisHistory(
        userId: userId,
      );

      final start = (page - 1) * pageSize;

      if (start >= cached.length) return [];

      final end = (start + pageSize).clamp(0, cached.length);

      return cached.sublist(start, end);
    }
  }
}