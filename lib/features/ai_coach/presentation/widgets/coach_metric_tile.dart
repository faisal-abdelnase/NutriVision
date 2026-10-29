import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/theme_text_styles.dart';
import '../models/coach_format.dart';

/// Metric number style: heading family with tabular figures.
TextStyle coachMetricStyle(BuildContext context, {Color? color}) {
  final locale = Localizations.localeOf(context);
  return ThemeTextStyles.tabularFigures(ThemeTextStyles.metricNum).copyWith(
    fontFamily: ThemeTextStyles.headingFamilyFor(locale),
    color: color ?? context.surfaceColors.textPrimary,
  );
}

/// Colors shared by the energy tiles and the macro dial: green for energy
/// and protein, blue for carbohydrates, orange for fats.
class CoachMacroColors {
  const CoachMacroColors({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  factory CoachMacroColors.of(BuildContext context) {
    final scheme = context.colorScheme;
    return CoachMacroColors(
      calories: scheme.primary,
      protein: scheme.primary,
      carbs: context.statusColors.info,
      fats: scheme.tertiary,
    );
  }

  final Color calories;
  final Color protein;
  final Color carbs;
  final Color fats;
}

class CoachMetric {
  const CoachMetric({
    required this.label,
    required this.icon,
    required this.color,
    required this.consumed,
    required this.status,
    this.target,
    this.unitSuffix = '',
  });

  final String label;
  final IconData icon;
  final Color color;
  final double consumed;
  final double? target;
  final String unitSuffix;
  final String status;

  double? get progress {
    final value = target;
    if (value == null || value <= 0) return null;
    return (consumed / value).clamp(0.0, 1.0).toDouble();
  }
}

class CoachMetricTile extends StatelessWidget {
  const CoachMetricTile({super.key, required this.metric});

  final CoachMetric metric;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final text = context.textTheme;
    final locale = Localizations.localeOf(context);
    final target = metric.target;
    final progress = metric.progress;

    return Container(
      padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
      decoration: BoxDecoration(
        color: surfaces.level2,
        borderRadius: ThemeDimensions.borderRadiusMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  ThemeTextStyles.clinicalCase(metric.label, locale),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelSmall,
                ),
              ),
              Icon(metric.icon, size: 16, color: metric.color),
            ],
          ),
          const SizedBox(height: ThemeDimensions.spaceSm),
          Text.rich(
            TextSpan(
              text: formatCoachNumber(metric.consumed),
              style: coachMetricStyle(context),
              children: [
                if (target != null)
                  TextSpan(
                    text:
                        ' / ${formatCoachNumber(target)}${metric.unitSuffix}',
                    style: text.bodySmall,
                  ),
              ],
            ),
          ),
          const SizedBox(height: ThemeDimensions.spaceXs),
          Text(
            metric.status,
            style: text.labelSmall?.copyWith(color: metric.color),
          ),
          const SizedBox(height: ThemeDimensions.spaceSm),
          ClipRRect(
            borderRadius: ThemeDimensions.borderRadiusPill,
            child: LinearProgressIndicator(
              value: progress ?? 0,
              minHeight: 6,
              color: metric.color,
              backgroundColor: surfaces.border,
            ),
          ),
        ],
      ),
    );
  }
}
