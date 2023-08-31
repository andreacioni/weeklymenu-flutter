import 'dart:developer';

import 'package:logging/logging.dart';

void logError(String message, Object? error, StackTrace? stackTrace) {
  log(message, level: Level.SEVERE.value, error: error, stackTrace: stackTrace);
}

void logWarn(String message, [Object? error, StackTrace? stackTrace]) {
  log(message,
      level: Level.WARNING.value, error: error, stackTrace: stackTrace);
}
