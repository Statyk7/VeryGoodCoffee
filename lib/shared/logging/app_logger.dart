import 'package:talker_flutter/talker_flutter.dart';

class AppLogger {
  static late Talker _talker;
  static bool _isInitialized = false;

  static void init() {
    if (!_isInitialized) {
      _talker = TalkerFlutter.init();
      _isInitialized = true;
    }
  }

  static bool get isInitialized => _isInitialized;

  static Talker get instance => _talker;

  static void info(String message) => _talker.info(message);

  static void debug(String message) => _talker.debug(message);

  static void warning(String message) => _talker.warning(message);

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _talker.error(message, error, stackTrace);
  }
}
