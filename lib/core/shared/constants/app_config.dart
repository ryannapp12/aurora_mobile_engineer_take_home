import 'package:flutter/foundation.dart';

class AppConfig {
  // Can be overridden with: --dart-define API_BASE_URL=https://example.com
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://november7-730026606190.europe-west1.run.app',
  );

  // Helpful toggle for additional diagnostics if ever needed
  static const bool enableUtils = bool.fromEnvironment('UTILS', defaultValue: true);

  static void debugPrintConfig() {
    if (kDebugMode) {
      // ignore: avoid_print
      print('AppConfig: apiBaseUrl=$apiBaseUrl enableUtils=$enableUtils');
    }
  }
}


