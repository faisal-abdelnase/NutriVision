import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_colors.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';

class OnboardingIllustrationCard extends StatelessWidget {
  const OnboardingIllustrationCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final surfaces = context.surfaceColors;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? surfaces.level1
            : ThemeColors.stitchSurfaceContainerLowest,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
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
                  offset: Offset(0, 8),
                  blurRadius: 24,
                ),
              ]
            : [
                BoxShadow(
                  color: ThemeColors.stitchSurfaceContainerHigh.withValues(
                    alpha: 0.5,
                  ),
                  offset: const Offset(0, 10),
                  blurRadius: 30,
                  spreadRadius: -4,
                ),
              ],
      ),
      padding: padding,
      child: child,
    );
  }
}
