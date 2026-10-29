import 'package:flutter/material.dart';

import '../../../../core/theme/theme_dimensions.dart';
import '../models/coach_context.dart';
import 'coach_guardrails_card.dart';
import 'coach_nutrition_card.dart';
import 'coach_suggested_card.dart';

/// Right-hand column on desktop; shown in a sheet/dialog on smaller screens.
class CoachContextSidebar extends StatelessWidget {
  const CoachContextSidebar({
    super.key,
    required this.coachContext,
    required this.onPrompt,
  });

  final CoachContext coachContext;
  final ValueChanged<String> onPrompt;

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: ThemeDimensions.spaceMd);

    return Column(
      children: [
        CoachNutritionCard(coachContext: coachContext),
        gap,
        CoachGuardrailsCard(coachContext: coachContext),
        gap,
        CoachSuggestedCard(onPrompt: onPrompt),
      ],
    );
  }
}
