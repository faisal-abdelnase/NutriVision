import 'package:flutter/material.dart';

import 'theme_colors.dart';
import 'theme_dimensions.dart';

Color _l(Color a, Color b, double t) => Color.lerp(a, b, t)!;

// ─────────────────────────────────────────────────────────────
// Surfaces & text hierarchy
// ─────────────────────────────────────────────────────────────

/// Canvas / card levels, borders and text tiers that ColorScheme has no
/// dedicated roles for.
///
/// ```dart
/// final s = Theme.of(context).extension<AppSurfaceColors>()!;
/// Container(decoration: BoxDecoration(color: s.level2, borderRadius: ...));
/// ```
@immutable
class AppSurfaceColors extends ThemeExtension<AppSurfaceColors> {
  const AppSurfaceColors({
    required this.canvas,
    required this.level1,
    required this.level2,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.placeholder,
    required this.cardShadow,
  });

  final Color canvas; // app background
  final Color level1; // main cards
  final Color level2; // nested surfaces / wells
  final Color border;
  final Color borderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color placeholder;

  /// Level-1 card shadow (empty in dark mode — depth comes from tone).
  final List<BoxShadow> cardShadow;

  static const light = AppSurfaceColors(
    canvas: ThemeColors.background,
    level1: ThemeColors.surfaceContainerLowest,
    level2: ThemeColors.surfaceContainerLow,
    border: ThemeColors.outlineVariant,
    borderStrong: ThemeColors.outline,
    textPrimary: ThemeColors.onSurface,
    textSecondary: ThemeColors.onSurfaceVariant,
    textMuted: ThemeColors.textMuted,
    placeholder: ThemeColors.placeholder,
    cardShadow: ThemeDimensions.shadowTier1,
  );

  static const dark = AppSurfaceColors(
    canvas: ThemeColors.darkCanvas,
    level1: ThemeColors.darkSurface1,
    level2: ThemeColors.darkSurface2,
    border: ThemeColors.darkBorder,
    borderStrong: ThemeColors.darkBorderStrong,
    textPrimary: ThemeColors.darkTextPrimary,
    textSecondary: ThemeColors.darkTextSecondary,
    textMuted: ThemeColors.darkTextMuted,
    placeholder: ThemeColors.darkTextMuted,
    cardShadow: <BoxShadow>[],
  );

