import 'package:flutter/material.dart';

/// NutriVision Clinical Design System — typography scale.
///
/// English : Plus Jakarta Sans (headings / metrics) + Inter (body / labels)
/// Arabic  : Cairo (headings / metrics)             + Tajawal (body / labels)
///
/// The static styles below intentionally leave `fontFamily` unset; the
/// family is applied per role in [buildTextTheme] based on the active
/// [Locale]. For Arabic, letter-spacing is reset to 0 and line height is
/// raised by +2px (per DESIGN.md) to clear ascenders/descenders.
///
/// Fonts must be declared in `pubspec.yaml` (see delivery notes) — until
/// they are, Flutter falls back to the platform font.
class ThemeTextStyles {
  ThemeTextStyles._();

  // ── Font families ─────────────────────────────────────
  static const String fontFamilyHeading = 'Plus Jakarta Sans';
  static const String fontFamilyBody = 'Inter';
  static const String fontFamilyHeadingArabic = 'Cairo';
  static const String fontFamilyBodyArabic = 'Tajawal';

  /// Legacy names (previously IBM Plex) — now point at the body families.
  static const String fontFamily = fontFamilyBody;
  static const String fontFamilyArabic = fontFamilyBodyArabic;

  static bool isArabic(Locale locale) => locale.languageCode == 'ar';

  /// Default (body) family for [ThemeData.fontFamily].
  static String fontFamilyFor(Locale locale) =>
      isArabic(locale) ? fontFamilyBodyArabic : fontFamilyBody;

  static String headingFamilyFor(Locale locale) =>
      isArabic(locale) ? fontFamilyHeadingArabic : fontFamilyHeading;

  // ── Display / page title ──────────────────────────────
  /// 40 / 700 / lh 48 / -0.02em
  static const TextStyle displayLarge = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.8,
  );

  /// 32 / 700 / lh 40 — compact display for mobile.
  static const TextStyle displayLargeMobile = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.48,
  );

  // ── Headline / section title ──────────────────────────
  /// 30 / 700 / lh 38
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.2667,
    letterSpacing: -0.45,
  );

  /// 24 / 700 / lh 32 — compact headline for mobile.
  static const TextStyle headlineLargeMobile = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3333,
    letterSpacing: -0.24,
  );

  /// 22 / 600 / lh 28
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.2727,
    letterSpacing: -0.22,
  );

  /// 18 / 600 / lh 24 — section title.
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3333,
  );

  // ── Title ─────────────────────────────────────────────
  /// 18 / 600 / lh 26
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4444,
  );

  /// 16 / 600 / lh 24
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  /// 14 / 600 / lh 20
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4286,
  );

  // ── Body ──────────────────────────────────────────────
  /// 16 / 400 / lh 24
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// 14 / 400 / lh 20
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4286,
  );

  /// 12 / 400 / lh 16
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3333,
    letterSpacing: 0.12,
  );

  // ── Label ─────────────────────────────────────────────
  /// 14 / 600 / lh 20 — buttons, field labels.
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4286,
    letterSpacing: 0.14,
  );

  /// 12 / 600 / lh 16
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3333,
    letterSpacing: 0.24,
  );

  /// 11 / 600 / lh 14 — metadata / clinical labels. Pair with
  /// [clinicalCase] for the uppercase treatment (English only).
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.2727,
    letterSpacing: 0.44,
  );

  /// Big metric number (calories, macros). Heading family, tabular digits.
  static const TextStyle metricNum = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 1.1538,
    letterSpacing: -0.52,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Applies tabular (fixed-width) figures — vitals, dosages, any number in
  /// a table/chart so digits stay vertically aligned.
  static TextStyle tabularFigures(TextStyle style) {
    return style.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  /// Uppercase for small metadata labels — skipped for Arabic, where
  /// uppercasing is meaningless and can break letter joining.
  static String clinicalCase(String text, Locale locale) =>
      isArabic(locale) ? text : text.toUpperCase();

  // ── Locale-aware TextTheme ────────────────────────────
  static TextTheme buildTextTheme(
    Locale locale, {
    required Color primary,
    required Color secondary,
  }) {
    final ar = isArabic(locale);
    final heading = headingFamilyFor(locale);
    final body = fontFamilyFor(locale);

    TextStyle h(TextStyle s, Color c) =>
        _adapt(s, ar).copyWith(fontFamily: heading, color: c);
    TextStyle b(TextStyle s, Color c) =>
        _adapt(s, ar).copyWith(fontFamily: body, color: c);

    return TextTheme(
      displayLarge: h(displayLarge, primary),
      headlineLarge: h(headlineLarge, primary),
      headlineMedium: h(headlineMedium, primary),
      headlineSmall: h(headlineSmall, primary),
      titleLarge: h(titleLarge, primary),
      titleMedium: b(titleMedium, primary),
      titleSmall: b(titleSmall, primary),
      bodyLarge: b(bodyLarge, primary),
      bodyMedium: b(bodyMedium, primary),
      bodySmall: b(bodySmall, secondary),
      labelLarge: b(labelLarge, primary),
      labelMedium: b(labelMedium, secondary),
      labelSmall: b(labelSmall, secondary),
    );
  }

  /// Arabic: no tracking, +2px line height.
  static TextStyle _adapt(TextStyle s, bool arabic) {
    if (!arabic) return s;
    final size = s.fontSize ?? 14;
    final lineHeight = size * (s.height ?? 1.5);
    return s.copyWith(letterSpacing: 0, height: (lineHeight + 2) / size);
  }
}