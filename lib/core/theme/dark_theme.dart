import 'package:flutter/material.dart';

import 'theme_builder.dart';
import 'theme_colors.dart';
import 'theme_extensions.dart';

/// Builds the dark-mode [ThemeData] for NutriVision.
///
/// One consistent deep-slate language: canvas `#0B1120`, cards `#151F32`,
/// nested `#1E293B`, borders `#334155`. All tokens are explicit (no
/// `fromSeed`), so no stray tonal colors leak in.
class DarkTheme {
  DarkTheme._();

  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: ThemeColors.primaryOnDark,
    onPrimary: ThemeColors.onPrimaryDark,
    primaryContainer: ThemeColors.primaryContainerDark,
    onPrimaryContainer: ThemeColors.onPrimaryContainerDark,
    secondary: ThemeColors.secondaryDark,
    onSecondary: ThemeColors.onSecondaryDark,
    secondaryContainer: ThemeColors.secondaryContainerDark,
    onSecondaryContainer: ThemeColors.onSecondaryContainerDark,
    tertiary: ThemeColors.tertiaryDark,
    onTertiary: ThemeColors.onTertiaryDark,
    tertiaryContainer: ThemeColors.tertiaryContainerDark,
    onTertiaryContainer: ThemeColors.onTertiaryContainerDark,
    error: ThemeColors.errorDark,
    onError: ThemeColors.onErrorDark,
    errorContainer: ThemeColors.errorContainerDark,
    onErrorContainer: ThemeColors.onErrorContainerDark,
    surface: ThemeColors.darkCanvas,
    onSurface: ThemeColors.darkTextPrimary,
    surfaceDim: ThemeColors.darkCanvas,
    surfaceBright: ThemeColors.darkSurface2,
    surfaceContainerLowest: ThemeColors.darkCanvas,
    surfaceContainerLow: ThemeColors.darkSurface1,
    surfaceContainer: ThemeColors.darkSurface1,
    surfaceContainerHigh: ThemeColors.darkSurface2,
    surfaceContainerHighest: ThemeColors.darkSurface3,
    onSurfaceVariant: ThemeColors.darkTextSecondary,
    outline: ThemeColors.darkBorderStrong,
    outlineVariant: ThemeColors.darkBorder,
    surfaceTint: ThemeColors.primary,
    inverseSurface: ThemeColors.slate100,
    onInverseSurface: ThemeColors.slate900,
    inversePrimary: ThemeColors.primaryDark,
    shadow: Colors.black,
    scrim: Colors.black,
  );

  static ThemeData build([Locale locale = const Locale('en')]) =>
      ThemeBuilder.build(
        colorScheme: colorScheme,
        surfaces: AppSurfaceColors.dark,
        status: AppStatusColors.dark,
        nutrition: NutritionColors.dark,
        ai: AIThemeColors.dark,
        locale: locale,
      );
}