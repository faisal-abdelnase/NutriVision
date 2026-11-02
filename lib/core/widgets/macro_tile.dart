import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/theme_dimensions.dart';
import 'scaled_text.dart';

class MacroTile extends StatelessWidget {
  const MacroTile({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.softColor,
  });

  final String label;
  final String value;
  final Color color;
  final Color softColor;

  @override
  Widget build(BuildContext context) {
    final t = context.textTheme;
    return Container(
      padding: const EdgeInsets.all(ThemeDimensions.space12),
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: ThemeDimensions.borderRadiusMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: ScaledText(label,
                    style: t.labelMedium, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ScaledText(value, style: t.titleMedium),
        ],
      ),
    );
  }
}