import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_colors.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/theme/theme_text_styles.dart';

class OnboardingStepBadge extends StatelessWidget {
  const OnboardingStepBadge({
    super.key,
    required this.slideIndex,
    required this.totalSlides,
  });

  final int slideIndex;
  final int totalSlides;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final locale = Localizations.localeOf(context);
    final isDark = context.isDarkMode;
    final (bg, fg, tagKey, subKey) = _info(isDark);

    return Wrap(
      spacing: ThemeDimensions.spaceSm,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: ThemeDimensions.borderRadiusPill,
          ),
          child: Text(
            context.tr(tagKey).toUpperCase(),
            style: ThemeTextStyles.labelSmall.copyWith(
              color: fg,
              fontFamily: ThemeTextStyles.fontFamilyFor(locale),
              letterSpacing: 0.6,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
        Text(
          context.tr(subKey),
          style: ThemeTextStyles.labelSmall.copyWith(
            color: surfaces.textMuted,
            fontFamily: ThemeTextStyles.fontFamilyFor(locale),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  (Color, Color, String, String) _info(bool isDark) => switch (slideIndex) {
    0 => (
      isDark
          ? ThemeColors.primaryDeep
          : ThemeColors.stitchPrimaryContainer.withValues(alpha: 0.16),
      isDark ? ThemeColors.stitchPrimaryFixed : ThemeColors.stitchPrimary,
      'step1Tag',
      'step1Sub',
    ),
    1 => (
      isDark ? ThemeColors.infoContainerDark : ThemeColors.stitchSecondaryFixed,
      isDark
          ? ThemeColors.stitchSecondaryDark
          : ThemeColors.stitchOnSecondaryFixed,
      'step2Tag',
      'step2Sub',
    ),
    2 => (
      isDark ? ThemeColors.primaryDeep : ThemeColors.stitchPrimaryFixed,
      isDark
          ? ThemeColors.stitchPrimaryFixed
          : ThemeColors.stitchOnPrimaryFixed,
      'step3Tag',
      'step3Sub',
    ),
    _ => (
      ThemeColors.stitchPrimaryContainer.withValues(alpha: 0.16),
      ThemeColors.stitchPrimary,
      'step1Tag',
      '',
    ),
  };
}
