import 'package:flutter/material.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/features/recipes/domain/entities/grocery_item.dart';

class GroceryItemTile extends StatelessWidget {
  const GroceryItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  final GroceryItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  String _quantity() {
    final q = item.quantity;
    final text = q == q.roundToDouble() ? q.toInt().toString() : q.toStringAsFixed(1);
    return '$text ${item.unit}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaces = context.surfaceColors;
    final checked = item.isChecked;

    final subtitle = [
      _quantity(),
      if (item.recipeTitle != null) 'from ${item.recipeTitle}',
    ].join(' • ');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onToggle,
        leading: Checkbox(value: checked, onChanged: (_) => onToggle()),
        title: Text(
          item.name,
          style: theme.textTheme.titleSmall?.copyWith(
            decoration: checked ? TextDecoration.lineThrough : null,
            color: checked ? surfaces.textMuted : surfaces.textPrimary,
          ),
        ),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
        trailing: IconButton(
          tooltip: 'Remove',
          icon: const Icon(Icons.close),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
