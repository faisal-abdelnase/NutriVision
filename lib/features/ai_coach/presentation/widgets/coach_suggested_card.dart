import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

/// Ready-made questions that are sent to the coach when tapped.
class CoachSuggestedCard extends StatelessWidget {
  const CoachSuggestedCard({super.key, required this.onPrompt});

  final ValueChanged<String> onPrompt;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final text = context.textTheme;
    final prompts = [
      context.tr('coachSuggested1'),
      context.tr('coachSuggested2'),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeDimensions.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.tr('coachSuggestedTitle'), style: text.titleSmall),
            const SizedBox(height: ThemeDimensions.space12),
            for (final prompt in prompts)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Material(
                  color: surfaces.level2,
                  borderRadius: ThemeDimensions.borderRadiusMedium,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => onPrompt(prompt),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: ThemeDimensions.touchTarget,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                prompt,
                                style: text.bodySmall
                                    ?.copyWith(color: surfaces.textPrimary),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward,
                                size: 16, color: surfaces.textMuted),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
