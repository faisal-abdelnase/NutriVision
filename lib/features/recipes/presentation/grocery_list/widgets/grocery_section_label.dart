import 'package:flutter/material.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';

class GrocerySectionLabel extends StatelessWidget {
  const GrocerySectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: context.surfaceColors.textSecondary),
      ),
    );
  }
}
