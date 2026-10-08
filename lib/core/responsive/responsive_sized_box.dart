import 'package:flutter/widgets.dart';

import 'responsive_value.dart';

/// A spacing gap whose size scales with the current breakpoint.
/// Use [ResponsiveSizedBox.vertical] / [.horizontal] for the common cases.
class ResponsiveSizedBox extends StatelessWidget {
  const ResponsiveSizedBox({
    super.key,
    this.width,
    this.height,
  });

  factory ResponsiveSizedBox.vertical(double base) =>
      ResponsiveSizedBox(height: base);

  factory ResponsiveSizedBox.horizontal(double base) =>
      ResponsiveSizedBox(width: base);

  /// Base size at the `sm` breakpoint; scaled down slightly on `xs`
  /// and up on larger breakpoints.
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    double? scale(double? base) {
      if (base == null) return null;
      return responsiveValue<double>(
        context,
        xs: base * 0.75,
        sm: base,
        md: base * 1.1,
        lg: base * 1.25,
        xl: base * 1.4,
      );
    }

    return SizedBox(width: scale(width), height: scale(height));
  }
}
