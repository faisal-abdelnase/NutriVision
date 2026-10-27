import '../../domain/entities/meal_analysis_result.dart';

abstract class MealAnalysisState {
  const MealAnalysisState();
}

class MealAnalysisInitial extends MealAnalysisState {
  const MealAnalysisInitial();
}

class MealAnalysisLoading extends MealAnalysisState {
  const MealAnalysisLoading();
}

class MealAnalysisSuccess extends MealAnalysisState {
  final MealAnalysisResult result;

  const MealAnalysisSuccess(this.result);
}

class MealAnalysisFailure extends MealAnalysisState {
  final String message;

  const MealAnalysisFailure(this.message);
}

class MealAnalysisDetailsLoading extends MealAnalysisState {
  const MealAnalysisDetailsLoading();
}

class MealAnalysisDetailsSuccess extends MealAnalysisState {
  final MealAnalysisResult? result;

  const MealAnalysisDetailsSuccess(this.result);
}

class MealAnalysisHistoryLoading extends MealAnalysisState {
  const MealAnalysisHistoryLoading();
}

class MealAnalysisHistorySuccess extends MealAnalysisState {
  final List<MealAnalysisResult> results;
  final int page;
  final bool hasMore;

  const MealAnalysisHistorySuccess({
    required this.results,
    required this.page,
    required this.hasMore,
  });
}

class MealAnalysisHistoryFailure extends MealAnalysisState {
  final String message;

  const MealAnalysisHistoryFailure(this.message);
}

class MealAnalysisSaveLoading extends MealAnalysisState {
  final MealAnalysisResult result;

  const MealAnalysisSaveLoading(this.result);
}

class MealAnalysisSaveSuccess extends MealAnalysisState {
  final MealAnalysisResult result;

  const MealAnalysisSaveSuccess(this.result);
}

class MealAnalysisSaveFailure extends MealAnalysisState {
  final String message;
  final MealAnalysisResult result;

  const MealAnalysisSaveFailure(this.message, {required this.result});
}
