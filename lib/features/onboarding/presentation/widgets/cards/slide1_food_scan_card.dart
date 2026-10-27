import 'package:flutter/material.dart';
import 'package:nutri_vision/core/constants/asset_paths.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_colors.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/theme/theme_text_styles.dart';

import '../components/asset_or_fallback_food_image.dart';
import 'onboarding_illustration_card.dart';

class Slide1FoodScanCard extends StatelessWidget {
  const Slide1FoodScanCard({
    super.key,
    required this.pulse,
    required this.progress,
  });

  final Animation<double> pulse;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return OnboardingIllustrationCard(
      child: Column(
        children: [
          _FoodScanImageHUD(pulse: pulse),

          const SizedBox(height: 12),

          _MacroBreakdownRow(progress: progress, isDark: isDark),

          const SizedBox(height: 10),

          const _MicroNutrientPillsRow(),
        ],
      ),
    );
  }
}

class _FoodScanImageHUD extends StatelessWidget {
  const _FoodScanImageHUD({required this.pulse});

  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const AssetOrFallbackFoodImage(
              assetPath: AssetPaths.onboardingSalmonBowl,
              fallbackGradient: [
                ThemeColors.primaryDeep,
                ThemeColors.stitchPrimary,
                ThemeColors.stitchPrimaryContainer,
              ],
              fallbackIcon: Icons.restaurant_rounded,
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ThemeColors.stitchScrim.withValues(alpha: 0.33),
                    Colors.transparent,
                    ThemeColors.stitchScrim,
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),

            _FoodScanTargetTag(pulse: pulse),

            const _FoodScanAccuracyBadge(),

            const _FoodScanTelemetryGlassHUD(),
          ],
        ),
      ),
    );
  }
}

