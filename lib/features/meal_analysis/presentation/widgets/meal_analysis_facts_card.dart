import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/utils/formatters.dart';
import 'package:nutri_vision/features/meal_analysis/domain/entities/meal_analysis_result.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/utils/meal_analysis_summary.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_card.dart';

class MealAnalysisFactsCard extends StatelessWidget {
  const MealAnalysisFactsCard({
    super.key,
    required this.result,
    required this.summary,
  });

  final MealAnalysisResult result;
  final MealAnalysisSummary summary;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final status = context.statusColors;
    final textTheme = context.textTheme;

    return MealAnalysisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('mealAnalysisDetailsTitle'),
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: ThemeDimensions.spaceMd),
          if (summary.confidencePercent != null) ...[
            Row(
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: summary.confidencePercent! / 100,
                        strokeWidth: 6,
                        strokeCap: StrokeCap.round,
                        backgroundColor: surfaces.border,
                        valueColor: AlwaysStoppedAnimation(status.success),
                      ),
                      Text(
                        '${summary.confidencePercent!.round()}%',
                        style: textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: ThemeDimensions.spaceMd),
                Expanded(
                  child: Text(
                    context.tr('mealAnalysisConfidenceLabel'),
                    style: textTheme.bodyMedium?.copyWith(
                      color: surfaces.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: ThemeDimensions.spaceMd),
          ],
          _FactRow(
            icon: Icons.restaurant_menu,
            label: context.tr('mealAnalysisDetectedFoods'),
            value: '${result.foodItems.length}',
          ),
          const SizedBox(height: ThemeDimensions.spaceSm),
          _FactRow(
            icon: Icons.schedule,
            label: context.tr('mealAnalysisAnalyzedAt'),
            value: Formatters.time(result.analyzedAt),
          ),
          if (summary.totalWeightGrams > 0) ...[
            const SizedBox(height: ThemeDimensions.spaceSm),
            _FactRow(
              icon: Icons.scale_outlined,
              label: context.tr('mealAnalysisTotalWeight'),
              value: context.tr('mealAnalysisWeightValue', {
                'weight': formatMetric(summary.totalWeightGrams),
              }),
            ),
          ],
          if (result.linkedMealId != null) ...[
            const SizedBox(height: ThemeDimensions.spaceMd),
            Text(
              context.tr('mealAnalysisAlreadyLogged'),
              style: textTheme.labelMedium?.copyWith(color: status.success),
            ),
          ],
        ],
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final textTheme = context.textTheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: surfaces.textSecondary),
        const SizedBox(width: ThemeDimensions.spaceSm),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: surfaces.textSecondary),
          ),
        ),
        Text(value, style: textTheme.labelLarge),
      ],
    );
  }
}
