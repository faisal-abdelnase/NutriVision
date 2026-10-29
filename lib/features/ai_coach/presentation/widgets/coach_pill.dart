import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

/// Pill-shaped label or action chip used across the coach screen.
class CoachPill extends StatelessWidget {
  const CoachPill({
    super.key,
    required this.label,
    this.icon,
    this.iconColor,
    this.background,
    this.foreground,
    this.borderColor,
    this.onTap,
    this.compact = false,
  });

  final String label;
  final IconData? icon;
  final Color? iconColor;
  final Color? background;
  final Color? foreground;
  final Color? borderColor;
  final VoidCallback? onTap;

  /// Static badges use the compact height; tappable pills keep a 44px target.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final foregroundColor = foreground ?? surfaces.textPrimary;

    return Material(
      color: background ?? surfaces.level2,
      clipBehavior: Clip.antiAlias,
      shape: StadiumBorder(
        side: BorderSide(color: borderColor ?? Colors.transparent),
      ),
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: compact ? 28 : ThemeDimensions.touchTarget,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: iconColor ?? foregroundColor),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelMedium
                        ?.copyWith(color: foregroundColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
