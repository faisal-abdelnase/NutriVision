import 'package:flutter/material.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';

class ClinicalSpecCard extends StatelessWidget {
  const ClinicalSpecCard({super.key, required this.stepIndex});

  final int stepIndex;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final isDark = context.isDarkMode;

    final bgColor = isDark
        ? ThemeColors.darkSurface1
        : ThemeColors.stitchSurfaceContainerLow;
    final itemBg = isDark
        ? ThemeColors.darkSurface2
        : ThemeColors.stitchSurfaceContainerLowest;
    final borderColor = isDark
        ? ThemeColors.darkBorder
        : ThemeColors.stitchSurfaceContainerHighest.withValues(alpha: 0.5);

    String title;
    String subtitle;
    String badge;
    List<Map<String, String>> items;

    if (stepIndex == 0) {
      title = 'Flutter Architecture & State Contract';
      subtitle = 'Package: package:nutri_vision/features/nutrition_profile';
      badge = 'v2.4-Production-Spec';
      items = [
        {
          'tag': 'BLoC / Cubit Architecture',
          'color': 'primary',
          'body':
              'NutritionProfileCubit orchestrates immutable UserBiometrics(age, gender, heightCm, weightKg, activityFactor) and persists to secure storage.',
        },
        {
          'tag': 'BMR Algorithm Contract',
          'color': 'secondary',
          'body':
              'MifflinStJeorCalculator.calculate(biometrics) outputs dynamic BMR and TDEE in real time with zero frame stutter.',
        },
        {
          'tag': 'Adaptive Canvas & RTL',
          'color': 'tertiary',
          'body':
              'LayoutBuilder transitions dynamically between vertical Column on mobile and split 12-col layout on desktop with full RTL flipping.',
        },
      ];
    } else if (stepIndex == 1) {
      title = 'Flutter Cross-Platform Architecture Specification';
      subtitle = 'Step 2 of 3 • Goal Selection & Target Calibrator';
      badge = 'WCAG AAA';
      items = [
        {
          'tag': 'GoalSelectionNotifier Contract',
          'color': 'primary',
          'body':
              'State management ensures instantaneous reaction to goal switches, providing haptic feedback and recalculating caloric boundaries.',
        },
        {
          'tag': 'Accessible WCAG AAA Semantics',
          'color': 'secondary',
          'body':
              'Each option renders Semantics(selected: isSelected, button: true, label: goal.title) ensuring screen readers announce real-time state changes.',
        },
        {
          'tag': '8-Point Spatial System',
          'color': 'tertiary',
          'body':
              'Internal micro-badges use 4px sub-grid with strict 44x44px min-touch areas, localized Arabic numerals, and auto-mirrored RTL vector arrows.',
        },
      ];
    } else {
      title = 'Cross-Platform Architecture Specification (BLoC • WCAG AAA)';
      subtitle = 'Step 3 of 3 • NutriVision Onboarding Engine Pipeline';
      badge = 'Deterministic Zero-Error Heuristic';
      items = [
        {
          'tag': 'STATE MANAGEMENT',
          'color': 'primary',
          'body':
              'Implements an immutable AllergenFilterState. Dispatches synchronous ToggleAllergenIntent with immediate re-evaluation of high-risk ingredient tokens.',
        },
        {
          'tag': 'CLINICAL GUARDRAIL',
          'color': 'secondary',
          'body':
              'Zero-tolerance algorithmic filter matching CODEX STAN 1-1985 & FDA FALCPA standards. Replaces allergen vectors with isocaloric alternatives in the meal swap tensor.',
        },
        {
          'tag': 'ACCESSIBILITY & RTL',
          'color': 'tertiary',
          'body':
              'Padded 44x44px minimum touch boundaries with high-contrast screen reader alerts. Bi-directional mirrors for Arabic typography.',
        },
      ];
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeDimensions.spaceLg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ThemeColors.stitchSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'FL',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: surfaces.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? ThemeColors.stitchSecondaryDark
                            : ThemeColors.stitchSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? ThemeColors.stitchTrackDark
                      : ThemeColors.stitchSurfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                    color: surfaces.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: ThemeDimensions.spaceMd),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 720;
              final tiles = items.map((item) {
                Color tagColor;
                if (item['color'] == 'primary') {
                  tagColor = isDark
                      ? ThemeColors.stitchPrimaryDark
                      : ThemeColors.stitchPrimary;
                } else if (item['color'] == 'secondary') {
                  tagColor = isDark
                      ? ThemeColors.stitchSecondaryDark
                      : ThemeColors.stitchSecondary;
                } else {
                  tagColor = isDark
                      ? ThemeColors.stitchTertiaryDark
                      : ThemeColors.stitchTertiary;
                }

                return Container(
                  padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
                  decoration: BoxDecoration(
                    color: itemBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['tag']!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: tagColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['body']!,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: surfaces.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();

              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: tiles[0]),
                    const SizedBox(width: 12),
                    Expanded(child: tiles[1]),
                    const SizedBox(width: 12),
                    Expanded(child: tiles[2]),
                  ],
                );
              } else {
                return Column(
                  children: [
                    tiles[0],
                    const SizedBox(height: 10),
                    tiles[1],
                    const SizedBox(height: 10),
                    tiles[2],
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
