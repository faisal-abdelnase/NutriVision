import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../domain/entities/coach_message.dart';
import 'coach_pill.dart';

class CoachAvatar extends StatelessWidget {
  const CoachAvatar({super.key, required this.isUser});

  final bool isUser;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final surfaces = context.surfaceColors;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isUser ? surfaces.level2 : scheme.primary,
        borderRadius: ThemeDimensions.borderRadiusMedium,
        border: isUser ? Border.all(color: surfaces.border) : null,
      ),
      child: Icon(
        isUser ? Icons.person_outline : Icons.psychology_outlined,
        size: 22,
        color: isUser ? surfaces.textPrimary : scheme.onPrimary,
      ),
    );
  }
}

/// One chat message. The tail corner and avatar side follow the text
/// direction, so the layout mirrors automatically in Arabic.
class CoachMessageBubble extends StatelessWidget {
  const CoachMessageBubble({super.key, required this.message});

  final CoachMessage message;

  bool get _isUser => message.role == CoachMessageRole.user;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final surfaces = context.surfaceColors;
    final text = context.textTheme;
    final ai = context.aiColors;

    final time = Text(
      Formatters.time(message.createdAt),
      style: text.bodySmall,
    );
    final profileName = context
        .select((ProfileCubit cubit) => cubit.state.profile?.fullName)
        ?.trim();
    final name = Text(
      _isUser
          ? (profileName == null || profileName.isEmpty
              ? context.tr('coachYou')
              : profileName)
          : context.tr('coachAiName'),
      style: text.labelLarge,
    );

    final meta = Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: _isUser
          ? [time, name]
          : [
              name,
              CoachPill(
                compact: true,
                label: context.tr('coachAiBadge'),
                background: ai.soft,
                foreground: ai.onSoft,
              ),
              time,
            ],
    );

    const large = Radius.circular(ThemeDimensions.radiusCard);
    const small = Radius.circular(4);

    final bubble = Container(
      padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
      decoration: BoxDecoration(
        color: _isUser ? scheme.primary : surfaces.level2,
        borderRadius: BorderRadiusDirectional.only(
          topStart: _isUser ? large : small,
          topEnd: _isUser ? small : large,
          bottomStart: large,
          bottomEnd: large,
        ),
      ),
      child: SelectableText(
        message.content,
        style: text.bodyMedium?.copyWith(
          height: 1.5,
          color: _isUser ? scheme.onPrimary : surfaces.textPrimary,
        ),
      ),
    );

    final body = Flexible(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          crossAxisAlignment:
              _isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            meta,
            const SizedBox(height: 6),
            bubble,
          ],
        ),
      ),
    );

    final row = Row(
      mainAxisAlignment:
          _isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _isUser
          ? [body, const SizedBox(width: 12), CoachAvatar(isUser: true)]
          : [CoachAvatar(isUser: false), const SizedBox(width: 12), body],
    );

    // Announce assistant replies to screen readers.
    return _isUser ? row : Semantics(liveRegion: true, child: row);
  }
}
