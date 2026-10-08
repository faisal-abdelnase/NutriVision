import 'package:flutter/material.dart';

import 'app_button_styles.dart';
import 'theme_colors.dart';
import 'theme_dimensions.dart';
import 'theme_extensions.dart';
import 'theme_text_styles.dart';

/// Shared [ThemeData] factory. `LightTheme` / `DarkTheme` only supply
/// tokens (ColorScheme + extensions); every component theme lives here so
/// both modes stay structurally identical.
class ThemeBuilder {
  ThemeBuilder._();

  static ThemeData build({
    required ColorScheme colorScheme,
    required AppSurfaceColors surfaces,
    required AppStatusColors status,
    required NutritionColors nutrition,
    required AIThemeColors ai,
    required Locale locale,
  }) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final textTheme = ThemeTextStyles.buildTextTheme(
      locale,
      primary: surfaces.textPrimary,
      secondary: surfaces.textSecondary,
    );

    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: ThemeDimensions.borderRadiusInput,
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surfaces.canvas,
      canvasColor: surfaces.canvas,
      fontFamily: ThemeTextStyles.fontFamilyFor(locale),
      textTheme: textTheme,
      focusColor: colorScheme.primary.withValues(alpha: 0.16),
      extensions: <ThemeExtension<dynamic>>[surfaces, status, nutrition, ai],
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withValues(alpha: 0.25),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaces.canvas,
        foregroundColor: surfaces.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: surfaces.level1,
        elevation: isDark ? 0 : 1,
        shadowColor: ThemeColors.slate900.withValues(alpha: 0.06),
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeDimensions.borderRadiusCard,
          side: BorderSide(color: surfaces.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppButtonStyles.primary(colorScheme),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: AppButtonStyles.tonal(colorScheme),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: AppButtonStyles.outline(colorScheme),
      ),
      textButtonTheme: TextButtonThemeData(
        style: AppButtonStyles.text(colorScheme),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(ThemeDimensions.touchTarget),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaces.level1,
        constraints:
            const BoxConstraints(minHeight: ThemeDimensions.inputHeight),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ThemeDimensions.inputHorizontalPadding,
          vertical: ThemeDimensions.spaceSm,
        ),
        border: inputBorder(surfaces.border),
        enabledBorder: inputBorder(surfaces.border),
        disabledBorder: inputBorder(surfaces.border.withValues(alpha: 0.5)),
        focusedBorder: inputBorder(colorScheme.primary, 2),
        errorBorder: inputBorder(colorScheme.error),
        focusedErrorBorder: inputBorder(colorScheme.error, 2),
        labelStyle: textTheme.labelLarge?.copyWith(color: surfaces.textSecondary),
        hintStyle: textTheme.bodyMedium?.copyWith(color: surfaces.placeholder),
        helperStyle: textTheme.bodySmall,
        errorStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.error,
          fontWeight: FontWeight.w600,
        ),
        errorMaxLines: 2,
        prefixIconColor: surfaces.textMuted,
        suffixIconColor: surfaces.textMuted,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaces.level2,
        selectedColor: colorScheme.secondaryContainer,
        surfaceTintColor: Colors.transparent,
        labelStyle:
            textTheme.labelMedium?.copyWith(color: surfaces.textSecondary),
        secondaryLabelStyle: textTheme.labelMedium
            ?.copyWith(color: colorScheme.onSecondaryContainer),
        padding: const EdgeInsets.symmetric(horizontal: ThemeDimensions.spaceSm),
        side: BorderSide(color: surfaces.border),
        shape: const StadiumBorder(),
        elevation: 0,
        showCheckmark: false,
      ),
      checkboxTheme: CheckboxThemeData(
        side: WidgetStateBorderSide.resolveWith(
          (states) => BorderSide(
            color: states.contains(WidgetState.selected)
                ? colorScheme.primary
                : colorScheme.outline,
            width: 1.5,
          ),
        ),
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : Colors.transparent,
        ),
        checkColor: WidgetStatePropertyAll(colorScheme.onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeDimensions.radiusSm),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : surfaces.borderStrong,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      dividerTheme: DividerThemeData(
        color: surfaces.border,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaces.level1,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        barrierColor: ThemeDimensions.overlayScrim,
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeDimensions.borderRadiusCard,
          side: BorderSide(color: surfaces.border),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaces.level1,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalBarrierColor: ThemeDimensions.overlayScrim,
        dragHandleColor: surfaces.borderStrong,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ThemeDimensions.radiusCard),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium
            ?.copyWith(color: colorScheme.onInverseSurface),
        actionTextColor: colorScheme.inversePrimary,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: ThemeDimensions.borderRadiusMedium,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: ThemeDimensions.navBarHeight,
        backgroundColor: surfaces.level1,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: colorScheme.secondaryContainer,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colorScheme.onSecondaryContainer
                : surfaces.textMuted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected)
                ? colorScheme.onSecondaryContainer
                : surfaces.textMuted,
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: surfaces.border,
        circularTrackColor: surfaces.border,
      ),
    );
  }
}