class _FoodScanTargetTag extends StatelessWidget {
  const _FoodScanTargetTag({required this.pulse});

  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return PositionedDirectional(
      top: 12,
      start: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: ThemeColors.stitchSurfaceContainerLowest.withValues(
            alpha: 0.92,
          ),
          borderRadius: ThemeDimensions.borderRadiusPill,
          boxShadow: const [
            BoxShadow(
              color: ThemeColors.stitchShadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: pulse,
              builder: (context, _) => Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.stitchPrimaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.stitchPrimaryContainer.withValues(
                        alpha: pulse.value,
                      ),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              context.tr('slide1FoodTitle'),
              style: ThemeTextStyles.labelSmall.copyWith(
                color: ThemeColors.onSurface,
                fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodScanAccuracyBadge extends StatelessWidget {
  const _FoodScanAccuracyBadge();

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return PositionedDirectional(
      top: 12,
      end: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: ThemeColors.stitchInverseSurface.withValues(alpha: 0.88),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.verified_user_rounded,
              size: 13,
              color: ThemeColors.stitchPrimaryFixed,
            ),
            const SizedBox(width: 4),
            Text(
              context.tr('slide1Accuracy'),
              style: ThemeTextStyles.labelSmall.copyWith(
                color: ThemeColors.stitchInverseOnSurface,
                fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodScanTelemetryGlassHUD extends StatelessWidget {
  const _FoodScanTelemetryGlassHUD();

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return PositionedDirectional(
      bottom: 10,
      start: 10,
      end: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: ThemeColors.stitchSurfaceContainerLowest.withValues(
            alpha: 0.93,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          boxShadow: const [
            BoxShadow(
              color: ThemeColors.stitchShadow,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr('caloricEst').toUpperCase(),
                    style: ThemeTextStyles.labelSmall.copyWith(
                      color: ThemeColors.onSurfaceVariant,
                      fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        context.tr('slide1CaloricLoad'),
                        style: ThemeTextStyles.metricNum.copyWith(
                          color: ThemeColors.stitchPrimary,
                          fontFamily: ThemeTextStyles.headingFamilyFor(locale),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.tr('slide1CaloricUnit'),
                        style: ThemeTextStyles.bodySmall.copyWith(
                          color: ThemeColors.onSurfaceVariant,
                          fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr('glycemicImpact'),
                    style: ThemeTextStyles.labelSmall.copyWith(
                      color: ThemeColors.onSurfaceVariant,
                      fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: const BoxDecoration(
                      color: ThemeColors.stitchPrimaryFixed,
                      borderRadius: ThemeDimensions.borderRadiusPill,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.trending_flat,
                          size: 13,
                          color: ThemeColors.stitchOnPrimaryFixed,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          context.tr('lowGI'),
                          style: ThemeTextStyles.labelSmall.copyWith(
                            color: ThemeColors.stitchOnPrimaryFixed,
                            fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroBreakdownRow extends StatelessWidget {
  const _MacroBreakdownRow({required this.progress, required this.isDark});

  final Animation<double> progress;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        return Row(
          children: [
            Expanded(
              child: _MacroTile(
                label: context.tr('protein'),
                value: context.tr('slide1ProteinVal'),
                percent: 0.78 * progress.value,
                pct: context.tr('slide1ProteinTarget'),
                barColor: ThemeColors.stitchPrimaryContainer,
                textColor: isDark
                    ? ThemeColors.stitchPrimaryFixed
                    : ThemeColors.stitchPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MacroTile(
                label: context.tr('complexCarbs'),
                value: context.tr('slide1CarbsVal'),
                percent: 0.52 * progress.value,
                pct: context.tr('slide1CarbsTarget'),
                barColor: ThemeColors.stitchSecondary,
                textColor: isDark
                    ? ThemeColors.stitchSecondaryDark
                    : ThemeColors.stitchSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MacroTile(
                label: context.tr('healthyFats'),
                value: context.tr('slide1FatsVal'),
                percent: 0.40 * progress.value,
                pct: context.tr('slide1FatsTarget'),
                barColor: ThemeColors.stitchTertiaryContainer,
                textColor: isDark
                    ? ThemeColors.stitchTertiaryDark
                    : ThemeColors.stitchTertiary,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MacroTile extends StatelessWidget {
  const _MacroTile({
    required this.label,
    required this.value,
    required this.percent,
    required this.pct,
    required this.barColor,
    required this.textColor,
  });

  final String label;
  final String value;
  final double percent;
  final String pct;
  final Color barColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final surfaces = context.surfaceColors;
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? surfaces.level2 : ThemeColors.stitchSurfaceContainerLow,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: ThemeTextStyles.labelSmall.copyWith(
              color: surfaces.textSecondary,
              fontFamily: ThemeTextStyles.fontFamilyFor(locale),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: ThemeTextStyles.headlineSmall.copyWith(
              color: surfaces.textPrimary,
              fontFamily: ThemeTextStyles.headingFamilyFor(locale),
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: ThemeDimensions.borderRadiusPill,
            child: LinearProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              backgroundColor: isDark
                  ? ThemeColors.stitchTrackDark
                  : ThemeColors.stitchSurfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            pct,
            style: ThemeTextStyles.labelSmall.copyWith(
              color: textColor,
              fontFamily: ThemeTextStyles.fontFamilyFor(locale),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MicroNutrientPillsRow extends StatelessWidget {
  const _MicroNutrientPillsRow();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _NutrientPill(
            icon: Icons.spa_rounded,
            label: context.tr('slide1Fiber'),
            iconColor: ThemeColors.stitchPrimaryContainer,
          ),
          const SizedBox(width: 6),
          _NutrientPill(
            icon: Icons.water_drop_rounded,
            label: context.tr('slide1Omega3'),
            iconColor: ThemeColors.stitchSecondary,
          ),
          const SizedBox(width: 6),
          _NutrientPill(
            icon: Icons.bolt_rounded,
            label: context.tr('slide1Zinc'),
            iconColor: ThemeColors.stitchTertiary,
          ),
        ],
      ),
    );
  }
}

class _NutrientPill extends StatelessWidget {
  const _NutrientPill({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final surfaces = context.surfaceColors;
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? surfaces.level2 : ThemeColors.stitchSurfaceContainer,
        borderRadius: ThemeDimensions.borderRadiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: ThemeTextStyles.labelSmall.copyWith(
              color: surfaces.textPrimary,
              fontFamily: ThemeTextStyles.fontFamilyFor(locale),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
