import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

/// Shown when the conversation has no messages yet.
class CoachEmptyState extends StatelessWidget {
  const CoachEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final ai = context.aiColors;
    final text = context.textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeDimensions.spaceLg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: ai.soft,
                  borderRadius: ThemeDimensions.borderRadiusCard,
                ),
                child: Icon(Icons.psychology_alt_outlined,
                    size: 36, color: ai.onSoft),
              ),
              const SizedBox(height: ThemeDimensions.spaceMd),
              Text(
                context.tr('coachEmptyTitle'),
                textAlign: TextAlign.center,
                style: text.headlineMedium,
              ),
              const SizedBox(height: ThemeDimensions.spaceSm),
              Text(
                context.tr('coachEmptyDesc'),
                textAlign: TextAlign.center,
                style: text.bodyMedium
                    ?.copyWith(color: context.surfaceColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
