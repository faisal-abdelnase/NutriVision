import 'package:flutter/widgets.dart';

import '../theme/theme_dimensions.dart';
import 'responsive_value.dart';

/// Horizontal screen padding that grows with the available width, so
/// content doesn't hug the edges on tablets/desktop.
class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({
    super.key,
    required this.child,
    this.vertical = 0,
  });

  final Widget child;
  final double vertical;

  @override
  Widget build(BuildContext context) {
    final horizontal = responsiveValue<double>(
      context,
      xs: ThemeDimensions.marginMobile,
      sm: ThemeDimensions.marginMobile,
      md: ThemeDimensions.marginTablet,
      lg: ThemeDimensions.marginTablet,
      xl: ThemeDimensions.marginDesktop,
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: child,
    );
  }
}
