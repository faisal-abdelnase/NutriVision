import 'package:flutter/material.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';

class RecipeFormSection extends StatelessWidget {
  const RecipeFormSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: context.surfaceColors.textMuted),
                ),
              ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
