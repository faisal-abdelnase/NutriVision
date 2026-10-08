
import 'package:flutter/material.dart';
import 'breakpoints.dart';

class AppText extends StatelessWidget {
  final String text;
  final double baseFontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;
  final AppBreakpoint breakpoint;

  const AppText(
    this.text, {
    super.key,
    required this.baseFontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style, 
    required this.breakpoint,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: (style ?? const TextStyle()).copyWith(fontSize: sp(baseFontSize)),
    );
  }

  double sp(double base) {
    final factor = switch (breakpoint) {
      AppBreakpoint.xs => 0.80,
      AppBreakpoint.sm => 1.00,
      AppBreakpoint.md => 1.10,
      AppBreakpoint.lg => 1.20,
      AppBreakpoint.xl => 1.30,
    };
    return base * factor;
  }
}