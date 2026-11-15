import 'package:flutter/material.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tiles = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) tiles.add(const Divider());
      tiles.add(children[i]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
          child: Text(
            title,
            style: theme.textTheme.titleSmall
                ?.copyWith(color: context.surfaceColors.textSecondary),
          ),
        ),
        Card(child: Column(children: tiles)),
      ],
    );
  }
}
