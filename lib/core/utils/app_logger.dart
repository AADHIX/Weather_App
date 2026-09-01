import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '[INFO] ';
      debugPrint('ℹ️ $prefix$message');
    }
  }

  static void success(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '[SUCCESS] ';
      debugPrint('✅ $prefix$message');
    }
  }

  static void warning(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '[WARNING] ';
      debugPrint('⚠️ $prefix$message');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace, String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '[ERROR] ';
      debugPrint('❌ $prefix$message');
      if (error != null) {
        debugPrint('   Details: $error');
      }
      if (stackTrace != null) {
        debugPrint('   StackTrace: $stackTrace');
      }
    }
  }
}
