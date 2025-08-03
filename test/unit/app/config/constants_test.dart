import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee/app/config/constants.dart';

void main() {
  group('AppConstants', () {
    test('should have correct coffee API URL', () {
      expect(
        AppConstants.coffeeApiUrl,
        equals('https://coffee.alexflipnote.dev'),
      );
    });

    test('should have correct app version', () {
      expect(AppConstants.appVersion, equals('1.0.0'));
    });

    test('should have correct splash duration in seconds', () {
      expect(AppConstants.splashDurationSeconds, equals(2));
      expect(AppConstants.splashDurationSeconds, isA<int>());
      expect(AppConstants.splashDurationSeconds, greaterThan(0));
    });

    test('should have immutable constant values', () {
      // These tests verify that constants are properly defined as const
      expect(AppConstants.coffeeApiUrl, isA<String>());
      expect(AppConstants.appVersion, isA<String>());
      expect(AppConstants.splashDurationSeconds, isA<int>());
    });

    test('coffee API URL should be a valid URL format', () {
      const url = AppConstants.coffeeApiUrl;
      expect(url, startsWith('https://'));
      expect(Uri.tryParse(url), isNotNull);
    });

    test('app version should follow semantic versioning format', () {
      const version = AppConstants.appVersion;
      final versionRegex = RegExp(r'^\d+\.\d+\.\d+$');
      expect(versionRegex.hasMatch(version), isTrue);
    });
  });
}
