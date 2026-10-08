import 'package:flutter/widgets.dart';

import 'breakpoints.dart';

/// Returns a different value depending on the current [AppBreakpoint].
///
/// Any breakpoint left unspecified falls back to the next smaller one
/// that was provided, so callers only need to set the sizes that
/// actually change:
///
/// ```dart
/// final columns = responsiveValue(context, xs: 1, md: 2, xl: 4);
/// ```
T responsiveValue<T>(
  BuildContext context, {
  required T xs,
  T? sm,
  T? md,
  T? lg,
  T? xl,
}) {
  final width = MediaQuery.sizeOf(context).width;
  final breakpoint = Breakpoints.of(width);
  return switch (breakpoint) {
    AppBreakpoint.xs => xs,
    AppBreakpoint.sm => sm ?? xs,
    AppBreakpoint.md => md ?? sm ?? xs,
    AppBreakpoint.lg => lg ?? md ?? sm ?? xs,
    AppBreakpoint.xl => xl ?? lg ?? md ?? sm ?? xs,
  };
}
