import 'package:flutter/material.dart';

import '../responsive/breakpoints.dart';
import '../responsive/responsive_text.dart';

/// Thin wrapper around [AppText]: it supplies the breakpoint and takes the
/// base font size from the given theme style, so call sites stay short.
class ScaledText extends StatelessWidget {
  const ScaledText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final resolved =
        style ?? Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    return AppText(
      text,
      baseFontSize: resolved.fontSize ?? 14,
      style: resolved,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      breakpoint: Breakpoints.of(MediaQuery.sizeOf(context).width),
    );
  }
}