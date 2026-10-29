import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

/// Shown while the coach is preparing an answer.
class CoachTypingIndicator extends StatelessWidget {
  const CoachTypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;

    return Semantics(
      liveRegion: true,
      label: context.tr('coachTyping'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SyncAvatar(),
          const SizedBox(width: 12),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
              decoration: BoxDecoration(
                color: surfaces.level2,
                borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(4),
                  topEnd: Radius.circular(ThemeDimensions.radiusCard),
                  bottomStart: Radius.circular(ThemeDimensions.radiusCard),
                  bottomEnd: Radius.circular(ThemeDimensions.radiusCard),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _BouncingDots(),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      context.tr('coachTyping'),
                      style: context.textTheme.bodySmall
                          ?.copyWith(color: surfaces.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BouncingDots extends StatefulWidget {
  const _BouncingDots();

  @override
  State<_BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<_BouncingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final t = (_controller.value - index * 0.15) % 1.0;
            final offset = -4 * math.sin(t * math.pi);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Transform.translate(
                offset: Offset(0, offset),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _SyncAvatar extends StatelessWidget {
  const _SyncAvatar();

  @override
  Widget build(BuildContext context) {
    final ai = context.aiColors;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: ai.soft, shape: BoxShape.circle),
      child: Icon(Icons.sync, size: 20, color: ai.onSoft),
    );
  }
}
