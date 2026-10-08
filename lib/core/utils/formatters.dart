/// Generic, feature-agnostic formatting helpers. No `intl` (or other)
/// package dependency — plain Dart is enough for these.
class Formatters {
  Formatters._();

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// `12 Mar 2026`
  static String date(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} '
        '${_months[date.month - 1]} ${date.year}';
  }

  /// `09:41`
  static String time(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  /// `12 Mar 2026, 09:41`
  static String dateTime(DateTime date) => '${Formatters.date(date)}, ${time(date)}';

  /// `1.2 KB`, `3.4 MB`, ...
  static String fileSize(int bytes) {
    const units = ['B', 'KB', 'MB', 'GB'];
    double size = bytes.toDouble();
    var unitIndex = 0;
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    return '${size.toStringAsFixed(unitIndex == 0 ? 0 : 1)} ${units[unitIndex]}';
  }

  /// Truncates [text] to [maxLength], appending an ellipsis when cut.
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength).trimRight()}…';
  }
}
