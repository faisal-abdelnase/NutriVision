import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../cubit/ai_coach_cubit.dart';
import '../cubit/ai_coach_state.dart';
import '../models/coach_context.dart';
import 'coach_context_builder.dart';
import 'coach_empty_state.dart';
import 'coach_input_dock.dart';
import 'coach_message_list.dart';
import 'coach_quick_prompts.dart';

/// The conversation card: messages, quick prompts and the input dock.
class CoachChatPanel extends StatelessWidget {
  const CoachChatPanel({
    super.key,
    required this.userId,
    required this.controller,
    required this.onSend,
    required this.onRetry,
  });

  final String userId;
  final TextEditingController controller;
  final ValueChanged<String> onSend;
  final VoidCallback onRetry;

  void _requestAdvice(BuildContext context, CoachContext coachContext) {
    final profile = coachContext.profile;
    context.read<AiCoachCubit>().loadNutritionAdvice(
          userId: userId,
          dietaryPreferences: profile?.dietaryPreferences ?? const [],
          allergies: profile?.allergies ?? const [],
          referencedMealIds:
              coachContext.recentMeals.map((meal) => meal.mealId).toList(),
          goal: profile?.goal,
        );
  }

  @override
  Widget build(BuildContext context) {
    return CoachContextBuilder(
      userId: userId,
      builder: (context, coachContext) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: BlocBuilder<AiCoachCubit, AiCoachState>(
            builder: (context, state) {
              final hasConversation = state.currentConversation != null;
              final isInitialLoading = state.messages.isEmpty &&
                  (state.status == AiCoachStatus.initial ||
                      state.status == AiCoachStatus.loading);
              final hasFailed =
                  state.status == AiCoachStatus.failure && !hasConversation;
              final canSend = hasConversation && !state.isSending;
              final advice = state.nutritionAdvice;

              final Widget body;
              if (isInitialLoading) {
                body = const Center(child: CircularProgressIndicator());
              } else if (hasFailed) {
                body = _ChatErrorState(onRetry: onRetry);
              } else if (state.messages.isEmpty &&
                  advice == null &&
                  !state.isSending) {
                body = const CoachEmptyState();
              } else {
                body = CoachMessageList(
                  messages: state.messages,
                  advice: advice,
                  isSending: state.isSending,
                  canLoadEarlier: state.hasMoreMessages &&
                      state.messages.length >= AiCoachCubit.pageSize,
                  isLoadingEarlier: state.isLoadingMore,
                  onLoadEarlier: () => context
                      .read<AiCoachCubit>()
                      .loadEarlierMessages(userId: userId),
                );
              }

              return Column(
                children: [
                  Expanded(child: body),
                  if (hasConversation && !isInitialLoading) ...[
                    CoachQuickPrompts(
                      onPrompt: onSend,
                      onAdvice: () => _requestAdvice(context, coachContext),
                      canSend: canSend,
                      hasAdvice: advice != null,
                      isLoadingAdvice: state.isLoadingAdvice,
                    ),
                    const SizedBox(height: ThemeDimensions.spaceXs),
                  ],
                  CoachInputDock(
                    controller: controller,
                    enabled: hasConversation,
                    isSending: state.isSending,
                    onSend: onSend,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _ChatErrorState extends StatelessWidget {
  const _ChatErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeDimensions.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined,
                size: 40, color: context.surfaceColors.textMuted),
            const SizedBox(height: ThemeDimensions.spaceMd),
            Text(
              context.tr('coachLoadFailed'),
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: ThemeDimensions.spaceMd),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(context.tr('retry')),
            ),
          ],
        ),
      ),
    );
  }
}
