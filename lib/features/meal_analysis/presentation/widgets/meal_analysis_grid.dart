import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:nutri_vision/core/responsive/breakpoints.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';

/// Equal-height grid whose column count follows the *available* width
/// (via [Breakpoints]) rather than the screen width, so it stays correct
/// inside navigation rails/drawers. Unspecified breakpoints fall back to the
/// next smaller one, like `responsiveValue`.
class MealAnalysisGrid extends StatelessWidget {
  const MealAnalysisGrid({
    super.key,
    required this.children,
    this.xs = 1,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.spacing = ThemeDimensions.spaceMd,
  });

  final List<Widget> children;
  final int xs;
  final int? sm;
  final int? md;
  final int? lg;
  final int? xl;
  final double spacing;

  int _columnsFor(AppBreakpoint breakpoint) => switch (breakpoint) {
        AppBreakpoint.xs => xs,
        AppBreakpoint.sm => sm ?? xs,
        AppBreakpoint.md => md ?? sm ?? xs,
        AppBreakpoint.lg => lg ?? md ?? sm ?? xs,
        AppBreakpoint.xl => xl ?? lg ?? md ?? sm ?? xs,
      };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = math.max(
          1,
          _columnsFor(Breakpoints.of(constraints.maxWidth)),
        );

        final rows = <Widget>[];
        for (var start = 0; start < children.length; start += columns) {
          final end = math.min(start + columns, children.length);
          final slice = children.sublist(start, end);

          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < columns; i++) ...[
                    if (i > 0) SizedBox(width: spacing),
                    Expanded(
                      child: i < slice.length
                          ? slice[i]
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          );
          if (end < children.length) rows.add(SizedBox(height: spacing));
        }

        return Column(children: rows);
      },
    );
  }
}
