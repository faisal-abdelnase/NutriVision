/// Global, feature-agnostic application constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'MediLink';

  static const int defaultPageSize = 20;

  static const Duration defaultAnimationDuration = Duration(milliseconds: 250);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration debounceDuration = Duration(milliseconds: 400);
}
