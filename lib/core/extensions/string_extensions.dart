extension StringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
}

extension NonNullStringExtensions on String {
  /// Capitalizes just the first character, leaving the rest untouched.
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