  @override
  AppSurfaceColors copyWith({
    Color? canvas,
    Color? level1,
    Color? level2,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? placeholder,
    List<BoxShadow>? cardShadow,
  }) {
    return AppSurfaceColors(
      canvas: canvas ?? this.canvas,
      level1: level1 ?? this.level1,
      level2: level2 ?? this.level2,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      placeholder: placeholder ?? this.placeholder,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  AppSurfaceColors lerp(ThemeExtension<AppSurfaceColors>? other, double t) {
    if (other is! AppSurfaceColors) return this;
    return AppSurfaceColors(
      canvas: _l(canvas, other.canvas, t),
      level1: _l(level1, other.level1, t),
      level2: _l(level2, other.level2, t),
      border: _l(border, other.border, t),
      borderStrong: _l(borderStrong, other.borderStrong, t),
      textPrimary: _l(textPrimary, other.textPrimary, t),
      textSecondary: _l(textSecondary, other.textSecondary, t),
      textMuted: _l(textMuted, other.textMuted, t),
      placeholder: _l(placeholder, other.placeholder, t),
      cardShadow:
          BoxShadow.lerpList(cardShadow, other.cardShadow, t) ?? cardShadow,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Clinical status
// ─────────────────────────────────────────────────────────────

/// Clinical status tokens. [critical] mirrors [ColorScheme.error]; keep
/// using `colorScheme.error` for ordinary form validation and [critical]
/// for emergency / contraindication states.
///
/// Remember: never communicate status by color alone — pair with an icon
/// or label.
@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  const AppStatusColors({
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.critical,
    required this.criticalContainer,
    required this.onCriticalContainer,
    required this.info,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.neutral,
    required this.neutralContainer,
    required this.onNeutralContainer,
  });

  final Color success;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color critical;
  final Color criticalContainer;
  final Color onCriticalContainer;
  final Color info;
  final Color infoContainer;
  final Color onInfoContainer;
  final Color neutral;
  final Color neutralContainer;
  final Color onNeutralContainer;

  static const light = AppStatusColors(
    success: ThemeColors.success,
    successContainer: ThemeColors.successContainer,
    onSuccessContainer: ThemeColors.onSuccessContainer,
    warning: ThemeColors.warning,
    warningContainer: ThemeColors.warningContainer,
    onWarningContainer: ThemeColors.onWarningContainer,
    critical: ThemeColors.critical,
    criticalContainer: ThemeColors.criticalContainer,
    onCriticalContainer: ThemeColors.onCriticalContainer,
    info: ThemeColors.info,
    infoContainer: ThemeColors.infoContainer,
    onInfoContainer: ThemeColors.onInfoContainer,
    neutral: ThemeColors.neutral,
    neutralContainer: ThemeColors.neutralContainer,
    onNeutralContainer: ThemeColors.onNeutralContainer,
  );

  static const dark = AppStatusColors(
    success: ThemeColors.successDark,
    successContainer: ThemeColors.successContainerDark,
    onSuccessContainer: ThemeColors.onSuccessContainerDark,
    warning: ThemeColors.warningDark,
    warningContainer: ThemeColors.warningContainerDark,
    onWarningContainer: ThemeColors.onWarningContainerDark,
    critical: ThemeColors.criticalDark,
    criticalContainer: ThemeColors.criticalContainerDark,
    onCriticalContainer: ThemeColors.onCriticalContainerDark,
    info: ThemeColors.infoDark,
    infoContainer: ThemeColors.infoContainerDark,
    onInfoContainer: ThemeColors.onInfoContainerDark,
    neutral: ThemeColors.neutralDark,
    neutralContainer: ThemeColors.neutralContainerDark,
    onNeutralContainer: ThemeColors.onNeutralContainerDark,
  );

  @override
  AppStatusColors copyWith({
    Color? success,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? critical,
    Color? criticalContainer,
    Color? onCriticalContainer,
    Color? info,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? neutral,
    Color? neutralContainer,
    Color? onNeutralContainer,
  }) {
    return AppStatusColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      critical: critical ?? this.critical,
      criticalContainer: criticalContainer ?? this.criticalContainer,
      onCriticalContainer: onCriticalContainer ?? this.onCriticalContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      neutral: neutral ?? this.neutral,
      neutralContainer: neutralContainer ?? this.neutralContainer,
      onNeutralContainer: onNeutralContainer ?? this.onNeutralContainer,
    );
  }

  @override
  AppStatusColors lerp(ThemeExtension<AppStatusColors>? other, double t) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      success: _l(success, other.success, t),
      successContainer: _l(successContainer, other.successContainer, t),
      onSuccessContainer: _l(onSuccessContainer, other.onSuccessContainer, t),
      warning: _l(warning, other.warning, t),
      warningContainer: _l(warningContainer, other.warningContainer, t),
      onWarningContainer: _l(onWarningContainer, other.onWarningContainer, t),
      critical: _l(critical, other.critical, t),
      criticalContainer: _l(criticalContainer, other.criticalContainer, t),
      onCriticalContainer:
          _l(onCriticalContainer, other.onCriticalContainer, t),
      info: _l(info, other.info, t),
      infoContainer: _l(infoContainer, other.infoContainer, t),
      onInfoContainer: _l(onInfoContainer, other.onInfoContainer, t),
      neutral: _l(neutral, other.neutral, t),
      neutralContainer: _l(neutralContainer, other.neutralContainer, t),
      onNeutralContainer: _l(onNeutralContainer, other.onNeutralContainer, t),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Nutrition semantic colors
// ─────────────────────────────────────────────────────────────

/// Macro / energy colors used by gauges, charts, legends and stat tiles.
@immutable
class NutritionColors extends ThemeExtension<NutritionColors> {
  const NutritionColors({
    required this.protein,
    required this.proteinSoft,
    required this.carbohydrates,
    required this.carbohydratesSoft,
    required this.fats,
    required this.fatsSoft,
    required this.calories,
    required this.caloriesSoft,
  });

  final Color protein;
  final Color proteinSoft;
  final Color carbohydrates;
  final Color carbohydratesSoft;
  final Color fats;
  final Color fatsSoft;
  final Color calories;
  final Color caloriesSoft;

  static const light = NutritionColors(
    protein: ThemeColors.protein,
    proteinSoft: ThemeColors.proteinSoft,
    carbohydrates: ThemeColors.carbohydrates,
    carbohydratesSoft: ThemeColors.carbohydratesSoft,
    fats: ThemeColors.fats,
    fatsSoft: ThemeColors.fatsSoft,
    calories: ThemeColors.calories,
    caloriesSoft: ThemeColors.caloriesSoft,
  );

  static const dark = NutritionColors(
    protein: ThemeColors.proteinDark,
    proteinSoft: ThemeColors.proteinSoftDark,
    carbohydrates: ThemeColors.carbohydratesDark,
    carbohydratesSoft: ThemeColors.carbohydratesSoftDark,
    fats: ThemeColors.fatsDark,
    fatsSoft: ThemeColors.fatsSoftDark,
    calories: ThemeColors.caloriesDark,
    caloriesSoft: ThemeColors.caloriesSoftDark,
  );

  @override
  NutritionColors copyWith({
    Color? protein,
    Color? proteinSoft,
    Color? carbohydrates,
    Color? carbohydratesSoft,
    Color? fats,
    Color? fatsSoft,
    Color? calories,
    Color? caloriesSoft,
  }) {
    return NutritionColors(
      protein: protein ?? this.protein,
      proteinSoft: proteinSoft ?? this.proteinSoft,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      carbohydratesSoft: carbohydratesSoft ?? this.carbohydratesSoft,
      fats: fats ?? this.fats,
      fatsSoft: fatsSoft ?? this.fatsSoft,
      calories: calories ?? this.calories,
      caloriesSoft: caloriesSoft ?? this.caloriesSoft,
    );
  }

  @override
  NutritionColors lerp(ThemeExtension<NutritionColors>? other, double t) {
    if (other is! NutritionColors) return this;
    return NutritionColors(
      protein: _l(protein, other.protein, t),
      proteinSoft: _l(proteinSoft, other.proteinSoft, t),
      carbohydrates: _l(carbohydrates, other.carbohydrates, t),
      carbohydratesSoft: _l(carbohydratesSoft, other.carbohydratesSoft, t),
      fats: _l(fats, other.fats, t),
      fatsSoft: _l(fatsSoft, other.fatsSoft, t),
      calories: _l(calories, other.calories, t),
      caloriesSoft: _l(caloriesSoft, other.caloriesSoft, t),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// AI identity
// ─────────────────────────────────────────────────────────────

/// One visual identity for every AI surface (Coach, Recipe Generator,
/// Progress Insights): **NutriVision Intelligence Engine**.
@immutable
class AIThemeColors extends ThemeExtension<AIThemeColors> {
  const AIThemeColors({
    required this.accent,
    required this.soft,
    required this.border,
    required this.onSoft,
  });

  final Color accent;
  final Color soft;
  final Color border;
  final Color onSoft;

  static const String badgeLabel = 'NutriVision Intelligence Engine • v4.2';

  /// Sparkle icon for AI surfaces. If the project already depends on
  /// `lucide_icons`, swap for `LucideIcons.sparkles` — no new dependency
  /// is added here.
  static const IconData icon = Icons.auto_awesome;

  static const light = AIThemeColors(
    accent: ThemeColors.aiPrimary,
    soft: ThemeColors.aiSoft,
    border: ThemeColors.aiBorder,
    onSoft: ThemeColors.aiOnSoft,
  );

  static const dark = AIThemeColors(
    accent: ThemeColors.aiPrimaryDark,
    soft: ThemeColors.aiSoftDark,
    border: ThemeColors.aiBorderDark,
    onSoft: ThemeColors.aiOnSoftDark,
  );

  @override
  AIThemeColors copyWith({
    Color? accent,
    Color? soft,
    Color? border,
    Color? onSoft,
  }) {
    return AIThemeColors(
      accent: accent ?? this.accent,
      soft: soft ?? this.soft,
      border: border ?? this.border,
      onSoft: onSoft ?? this.onSoft,
    );
  }

  @override
  AIThemeColors lerp(ThemeExtension<AIThemeColors>? other, double t) {
    if (other is! AIThemeColors) return this;
    return AIThemeColors(
      accent: _l(accent, other.accent, t),
      soft: _l(soft, other.soft, t),
      border: _l(border, other.border, t),
      onSoft: _l(onSoft, other.onSoft, t),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Convenience accessors
// ─────────────────────────────────────────────────────────────

/// `context.statusColors`, `context.nutritionColors`, ...
extension AppThemeContext on BuildContext {
  AppSurfaceColors get surfaceColors =>
      Theme.of(this).extension<AppSurfaceColors>()!;
  AppStatusColors get statusColors =>
      Theme.of(this).extension<AppStatusColors>()!;
  NutritionColors get nutritionColors =>
      Theme.of(this).extension<NutritionColors>()!;
  AIThemeColors get aiColors => Theme.of(this).extension<AIThemeColors>()!;
}