/// Screen-size classes used by the responsive and adaptive systems.
///
/// ```text
/// xs  < 360
/// sm  360 - 599   (phone)
/// md  600 - 839   (large phone / small tablet)
/// lg  840 - 1199  (tablet)
/// xl  >= 1200     (desktop)
/// ```
enum AppBreakpoint { xs, sm, md, lg, xl }

class Breakpoints {
  Breakpoints._();

  static const double sm = 360;
  static const double md = 600;
  static const double lg = 840;
  static const double xl = 1200;

  static AppBreakpoint of(double width) {
    if (width < sm) return AppBreakpoint.xs;
    if (width < md) return AppBreakpoint.sm;
    if (width < lg) return AppBreakpoint.md;
    if (width < xl) return AppBreakpoint.lg;
    return AppBreakpoint.xl;
  }

  static bool isMobile(AppBreakpoint bp) =>
      bp == AppBreakpoint.xs || bp == AppBreakpoint.sm;
  static bool isTablet(AppBreakpoint bp) =>
      bp == AppBreakpoint.md || bp == AppBreakpoint.lg;
  static bool isDesktop(AppBreakpoint bp) => bp == AppBreakpoint.xl;
}
