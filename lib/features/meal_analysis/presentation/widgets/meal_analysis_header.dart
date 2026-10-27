import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/responsive/breakpoints.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_pill.dart';

/// Page heading with the main screen actions.
///
/// Optional actions are only rendered when their owning feature supplies a
/// callback.
class MealAnalysisHeader extends StatelessWidget {
  const MealAnalysisHeader({
    super.key,
    required this.logId,
    required this.isLogging,
    required this.isLogged,
    this.onConfirm,
    this.onEditPortions,
    this.onAskDietitian,
  });

  final String logId;
  final bool isLogging;
  final bool isLogged;
  final VoidCallback? onConfirm;
  final VoidCallback? onEditPortions;
  final VoidCallback? onAskDietitian;

  @override
  Widget build(BuildContext context) {
    final status = context.statusColors;
    final surfaces = context.surfaceColors;

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MealAnalysisPill(
          label: context.tr('mealAnalysisLogBadge', {'id': logId}),
          background: status.infoContainer,
          foreground: status.onInfoContainer,
          uppercase: true,
        ),
        const SizedBox(height: ThemeDimensions.spaceSm),
        Text(
          context.tr('mealAnalysisTitle'),
          style: context.textTheme.headlineLarge,
        ),
        const SizedBox(height: ThemeDimensions.spaceXs),
        Text(
          context.tr('mealAnalysisSubtitle'),
          style: context.textTheme.bodyMedium?.copyWith(
            color: surfaces.textSecondary,
          ),
        ),
      ],
    );

    final actions = Wrap(
      spacing: ThemeDimensions.spaceSm,
      runSpacing: ThemeDimensions.spaceSm,
      children: [
        if (onEditPortions != null)
          FilledButton.icon(
            onPressed: onEditPortions,
            icon: const Icon(Icons.tune, size: 18),
            label: Text(context.tr('mealAnalysisEditPortions')),
          ),
        if (onAskDietitian != null)
          OutlinedButton.icon(
            onPressed: onAskDietitian,
            icon: const Icon(Icons.forum_outlined, size: 18),
            label: Text(context.tr('mealAnalysisAskDietitian')),
          ),
        ElevatedButton.icon(
          onPressed: (isLogging || isLogged) ? null : onConfirm,
          icon: isLogging
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  isLogged ? Icons.task_alt : Icons.check_circle_outline,
                  size: 18,
                ),
          label: Text(
            context.tr(
              isLogged ? 'mealAnalysisLogged' : 'mealAnalysisConfirmLog',
            ),
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.lg) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: titleBlock),
              const SizedBox(width: ThemeDimensions.spaceMd),
              actions,
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleBlock,
            const SizedBox(height: ThemeDimensions.spaceMd),
            actions,
          ],
        );
      },
    );
  }
}
