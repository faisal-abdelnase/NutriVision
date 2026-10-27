import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_colors.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/theme/theme_text_styles.dart';
import '../components/circular_gauge_painter.dart';
import 'onboarding_illustration_card.dart';

class Slide3HabitsCard extends StatelessWidget {
  const Slide3HabitsCard({
    super.key,
    required this.pulse,
    required this.progress,
    required this.isDark,
  });

  final Animation<double> pulse;
  final Animation<double> progress;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return OnboardingIllustrationCard(
      child: Column(
        children: [
          const _StreakBanner(),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _NutritionTargetRing(progress: progress, isDark: isDark),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _HydrationMetricCard(progress: progress, isDark: isDark),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _WeeklyCadenceHeatmap(isDark: isDark),
        ],
      ),
    );
  }
}

class _StreakBanner extends StatelessWidget {
  const _StreakBanner();

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeColors.stitchPrimary,
            ThemeColors.stitchPrimaryContainer,
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.stitchShadowPrimary,
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('streakBadge').toUpperCase(),
                style: TextStyle(
                  fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                  color: ThemeColors.stitchSurfaceContainerLowest.withValues(
                    alpha: 0.9,
                  ),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    size: 20,
                    color: ThemeColors.stitchAmberAlert,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.tr('streakDays'),
                    style: TextStyle(
                      fontFamily: ThemeTextStyles.headingFamilyFor(locale),
                      color: ThemeColors.stitchSurfaceContainerLowest,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: ThemeColors.stitchSurfaceContainerLowest.withValues(
                alpha: 0.22,
              ),
              borderRadius: ThemeDimensions.borderRadiusPill,
            ),
            child: Text(
              context.tr('slide3Points'),
              style: TextStyle(
                fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                color: ThemeColors.stitchSurfaceContainerLowest,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionTargetRing extends StatelessWidget {
  const _NutritionTargetRing({required this.progress, required this.isDark});

  final Animation<double> progress;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? surfaces.level2 : ThemeColors.stitchSurfaceContainerLow,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          Text(
            context.tr('goalNutrition'),
            style: TextStyle(
              fontFamily: ThemeTextStyles.fontFamilyFor(locale),
              color: surfaces.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 76,
            height: 76,
            child: AnimatedBuilder(
              animation: progress,
              builder: (context, _) {
                final pct = (0.92 * progress.value);
                return CustomPaint(
                  painter: CircularGaugePainter(
                    progress: pct,
                    trackColor: isDark
                        ? ThemeColors.stitchTrackDark
                        : ThemeColors.stitchSurfaceContainerHighest,
                    progressColor: ThemeColors.stitchPrimary,
                    strokeWidth: 6.5,
                  ),
                  child: Center(
                    child: Text(
                      '${(pct * 100).toInt()}%',
                      style: ThemeTextStyles.metricNum.copyWith(
                        color: surfaces.textPrimary,
                        fontFamily: ThemeTextStyles.headingFamilyFor(locale),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.tr('statusOptimal'),
            style: TextStyle(
              fontFamily: ThemeTextStyles.fontFamilyFor(locale),
              color: ThemeColors.stitchPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HydrationMetricCard extends StatelessWidget {
  const _HydrationMetricCard({required this.progress, required this.isDark});

  final Animation<double> progress;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? surfaces.level2 : ThemeColors.stitchSurfaceContainerLow,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('goalHydration'),
                style: TextStyle(
                  fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                  color: surfaces.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.water_drop_rounded,
                size: 15,
                color: ThemeColors.stitchSecondary,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                context.tr('slide3HydrationVal'),
                style: ThemeTextStyles.metricNum.copyWith(
                  color: ThemeColors.stitchSecondary,
                  fontFamily: ThemeTextStyles.headingFamilyFor(locale),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                context.tr('slide3HydrationUnit'),
                style: TextStyle(
                  fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                  color: surfaces.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: progress,
            builder: (context, _) {
              return ClipRRect(
                borderRadius: ThemeDimensions.borderRadiusPill,
                child: LinearProgressIndicator(
                  value: (0.85 * progress.value).clamp(0.0, 1.0),
                  backgroundColor: isDark
                      ? ThemeColors.stitchTrackDark
                      : ThemeColors.stitchSurfaceContainerHighest,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    ThemeColors.stitchSecondary,
                  ),
                  minHeight: 6,
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('slide3HydrationProgress'),
                style: TextStyle(
                  fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                  color: surfaces.textSecondary,
                  fontSize: 9,
                ),
              ),
              Text(
                context.tr('slide3HydrationRemaining'),
                style: TextStyle(
                  fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                  color: surfaces.textSecondary,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyCadenceHeatmap extends StatelessWidget {
  const _WeeklyCadenceHeatmap({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? surfaces.level2 : ThemeColors.stitchSurfaceContainerLow,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('weekOverview'),
                style: TextStyle(
                  fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                  color: surfaces.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
              Text(
                context.tr('slide3CadenceDays'),
                style: TextStyle(
                  fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                  color: ThemeColors.stitchPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _HeatmapDayTile(day: context.tr('dayMon'), pct: '100%'),
              const SizedBox(width: 4),
              _HeatmapDayTile(day: context.tr('dayTue'), pct: '98%'),
              const SizedBox(width: 4),
              _HeatmapDayTile(day: context.tr('dayWed'), pct: '95%'),
              const SizedBox(width: 4),
              _HeatmapDayTile(day: context.tr('dayThu'), pct: '92%'),
              const SizedBox(width: 4),
              _HeatmapDayTile(day: context.tr('dayFri'), pct: '96%'),
              const SizedBox(width: 4),
              _HeatmapDayTile(day: context.tr('daySat'), pct: '94%'),
              const SizedBox(width: 4),
              _HeatmapDayTile(
                day: context.tr('daySun'),
                pct: '99%',
                isCurrentActive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeatmapDayTile extends StatelessWidget {
  const _HeatmapDayTile({
    required this.day,
    required this.pct,
    this.isCurrentActive = false,
  });

  final String day;
  final String pct;
  final bool isCurrentActive;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isCurrentActive
              ? ThemeColors.stitchPrimary
              : ThemeColors.stitchPrimaryContainer.withValues(alpha: 0.85),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          boxShadow: isCurrentActive
              ? const [
                  BoxShadow(
                    color: ThemeColors.stitchShadowPrimary,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                color: ThemeColors.stitchSurfaceContainerLowest,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              pct,
              style: TextStyle(
                fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                color: ThemeColors.stitchSurfaceContainerLowest,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
