/// Generic, feature-agnostic form validators returning a Flutter
/// `FormField`-compatible `String?` (null = valid).
class Validators {
  Validators._();

  static final RegExp _emailPattern =
      RegExp(r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,}$');

  // A loose international phone pattern: optional +, 7-15 digits.
  static final RegExp _phonePattern = RegExp(r'^\+?[0-9]{7,15}$');

  static String? required(String? value, {String message = 'This field is required'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value, message: 'Email is required');
    if (requiredError != null) return requiredError;
    if (!_emailPattern.hasMatch(value!.trim())) return 'Invalid email format';
    return null;
  }

  static String? password(String? value, {int minLength = 8}) {
    final requiredError = required(value, message: 'Password is required');
    if (requiredError != null) return requiredError;
    if (value!.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  static String? phone(String? value) {
    final requiredError = required(value, message: 'Phone number is required');
    if (requiredError != null) return requiredError;
    if (!_phonePattern.hasMatch(value!.trim())) {
      return 'Invalid phone number';
    }
    return null;
  }
}
