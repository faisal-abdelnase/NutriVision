import 'package:flutter/material.dart';
import 'package:nutri_vision/core/responsive/responsive_padding.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';

/// Centers content, caps its width on large screens and applies
/// responsive horizontal padding.
class ContentContainer extends StatelessWidget {
  const ContentContainer({
    super.key,
    required this.child,
    this.maxWidth = ThemeDimensions.contentMaxWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ResponsivePadding(child: child),
      ),
    );
  }
}
