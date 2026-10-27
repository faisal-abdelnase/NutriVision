import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/theme/theme_text_styles.dart';
import 'package:nutri_vision/features/meal_analysis/domain/entities/meal_analysis_result.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/utils/meal_analysis_insights.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_card.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_grid.dart';

/// AI insights. REAL data: backend insights/warnings/summary when present,
/// otherwise simple insights derived from the real macro totals.
///
/// [onApplyRecommendation] belongs to the diet-plan feature and is only shown
/// when that feature supplies a callback.
class MealAnalysisInsightsSection extends StatelessWidget {
  const MealAnalysisInsightsSection({
    super.key,
    required this.result,
    this.onApplyRecommendation,
  });

  final MealAnalysisResult result;
  final VoidCallback? onApplyRecommendation;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final ai = context.aiColors;
    final textTheme = context.textTheme;
    final insights = buildMealInsights(result);
    final positives = insights.where((i) => !i.isWarning).toList();
    final warnings = insights.where((i) => i.isWarning).toList();
    final summary = result.analysisSummary?.trim();

    return MealAnalysisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeDimensions.spaceSm),
                decoration: BoxDecoration(
                  color: ai.soft,
                  borderRadius: ThemeDimensions.borderRadiusMedium,
                  border: Border.all(color: ai.border),
                ),
                child: Icon(AIThemeColors.icon, size: 20, color: ai.accent),
              ),
              const SizedBox(width: ThemeDimensions.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('mealAnalysisInsightsTitle'),
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      context.tr('mealAnalysisInsightsSubtitle'),
                      style: textTheme.bodySmall?.copyWith(
                        color: surfaces.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: ThemeDimensions.spaceMd),
          if (insights.isEmpty)
            Text(
              context.tr('mealAnalysisNoInsights'),
              style: textTheme.bodyMedium?.copyWith(
                color: surfaces.textSecondary,
              ),
            ),
          if (positives.isNotEmpty)
            MealAnalysisGrid(
              md: 2,
              children: [for (final i in positives) _InsightTile(insight: i)],
            ),
          if (positives.isNotEmpty && warnings.isNotEmpty)
            const SizedBox(height: ThemeDimensions.space12),
          for (final i in warnings) ...[
            _InsightTile(insight: i),
            const SizedBox(height: ThemeDimensions.space12),
          ],
          if (summary != null && summary.isNotEmpty) ...[
            const SizedBox(height: ThemeDimensions.spaceXs),
            _Recommendation(text: summary, onApply: onApplyRecommendation),
          ],
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({required this.insight});

  final MealInsight insight;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final status = context.statusColors;
    final textTheme = context.textTheme;

    final isWarning = insight.isWarning;
    final background = isWarning ? status.warningContainer : surfaces.level2;
    final titleColor = isWarning
        ? status.onWarningContainer
        : surfaces.textPrimary;
    final bodyColor = isWarning
        ? status.onWarningContainer
        : surfaces.textSecondary;

    final title = insight.text ?? context.tr(insight.titleKey!, insight.params);
    final description = insight.descriptionKey == null
        ? null
        : context.tr(insight.descriptionKey!, insight.params);

    return Container(
      padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
      decoration: BoxDecoration(
        color: background,
        borderRadius: ThemeDimensions.borderRadiusMedium,
        border: isWarning
            ? Border.all(color: status.warning.withValues(alpha: 0.4))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isWarning ? Icons.warning_amber_rounded : Icons.check_circle,
            size: 20,
            color: isWarning ? status.warning : status.success,
          ),
          const SizedBox(width: ThemeDimensions.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.labelLarge?.copyWith(color: titleColor),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: textTheme.bodySmall?.copyWith(color: bodyColor),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Recommendation extends StatelessWidget {
  const _Recommendation({required this.text, this.onApply});

  final String text;
  final VoidCallback? onApply;

  @override
  Widget build(BuildContext context) {
    final status = context.statusColors;
    final textTheme = context.textTheme;
    final locale = Localizations.localeOf(context);

    final body = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.lightbulb_outline, size: 20, color: status.info),
        const SizedBox(width: ThemeDimensions.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ThemeTextStyles.clinicalCase(
                  context.tr('mealAnalysisRecommendationTitle'),
                  locale,
                ),
                style: textTheme.labelSmall?.copyWith(
                  color: status.onInfoContainer,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: textTheme.bodyMedium?.copyWith(
                  color: status.onInfoContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
      decoration: BoxDecoration(
        color: status.infoContainer,
        borderRadius: ThemeDimensions.borderRadiusMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          body,
          if (onApply != null) ...[
            const SizedBox(height: ThemeDimensions.space12),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: OutlinedButton.icon(
                onPressed: onApply,
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: Text(context.tr('mealAnalysisApplyToPlan')),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
