import 'package:flutter/material.dart';

/// NutriVision Clinical Design System — color tokens (single source of truth).
///
/// Convention:
/// * Un-suffixed tokens are the **light** values.
/// * `...Dark` tokens are the **dark** values.
/// * Feature code should NOT use these directly when a themed alternative
///   exists — prefer `Theme.of(context).colorScheme` or the ThemeExtensions
///   in `theme_extensions.dart` (AppSurfaceColors, AppStatusColors,
///   NutritionColors, AIThemeColors) so dark mode works automatically.
class ThemeColors {
  ThemeColors._();

  // ── Slate neutrals (shared scale) ─────────────────────
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // ── Brand: Emerald ────────────────────────────────────
  static const Color primary = Color(0xFF10B981); // brand base
  static const Color primaryDark = Color(0xFF059669); // buttons / hover
  static const Color primaryDarker = Color(0xFF047857); // pressed / text-safe
  static const Color primaryLight = Color(0xFF34D399);
  static const Color primarySoft = Color(0xFFECFDF5);
  static const Color primarySurface = Color(0xFFD1FAE5);
  static const Color primaryDeep = Color(0xFF064E3B); // dark container wash

  /// Kept for backward compatibility — dark scheme is now explicit.
  @Deprecated('Dark scheme is explicit now; use ThemeColors.primary.')
  static const Color darkSeed = primary;

  // ── Light surfaces & text ─────────────────────────────
  static const Color background = slate50; // application canvas
  static const Color surface = slate50;
  static const Color surfaceDim = slate200;
  static const Color surfaceBright = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // Level 1
  static const Color surfaceContainerLow = slate100; // Level 2
  static const Color surfaceContainer = slate100;
  static const Color surfaceContainerHigh = slate200;
  static const Color surfaceContainerHighest = slate300;
  static const Color surfaceVariant = slate200;

  static const Color onSurface = slate900; // primary text
  static const Color onBackground = slate900;
  static const Color onSurfaceVariant = slate600; // secondary text
  static const Color textMuted = slate500; // muted text
  static const Color placeholder = slate400;

  static const Color outline = slate300; // strong border
  static const Color outlineVariant = slate200; // default border
  static const Color surfaceTint = primary;
  static const Color inverseSurface = slate800;
  static const Color inverseOnSurface = slate100;
  static const Color inversePrimary = primaryLight;

  // ── Light scheme roles ────────────────────────────────
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = primarySoft;
  static const Color onPrimaryContainer = primaryDarker;

  // Secondary stays in the emerald family so selected states are emerald.
  static const Color secondary = primaryDarker;
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = primarySurface;
  static const Color onSecondaryContainer = primaryDeep;

