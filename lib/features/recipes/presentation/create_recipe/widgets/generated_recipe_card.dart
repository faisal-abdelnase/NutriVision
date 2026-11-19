import 'package:flutter/material.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/features/recipes/domain/entities/recipe.dart';

class GeneratedRecipeCard extends StatelessWidget {
  const GeneratedRecipeCard({
    super.key,
    required this.recipe,
    required this.onSave,
  });

  final Recipe recipe;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaces = context.surfaceColors;
    final ai = context.aiColors;
    final nutrition = context.nutritionColors;

    Widget stat(String label, String value, Color color) => Expanded(
          child: Column(
            children: [
              Text(value,
                  style: theme.textTheme.titleMedium?.copyWith(color: color)),
              Text(label, style: theme.textTheme.bodySmall),
            ],
          ),
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(AIThemeColors.icon, size: 18, color: ai.accent),
                const SizedBox(width: 6),
                Text('AI generated',
                    style: theme.textTheme.labelMedium
                        ?.copyWith(color: ai.accent)),
              ],
            ),
            const SizedBox(height: 8),
            Text(recipe.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(recipe.description,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: surfaces.textSecondary)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.timer_outlined, size: 16),
                  label: Text(
                      '${recipe.preparationMinutes + recipe.cookingMinutes} min'),
                ),
                Chip(
                  avatar: const Icon(Icons.people_outline, size: 16),
                  label: Text('${recipe.servings} servings'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: surfaces.level2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  stat('kcal', recipe.caloriesPerServing.round().toString(), nutrition.calories),
                  stat('Protein', '${recipe.proteinGramsPerServing.round()}g', nutrition.protein),
                  stat('Carbs', '${recipe.carbohydrateGramsPerServing.round()}g', nutrition.carbohydrates),
                  stat('Fat', '${recipe.fatGramsPerServing.round()}g', nutrition.fats),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text('per serving', style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
            Text('Ingredients', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final ing in recipe.ingredients)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '• ${ing.quantity % 1 == 0 ? ing.quantity.toInt() : ing.quantity} ${ing.unit} ${ing.name}${ing.isOptional ? ' (optional)' : ''}',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            const SizedBox(height: 16),
            Text('Instructions', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (var i = 0; i < recipe.instructions.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: ai.soft,
                      child: Text('${i + 1}',
                          style: theme.textTheme.labelSmall
                              ?.copyWith(color: ai.onSoft)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(recipe.instructions[i],
                            style: theme.textTheme.bodyMedium)),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.bookmark_border),
                label: const Text('Save recipe'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
