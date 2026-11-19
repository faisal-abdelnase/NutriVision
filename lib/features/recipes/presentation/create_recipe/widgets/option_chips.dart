import 'package:flutter/material.dart';

/// Wrap of selectable chips. Selection logic (single / multi) is decided
/// by the caller through [onToggle].
class OptionChips extends StatelessWidget {
  const OptionChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          FilterChip(
            label: Text(option),
            selected: selected.contains(option),
            onSelected: (_) => onToggle(option),
          ),
      ],
    );
  }
}
