import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/string_extensions.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/utils/formatters.dart';
import 'package:nutri_vision/features/meal_tracking/domain/entities/meal.dart';

import 'macro_chip.dart';

class MealHistoryTile extends StatelessWidget {
  const MealHistoryTile({
    super.key,
    required this.meal,
    required this.onDelete,
    this.onTap,
  });

  final Meal meal;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  IconData _icon() => switch (meal.mealType.toLowerCase()) {
        'breakfast' => Icons.free_breakfast_outlined,
        'lunch' => Icons.lunch_dining_outlined,
        'dinner' => Icons.dinner_dining_outlined,
        'snack' => Icons.cookie_outlined,
        _ => Icons.restaurant_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaces = context.surfaceColors;
    final nutrition = context.nutritionColors;

    return Card(
      child: InkWell(
        borderRadius: ThemeDimensions.borderRadiusCard,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: nutrition.proteinSoft,
                  borderRadius: ThemeDimensions.borderRadiusMedium,
                ),
                child: Icon(_icon(), color: nutrition.protein),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${meal.mealType.capitalize()} • ${Formatters.time(meal.eatenAt)}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: surfaces.textMuted),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        MacroChip(label: 'P', grams: meal.proteinGrams, color: nutrition.protein),
                        MacroChip(label: 'C', grams: meal.carbohydrateGrams, color: nutrition.carbohydrates),
                        MacroChip(label: 'F', grams: meal.fatGrams, color: nutrition.fats),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${meal.calories.round()}',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: nutrition.calories),
                  ),
                  Text('kcal', style: theme.textTheme.bodySmall),
                  IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
