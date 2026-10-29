import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'coach_metric_tile.dart';
import 'coach_pill.dart';

/// Horizontally scrollable shortcuts above the input field. The first chip
/// requests personalized advice from the backend; the others send a message.
class CoachQuickPrompts extends StatelessWidget {
  const CoachQuickPrompts({
    super.key,
    required this.onPrompt,
    required this.onAdvice,
    required this.canSend,
    required this.hasAdvice,
    required this.isLoadingAdvice,
  });

  final ValueChanged<String> onPrompt;
  final VoidCallback onAdvice;
  final bool canSend;
  final bool hasAdvice;
  final bool isLoadingAdvice;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final colors = CoachMacroColors.of(context);
    final border = context.surfaceColors.border;

    final prompts = <({IconData icon, Color color, String label})>[
      (
        icon: Icons.schedule,
        color: scheme.primary,
        label: context.tr('coachPromptNext'),
      ),
      (
        icon: Icons.troubleshoot,
        color: colors.carbs,
        label: context.tr('coachPromptBalance'),
      ),
      (
        icon: Icons.cookie_outlined,
        color: colors.fats,
        label: context.tr('coachPromptSnack'),
      ),
      (
        icon: Icons.speed,
        color: colors.protein,
        label: context.tr('coachPromptProtein'),
      ),
    ];

    return SizedBox(
      height: ThemeDimensions.touchTarget,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeDimensions.spaceMd,
        ),
        children: [
          CoachPill(
            label: context.tr(
              hasAdvice ? 'coachAdviceRefresh' : 'coachAdviceGet',
            ),
            icon: isLoadingAdvice
                ? Icons.hourglass_top_rounded
                : Icons.auto_awesome,
            iconColor: scheme.primary,
            borderColor: border,
            onTap: isLoadingAdvice ? null : onAdvice,
          ),
          for (final prompt in prompts) ...[
            const SizedBox(width: ThemeDimensions.spaceSm),
            CoachPill(
              label: prompt.label,
              icon: prompt.icon,
              iconColor: prompt.color,
              borderColor: border,
              onTap: canSend ? () => onPrompt(prompt.label) : null,
            ),
          ],
        ],
      ),
    );
  }
}
