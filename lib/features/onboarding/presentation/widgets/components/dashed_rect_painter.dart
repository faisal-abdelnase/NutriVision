import 'dart:math' as math;
import 'package:flutter/material.dart';

class DashedRectPainter extends CustomPainter {
  const DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashLength = 7.0,
    this.dashGap = 4.5,
    this.radius = 14.0,
  });

  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final next = math.min(distance + dashLength, metric.length);
        final extractPath = metric.extractPath(distance, next);
        canvas.drawPath(extractPath, paint);
        distance += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedRectPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.radius != radius;
}
