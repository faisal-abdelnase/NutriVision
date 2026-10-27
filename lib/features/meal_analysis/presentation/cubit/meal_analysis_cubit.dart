import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/meal_analysis_request.dart';
import '../../domain/entities/meal_analysis_result.dart';
import '../../domain/usecases/analyze_meal_from_image.dart';
import '../../domain/usecases/analyze_meal_from_text.dart';
import '../../domain/usecases/get_meal_analysis_by_id.dart';
import '../../domain/usecases/get_meal_analysis_history.dart';
import '../../domain/usecases/save_meal_analysis.dart';
import 'meal_analysis_state.dart';

class MealAnalysisCubit extends Cubit<MealAnalysisState> {
  final AnalyzeMealFromText analyzeMealFromText;
  final AnalyzeMealFromImage analyzeMealFromImage;
  final GetMealAnalysisById getMealAnalysisById;
  final GetMealAnalysisHistory getMealAnalysisHistory;
  final SaveMealAnalysis saveMealAnalysis;

  MealAnalysisCubit({
    required this.analyzeMealFromText,
    required this.analyzeMealFromImage,
    required this.getMealAnalysisById,
    required this.getMealAnalysisHistory,
    required this.saveMealAnalysis,
  }) : super(const MealAnalysisInitial());

  String _errorMessage(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  Future<void> analyzeText({
    required MealAnalysisRequest request,
  }) async {
    emit(const MealAnalysisLoading());

    try {
      final result = await analyzeMealFromText(request: request);
      emit(MealAnalysisSuccess(result));
    } catch (error) {
      emit(MealAnalysisFailure(_errorMessage(error)));
    }
  }

  Future<void> analyzeImage({
    required MealAnalysisRequest request,
  }) async {
    emit(const MealAnalysisLoading());

    try {
      final result = await analyzeMealFromImage(request: request);
      emit(MealAnalysisSuccess(result));
    } catch (error) {
      emit(MealAnalysisFailure(_errorMessage(error)));
    }
  }

  Future<void> getAnalysisById({
    required String analysisId,
    required String userId,
  }) async {
    emit(const MealAnalysisDetailsLoading());

    try {
      final result = await getMealAnalysisById(
        analysisId: analysisId,
        userId: userId,
      );

      emit(MealAnalysisDetailsSuccess(result));
    } catch (error) {
      emit(MealAnalysisFailure(_errorMessage(error)));
    }
  }

  Future<void> loadHistory({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    emit(const MealAnalysisHistoryLoading());

    try {
      final results = await getMealAnalysisHistory(
        userId: userId,
        page: page,
        pageSize: pageSize,
      );

      emit(
        MealAnalysisHistorySuccess(
          results: results,
          page: page,
          hasMore: results.length == pageSize,
        ),
      );
    } catch (error) {
      emit(MealAnalysisHistoryFailure(_errorMessage(error)));
    }
  }

  Future<void> saveResult({
    required MealAnalysisResult result,
  }) async {
    emit(MealAnalysisSaveLoading(result));

    try {
      final saved = await saveMealAnalysis(result: result);
      emit(MealAnalysisSaveSuccess(saved));
    } catch (error) {
      emit(
        MealAnalysisSaveFailure(
          _errorMessage(error),
          result: result,
        ),
      );
    }
  }
}
