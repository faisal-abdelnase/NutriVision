import 'package:flutter/widgets.dart';

import 'breakpoints.dart';

typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  AppBreakpoint breakpoint,
);

/// Picks between [mobile], [tablet] and [desktop] builders based on the
/// available width (via [LayoutBuilder], so it reacts to nested
/// constraints too, not just the full screen size).
///
/// Only [mobile] is required — [tablet] and [desktop] fall back to it
/// when omitted.
class AppResponsiveBuilder extends StatelessWidget {
  const AppResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final ResponsiveWidgetBuilder mobile;
  final ResponsiveWidgetBuilder? tablet;
  final ResponsiveWidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = Breakpoints.of(constraints.maxWidth);
        if (Breakpoints.isDesktop(breakpoint) && desktop != null) {
          return desktop!(context, breakpoint);
        }
        if (Breakpoints.isTablet(breakpoint) && tablet != null) {
          return tablet!(context, breakpoint);
        }
        return mobile(context, breakpoint);
      },
    );
  }
}
