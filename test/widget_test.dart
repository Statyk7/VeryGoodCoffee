// Basic tests for Very Good Coffee app

import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee/app/config/constants.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';
import 'dart:typed_data';

void main() {
  group('AppConstants', () {
    test('should have correct values', () {
      expect(AppConstants.appName, 'Very Good Coffee');
      expect(AppConstants.appVersion, '1.0.0');
      expect(AppConstants.coffeeApiUrl, 'https://coffee.alexflipnote.dev');
      expect(AppConstants.splashDurationSeconds, 2);
    });
  });

  group('CoffeeImage', () {
    test('should create instance with required fields', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4]);
      const sourceUrl = 'https://example.com/coffee.jpg';
      
      final image = CoffeeImage(
        bytes: bytes,
        sourceUrl: sourceUrl,
      );
      
      expect(image.bytes, equals(bytes));
      expect(image.sourceUrl, equals(sourceUrl));
      expect(image.id, isNull);
      expect(image.savedAt, isNull);
    });

    test('should support copyWith', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4]);
      const sourceUrl = 'https://example.com/coffee.jpg';
      final now = DateTime.now();
      
      final image = CoffeeImage(
        bytes: bytes,
        sourceUrl: sourceUrl,
      );
      
      final copiedImage = image.copyWith(
        id: 'test-id',
        savedAt: now,
      );
      
      expect(copiedImage.bytes, equals(bytes));
      expect(copiedImage.sourceUrl, equals(sourceUrl));
      expect(copiedImage.id, equals('test-id'));
      expect(copiedImage.savedAt, equals(now));
    });
  });
}
