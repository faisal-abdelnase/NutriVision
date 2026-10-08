import 'package:flutter/material.dart';

import 'theme_builder.dart';
import 'theme_colors.dart';
import 'theme_extensions.dart';

/// Builds the light-mode [ThemeData] for NutriVision.
///
/// Note: `colorScheme.primary` is Emerald 600 (`#059669`) rather than the
/// brand base `#10B981`, because white text on `#10B981` is only ~2.5:1.
/// The brand base stays available as [ThemeColors.primary] for gauges,
/// focus accents and decorative use.
class LightTheme {
  LightTheme._();

  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: ThemeColors.primaryDark,
    onPrimary: ThemeColors.onPrimary,
    primaryContainer: ThemeColors.primaryContainer,
    onPrimaryContainer: ThemeColors.onPrimaryContainer,
    secondary: ThemeColors.secondary,
    onSecondary: ThemeColors.onSecondary,
    secondaryContainer: ThemeColors.secondaryContainer,
    onSecondaryContainer: ThemeColors.onSecondaryContainer,
    tertiary: ThemeColors.tertiary,
    onTertiary: ThemeColors.onTertiary,
    tertiaryContainer: ThemeColors.tertiaryContainer,
    onTertiaryContainer: ThemeColors.onTertiaryContainer,
    error: ThemeColors.error,
    onError: ThemeColors.onError,
    errorContainer: ThemeColors.errorContainer,
    onErrorContainer: ThemeColors.onErrorContainer,
    surface: ThemeColors.surface,
    onSurface: ThemeColors.onSurface,
    surfaceDim: ThemeColors.surfaceDim,
    surfaceBright: ThemeColors.surfaceBright,
    surfaceContainerLowest: ThemeColors.surfaceContainerLowest,
    surfaceContainerLow: ThemeColors.surfaceContainerLow,
    surfaceContainer: ThemeColors.surfaceContainer,
    surfaceContainerHigh: ThemeColors.surfaceContainerHigh,
    surfaceContainerHighest: ThemeColors.surfaceContainerHighest,
    onSurfaceVariant: ThemeColors.onSurfaceVariant,
    outline: ThemeColors.outline,
    outlineVariant: ThemeColors.outlineVariant,
    surfaceTint: ThemeColors.surfaceTint,
    inverseSurface: ThemeColors.inverseSurface,
    onInverseSurface: ThemeColors.inverseOnSurface,
    inversePrimary: ThemeColors.inversePrimary,
    shadow: Colors.black,
    scrim: Colors.black,
  );

  /// [locale] selects the English vs Arabic font families app-wide.
  static ThemeData build([Locale locale = const Locale('en')]) =>
      ThemeBuilder.build(
        colorScheme: colorScheme,
        surfaces: AppSurfaceColors.light,
        status: AppStatusColors.light,
        nutrition: NutritionColors.light,
        ai: AIThemeColors.light,
        locale: locale,
      );
}