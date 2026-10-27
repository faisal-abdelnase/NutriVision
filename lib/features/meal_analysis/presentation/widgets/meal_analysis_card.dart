import 'package:flutter/material.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';

/// Level-1 surface used by every section of the meal analysis screen.
class MealAnalysisCard extends StatelessWidget {
  const MealAnalysisCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(ThemeDimensions.space20),
    this.color,
    this.highlighted = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? surfaces.level1,
        borderRadius: ThemeDimensions.borderRadiusCard,
        border: Border.all(
          color: highlighted ? primary : surfaces.border,
          width: highlighted ? 1.5 : 1,
        ),
        boxShadow: surfaces.cardShadow,
      ),
      child: child,
    );
  }
}
