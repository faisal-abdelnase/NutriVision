import 'package:flutter/material.dart';

/// NutriVision Clinical Design System — spacing, radius, sizing,
/// breakpoints and elevation tokens.
///
/// Spacing follows an 8-point grid (with a 4px sub-grid):
/// 4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 48 · 64.
class ThemeDimensions {
  ThemeDimensions._();

  // ── Spacing scale ─────────────────────────────────────
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double space12 = 12;
  static const double spaceMd = 16;
  static const double space20 = 20;
  static const double spaceLg = 24;
  static const double spaceXl = 32;
  static const double space40 = 40;
  static const double space48 = 48;
  static const double space64 = 64;

  // ── Grid gutters, per breakpoint tier ─────────────────
  static const double gutterMobile = 12; // compact (320–360)
  static const double gutter = 16; // mobile
  static const double gutterTablet = 24;
  static const double gutterDesktop = 32;

  // ── Screen margins, per breakpoint tier ───────────────
  static const double marginMobile = 16;
  static const double margin = 16;
  static const double marginTablet = 32;
  static const double marginDesktop = 48;

  /// Desktop content canvas cap (max-w-7xl).
  static const double contentMaxWidth = 1280;

  // ── Radius tokens ─────────────────────────────────────
  static const double radiusCard = 16; // main cards, dialogs, sheets
  static const double radiusMedium = 12; // nested cards / stat tiles
  static const double radiusButton = 12;
  static const double radiusInput = 12;
  static const double radiusPill = 999; // chips, tags, avatars

  // Legacy names kept so existing code keeps compiling.
  static const double radiusSm = 6; // checkbox accents
  static const double radiusBase = radiusMedium; // was 8
  static const double radiusMd = radiusMedium;
  static const double radiusLg = radiusCard;
  static const double radiusXl = radiusCard; // was 24
  static const double radiusFull = radiusPill;

  static const BorderRadius borderRadiusCard =
      BorderRadius.all(Radius.circular(radiusCard));
  static const BorderRadius borderRadiusMedium =
      BorderRadius.all(Radius.circular(radiusMedium));
  static const BorderRadius borderRadiusButton =
      BorderRadius.all(Radius.circular(radiusButton));
  static const BorderRadius borderRadiusInput =
      BorderRadius.all(Radius.circular(radiusInput));
  static const BorderRadius borderRadiusPill =
      BorderRadius.all(Radius.circular(radiusPill));

  // Legacy aliases.
  static const BorderRadius borderRadiusSm =
      BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusBase = borderRadiusMedium;
  static const BorderRadius borderRadiusMd = borderRadiusMedium;
  static const BorderRadius borderRadiusLg = borderRadiusCard;
  static const BorderRadius borderRadiusXl = borderRadiusCard;
  static const BorderRadius borderRadiusFull = borderRadiusPill;

  // ── Component sizing ──────────────────────────────────
  static const double buttonHeight = 44;
  static const double inputHeight = 44;
  static const double inputHorizontalPadding = 14;
  static const double chipHeight = 32;
  static const double checkboxFrame = 20;
  static const double touchTarget = 44; // minimum interactive size
  static const double navBarHeight = 64;

  // ── Elevation (soft slate-tinted shadows, never pure black) ──
  static const List<BoxShadow> shadowTier1 = [
    BoxShadow(
      color: Color(0x0A0F172A),
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
    BoxShadow(
      color: Color(0x080F172A),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> shadowTier2 = [
    BoxShadow(
      color: Color(0x0D0F172A),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x080F172A),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -4,
    ),
  ];

  static const List<BoxShadow> shadowTier3 = [
    BoxShadow(
      color: Color(0x290F172A),
      offset: Offset(0, 16),
      blurRadius: 40,
    ),
  ];

  /// Dark-mode elevated nodes: diffuse emerald-tinted glow.
  static const List<BoxShadow> shadowDarkTier2 = [
    BoxShadow(
      color: Color(0x0F10B981),
      offset: Offset(0, 10),
      blurRadius: 25,
      spreadRadius: -5,
    ),
  ];

  /// Modal/drawer/alert overlay scrim: rgba(15,23,42,0.6).
  static const Color overlayScrim = Color(0x990F172A);
}

/// Width tiers. Pure constants — the theme never lays screens out itself.
class ThemeBreakpoints {
  ThemeBreakpoints._();

  static const double compact = 320; // 320–359
  static const double mobile = 360; // 360–599
  static const double tablet = 600; // 600–839
  static const double desktop = 840; // 840–1199
  static const double largeDesktop = 1200; // 1200+

  static double gutterFor(double width) {
    if (width >= desktop) return ThemeDimensions.gutterDesktop;
    if (width >= tablet) return ThemeDimensions.gutterTablet;
    if (width >= mobile) return ThemeDimensions.gutter;
    return ThemeDimensions.gutterMobile;
  }

  static double marginFor(double width) {
    if (width >= desktop) return ThemeDimensions.marginDesktop;
    if (width >= tablet) return ThemeDimensions.marginTablet;
    return ThemeDimensions.marginMobile;
  }
}