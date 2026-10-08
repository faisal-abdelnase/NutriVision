import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';

extension ContextExtensions on BuildContext {
  // ── MediaQuery shortcuts ─────────────────────────────
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;

  // ── Theme shortcuts ──────────────────────────────────
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // ── Localization shortcuts ───────────────────────────
  /// Translates [key] via [AppLocalizations], falling back to the raw
  /// key when no localization is registered yet.
  String tr(String key, [Map<String, String>? params]) {
    return AppLocalizations.of(this).translate(key, params: params);
  }
}
