import 'dart:developer' as developer;

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';

/// Temporary diagnostics for tracing the AI Coach request across layers.
class AiCoachDiagnostics {
  static const _loggerName = 'NutriVision.AICoach';

  static void info(String message) {
    developer.log(message, name: _loggerName);
  }

  static void failure(
    String operation,
    Object error,
    StackTrace stackTrace, {
    String? details,
  }) {
    final code = switch (error) {
      FirebaseException(:final code) => code,
      _ => null,
    };
    final message = switch (error) {
      FirebaseAIException(:final message) => message,
      FirebaseException(:final message) => message,
      _ => error.toString(),
    };
    final status = RegExp(
      r'(?:HTTP(?: status)?|status(?: code)?)[^0-9]{0,12}(\d{3})',
      caseSensitive: false,
    ).firstMatch(message!)?.group(1) ??
        RegExp(r'\b([1-5]\d{2})\s+(?:[A-Z][A-Z_]+|[A-Za-z])')
            .firstMatch(message)
            ?.group(1);

    developer.log(
      '$operation failed'
      '\nException type: ${error.runtimeType}'
      '\nOriginal message: $message'
      '\nFirebase error code: ${code ?? 'unavailable'}'
      '\nHTTP status: ${status ?? 'unavailable'}'
      '${details == null ? '' : '\n$details'}',
      name: _loggerName,
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }
}
