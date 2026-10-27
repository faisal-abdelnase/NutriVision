import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_colors.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/theme/theme_text_styles.dart';

class OnboardingToolbar extends StatelessWidget {
  const OnboardingToolbar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.pulse,
    required this.onStepTap,
    required this.onSkip,
    required this.isDark,
  });

  final int currentPage;
  final int totalPages;
  final Animation<double> pulse;
  final ValueChanged<int> onStepTap;
  final VoidCallback onSkip;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final locale = Localizations.localeOf(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: context.screenWidth.clamp(320.0, 1100.0) - 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? surfaces.level2
                        : ThemeColors.stitchSurfaceContainer,
                    borderRadius: ThemeDimensions.borderRadiusPill,
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
                                color: ThemeColors.stitchPrimaryContainer
                                    .withValues(alpha: pulse.value),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        context.tr('badgeClinical'),
                        style: TextStyle(
                          fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                          color: surfaces.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                if (context.screenWidth >= 640) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? ThemeColors.primaryDeep
                          : ThemeColors.stitchSurfaceContainerHigh,
                      borderRadius: ThemeDimensions.borderRadiusPill,
                    ),
                    child: Text(
                      context.tr('onboardingFlow'),
                      style: TextStyle(
                        fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                        color: ThemeColors.stitchPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: isDark
                        ? surfaces.level2
                        : ThemeColors.stitchSurfaceContainerLow,
                    borderRadius: ThemeDimensions.borderRadiusPill,
                    boxShadow: const [
                      BoxShadow(
                        color: ThemeColors.stitchShadow,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(totalPages, (i) {
                      final isActive = i == currentPage;
                      return InkWell(
                        onTap: () => onStepTap(i),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(999),
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? ThemeColors.stitchPrimary
                                : Colors.transparent,
                            borderRadius: ThemeDimensions.borderRadiusPill,
                            boxShadow: isActive
                                ? const [
                                    BoxShadow(
                                      color: ThemeColors.stitchShadowPrimary,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                              color: isActive
                                  ? ThemeColors.stitchSurfaceContainerLowest
                                  : surfaces.textSecondary,
                              fontWeight: isActive
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(width: 8),

                TextButton(
                  onPressed: onSkip,
                  style: TextButton.styleFrom(
                    foregroundColor: surfaces.textSecondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.tr('skip'),
                        style: TextStyle(
                          fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                          color: surfaces.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(
                        isRtl ? Icons.arrow_back : Icons.arrow_forward,
                        size: 15,
                        color: surfaces.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
