import 'package:flutter/widgets.dart';

import 'adaptive_layout.dart';

/// Which navigation *shell* to render for the current layout class.
enum AdaptiveNavType { bottomBar, rail, drawer }

class AdaptiveNavigation {
  AdaptiveNavigation._();

  static AdaptiveNavType of(BuildContext context) =>
      typeFor(AdaptiveLayout.of(context));

  static AdaptiveNavType typeFor(AdaptiveLayoutClass layoutClass) {
    return switch (layoutClass) {
      AdaptiveLayoutClass.compact => AdaptiveNavType.bottomBar,
      AdaptiveLayoutClass.medium => AdaptiveNavType.rail,
      AdaptiveLayoutClass.expanded => AdaptiveNavType.drawer,
    };
  }
}

/// A single destination shared across bottom bar / rail / drawer.
/// Feature modules supply the actual list later — this is just the shape.
@immutable
class AdaptiveNavItem {
  const AdaptiveNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
