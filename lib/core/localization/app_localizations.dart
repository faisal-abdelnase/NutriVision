import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Loads and exposes the translated strings for the current [Locale].
///
/// Usage in widgets:
/// ```dart
/// Text(AppLocalizations.of(context).translate('save'))
/// // or, via the ContextExtensions helper:
/// Text(context.tr('save'))
/// ```
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    final instance = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(
      instance != null,
      'AppLocalizations not found in context. '
      'Make sure AppLocalizations.delegate is registered in MaterialApp.',
    );
    return instance!;
  }

  Map<String, String> _strings = const {};

  Future<void> load() async {
    final raw = await rootBundle.loadString(
      'lib/core/localization/translations/${locale.languageCode}.json',
    );
    final decoded = json.decode(raw) as Map<String, dynamic>;
    _strings = decoded.map((key, value) => MapEntry(key, value.toString()));
  }

  /// Returns the translated string for [key], substituting any `{param}`
  /// placeholders found in [params]. Falls back to [key] itself when no
  /// translation is found, so missing keys are still visible instead of
  /// crashing the UI.
  String translate(String key, {Map<String, String>? params}) {
    var value = _strings[key] ?? key;
    if (params != null) {
      for (final entry in params.entries) {
        value = value.replaceAll('{${entry.key}}', entry.value);
      }
    }
    return value;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      const ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    try {
      await localizations.load();
    } on FlutterError {
      if (locale.languageCode == 'en') rethrow;
      final fallback = AppLocalizations(const Locale('en'));
      await fallback.load();
      localizations._strings = fallback._strings;
    } on FormatException {
      if (locale.languageCode == 'en') rethrow;
      final fallback = AppLocalizations(const Locale('en'));
      await fallback.load();
      localizations._strings = fallback._strings;
    }
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
