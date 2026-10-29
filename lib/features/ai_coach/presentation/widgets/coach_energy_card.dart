import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/responsive/responsive_value.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../models/coach_context.dart';
import '../models/coach_format.dart';
import 'coach_metric_tile.dart';
import 'coach_pill.dart';

/// "Today's progress & remaining energy" summary with four metric tiles.
class CoachEnergyCard extends StatelessWidget {
  const CoachEnergyCard({super.key, required this.coachContext});

  final CoachContext coachContext;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final text = context.textTheme;
    final ai = context.aiColors;
    final percent = coachContext.caloriePercent;

    final padding = responsiveValue<double>(
      context,
      xs: ThemeDimensions.spaceMd,
      md: ThemeDimensions.space20,
      lg: ThemeDimensions.spaceLg,
    );

    return Card(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: ThemeDimensions.spaceSm,
              runSpacing: ThemeDimensions.spaceSm,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: ai.soft,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.sync, size: 20, color: ai.onSoft),
                    ),
                    const SizedBox(width: ThemeDimensions.space12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('coachEnergyTitle'),
                            style: text.titleMedium,
                          ),
                          Text(
                            context.tr('coachEnergySubtitle'),
                            style: text.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (percent != null)
                  CoachPill(
                    compact: true,
                    label: context.tr(
                      'coachTargetMet',
                      {'percent': percent.toString()},
                    ),
                    background: ai.soft,
                    foreground: ai.onSoft,
                    borderColor: ai.border,
                  ),
              ],
            ),
            const SizedBox(height: ThemeDimensions.spaceMd),
            switch (coachContext.status) {
              CoachContextStatus.loading => const Padding(
                  padding: EdgeInsets.all(ThemeDimensions.spaceLg),
                  child: Center(child: CircularProgressIndicator()),
                ),
              CoachContextStatus.error => Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: context.colorScheme.error, size: 20),
                    const SizedBox(width: ThemeDimensions.spaceSm),
                    Expanded(
                      child: Text(
                        context.tr('coachContextError'),
                        style: text.bodyMedium
                            ?.copyWith(color: surfaces.textSecondary),
                      ),
                    ),
                    TextButton(
                      onPressed: coachContext.onRetry,
                      child: Text(context.tr('retry')),
                    ),
                  ],
                ),
              CoachContextStatus.ready => _MetricsGrid(
                  metrics: _buildMetrics(context),
                ),
            },
          ],
        ),
      ),
    );
  }

  List<CoachMetric> _buildMetrics(BuildContext context) {
    final colors = CoachMacroColors.of(context);
    final c = coachContext;

    String macroStatus(double consumed, double? target) {
      if (target == null) {
        return context.tr(
          'coachGramsLogged',
          {'value': formatCoachNumber(consumed)},
        );
      }
      final difference = target - consumed;
      return difference >= 0
          ? context.tr(
              'coachGramsRemaining',
              {'value': formatCoachNumber(difference)},
            )
          : context.tr(
              'coachGramsOver',
              {'value': formatCoachNumber(-difference)},
            );
    }

    final calorieTarget = c.calorieTarget;
    final calorieStatus = calorieTarget == null
        ? context.tr('coachNoTarget')
        : calorieTarget - c.consumedCalories >= 0
            ? context.tr('coachKcalRemaining', {
                'value': formatCoachNumber(calorieTarget - c.consumedCalories),
              })
            : context.tr('coachKcalOver', {
                'value': formatCoachNumber(c.consumedCalories - calorieTarget),
              });

    return [
      CoachMetric(
        label: context.tr('coachEnergyBalance'),
        icon: Icons.local_fire_department_outlined,
        color: colors.calories,
        consumed: c.consumedCalories,
        target: calorieTarget,
        status: calorieStatus,
      ),
      CoachMetric(
        label: context.tr('coachProtein'),
        icon: Icons.fitness_center,
        color: colors.protein,
        consumed: c.consumedProtein,
        target: c.proteinTarget,
        unitSuffix: 'g',
        status: macroStatus(c.consumedProtein, c.proteinTarget),
      ),
      CoachMetric(
        label: context.tr('coachCarbs'),
        icon: Icons.grain,
        color: colors.carbs,
        consumed: c.consumedCarbs,
        target: c.carbsTarget,
        unitSuffix: 'g',
        status: macroStatus(c.consumedCarbs, c.carbsTarget),
      ),
      CoachMetric(
        label: context.tr('coachFats'),
        icon: Icons.water_drop_outlined,
        color: colors.fats,
        consumed: c.consumedFat,
        target: c.fatTarget,
        unitSuffix: 'g',
        status: macroStatus(c.consumedFat, c.fatTarget),
      ),
    ];
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.metrics});

  final List<CoachMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = ThemeDimensions.spaceMd;
        final columns = constraints.maxWidth >= 640 ? 4 : 2;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final metric in metrics)
              SizedBox(width: width, child: CoachMetricTile(metric: metric)),
          ],
        );
      },
    );
  }
}
