import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';

class MealAnalysisLoadingView extends StatelessWidget {
  const MealAnalysisLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: ThemeDimensions.spaceMd),
          Text(
            context.tr('loading'),
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class MealAnalysisErrorView extends StatelessWidget {
  const MealAnalysisErrorView({super.key, this.message, this.onRetry});

  /// Backend message; shown under the localized title when available.
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final status = context.statusColors;
    final surfaces = context.surfaceColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeDimensions.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: status.critical),
            const SizedBox(height: ThemeDimensions.spaceMd),
            Text(
              context.tr('error'),
              style: context.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: ThemeDimensions.spaceSm),
              Text(
                message!,
                style: context.textTheme.bodySmall?.copyWith(
                  color: surfaces.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: ThemeDimensions.spaceLg),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(context.tr('retry')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MealAnalysisEmptyView extends StatelessWidget {
  const MealAnalysisEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.restaurant_outlined, size: 48, color: surfaces.textMuted),
          const SizedBox(height: ThemeDimensions.spaceMd),
          Text(
            context.tr('noData'),
            style: context.textTheme.bodyMedium?.copyWith(
              color: surfaces.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
