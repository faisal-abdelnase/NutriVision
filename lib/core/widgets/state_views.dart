import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/theme_dimensions.dart';
import '../theme/theme_extensions.dart';
import 'scaled_text.dart';

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeDimensions.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 40, color: context.statusColors.critical),
            const SizedBox(height: ThemeDimensions.space12),
            ScaledText(message,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium),
            if (onRetry != null) ...[
              const SizedBox(height: ThemeDimensions.spaceMd),
              OutlinedButton(
                onPressed: onRetry,
                child: Text(context.tr('retry')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeDimensions.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: context.surfaceColors.textMuted),
            const SizedBox(height: ThemeDimensions.space12),
            ScaledText(message,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: ThemeDimensions.spaceMd),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}