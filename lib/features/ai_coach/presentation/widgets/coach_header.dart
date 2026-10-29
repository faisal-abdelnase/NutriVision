import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/responsive/responsive_value.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../cubit/ai_coach_cubit.dart';
import 'coach_pill.dart';

/// Page title with badge, subtitle and the reset-session action.
class CoachHeader extends StatelessWidget {
  const CoachHeader({
    super.key,
    required this.onNewSession,
    this.onInsights,
  });

  final VoidCallback onNewSession;

  /// Opens the insights sheet; only provided on screens without the sidebar.
  final VoidCallback? onInsights;

  @override
  Widget build(BuildContext context) {
    final ai = context.aiColors;
    final surfaces = context.surfaceColors;
    final text = context.textTheme;
    final isBusy =
        context.select((AiCoachCubit cubit) => cubit.state.isSending);
    final canPop = Navigator.of(context).canPop();

    final titleStyle = responsiveValue<TextStyle>(
      context,
      xs: text.headlineSmall!,
      md: text.headlineMedium!,
      lg: text.headlineLarge!,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (canPop) ...[
          IconButton(
            tooltip: context.tr('back'),
            icon: const BackButtonIcon(),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: ThemeDimensions.spaceXs),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: ThemeDimensions.space12,
                runSpacing: ThemeDimensions.spaceXs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(context.tr('coachTitle'), style: titleStyle),
                  CoachPill(
                    compact: true,
                    label: context.tr('coachBadge'),
                    background: ai.soft,
                    foreground: ai.onSoft,
                    borderColor: ai.border,
                  ),
                ],
              ),
              const SizedBox(height: ThemeDimensions.spaceXs),
              Text(
                context.tr('coachSubtitle'),
                style: text.bodyMedium?.copyWith(color: surfaces.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(width: ThemeDimensions.spaceSm),
        if (onInsights != null)
          IconButton(
            tooltip: context.tr('coachInsights'),
            icon: const Icon(Icons.insights_outlined),
            onPressed: onInsights,
          ),
        TextButton.icon(
          onPressed: isBusy ? null : onNewSession,
          icon: const Icon(Icons.history, size: 18),
          label: Text(context.tr('coachNewSession')),
        ),
      ],
    );
  }
}
