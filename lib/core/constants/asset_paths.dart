/// Centralized base paths for asset directories.
///
/// Only directory roots are defined here — no individual file names are
/// referenced yet, since no assets exist in the project at this stage.
/// Feature code should build on these, e.g.:
/// `'${AssetPaths.images}/logo.png'`.
///
/// Expected structure (declare in pubspec.yaml once assets are added):
/// ```text
/// assets/
/// ├── images/
/// ├── icons/
/// ├── illustrations/
/// └── fonts/
/// ```
class AssetPaths {
  AssetPaths._();

  static const String images = 'assets/images';
  static const String icons = 'assets/icons';
  static const String illustrations = 'assets/illustrations';
  static const String fonts = 'assets/fonts';
  static const String lang = 'assets/lang';
}
