import 'package:flutter/material.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';

class GroceryProgressHeader extends StatelessWidget {
  const GroceryProgressHeader({
    super.key,
    required this.checked,
    required this.total,
  });

  final int checked;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaces = context.surfaceColors;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$checked of $total items collected',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : checked / total,
                minHeight: 8,
                backgroundColor: surfaces.level2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
