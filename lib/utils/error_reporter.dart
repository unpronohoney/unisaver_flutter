import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized error reporting service for Firebase Crashlytics
class ErrorReporter {
  static final ErrorReporter _instance = ErrorReporter._internal();
  factory ErrorReporter() => _instance;
  ErrorReporter._internal();

  static ErrorReporter get instance => _instance;

  /// Reports an error to Firebase Crashlytics
  /// Use this for non-fatal errors that should be tracked
  Future<void> reportError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    // Always print in debug mode
    debugPrint('Error: $error\nReason: $reason\nStackTrace: $stackTrace');

    // Only report to Crashlytics in release mode
    if (kReleaseMode) {
      try {
        if (reason != null) {
          await FirebaseCrashlytics.instance.log(reason);
        }
        await FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          fatal: fatal,
        );
      } catch (e) {
        debugPrint('Failed to report error to Crashlytics: $e');
      }
    }
  }

  /// Log a message to Crashlytics (for context before errors)
  Future<void> log(String message) async {
    debugPrint('Log: $message');
    if (kReleaseMode) {
      try {
        await FirebaseCrashlytics.instance.log(message);
      } catch (e) {
        debugPrint('Failed to log to Crashlytics: $e');
      }
    }
  }

  /// Set a custom key-value pair for crash reports
  Future<void> setCustomKey(String key, dynamic value) async {
    if (kReleaseMode) {
      try {
        await FirebaseCrashlytics.instance.setCustomKey(key, value);
      } catch (e) {
        debugPrint('Failed to set custom key: $e');
      }
    }
  }
}
