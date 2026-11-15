import 'package:flutter/material.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';

class ProfileInfoTile extends StatelessWidget {
  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.label,
    this.value,
  });

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaces = context.surfaceColors;
    final text = (value == null || value!.trim().isEmpty) ? '—' : value!;

    return ListTile(
      leading: Icon(icon, color: surfaces.textMuted),
      title: Text(label,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: surfaces.textMuted)),
      subtitle: Text(text, style: theme.textTheme.bodyLarge),
    );
  }
}
