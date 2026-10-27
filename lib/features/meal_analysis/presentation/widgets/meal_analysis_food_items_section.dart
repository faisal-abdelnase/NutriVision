import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/features/meal_analysis/domain/entities/analyzed_food_item.dart';
import 'package:nutri_vision/features/meal_analysis/domain/entities/meal_analysis_result.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/utils/meal_analysis_summary.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_card.dart';

class MealAnalysisFoodItemsSection extends StatelessWidget {
  const MealAnalysisFoodItemsSection({super.key, required this.result});

  final MealAnalysisResult result;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('mealAnalysisFoodsTitle'),
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: ThemeDimensions.spaceMd),
        MealAnalysisCard(
          child: result.foodItems.isEmpty
              ? Text(
                  context.tr('mealAnalysisNoDetectedFoods'),
                  style: textTheme.bodyMedium?.copyWith(
                    color: surfaces.textSecondary,
                  ),
                )
              : Column(
                  children: [
                    for (
                      var index = 0;
                      index < result.foodItems.length;
                      index++
                    ) ...[
                      _FoodItemRow(item: result.foodItems[index]),
                      if (index < result.foodItems.length - 1) ...[
                        const SizedBox(height: ThemeDimensions.spaceMd),
                        Divider(height: 1, color: surfaces.border),
                        const SizedBox(height: ThemeDimensions.spaceMd),
                      ],
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _FoodItemRow extends StatelessWidget {
  const _FoodItemRow({required this.item});

  final AnalyzedFoodItem item;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final nutrition = context.nutritionColors;
    final textTheme = context.textTheme;
    final quantity = [
      formatMetric(item.estimatedQuantity, decimals: 1),
      item.quantityUnit,
    ].where((part) => part.trim().isNotEmpty).join(' ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeDimensions.spaceSm),
          decoration: BoxDecoration(
            color: surfaces.level2,
            borderRadius: ThemeDimensions.borderRadiusMedium,
          ),
          child: Icon(
            Icons.restaurant_outlined,
            color: nutrition.protein,
            size: 20,
          ),
        ),
        const SizedBox(width: ThemeDimensions.spaceMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, style: textTheme.titleSmall),
              if (quantity.isNotEmpty) ...[
                const SizedBox(height: ThemeDimensions.spaceXs),
                Text(
                  quantity,
                  style: textTheme.bodySmall?.copyWith(
                    color: surfaces.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: ThemeDimensions.spaceSm),
              Wrap(
                spacing: ThemeDimensions.spaceMd,
                runSpacing: ThemeDimensions.spaceXs,
                children: [
                  _NutrientValue(
                    label: context.tr('mealAnalysisCalories'),
                    value:
                        '${formatMetric(item.calories)} ${context.tr('unitKcal')}',
                  ),
                  _NutrientValue(
                    label: context.tr('mealAnalysisProtein'),
                    value:
                        '${formatMetric(item.proteinGrams, decimals: 1)} ${context.tr('unitG')}',
                  ),
                  _NutrientValue(
                    label: context.tr('mealAnalysisCarbs'),
                    value:
                        '${formatMetric(item.carbohydrateGrams, decimals: 1)} ${context.tr('unitG')}',
                  ),
                  _NutrientValue(
                    label: context.tr('mealAnalysisFatsShort'),
                    value:
                        '${formatMetric(item.fatGrams, decimals: 1)} ${context.tr('unitG')}',
                  ),
                ],
              ),
              if (item.confidenceScore != null) ...[
                const SizedBox(height: ThemeDimensions.spaceXs),
                Text(
                  context.tr('mealAnalysisItemConfidence', {
                    'value': formatMetric(
                      normalizePercent(item.confidenceScore!),
                      decimals: 1,
                    ),
                  }),
                  style: textTheme.bodySmall?.copyWith(
                    color: surfaces.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _NutrientValue extends StatelessWidget {
  const _NutrientValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final textTheme = context.textTheme;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: textTheme.bodySmall?.copyWith(color: surfaces.textMuted),
          ),
          TextSpan(text: value, style: textTheme.labelMedium),
        ],
      ),
    );
  }
}
