import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/features/image_gallery/data/services/image_gallery_service_impl.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/test_data.dart';

void main() {
  group('ImageGalleryServiceImpl', () {
    late ImageGalleryServiceImpl service;
    late MockImageGalleryLocalDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockImageGalleryLocalDataSource();
      service = ImageGalleryServiceImpl(mockDataSource);

      // Register fallback values
      registerFallbackValue(TestData.sampleCoffeeImage);
    });

    group('getAllImages', () {
      test('should return list of images from data source', () async {
        // Arrange
        final expectedImages = TestData.sampleCoffeeImageList;
        when(
          () => mockDataSource.getAllImages(),
        ).thenAnswer((_) async => expectedImages);

        // Act
        final result = await service.getAllImages();

        // Assert
        expect(result, equals(expectedImages));
        expect(result.length, equals(expectedImages.length));
        verify(() => mockDataSource.getAllImages()).called(1);
      });

      test('should return empty list when no images exist', () async {
        // Arrange
        when(
          () => mockDataSource.getAllImages(),
        ).thenAnswer((_) async => <CoffeeImage>[]);

        // Act
        final result = await service.getAllImages();

        // Assert
        expect(result, isEmpty);
        verify(() => mockDataSource.getAllImages()).called(1);
      });

      test('should propagate exception from data source', () async {
        // Arrange
        final exception = Exception('File system error');
        when(() => mockDataSource.getAllImages()).thenThrow(exception);

        // Act & Assert
        expect(
          () => service.getAllImages(),
          throwsA(equals(exception)),
        );
        verify(() => mockDataSource.getAllImages()).called(1);
      });
    });

    group('addImage', () {
      test('should save image through data source', () async {
        // Arrange
        final testImage = TestData.sampleCoffeeImage;
        when(() => mockDataSource.saveImage(any())).thenAnswer((_) async {});

        // Act
        await service.addImage(testImage);

        // Assert
        verify(() => mockDataSource.saveImage(testImage)).called(1);
      });

      test('should propagate exception from data source', () async {
        // Arrange
        final testImage = TestData.sampleCoffeeImage;
        final exception = Exception('Failed to save');
        when(() => mockDataSource.saveImage(any())).thenThrow(exception);

        // Act & Assert
        expect(
          () => service.addImage(testImage),
          throwsA(equals(exception)),
        );
        verify(() => mockDataSource.saveImage(testImage)).called(1);
      });

      test('should handle different image formats', () async {
        // Arrange
        final images = TestData.sampleCoffeeImageList;
        when(() => mockDataSource.saveImage(any())).thenAnswer((_) async {});

        // Act
        for (final image in images) {
          await service.addImage(image);
        }

        // Assert
        for (final image in images) {
          verify(() => mockDataSource.saveImage(image)).called(1);
        }
      });
    });

    group('removeImage', () {
      test('should remove image through data source', () async {
        // Arrange
        const testImageId = 'test-image-123';
        when(() => mockDataSource.removeImage(any())).thenAnswer((_) async {});

        // Act
        await service.removeImage(testImageId);

        // Assert
        verify(() => mockDataSource.removeImage(testImageId)).called(1);
      });

      test('should propagate exception from data source', () async {
        // Arrange
        const testImageId = 'test-image-123';
        final exception = Exception('Failed to remove');
        when(() => mockDataSource.removeImage(any())).thenThrow(exception);

        // Act & Assert
        expect(
          () => service.removeImage(testImageId),
          throwsA(equals(exception)),
        );
        verify(() => mockDataSource.removeImage(testImageId)).called(1);
      });

      test('should handle empty or null image IDs', () async {
        // Arrange
        when(() => mockDataSource.removeImage(any())).thenAnswer((_) async {});

        // Act & Assert
        await service.removeImage('');
        verify(() => mockDataSource.removeImage('')).called(1);
      });

      test('should handle special characters in image ID', () async {
        // Arrange
        const specialId = 'image-with-special-chars_123!@#';
        when(() => mockDataSource.removeImage(any())).thenAnswer((_) async {});

        // Act
        await service.removeImage(specialId);

        // Assert
        verify(() => mockDataSource.removeImage(specialId)).called(1);
      });
    });
  });
}
