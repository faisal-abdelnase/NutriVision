import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../models/coach_context.dart';
import '../models/coach_format.dart';

/// Allergies, preferences and goals from the user's nutrition profile that
/// the coach is told to respect.
class CoachGuardrailsCard extends StatelessWidget {
  const CoachGuardrailsCard({super.key, required this.coachContext});

  final CoachContext coachContext;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final text = context.textTheme;
    final scheme = context.colorScheme;
    final profile = coachContext.profile;

    final items = <({IconData icon, Color color, String label})>[];

    if (profile != null) {
      for (final allergy in profile.allergies) {
        items.add((
          icon: Icons.warning_amber_rounded,
          color: context.statusColors.warning,
          label: context.tr('coachGuardAllergy', {'value': allergy}),
        ));
      }
      for (final preference in profile.dietaryPreferences) {
        items.add((
          icon: Icons.check_circle_outline,
          color: scheme.primary,
          label: context.tr('coachGuardPreference', {'value': preference}),
        ));
      }
      final goal = profile.goal;
      if (goal != null && goal.trim().isNotEmpty) {
        items.add((
          icon: Icons.flag_outlined,
          color: scheme.secondary,
          label: context.tr('coachGuardGoal', {'value': goal}),
        ));
      }
    }

    final protein = coachContext.proteinTarget;
    if (protein != null) {
      items.add((
        icon: Icons.tune,
        color: scheme.secondary,
        label: context.tr(
          'coachGuardProtein',
          {'value': formatCoachNumber(protein)},
        ),
      ));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeDimensions.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield_outlined, color: scheme.secondary, size: 20),
                const SizedBox(width: ThemeDimensions.spaceSm),
                Expanded(
                  child: Text(
                    context.tr('coachGuardrailsTitle'),
                    style: text.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: ThemeDimensions.space12),
            if (items.isEmpty)
              Text(
                context.tr('coachGuardEmpty'),
                style: text.bodySmall?.copyWith(color: surfaces.textSecondary),
              )
            else
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: surfaces.level2,
                      borderRadius: ThemeDimensions.borderRadiusMedium,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(item.icon, size: 18, color: item.color),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.label,
                            style: text.bodySmall
                                ?.copyWith(color: surfaces.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
