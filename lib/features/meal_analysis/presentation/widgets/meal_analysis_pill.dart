import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_text_styles.dart';

/// Small rounded label used for badges, tags and status chips.
class MealAnalysisPill extends StatelessWidget {
  const MealAnalysisPill({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    this.icon,
    this.uppercase = false,
  });

  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    final text = uppercase
        ? ThemeTextStyles.clinicalCase(label, Localizations.localeOf(context))
        : label;

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              text,
              style: context.textTheme.labelSmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
