import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/responsive/responsive_value.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

/// Text field, send button and the clinical disclaimer.
class CoachInputDock extends StatelessWidget {
  const CoachInputDock({
    super.key,
    required this.controller,
    required this.enabled,
    required this.isSending,
    required this.onSend,
  });

  final TextEditingController controller;

  /// False until a conversation is open.
  final bool enabled;
  final bool isSending;
  final ValueChanged<String> onSend;

  void _submit() {
    final text = controller.text.trim();
    if (text.isEmpty || !enabled || isSending) return;
    controller.clear();
    onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final text = context.textTheme;
    final showLabel = responsiveValue<bool>(context, xs: false, sm: true);

    return Padding(
      padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsetsDirectional.only(
              start: ThemeDimensions.space12,
              end: ThemeDimensions.spaceSm,
              top: 6,
              bottom: 6,
            ),
            decoration: BoxDecoration(
              color: surfaces.level2,
              borderRadius: ThemeDimensions.borderRadiusCard,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    enabled: enabled,
                    minLines: 1,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: context.tr('coachInputHint'),
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: ThemeDimensions.spaceSm),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    final canSend =
                        enabled && !isSending && value.text.trim().isNotEmpty;
                    return showLabel
                        ? FilledButton.icon(
                            onPressed: canSend ? _submit : null,
                            icon: const Icon(Icons.arrow_forward, size: 18),
                            label: Text(context.tr('coachSend')),
                          )
                        : IconButton.filled(
                            onPressed: canSend ? _submit : null,
                            tooltip: context.tr('coachSend'),
                            icon: const Icon(Icons.arrow_forward, size: 18),
                          );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: ThemeDimensions.spaceSm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.health_and_safety_outlined,
                  size: 14, color: surfaces.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  context.tr('coachDisclaimer'),
                  style: text.labelSmall?.copyWith(color: surfaces.textMuted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
