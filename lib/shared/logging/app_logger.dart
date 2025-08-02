import 'package:talker_flutter/talker_flutter.dart';

class AppLogger {
  static late Talker _talker;

  static void init() {
    _talker = TalkerFlutter.init();
  }

  static Talker get instance => _talker;

  static void info(String message) => _talker.info(message);
  static void debug(String message) => _talker.debug(message);
  static void warning(String message) => _talker.warning(message);
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _talker.error(message, error, stackTrace);
  }
}