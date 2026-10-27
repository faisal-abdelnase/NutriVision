import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_card.dart';

/// Export / share actions supplied by the owning features.
class MealAnalysisExportCard extends StatelessWidget {
  const MealAnalysisExportCard({
    super.key,
    this.onDownloadPdf,
    this.onShareWithDietitian,
  });

  final VoidCallback? onDownloadPdf;
  final VoidCallback? onShareWithDietitian;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final status = context.statusColors;
    final textTheme = context.textTheme;

    final info = Row(
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeDimensions.spaceSm),
          decoration: BoxDecoration(
            color: status.infoContainer,
            borderRadius: ThemeDimensions.borderRadiusMedium,
          ),
          child: Icon(Icons.assignment_outlined, color: status.info),
        ),
        const SizedBox(width: ThemeDimensions.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('mealAnalysisExportTitle'),
                style: textTheme.titleSmall,
              ),
              Text(
                context.tr('mealAnalysisExportSubtitle'),
                style: textTheme.bodySmall?.copyWith(
                  color: surfaces.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final actions = Wrap(
      spacing: ThemeDimensions.spaceSm,
      runSpacing: ThemeDimensions.spaceSm,
      children: [
        if (onDownloadPdf != null)
          FilledButton.icon(
            onPressed: onDownloadPdf,
            icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
            label: Text(context.tr('mealAnalysisDownloadPdf')),
          ),
        if (onShareWithDietitian != null)
          ElevatedButton.icon(
            onPressed: onShareWithDietitian,
            icon: const Icon(Icons.share_outlined, size: 18),
            label: Text(context.tr('mealAnalysisShareDietitian')),
          ),
      ],
    );

    return MealAnalysisCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 720) {
            return Row(
              children: [
                Expanded(child: info),
                const SizedBox(width: ThemeDimensions.spaceMd),
                actions,
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              info,
              const SizedBox(height: ThemeDimensions.spaceMd),
              actions,
            ],
          );
        },
      ),
    );
  }
}
