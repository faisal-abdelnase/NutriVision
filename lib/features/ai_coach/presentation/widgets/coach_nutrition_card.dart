import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/responsive/responsive_text.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/theme_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../models/coach_context.dart';
import '../models/coach_format.dart';
import 'coach_metric_tile.dart';
import 'coach_pill.dart';

/// Macro split dial plus the meals logged today.
class CoachNutritionCard extends StatelessWidget {
  const CoachNutritionCard({super.key, required this.coachContext});

  final CoachContext coachContext;

  @override
  Widget build(BuildContext context) {
    final text = context.textTheme;
    final ai = context.aiColors;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeDimensions.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: ai.soft,
                    borderRadius: ThemeDimensions.borderRadiusMedium,
                  ),
                  child: Icon(Icons.monitor_heart_outlined,
                      size: 18, color: ai.onSoft),
                ),
                const SizedBox(width: ThemeDimensions.spaceSm),
                Expanded(
                  child: Text(
                    context.tr('coachNutritionTitle'),
                    style: text.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: ThemeDimensions.spaceMd),
            if (coachContext.status == CoachContextStatus.loading)
              const Padding(
                padding: EdgeInsets.all(ThemeDimensions.spaceLg),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (coachContext.status == CoachContextStatus.error)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: coachContext.onRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(context.tr('retry')),
                ),
              )
            else ...[
              _MacroDial(coachContext: coachContext),
              const SizedBox(height: ThemeDimensions.spaceMd),
              _MealChronology(coachContext: coachContext),
            ],
          ],
        ),
      ),
    );
  }
}

class _MacroDial extends StatelessWidget {
  const _MacroDial({required this.coachContext});

  final CoachContext coachContext;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final colors = CoachMacroColors.of(context);
    final text = context.textTheme;
    final c = coachContext;
    final percent = c.caloriePercent;

    final segments = [
      _DialSegment(c.consumedProtein, colors.protein),
      _DialSegment(c.consumedCarbs, colors.carbs),
      _DialSegment(c.consumedFat, colors.fats),
    ];

    Widget legend(String label, Color color, double consumed, double? target) {
      final value = target == null
          ? '${formatCoachNumber(consumed)}g'
          : '${formatCoachNumber(consumed)}g / ${formatCoachNumber(target)}g';
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall
                      ?.copyWith(color: surfaces.textPrimary)),
            ),
            const SizedBox(width: 6),
            Text(
              value,
              style: ThemeTextStyles.tabularFigures(
                text.labelMedium ?? const TextStyle(),
              ).copyWith(color: surfaces.textPrimary),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
      decoration: BoxDecoration(
        color: surfaces.level2,
        borderRadius: ThemeDimensions.borderRadiusMedium,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size.square(96),
                  painter: _MacroDialPainter(
                    track: surfaces.border,
                    segments: segments,
                    strokeWidth: 10,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      percent == null ? '—' : '$percent%',
                      style: text.titleMedium,
                    ),
                    AppText(
                        ThemeTextStyles.clinicalCase(
                        context.tr('coachDialLabel'),
                        Localizations.localeOf(context),
                      ),
                      breakpoint: context.breakpoint,
                      baseFontSize: 7,
                      style: text.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: ThemeDimensions.spaceMd),
          Expanded(
            child: Column(
              children: [
                legend(context.tr('coachProtein'), colors.protein,
                    c.consumedProtein, c.proteinTarget),
                legend(context.tr('coachCarbs'), colors.carbs,
                    c.consumedCarbs, c.carbsTarget),
                legend(context.tr('coachFats'), colors.fats,
                    c.consumedFat, c.fatTarget),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DialSegment {
  const _DialSegment(this.value, this.color);

  final double value;
  final Color color;
}

class _MacroDialPainter extends CustomPainter {
  _MacroDialPainter({
    required this.track,
    required this.segments,
    required this.strokeWidth,
  });

  final Color track;
  final List<_DialSegment> segments;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = track;
    canvas.drawArc(rect, 0, math.pi * 2, false, trackPaint);

    final total = segments.fold<double>(0, (sum, s) => sum + s.value);
    if (total <= 0) return;

    var start = -math.pi / 2;
    for (final segment in segments) {
      if (segment.value <= 0) continue;
      final sweep = segment.value / total * math.pi * 2;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = segment.color;
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _MacroDialPainter old) =>
      old.track != track ||
      old.strokeWidth != strokeWidth ||
      old.segments.length != segments.length ||
      !_sameSegments(old.segments);

  bool _sameSegments(List<_DialSegment> other) {
    for (var i = 0; i < segments.length; i++) {
      if (segments[i].value != other[i].value ||
          segments[i].color != other[i].color) {
        return false;
      }
    }
    return true;
  }
}

class _MealChronology extends StatelessWidget {
  const _MealChronology({required this.coachContext});

  final CoachContext coachContext;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final text = context.textTheme;
    final locale = Localizations.localeOf(context);
    final meals = coachContext.recentMeals;
    final target = coachContext.calorieTarget;
    final remaining =
        target == null ? null : target - coachContext.consumedCalories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ThemeTextStyles.clinicalCase(context.tr('coachMealsTitle'), locale),
          style: text.labelSmall,
        ),
        const SizedBox(height: ThemeDimensions.spaceSm),
        if (meals.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              context.tr('coachNoMeals'),
              style: text.bodySmall?.copyWith(color: surfaces.textSecondary),
            ),
          )
        else
          for (final meal in meals)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: surfaces.level2,
                  borderRadius: ThemeDimensions.borderRadiusMedium,
                ),
                child: Row(
                  children: [
                    Icon(_iconFor(meal.eatenAt),
                        size: 18, color: context.colorScheme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text.labelMedium
                                ?.copyWith(color: surfaces.textPrimary),
                          ),
                          Text(Formatters.time(meal.eatenAt),
                              style: text.bodySmall),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${formatCoachNumber(meal.calories)} ${context.tr('coachUnitKcal')}',
                      style: text.labelMedium
                          ?.copyWith(color: surfaces.textPrimary),
                    ),
                  ],
                ),
              ),
            ),
        if (remaining != null && remaining > 0)
          _NextMealCard(remaining: remaining),
      ],
    );
  }

  IconData _iconFor(DateTime time) {
    if (time.hour < 11) return Icons.wb_twilight;
    if (time.hour < 17) return Icons.wb_sunny_outlined;
    return Icons.nightlight_outlined;
  }
}

/// Highlights the calories still available today. Derived from the real
/// daily target and consumed calories.
class _NextMealCard extends StatelessWidget {
  const _NextMealCard({required this.remaining});

  final double remaining;

  @override
  Widget build(BuildContext context) {
    final ai = context.aiColors;
    final text = context.textTheme;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ai.soft,
        borderRadius: ThemeDimensions.borderRadiusMedium,
        border: Border.all(color: ai.border),
      ),
      child: Row(
        children: [
          Icon(Icons.restaurant_outlined, size: 18, color: ai.onSoft),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('coachNextMeal'),
                  style: text.labelMedium?.copyWith(color: ai.onSoft),
                ),
                Text(
                  context.tr('coachNextMealRemaining',
                      {'value': formatCoachNumber(remaining)}),
                  style: text.bodySmall?.copyWith(color: ai.onSoft),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          CoachPill(
            compact: true,
            label: ThemeTextStyles.clinicalCase(
              context.tr('coachActive'),
              Localizations.localeOf(context),
            ),
            background: ai.border,
            foreground: ai.onSoft,
          ),
        ],
      ),
    );
  }
}
