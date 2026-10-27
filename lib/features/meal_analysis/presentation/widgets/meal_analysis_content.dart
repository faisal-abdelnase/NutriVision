import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/responsive/breakpoints.dart';
import 'package:nutri_vision/core/responsive/responsive_padding.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/features/meal_analysis/domain/entities/meal_analysis_result.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/utils/meal_analysis_meal_mapper.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/utils/meal_analysis_summary.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_export_card.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_facts_card.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_food_items_section.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_header.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_hero_card.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_insights_section.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_macros_section.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/cubit/meal_analysis_cubit.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/cubit/meal_analysis_state.dart';
import 'package:nutri_vision/features/meal_tracking/presentation/cubit/meal_cubit.dart';
import 'package:nutri_vision/features/meal_tracking/presentation/cubit/meal_state.dart';

/// Scrollable composition of the whole meal analysis screen.
///
/// Requires [MealCubit] for logging and [MealAnalysisCubit] for persisting the
/// meal-to-analysis link after logging succeeds.
/// Optional actions are only rendered when callbacks are supplied.
class MealAnalysisContent extends StatelessWidget {
  const MealAnalysisContent({
    super.key,
    required this.result,
    this.onEditPortions,
    this.onAskDietitian,
    this.onApplyRecommendation,
    this.onDownloadPdf,
    this.onShareWithDietitian,
  });

  final MealAnalysisResult result;
  final VoidCallback? onEditPortions;
  final VoidCallback? onAskDietitian;
  final VoidCallback? onApplyRecommendation;
  final VoidCallback? onDownloadPdf;
  final VoidCallback? onShareWithDietitian;

  @override
  Widget build(BuildContext context) {
    final summary = MealAnalysisSummary.fromResult(result);
    const sectionGap = SizedBox(height: ThemeDimensions.spaceXl);

    return BlocListener<MealAnalysisCubit, MealAnalysisState>(
      listenWhen: (previous, current) => current is MealAnalysisSaveFailure,
      listener: (context, state) {
        final failure = state as MealAnalysisSaveFailure;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                '${context.tr('mealAnalysisLinkSaveFailed')} ${failure.message}',
              ),
            ),
          );
      },
      child: BlocListener<MealCubit, MealState>(
        listenWhen: (previous, current) =>
            current is MealOperationSuccess || current is MealError,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar();

          if (state is MealOperationSuccess) {
            messenger.showSnackBar(
              SnackBar(content: Text(context.tr('mealAnalysisLogSuccess'))),
            );
            final loggedMeal = state.meal;
            if (loggedMeal != null && result.linkedMealId == null) {
              unawaited(
                context.read<MealAnalysisCubit>().saveResult(
                  result: result.copyWith(linkedMealId: loggedMeal.id),
                ),
              );
            }
            return;
          }

          final error = state as MealError;
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                '${context.tr('mealAnalysisLogFailed')} ${error.message}',
              ),
            ),
          );
        },
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: ThemeDimensions.contentMaxWidth,
              ),
              child: ResponsivePadding(
                vertical: ThemeDimensions.spaceLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BlocBuilder<MealCubit, MealState>(
                      buildWhen: (previous, current) =>
                          current is MealLoading ||
                          current is MealOperationSuccess ||
                          current is MealError,
                      builder: (context, state) => MealAnalysisHeader(
                        logId: summary.shortId,
                        isLogging: state is MealLoading,
                        isLogged:
                            result.linkedMealId != null ||
                            state is MealOperationSuccess,
                        onConfirm: result.linkedMealId == null
                            ? () => context.read<MealCubit>().addMeal(
                                meal: MealAnalysisMealMapper.toMeal(result),
                              )
                            : null,
                        onEditPortions: onEditPortions,
                        onAskDietitian: onAskDietitian,
                      ),
                    ),
                    sectionGap,
                    _HeroAndFacts(result: result, summary: summary),
                    sectionGap,
                    MealAnalysisFoodItemsSection(result: result),
                    sectionGap,
                    MealAnalysisMacrosSection(result: result, summary: summary),
                    sectionGap,
                    MealAnalysisInsightsSection(
                      result: result,
                      onApplyRecommendation: onApplyRecommendation,
                    ),
                    if (onDownloadPdf != null ||
                        onShareWithDietitian != null) ...[
                      sectionGap,
                      MealAnalysisExportCard(
                        onDownloadPdf: onDownloadPdf,
                        onShareWithDietitian: onShareWithDietitian,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroAndFacts extends StatelessWidget {
  const _HeroAndFacts({required this.result, required this.summary});

  final MealAnalysisResult result;
  final MealAnalysisSummary summary;

  @override
  Widget build(BuildContext context) {
    final hero = MealAnalysisHeroCard(result: result, summary: summary);
    final facts = MealAnalysisFactsCard(result: result, summary: summary);

    return LayoutBuilder(
      builder: (context, constraints) {
        final gutter = ThemeBreakpoints.gutterFor(constraints.maxWidth);

        if (constraints.maxWidth >= Breakpoints.lg) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 7, child: hero),
                SizedBox(width: gutter),
                Expanded(flex: 5, child: facts),
              ],
            ),
          );
        }
        return Column(
          children: [
            hero,
            SizedBox(height: gutter),
            facts,
          ],
        );
      },
    );
  }
}