  // Tertiary = amber (carbohydrates / caution family).
  static const Color tertiary = Color(0xFFB45309);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFEF3C7);
  static const Color onTertiaryContainer = Color(0xFF92400E);

  static const Color error = Color(0xFFDC2626);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF991B1B);

  // ── Dark surfaces & text (deep slate, one consistent family) ──
  static const Color darkCanvas = Color(0xFF0B1120);
  static const Color darkSurface1 = Color(0xFF151F32); // main cards
  static const Color darkSurface2 = slate800; // nested
  static const Color darkSurface3 = slate700; // overlays / highest
  static const Color darkBorder = slate700;
  static const Color darkBorderStrong = slate600;
  static const Color darkTextPrimary = slate50;
  static const Color darkTextSecondary = slate300;
  static const Color darkTextMuted = slate400;

  // ── Dark scheme roles ─────────────────────────────────
  static const Color primaryOnDark = primary;
  static const Color onPrimaryDark = Color(0xFF022C22);
  static const Color primaryContainerDark = primaryDeep;
  static const Color onPrimaryContainerDark = Color(0xFF6EE7B7);

  static const Color secondaryDark = primaryLight;
  static const Color onSecondaryDark = Color(0xFF022C22);
  static const Color secondaryContainerDark = Color(0xFF065F46);
  static const Color onSecondaryContainerDark = Color(0xFFA7F3D0);

  static const Color tertiaryDark = Color(0xFFFBBF24);
  static const Color onTertiaryDark = Color(0xFF451A03);
  static const Color tertiaryContainerDark = Color(0xFF78350F);
  static const Color onTertiaryContainerDark = Color(0xFFFDE68A);

  static const Color errorDark = Color(0xFFF87171);
  static const Color onErrorDark = Color(0xFF450A0A);
  static const Color errorContainerDark = Color(0xFF7F1D1D);
  static const Color onErrorContainerDark = Color(0xFFFECACA);

  // ── Nutrition semantic colors ─────────────────────────
  static const Color protein = Color(0xFF10B981);
  static const Color carbohydrates = Color(0xFFF59E0B);
  static const Color fats = Color(0xFFF43F5E);
  static const Color calories = Color(0xFF0284C7);

  static const Color proteinSoft = Color(0xFFECFDF5);
  static const Color carbohydratesSoft = Color(0xFFFFFBEB);
  static const Color fatsSoft = Color(0xFFFFF1F2);
  static const Color caloriesSoft = Color(0xFFF0F9FF);

  static const Color proteinDark = Color(0xFF34D399);
  static const Color carbohydratesDark = Color(0xFFFBBF24);
  static const Color fatsDark = Color(0xFFFB7185);
  static const Color caloriesDark = Color(0xFF38BDF8);

  static const Color proteinSoftDark = Color(0xFF064E3B);
  static const Color carbohydratesSoftDark = Color(0xFF451A03);
  static const Color fatsSoftDark = Color(0xFF4C0519);
  static const Color caloriesSoftDark = Color(0xFF082F49);

  // ── AI identity (NutriVision Intelligence Engine) ─────
  static const Color aiPrimary = primary;
  static const Color aiSoft = primarySoft;
  static const Color aiBorder = Color(0xFFA7F3D0);
  static const Color aiOnSoft = primaryDarker;

  static const Color aiPrimaryDark = primaryLight;
  static const Color aiSoftDark = primaryDeep;
  static const Color aiBorderDark = Color(0xFF065F46);
  static const Color aiOnSoftDark = Color(0xFF6EE7B7);

  // ── Clinical status — light ───────────────────────────
  static const Color success = Color(0xFF059669);
  static const Color successContainer = Color(0xFFECFDF5);
  static const Color onSuccessContainer = Color(0xFF065F46);

  static const Color warning = Color(0xFFD97706);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color onWarningContainer = Color(0xFF92400E);

  static const Color critical = Color(0xFFDC2626);
  static const Color criticalContainer = Color(0xFFFEE2E2);
  static const Color onCriticalContainer = Color(0xFF991B1B);

  static const Color info = Color(0xFF0284C7);
  static const Color infoContainer = Color(0xFFE0F2FE);
  static const Color onInfoContainer = Color(0xFF075985);

  static const Color neutral = slate500;
  static const Color neutralContainer = slate100;
  static const Color onNeutralContainer = slate700;

  // ── Clinical status — dark ────────────────────────────
  static const Color successDark = Color(0xFF34D399);
  static const Color successContainerDark = Color(0xFF064E3B);
  static const Color onSuccessContainerDark = Color(0xFFA7F3D0);

  static const Color warningDark = Color(0xFFFBBF24);
  static const Color warningContainerDark = Color(0xFF451A03);
  static const Color onWarningContainerDark = Color(0xFFFDE68A);

  static const Color criticalDark = Color(0xFFF87171);
  static const Color criticalContainerDark = Color(0xFF450A0A);
  static const Color onCriticalContainerDark = Color(0xFFFECACA);

  static const Color infoDark = Color(0xFF38BDF8);
  static const Color infoContainerDark = Color(0xFF082F49);
  static const Color onInfoContainerDark = Color(0xFFBAE6FD);

  static const Color neutralDark = slate400;
  static const Color neutralContainerDark = slate800;
  static const Color onNeutralContainerDark = slate300;
}