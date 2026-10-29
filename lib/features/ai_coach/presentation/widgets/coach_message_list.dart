import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../domain/entities/coach_message.dart';
import '../../domain/entities/nutrition_advice.dart';
import 'coach_advice_card.dart';
import 'coach_message_bubble.dart';
import 'coach_typing_indicator.dart';

/// Scrollable conversation. Order: earlier-messages button, messages, the
/// advice card (when requested), then the typing indicator.
class CoachMessageList extends StatefulWidget {
  const CoachMessageList({
    super.key,
    required this.messages,
    required this.advice,
    required this.isSending,
    required this.canLoadEarlier,
    required this.isLoadingEarlier,
    required this.onLoadEarlier,
  });

  final List<CoachMessage> messages;
  final NutritionAdvice? advice;
  final bool isSending;
  final bool canLoadEarlier;
  final bool isLoadingEarlier;
  final VoidCallback onLoadEarlier;

  @override
  State<CoachMessageList> createState() => _CoachMessageListState();
}

class _CoachMessageListState extends State<CoachMessageList> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd(false));
  }

  @override
  void didUpdateWidget(covariant CoachMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldLast =
        oldWidget.messages.isEmpty ? null : oldWidget.messages.last.id;
    final newLast = widget.messages.isEmpty ? null : widget.messages.last.id;

    if (oldLast != newLast ||
        oldWidget.isSending != widget.isSending ||
        oldWidget.advice?.id != widget.advice?.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd(true));
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToEnd(bool animate) {
    if (!mounted || !_scroll.hasClients) return;
    final target = _scroll.position.maxScrollExtent;
    if (animate) {
      _scroll.animateTo(
        target,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _scroll.jumpTo(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showEarlier = widget.canLoadEarlier;
    final offset = showEarlier ? 1 : 0;
    final messageCount = widget.messages.length;
    final advice = widget.advice;
    final count = offset +
        messageCount +
        (advice != null ? 1 : 0) +
        (widget.isSending ? 1 : 0);

    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
      itemCount: count,
      itemBuilder: (context, index) {
        if (showEarlier && index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: ThemeDimensions.spaceMd),
            child: Center(
              child: widget.isLoadingEarlier
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : TextButton(
                      onPressed: widget.onLoadEarlier,
                      child: Text(context.tr('coachLoadEarlier')),
                    ),
            ),
          );
        }

        final position = index - offset;
        final Widget child;
        if (position < messageCount) {
          child = CoachMessageBubble(message: widget.messages[position]);
        } else if (advice != null && position == messageCount) {
          child = CoachAdviceCard(advice: advice);
        } else {
          child = const CoachTypingIndicator();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: ThemeDimensions.spaceLg),
          child: child,
        );
      },
    );
  }
}
