/// API-related constants only. No HTTP client, interceptors, or backend
/// integration is implemented here — that belongs to a future data layer.
class ApiConstants {
  ApiConstants._();

  /// Placeholder — replace once the real backend base URL is known.
  static const String baseUrl = 'https://api.medilink.example.com';

  static const String apiVersion = 'v1';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
