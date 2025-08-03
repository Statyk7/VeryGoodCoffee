import 'package:flutter_test/flutter_test.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:very_good_coffee/shared/logging/app_logger.dart';

void main() {
  group('AppLogger', () {
    setUp(AppLogger.init);

    test('should initialize properly', () {
      expect(AppLogger.isInitialized, isTrue);
    });

    test('should provide access to talker instance', () {
      final instance = AppLogger.instance;
      expect(instance, isA<Talker>());
    });

    test('should log info messages', () {
      expect(() => AppLogger.info('Test info message'), returnsNormally);
    });

    test('should log debug messages', () {
      expect(() => AppLogger.debug('Test debug message'), returnsNormally);
    });

    test('should log warning messages', () {
      expect(() => AppLogger.warning('Test warning message'), returnsNormally);
    });

    test('should log error messages', () {
      expect(
        () => AppLogger.error('Test error message'),
        returnsNormally,
      );
    });

    test('should log error messages with exception and stack trace', () {
      final exception = Exception('Test exception');
      final stackTrace = StackTrace.current;

      expect(
        () => AppLogger.error('Test error message', exception, stackTrace),
        returnsNormally,
      );
    });
  });
}
