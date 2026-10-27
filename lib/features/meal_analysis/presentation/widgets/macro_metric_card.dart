import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/theme/theme_text_styles.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_card.dart';

/// One macro tile: icon, label, big value + unit, caption and progress bar.
class MacroMetricCard extends StatelessWidget {
  const MacroMetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.caption,
    this.progress,
    required this.color,
    required this.softColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final String caption;

  /// Optional 0..1 proportion derived from the analysis.
  final double? progress;
  final Color color;
  final Color softColor;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final textTheme = context.textTheme;

    return MealAnalysisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: textTheme.labelMedium?.copyWith(
                        color: surfaces.textSecondary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(ThemeDimensions.spaceSm),
                    decoration: BoxDecoration(
                      color: softColor,
                      borderRadius: ThemeDimensions.borderRadiusMedium,
                    ),
                    child: Icon(icon, size: 18, color: color),
                  ),
                ],
              ),
              const SizedBox(height: ThemeDimensions.spaceSm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: ThemeTextStyles.tabularFigures(
                      textTheme.headlineLarge!.copyWith(
                        fontSize: 26,
                        color: surfaces.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    unit,
                    style: textTheme.bodySmall?.copyWith(
                      color: surfaces.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ThemeDimensions.spaceXs),
              Text(
                caption,
                style: textTheme.bodySmall?.copyWith(
                  color: surfaces.textSecondary,
                ),
              ),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: ThemeDimensions.spaceMd),
            ClipRRect(
              borderRadius: ThemeDimensions.borderRadiusPill,
              child: LinearProgressIndicator(
                value: progress!.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: surfaces.level2,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
