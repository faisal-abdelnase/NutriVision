import 'package:flutter/material.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';

class MacroChip extends StatelessWidget {
  const MacroChip({
    super.key,
    required this.label,
    required this.grams,
    required this.color,
  });

  final String label;
  final double grams;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: ThemeDimensions.borderRadiusPill,
      ),
      child: Text(
        '$label ${grams.round()}g',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}
