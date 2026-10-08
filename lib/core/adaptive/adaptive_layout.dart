import 'package:flutter/widgets.dart';

import '../responsive/breakpoints.dart';

/// Structural layout class, distinct from [AppBreakpoint]: this answers
/// "how should the *interaction structure* change", not "how much space
/// is there". Multiple breakpoints can map to the same layout class.
enum AdaptiveLayoutClass { compact, medium, expanded }

class AdaptiveLayout {
  AdaptiveLayout._();

  static AdaptiveLayoutClass of(BuildContext context) =>
      classFor(MediaQuery.sizeOf(context).width);

  static AdaptiveLayoutClass classFor(double width) {
    final bp = Breakpoints.of(width);
    if (Breakpoints.isMobile(bp)) return AdaptiveLayoutClass.compact;
    if (Breakpoints.isTablet(bp)) return AdaptiveLayoutClass.medium;
    return AdaptiveLayoutClass.expanded;
  }
}
