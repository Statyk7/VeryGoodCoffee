import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/features/image_fetcher/data/services/image_fetcher_service_impl.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/test_data.dart';

void main() {
  group('ImageFetcherServiceImpl', () {
    late ImageFetcherServiceImpl service;
    late MockCoffeeImageRemoteDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockCoffeeImageRemoteDataSource();
      service = ImageFetcherServiceImpl(mockDataSource);
    });

    group('getNewRandomImage', () {
      test('should return CoffeeImage from data source', () async {
        // Arrange
        final expectedImage = TestData.sampleCoffeeImage;
        when(
          () => mockDataSource.fetchRandomCoffeeImage(),
        ).thenAnswer((_) async => expectedImage);

        // Act
        final result = await service.getNewRandomImage();

        // Assert
        expect(result, equals(expectedImage));
        expect(result.bytes, equals(expectedImage.bytes));
        expect(result.sourceUrl, equals(expectedImage.sourceUrl));
        verify(() => mockDataSource.fetchRandomCoffeeImage()).called(1);
      });

      test('should propagate exception from data source', () async {
        // Arrange
        final exception = Exception('Network error');
        when(
          () => mockDataSource.fetchRandomCoffeeImage(),
        ).thenThrow(exception);

        // Act & Assert
        expect(
          () => service.getNewRandomImage(),
          throwsA(equals(exception)),
        );
        verify(() => mockDataSource.fetchRandomCoffeeImage()).called(1);
      });

      test('should not modify the image from data source', () async {
        // Arrange
        final originalImage = TestData.sampleCoffeeImage;
        when(
          () => mockDataSource.fetchRandomCoffeeImage(),
        ).thenAnswer((_) async => originalImage);

        // Act
        final result = await service.getNewRandomImage();

        // Assert
        expect(result, same(originalImage));
        expect(result.id, equals(originalImage.id));
        expect(result.savedAt, equals(originalImage.savedAt));
      });

      test('should handle different image types', () async {
        // Arrange
        final pngImage = CoffeeImage(
          bytes: TestData.sampleCoffeeImageList[1].bytes, // PNG bytes
          sourceUrl: 'https://example.com/image.png',
        );
        when(
          () => mockDataSource.fetchRandomCoffeeImage(),
        ).thenAnswer((_) async => pngImage);

        // Act
        final result = await service.getNewRandomImage();

        // Assert
        expect(result, equals(pngImage));
        expect(result.sourceUrl, contains('.png'));
      });
    });
  });
}
