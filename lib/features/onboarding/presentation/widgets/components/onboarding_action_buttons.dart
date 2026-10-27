import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_colors.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/theme/theme_text_styles.dart';

class OnboardingActionButtons extends StatelessWidget {
  const OnboardingActionButtons({
    super.key,
    required this.slideIndex,
    required this.onNext,
    this.onBack,
    this.onJumpToHabits,
  });

  final int slideIndex;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final VoidCallback? onJumpToHabits;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final surfaces = context.surfaceColors;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Wrap(
      spacing: ThemeDimensions.spaceMd,
      runSpacing: ThemeDimensions.spaceSm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColors.stitchPrimary,
            foregroundColor: ThemeColors.stitchSurfaceContainerLowest,
            elevation: 4,
            shadowColor: ThemeColors.stitchShadowPrimary,
            minimumSize: const Size(0, ThemeDimensions.buttonHeight + 4),
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
            shape: const RoundedRectangleBorder(
              borderRadius: ThemeDimensions.borderRadiusPill,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _ctaLabel(context),
                style: ThemeTextStyles.labelLarge.copyWith(
                  color: ThemeColors.stitchSurfaceContainerLowest,
                  fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: ThemeDimensions.spaceSm),
              Icon(
                slideIndex == 2
                    ? Icons.rocket_launch_rounded
                    : (isRtl ? Icons.arrow_back : Icons.arrow_forward),
                size: 18,
                color: ThemeColors.stitchSurfaceContainerLowest,
              ),
            ],
          ),
        ),

        if (slideIndex == 0 && onJumpToHabits != null) ...[
          TextButton(
            onPressed: onJumpToHabits,
            style: TextButton.styleFrom(
              foregroundColor: surfaces.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: const RoundedRectangleBorder(
                borderRadius: ThemeDimensions.borderRadiusPill,
              ),
            ),
            child: Text(
              context.tr('btnJumpHabits'),
              style: ThemeTextStyles.labelMedium.copyWith(
                color: surfaces.textSecondary,
                fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ] else if (slideIndex > 0 && onBack != null) ...[
          TextButton(
            onPressed: onBack,
            style: TextButton.styleFrom(
              foregroundColor: surfaces.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: const RoundedRectangleBorder(
                borderRadius: ThemeDimensions.borderRadiusPill,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isRtl ? Icons.arrow_forward : Icons.arrow_back,
                  size: 16,
                  color: surfaces.textSecondary,
                ),
                const SizedBox(width: ThemeDimensions.spaceXs),
                Text(
                  context.tr('back'),
                  style: ThemeTextStyles.labelMedium.copyWith(
                    color: surfaces.textSecondary,
                    fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _ctaLabel(BuildContext context) => switch (slideIndex) {
    0 => context.tr('btnContinueStep1'),
    1 => context.tr('btnContinueStep2'),
    2 => context.tr('getStarted'),
    _ => context.tr('next'),
  };
}
