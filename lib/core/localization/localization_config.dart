import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations.dart';

/// Everything a `MaterialApp` needs to support English (LTR) and
/// Arabic (RTL). Wire it up once in the app root:
///
/// ```dart
/// MaterialApp(
///   locale: LocalizationConfig.supportedLocales.first,
///   supportedLocales: LocalizationConfig.supportedLocales,
///   localizationsDelegates: LocalizationConfig.delegates,
///   localeResolutionCallback: LocalizationConfig.resolveLocale,
///   ...
/// )
/// ```
class LocalizationConfig {
  LocalizationConfig._();

  static const Locale english = Locale('en');
  static const Locale arabic = Locale('ar');

  static const List<Locale> supportedLocales = [english, arabic];

  static const List<LocalizationsDelegate<dynamic>> delegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// Picks a supported locale for the device's preferred locale,
  /// defaulting to English when there is no match.
  static Locale resolveLocale(
    Locale? deviceLocale,
    Iterable<Locale> supported,
  ) {
    if (deviceLocale == null) return english;
    for (final locale in supported) {
      if (locale.languageCode == deviceLocale.languageCode) return locale;
    }
    return english;
  }

  static bool isRtl(Locale locale) => locale.languageCode == 'ar';

  static TextDirection directionFor(Locale locale) =>
      isRtl(locale) ? TextDirection.rtl : TextDirection.ltr;
}
