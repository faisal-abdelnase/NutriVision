import 'package:flutter/material.dart';

import 'adaptive_layout.dart';

/// Shows [child] as a modal bottom sheet on compact (mobile) layouts and
/// as a centered dialog on medium/expanded layouts — the interaction
/// pattern users expect on each form factor.
Future<T?> showAdaptiveDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) {
  final layoutClass = AdaptiveLayout.of(context);

  if (layoutClass == AdaptiveLayoutClass.compact) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: builder,
    );
  }

  return showDialog<T>(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: builder(context),
      ),
    ),
  );
}
