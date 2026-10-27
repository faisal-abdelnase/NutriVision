import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_colors.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/theme/theme_text_styles.dart';
import '../onboarding_slide_data.dart';

class OnboardingFeatureBullet extends StatelessWidget {
  const OnboardingFeatureBullet({
    super.key,
    required this.bullet,
    required this.slideIndex,
    required this.bulletIndex,
  });

  final OnboardingBullet bullet;
  final int slideIndex;
  final int bulletIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final surfaces = context.surfaceColors;
    final locale = Localizations.localeOf(context);
    final (iconBg, iconFg) = _colors(isDark);

    return Padding(
      padding: const EdgeInsets.only(bottom: ThemeDimensions.space12 + 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(shape: BoxShape.circle, color: iconBg),
            child: Center(child: Icon(bullet.icon, size: 17, color: iconFg)),
          ),
          const SizedBox(width: ThemeDimensions.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(bullet.titleKey),
                  style: ThemeTextStyles.labelLarge.copyWith(
                    color: surfaces.textPrimary,
                    fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.tr(bullet.subtitleKey),
                  style: ThemeTextStyles.bodySmall.copyWith(
                    color: surfaces.textSecondary,
                    fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _colors(bool isDark) {
    if (slideIndex == 1) {
      return bulletIndex == 0
          ? (
              isDark
                  ? ThemeColors.infoContainerDark
                  : ThemeColors.stitchSecondaryFixed.withValues(alpha: 0.6),
              isDark
                  ? ThemeColors.stitchSecondaryDark
                  : ThemeColors.stitchSecondary,
            )
          : (
              isDark
                  ? ThemeColors.primaryDeep
                  : ThemeColors.stitchPrimaryContainer.withValues(alpha: 0.2),
              isDark
                  ? ThemeColors.stitchPrimaryFixed
                  : ThemeColors.stitchPrimary,
            );
    }
    return bulletIndex == 0
        ? (
            isDark
                ? ThemeColors.primaryDeep
                : ThemeColors.stitchPrimaryContainer.withValues(alpha: 0.2),
            isDark ? ThemeColors.stitchPrimaryFixed : ThemeColors.stitchPrimary,
          )
        : (
            isDark
                ? ThemeColors.infoContainerDark
                : ThemeColors.stitchSecondaryFixed.withValues(alpha: 0.6),
            isDark
                ? ThemeColors.stitchSecondaryDark
                : ThemeColors.stitchSecondary,
          );
  }
}
