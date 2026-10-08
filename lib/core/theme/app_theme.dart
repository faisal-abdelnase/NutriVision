import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

/// Single entry point for the app's themes.
///
/// Takes the active [Locale] because MediLink swaps its font family
/// (IBM Plex Sans ↔ IBM Plex Sans Arabic) with the language, per
/// DESIGN.md — so the theme needs to be rebuilt on locale change, same
/// as it already is on brightness change.
///
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light(locale),
///   darkTheme: AppTheme.dark(locale),
///   themeMode: ThemeMode.system,
/// )
/// ```
class AppTheme {
  AppTheme._();

  static ThemeData light([Locale locale = const Locale('en')]) =>
      LightTheme.build(locale);

  static ThemeData dark([Locale locale = const Locale('en')]) =>
      DarkTheme.build(locale);
}
