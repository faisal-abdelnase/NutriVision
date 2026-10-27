import 'package:flutter/material.dart';

import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.pageCount,
    required this.pageIndex,
    this.onDotTap,
  });

  final int pageCount;
  final int pageIndex;
  final ValueChanged<int>? onDotTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pageCount, (index) {
        final isActive = index == pageIndex;
        final dot = AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(
            horizontal: ThemeDimensions.spaceXs,
          ),
          width: isActive ? 32 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: isActive
                ? ThemeColors.stitchPrimary
                : ThemeColors.stitchSurfaceContainerHighest.withValues(
                    alpha: 0.8,
                  ),
            borderRadius: ThemeDimensions.borderRadiusPill,
          ),
        );

        if (onDotTap != null) {
          return InkWell(
            onTap: () => onDotTap!(index),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: dot,
            ),
          );
        }
        return dot;
      }),
    );
  }
}
