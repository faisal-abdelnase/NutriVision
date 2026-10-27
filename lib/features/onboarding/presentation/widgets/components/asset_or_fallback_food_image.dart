import 'package:flutter/material.dart';

import '../../../../../core/theme/theme_colors.dart';

class AssetOrFallbackFoodImage extends StatelessWidget {
  const AssetOrFallbackFoodImage({
    super.key,
    required this.assetPath,
    required this.fallbackGradient,
    required this.fallbackIcon,
    this.fit = BoxFit.cover,
  });

  final String assetPath;
  final List<Color> fallbackGradient;
  final IconData fallbackIcon;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: fallbackGradient,
            ),
          ),
          child: Center(
            child: Icon(
              fallbackIcon,
              size: 48,
              color: ThemeColors.stitchSurfaceContainerLowest.withValues(
                alpha: 0.35,
              ),
            ),
          ),
        );
      },
    );
  }
}
