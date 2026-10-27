import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/responsive/responsive_value.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/theme/theme_text_styles.dart';
import 'package:nutri_vision/core/utils/formatters.dart';
import 'package:nutri_vision/features/meal_analysis/domain/entities/analyzed_food_item.dart';
import 'package:nutri_vision/features/meal_analysis/domain/entities/meal_analysis_result.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/utils/meal_analysis_summary.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_card.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/widgets/meal_analysis_pill.dart';

/// Meal photo with detected items overlay. All values are real backend data.
class MealAnalysisHeroCard extends StatelessWidget {
  const MealAnalysisHeroCard({
    super.key,
    required this.result,
    required this.summary,
  });

  final MealAnalysisResult result;
  final MealAnalysisSummary summary;

  @override
  Widget build(BuildContext context) {
    final imageHeight = responsiveValue<double>(
      context,
      xs: 220,
      sm: 240,
      md: 300,
      lg: 320,
    );

    return MealAnalysisCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: ThemeDimensions.borderRadiusMedium,
            child: SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _MealImage(url: result.sourceImageUrl),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
                    child: _Overlay(result: result, summary: summary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: ThemeDimensions.spaceMd),
          const _Disclaimer(),
        ],
      ),
    );
  }
}

class _MealImage extends StatelessWidget {
  const _MealImage({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final placeholder = ColoredBox(
      color: surfaces.level2,
      child: Center(
        child: Icon(Icons.restaurant, size: 48, color: surfaces.textMuted),
      ),
    );

    final imageUrl = url;
    if (imageUrl == null || imageUrl.isEmpty) return placeholder;

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}

class _Overlay extends StatelessWidget {
  const _Overlay({required this.result, required this.summary});

  final MealAnalysisResult result;
  final MealAnalysisSummary summary;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = context.textTheme;
    final title = summary.title ?? context.tr('mealAnalysisUnnamedMeal');
    final weight = summary.totalWeightGrams;
    final items = result.foodItems.take(2).toList();
    final status = context.statusColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: ThemeDimensions.spaceSm,
          runSpacing: ThemeDimensions.spaceSm,
          children: [
            if (summary.confidencePercent != null)
              _OverlayChip(
                icon: Icons.verified,
                iconColor: status.success,
                label: context.tr('mealAnalysisConfidence', {
                  'value': formatMetric(summary.confidencePercent!, decimals: 1),
                }),
              ),
            _OverlayChip(
              icon: Icons.schedule,
              label: context.tr('mealAnalysisLoggedAt', {
                'time': Formatters.time(result.analyzedAt),
              }),
            ),
          ],
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (items.isNotEmpty)
                Align(
                  alignment: const AlignmentDirectional(-0.9, -0.2),
                  child: _DetectionTag(item: items[0], dotColor: status.success),
                ),
              if (items.length > 1)
                Align(
                  alignment: const AlignmentDirectional(0.9, 0.5),
                  child: _DetectionTag(item: items[1], dotColor: status.info),
                ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MealAnalysisPill(
                    label: context.tr(summary.mealTypeLabelKey),
                    background: cs.primary,
                    foreground: cs.onPrimary,
                    uppercase: true,
                  ),
                  const SizedBox(height: ThemeDimensions.spaceXs),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  if (weight > 0)
                    Text(
                      context.tr('mealAnalysisWeightNote', {
                        'weight': formatMetric(weight),
                      }),
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
            if (weight > 0) ...[
              const SizedBox(width: ThemeDimensions.space12),
              _OverlayChip(
                icon: Icons.scale_outlined,
                label: context.tr('mealAnalysisWeightChip', {
                  'weight': formatMetric(weight),
                }),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _OverlayChip extends StatelessWidget {
  const _OverlayChip({required this.icon, required this.label, this.iconColor});

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: ThemeDimensions.space12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: surfaces.level1.withValues(alpha: 0.9),
        borderRadius: ThemeDimensions.borderRadiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor ?? surfaces.textSecondary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(
                color: surfaces.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetectionTag extends StatelessWidget {
  const _DetectionTag({required this.item, required this.dotColor});

  final AnalyzedFoodItem item;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final confidence = item.confidenceScore;
    final quantity = formatMetric(item.estimatedQuantity);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 240),
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: surfaces.level1.withValues(alpha: 0.9),
          borderRadius: ThemeDimensions.borderRadiusMedium,
          border: Border.all(color: dotColor.withValues(alpha: 0.6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 4, backgroundColor: dotColor),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                '${item.name} ($quantity ${item.quantityUnit})'
                '${confidence == null ? '' : ' • ${formatMetric(normalizePercent(confidence))}%'}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  color: surfaces.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final status = context.statusColors;
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.all(ThemeDimensions.space12),
      decoration: BoxDecoration(
        color: surfaces.level2,
        borderRadius: ThemeDimensions.borderRadiusMedium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: status.info),
          const SizedBox(width: ThemeDimensions.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ThemeTextStyles.clinicalCase(
                    context.tr('mealAnalysisDisclaimerTitle'),
                    locale,
                  ),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: surfaces.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.tr('mealAnalysisDisclaimerBody'),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: surfaces.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
