import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/nutrition_advice.dart';
import 'coach_pill.dart';

/// Rich card shown in the chat stream with the personalized advice returned
/// by the coach backend. It is indented to line up with assistant bubbles.
class CoachAdviceCard extends StatelessWidget {
  const CoachAdviceCard({super.key, required this.advice});

  final NutritionAdvice advice;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final text = context.textTheme;
    final ai = context.aiColors;
    final status = context.statusColors;
    final scheme = context.colorScheme;
    final confidence = advice.confidenceScore;

    final card = Container(
      padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
      decoration: BoxDecoration(
        color: surfaces.level1,
        borderRadius: ThemeDimensions.borderRadiusCard,
        border: Border.all(color: surfaces.border),
        boxShadow: surfaces.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: ThemeDimensions.spaceSm,
            runSpacing: ThemeDimensions.spaceSm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CoachPill(
                compact: true,
                label: advice.category,
                icon: AIThemeColors.icon,
                background: ai.soft,
                foreground: ai.onSoft,
                borderColor: ai.border,
              ),
              if (confidence != null)
                CoachPill(
                  compact: true,
                  label: context.tr('coachAdviceConfidence', {
                    'value': (confidence <= 1 ? confidence * 100 : confidence)
                        .round()
                        .toString(),
                  }),
                ),
              Text(Formatters.time(advice.generatedAt), style: text.bodySmall),
            ],
          ),
          const SizedBox(height: ThemeDimensions.space12),
          Text(advice.title, style: text.titleLarge),
          const SizedBox(height: ThemeDimensions.spaceSm),
          Text(
            advice.content,
            style: text.bodyMedium?.copyWith(
              height: 1.5,
              color: surfaces.textSecondary,
            ),
          ),
          if (advice.recommendations.isNotEmpty) ...[
            const SizedBox(height: ThemeDimensions.spaceMd),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ThemeDimensions.space12),
              decoration: BoxDecoration(
                color: surfaces.level2,
                borderRadius: ThemeDimensions.borderRadiusMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('coachAdviceRecommendations'),
                    style: text.labelMedium?.copyWith(color: ai.onSoft),
                  ),
                  for (final item in advice.recommendations)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 16, color: scheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item,
                              style: text.bodySmall
                                  ?.copyWith(color: surfaces.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
          if (advice.warnings.isNotEmpty) ...[
            const SizedBox(height: ThemeDimensions.space12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ThemeDimensions.space12),
              decoration: BoxDecoration(
                color: status.warningContainer,
                borderRadius: ThemeDimensions.borderRadiusMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('coachAdviceWarnings'),
                    style: text.labelMedium
                        ?.copyWith(color: status.onWarningContainer),
                  ),
                  for (final warning in advice.warnings)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              size: 16, color: status.onWarningContainer),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              warning,
                              style: text.bodySmall?.copyWith(
                                  color: status.onWarningContainer),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 52),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: card,
          ),
        ),
      ],
    );
  }
}
