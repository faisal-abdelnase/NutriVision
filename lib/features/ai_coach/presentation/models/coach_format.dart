/// Formats a number with thousands separators, e.g. `1520` -> `1,520`.
String formatCoachNumber(num value) {
  final text = value.round().abs().toString();
  final buffer = StringBuffer(value < 0 ? '-' : '');

  for (var i = 0; i < text.length; i++) {
    final remaining = text.length - i;
    buffer.write(text[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }

  return buffer.toString();
}
