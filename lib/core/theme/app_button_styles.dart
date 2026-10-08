import 'package:flutter/material.dart';

import 'theme_colors.dart';
import 'theme_dimensions.dart';
import 'theme_extensions.dart';
import 'theme_text_styles.dart';

/// NutriVision button variants. Primary / tonal / outline / text are wired
/// into `ElevatedButton` / `FilledButton` / `OutlinedButton` / `TextButton`
/// by the theme; [danger] and [dangerFilled] are opt-in:
///
/// ```dart
/// OutlinedButton(
///   style: context.dangerButtonStyle,   // soft rose
///   onPressed: ...,
///   child: Text('Delete'),
/// )
/// ```
class AppButtonStyles {
  AppButtonStyles._();

  static ButtonStyle _base({
    required ColorScheme cs,
    required Color background,
    required Color backgroundActive,
    required Color foreground,
    BorderSide? side,
    double elevation = 0,
    Color? shadowColor,
  }) {
    final disabledFill = cs.onSurface.withValues(alpha: 0.12);
    final disabledFg = cs.onSurface.withValues(alpha: 0.38);
    final transparent = background == Colors.transparent;

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return transparent ? Colors.transparent : disabledFill;
        }
        if (states.contains(WidgetState.pressed) ||
            states.contains(WidgetState.hovered)) {
          return backgroundActive;
        }
        return background;
      }),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.disabled) ? disabledFg : foreground,
      ),
      side: side == null
          ? null
          : WidgetStateProperty.resolveWith<BorderSide?>(
              (states) => states.contains(WidgetState.disabled)
                  ? BorderSide(color: disabledFill)
                  : side,
            ),
      shadowColor: WidgetStatePropertyAll(shadowColor ?? Colors.transparent),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      elevation: WidgetStatePropertyAll(elevation),
      minimumSize: const WidgetStatePropertyAll(
        Size(0, ThemeDimensions.buttonHeight),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: ThemeDimensions.space20),
      ),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: ThemeDimensions.borderRadiusButton),
      ),
      textStyle: const WidgetStatePropertyAll(ThemeTextStyles.labelLarge),
    );
  }

  /// Emerald fill, white text (dark text on dark mode for contrast).
  static ButtonStyle primary(ColorScheme cs) {
    final isLight = cs.brightness == Brightness.light;
    return _base(
      cs: cs,
      background: cs.primary,
      backgroundActive:
          isLight ? ThemeColors.primaryDarker : ThemeColors.primaryLight,
      foreground: cs.onPrimary,
      elevation: isLight ? 1 : 0,
      shadowColor: ThemeColors.slate900.withValues(alpha: 0.12),
    );
  }

  /// Soft emerald surface, emerald text.
  static ButtonStyle tonal(ColorScheme cs) {
    final isLight = cs.brightness == Brightness.light;
    return _base(
      cs: cs,
      background: cs.primaryContainer,
      backgroundActive:
          isLight ? ThemeColors.primarySurface : ThemeColors.secondaryContainerDark,
      foreground: cs.onPrimaryContainer,
    );
  }

  /// Transparent, slate border and text.
  static ButtonStyle outline(ColorScheme cs) {
    return _base(
      cs: cs,
      background: Colors.transparent,
      backgroundActive: cs.onSurface.withValues(alpha: 0.06),
      foreground: cs.onSurface,
      side: BorderSide(color: cs.outline),
    );
  }

  /// Text-only emerald action (text-safe emerald shade for contrast).
  static ButtonStyle text(ColorScheme cs) {
    return _base(
      cs: cs,
      background: Colors.transparent,
      backgroundActive: cs.primary.withValues(alpha: 0.08),
      foreground: cs.onPrimaryContainer,
    ).copyWith(
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: ThemeDimensions.spaceMd),
      ),
    );
  }

  /// Soft rose background, rose text and border.
  static ButtonStyle danger(ColorScheme cs, AppStatusColors st) {
    return _base(
      cs: cs,
      background: st.criticalContainer,
      backgroundActive: st.critical.withValues(alpha: 0.18),
      foreground: st.onCriticalContainer,
      side: BorderSide(color: st.critical.withValues(alpha: 0.4)),
    );
  }

  /// Strong filled destructive action (confirmation step).
  static ButtonStyle dangerFilled(ColorScheme cs, AppStatusColors st) {
    final isLight = cs.brightness == Brightness.light;
    return _base(
      cs: cs,
      background: st.critical,
      backgroundActive:
          Color.lerp(st.critical, isLight ? Colors.black : Colors.white, 0.15)!,
      foreground: cs.onError,
    );
  }
}

extension AppButtonStyleContext on BuildContext {
  ButtonStyle get dangerButtonStyle =>
      AppButtonStyles.danger(Theme.of(this).colorScheme, statusColors);

  ButtonStyle get dangerFilledButtonStyle =>
      AppButtonStyles.dangerFilled(Theme.of(this).colorScheme, statusColors);
}