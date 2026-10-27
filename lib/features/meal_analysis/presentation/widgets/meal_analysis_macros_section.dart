import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/features/meal_analysis/domain/entities/meal_analysis_result.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/utils/meal_analysis_summary.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/macro_metric_card.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_grid.dart';

/// Macro totals and their energy contributions from the analysis result.
class MealAnalysisMacrosSection extends StatelessWidget {
  const MealAnalysisMacrosSection({
    super.key,
    required this.result,
    required this.summary,
  });

  final MealAnalysisResult result;
  final MealAnalysisSummary summary;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final nutrition = context.nutritionColors;
    final textTheme = context.textTheme;
    final unitG = context.tr('unitG');

    Widget legend(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: surfaces.textSecondary),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: ThemeDimensions.spaceMd,
          runSpacing: ThemeDimensions.spaceSm,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.tr('mealAnalysisMacrosTitle'),
                  style: textTheme.headlineSmall,
                ),
                Text(
                  context.tr('mealAnalysisMacrosSubtitle'),
                  style: textTheme.bodySmall?.copyWith(
                    color: surfaces.textSecondary,
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: ThemeDimensions.space12,
              children: [
                legend(nutrition.protein, context.tr('mealAnalysisProtein')),
                legend(
                  nutrition.carbohydrates,
                  context.tr('mealAnalysisCarbs'),
                ),
                legend(nutrition.fats, context.tr('mealAnalysisFatsShort')),
              ],
            ),
          ],
        ),
        const SizedBox(height: ThemeDimensions.spaceMd),
        MealAnalysisGrid(
          sm: 2,
          lg: 4,
          children: [
            MacroMetricCard(
              icon: Icons.local_fire_department_outlined,
              label: context.tr('mealAnalysisCalories'),
              value: formatMetric(result.totalCalories),
              unit: context.tr('unitKcal'),
              caption: context.tr('mealAnalysisCaloriesSubtitle'),
              color: nutrition.calories,
              softColor: nutrition.caloriesSoft,
            ),
            MacroMetricCard(
              icon: Icons.fitness_center,
              label: context.tr('mealAnalysisProtein'),
              value: formatMetric(result.totalProteinGrams, decimals: 1),
              unit: unitG,
              caption: context.tr('mealAnalysisMacroEnergyShare', {
                'percent': '${summary.proteinEnergyPercent}',
              }),
              progress: summary.proteinEnergyPercent / 100,
              color: nutrition.protein,
              softColor: nutrition.proteinSoft,
            ),
            MacroMetricCard(
              icon: Icons.grain,
              label: context.tr('mealAnalysisCarbs'),
              value: formatMetric(result.totalCarbohydrateGrams, decimals: 1),
              unit: unitG,
              caption: context.tr('mealAnalysisMacroEnergyShare', {
                'percent': '${summary.carbEnergyPercent}',
              }),
              progress: summary.carbEnergyPercent / 100,
              color: nutrition.carbohydrates,
              softColor: nutrition.carbohydratesSoft,
            ),
            MacroMetricCard(
              icon: Icons.opacity,
              label: context.tr('mealAnalysisFats'),
              value: formatMetric(result.totalFatGrams, decimals: 1),
              unit: unitG,
              caption: context.tr('mealAnalysisMacroEnergyShare', {
                'percent': '${summary.fatEnergyPercent}',
              }),
              progress: summary.fatEnergyPercent / 100,
              color: nutrition.fats,
              softColor: nutrition.fatsSoft,
            ),
          ],
        ),
      ],
    );
  }
}
