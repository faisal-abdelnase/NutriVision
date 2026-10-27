import 'package:flutter/material.dart';
import 'package:nutri_vision/core/theme/theme_colors.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';

class OnboardingCardShell extends StatelessWidget {
  const OnboardingCardShell({
    super.key,
    required this.child,
    required this.isDark,
  });

  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? surfaces.level1
            : ThemeColors.stitchSurfaceContainerLowest,
        borderRadius: const BorderRadius.all(Radius.circular(28)),
        border: Border.all(
          color: isDark
              ? surfaces.border
              : ThemeColors.stitchSurfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
        ),
        boxShadow: isDark
            ? const [
                BoxShadow(
                  color: ThemeColors.stitchShadow,
                  offset: Offset(0, 12),
                  blurRadius: 32,
                ),
              ]
            : [
                BoxShadow(
                  color: ThemeColors.stitchSurfaceContainerHigh.withValues(
                    alpha: 0.45,
                  ),
                  offset: const Offset(0, 14),
                  blurRadius: 36,
                  spreadRadius: -4,
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(28)),
        child: Stack(
          children: [
            PositionedDirectional(
              top: -60,
              end: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.stitchPrimaryContainer.withValues(
                    alpha: isDark ? 0.08 : 0.12,
                  ),
                ),
              ),
            ),

            PositionedDirectional(
              bottom: -60,
              start: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.stitchSecondaryContainer.withValues(
                    alpha: isDark ? 0.08 : 0.14,
                  ),
                ),
              ),
            ),

            child,
          ],
        ),
      ),
    );
  }
}
