import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nutri_vision/features/meal_analysis/domain/entities/meal_analysis_result.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/cubit/meal_analysis_cubit.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/cubit/meal_analysis_state.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_content.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_status_views.dart';
import 'package:nutri_vision/features/meal_tracking/presentation/cubit/meal_cubit.dart';

class MealAnalysisRouteArguments {
  const MealAnalysisRouteArguments.fromResult(MealAnalysisResult result)
    : initialResult = result,
      analysisId = null,
      userId = null;

  const MealAnalysisRouteArguments.byId({
    required this.analysisId,
    required this.userId,
  }) : initialResult = null;

  final MealAnalysisResult? initialResult;
  final String? analysisId;
  final String? userId;
}

/// Meal analysis result screen.
///
/// Provide either:
/// * [initialResult] — e.g. right after an analysis finished elsewhere; or
/// * [analysisId] + [userId] — the page loads it through the existing
///   [MealAnalysisCubit] (`getAnalysisById`).
///
/// The page only builds the screen body inside a minimal [Scaffold]. When the
/// app shell (adaptive navigation) exists, reuse [MealAnalysisContent] inside
/// it instead of duplicating navigation here.
///
/// Optional callbacks let owning features add actions to the result screen.
class MealAnalysisPage extends StatelessWidget {
  const MealAnalysisPage({
    super.key,
    this.initialResult,
    this.analysisId,
    this.userId,
    this.onEditPortions,
    this.onAskDietitian,
    this.onApplyRecommendation,
    this.onDownloadPdf,
    this.onShareWithDietitian,
  }) : assert(
         initialResult != null || (analysisId != null && userId != null),
         'Provide initialResult or both analysisId and userId.',
       );

  final MealAnalysisResult? initialResult;
  final String? analysisId;
  final String? userId;
  final VoidCallback? onEditPortions;
  final VoidCallback? onAskDietitian;
  final VoidCallback? onApplyRecommendation;
  final VoidCallback? onDownloadPdf;
  final VoidCallback? onShareWithDietitian;

  Widget _content(MealAnalysisResult result) => MealAnalysisContent(
    result: result,
    onEditPortions: onEditPortions,
    onAskDietitian: onAskDietitian,
    onApplyRecommendation: onApplyRecommendation,
    onDownloadPdf: onDownloadPdf,
    onShareWithDietitian: onShareWithDietitian,
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MealCubit>(create: (_) => GetIt.instance<MealCubit>()),
        BlocProvider<MealAnalysisCubit>(
          create: (_) {
            final cubit = GetIt.instance<MealAnalysisCubit>();
            if (initialResult == null) {
              cubit.getAnalysisById(analysisId: analysisId!, userId: userId!);
            }
            return cubit;
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: initialResult != null
              ? _content(initialResult!)
              : _LoadedBody(
                  analysisId: analysisId!,
                  userId: userId!,
                  contentBuilder: _content,
                ),
        ),
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({
    required this.analysisId,
    required this.userId,
    required this.contentBuilder,
  });

  final String analysisId;
  final String userId;
  final Widget Function(MealAnalysisResult result) contentBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealAnalysisCubit, MealAnalysisState>(
      builder: (context, state) {
        if (state is MealAnalysisDetailsSuccess) {
          final result = state.result;
          return result == null
              ? const MealAnalysisEmptyView()
              : contentBuilder(result);
        }
        if (state is MealAnalysisSuccess) return contentBuilder(state.result);
        if (state is MealAnalysisSaveLoading) {
          return contentBuilder(state.result);
        }
        if (state is MealAnalysisSaveSuccess) {
          return contentBuilder(state.result);
        }
        if (state is MealAnalysisSaveFailure) {
          return contentBuilder(state.result);
        }
        if (state is MealAnalysisFailure) {
          return MealAnalysisErrorView(
            message: state.message,
            onRetry: () => context.read<MealAnalysisCubit>().getAnalysisById(
              analysisId: analysisId,
              userId: userId,
            ),
          );
        }
        return const MealAnalysisLoadingView();
      },
    );
  }
}
