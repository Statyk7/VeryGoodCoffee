import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/features/image_gallery/data/data_source/image_gallery_local_data_source.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/test_data.dart';

void main() {
  group('ImageGalleryLocalDataSource', () {
    late ImageGalleryLocalDataSource dataSource;

    setUpAll(() {
      // Initialize Flutter binding for path_provider
      TestWidgetsFlutterBinding.ensureInitialized();
      // Initialize AppLogger for tests
      initializeTestLogger();
    });

    setUp(() {
      // Setup path_provider mock before creating data source
      setupPathProviderMock();

      dataSource = ImageGalleryLocalDataSource();

      // Register fallback values
      registerFallbackValue(TestData.sampleImageBytes);

      // Clean slate for each test
      final testDir = Directory('./test/fixtures/storage/coffee_images');
      if (testDir.existsSync()) {
        testDir.deleteSync(recursive: true);
      }
      testDir.createSync(recursive: true);
    });

    tearDown(() {
      // Clean up after each test
      final testDir = Directory('./test/fixtures/storage/coffee_images');
      if (testDir.existsSync()) {
        testDir.deleteSync(recursive: true);
      }
    });

    group('getAllImages', () {
      test(
        'should return empty list when metadata file does not exist',
        () async {
          // Act
          final result = await dataSource.getAllImages();

          // Assert
          expect(result, isEmpty);
        },
      );

      test(
        'should return list of images when metadata file exists with data',
        () async {
          // Arrange - Create test files
          final testDir = Directory('./test/fixtures/storage/coffee_images');
          final metadataFile = File('${testDir.path}/images_metadata.json');
          await metadataFile.writeAsString(TestData.sampleMetadataJson);

          // Create test image files with actual bytes
          final imageFile1 = File('${testDir.path}/image-1.jpg');
          await imageFile1.writeAsBytes(TestData.sampleImageBytes);

          final imageFile2 = File('${testDir.path}/image-2.jpg');
          await imageFile2.writeAsBytes(TestData.sampleImageBytes);

          // Act
          final result = await dataSource.getAllImages();

          // Assert
          expect(result, isA<List<CoffeeImage>>());
          expect(result, hasLength(2));
          expect(result[0].id, equals('image-1'));
          expect(
            result[0].sourceUrl,
            equals('https://coffee.alexflipnote.dev/image1.jpg'),
          );
          expect(result[0].bytes, equals(TestData.sampleImageBytes));
        },
      );

      test('should handle file system errors gracefully', () async {
        // Arrange - Create invalid metadata
        final testDir = Directory('./test/fixtures/storage/coffee_images');
        final metadataFile = File('${testDir.path}/images_metadata.json');
        await metadataFile.writeAsString('invalid json');

        // Act
        final result = await dataSource.getAllImages();

        // Assert - Should return empty list on error
        expect(result, isEmpty);
      });
    });

    group('saveImage', () {
      test('should save image and update metadata', () async {
        // Arrange
        final testImage = TestData.sampleCoffeeImage;
        final testDir = Directory('./test/fixtures/storage/coffee_images');
        final metadataFile = File('${testDir.path}/images_metadata.json');

        // Act
        await dataSource.saveImage(testImage);

        // Assert - Check that metadata file was created and updated
        expect(metadataFile.existsSync(), isTrue);

        final metadataContent = await metadataFile.readAsString();
        expect(metadataContent, isNotEmpty);
        expect(metadataContent, contains(testImage.sourceUrl));

        // Check that image files were created
        final imageFiles = await testDir
            .list()
            .where((entity) => entity is File && entity.path.endsWith('.jpg'))
            .toList();
        expect(imageFiles, hasLength(1));
      });

      test(
        'should append to existing metadata when saving new image',
        () async {
          // Arrange
          final testDir = Directory('./test/fixtures/storage/coffee_images');
          final metadataFile = File('${testDir.path}/images_metadata.json');
          await metadataFile.writeAsString('[]'); // Start with empty array

          final testImage1 = TestData.sampleCoffeeImage;
          final testImage2 = TestData.sampleCoffeeImage.copyWith(
            sourceUrl: 'https://coffee.alexflipnote.dev/another.jpg',
          );

          // Act
          await dataSource.saveImage(testImage1);
          await dataSource.saveImage(testImage2);

          // Assert
          final metadataContent = await metadataFile.readAsString();
          expect(metadataContent, contains(testImage1.sourceUrl));
          expect(metadataContent, contains(testImage2.sourceUrl));

          // Should have 2 image files
          final imageFiles = await testDir
              .list()
              .where((entity) => entity is File && entity.path.endsWith('.jpg'))
              .toList();
          expect(imageFiles, hasLength(2));
        },
      );
    });

    group('removeImage', () {
      test('should remove image file and update metadata', () async {
        // Arrange - First save an image
        final testImage = TestData.sampleCoffeeImage;
        final testDir = Directory('./test/fixtures/storage/coffee_images');
        final metadataFile = File('${testDir.path}/images_metadata.json');

        // Save image first
        await dataSource.saveImage(testImage);

        // Get the generated image ID from metadata
        final metadataContent = await metadataFile.readAsString();
        final metadata = json.decode(metadataContent) as List<dynamic>;
        final imageId = metadata[0]['id'] as String;

        // Verify image file exists
        final imageFile = File('${testDir.path}/$imageId.jpg');
        expect(imageFile.existsSync(), isTrue);

        // Act
        await dataSource.removeImage(imageId);

        // Assert - Image file should be deleted
        expect(imageFile.existsSync(), isFalse);

        // Metadata should be updated (empty array)
        final updatedMetadata = await metadataFile.readAsString();
        final updatedList = json.decode(updatedMetadata) as List<dynamic>;
        expect(updatedList, isEmpty);
      });

      test('should handle non-existent image gracefully', () async {
        // Arrange
        const nonExistentImageId = 'non-existent-id';

        // Act & Assert - Should not throw
        await dataSource.removeImage(nonExistentImageId);
        // If we get here without throwing, the test passes
      });

      test('should handle non-existent metadata file gracefully', () async {
        // Arrange - Remove metadata file if it exists
        final testDir = Directory('./test/fixtures/storage/coffee_images');
        final metadataFile = File('${testDir.path}/images_metadata.json');
        if (metadataFile.existsSync()) {
          await metadataFile.delete();
        }

        const testImageId = 'test-image-123';

        // Act & Assert - Should not throw
        await dataSource.removeImage(testImageId);
      });
    });

    group('directory and file operations', () {
      test('should create images directory if it does not exist', () async {
        // Arrange - Delete directory to test creation
        final testDir = Directory('./test/fixtures/storage/coffee_images');
        if (testDir.existsSync()) {
          testDir.deleteSync(recursive: true);
        }

        // Act - This should create the directory
        final result = await dataSource.getAllImages();

        // Assert - Directory should now exist
        expect(testDir.existsSync(), isTrue);
        expect(result, isA<List<CoffeeImage>>());
      });

      test('should handle metadata JSON parsing correctly', () async {
        // Arrange - Create test metadata with proper structure
        final testDir = Directory('./test/fixtures/storage/coffee_images');
        final metadataFile = File('${testDir.path}/images_metadata.json');
        await metadataFile.writeAsString(TestData.sampleMetadataJson);

        // Create corresponding image files
        final imageFile1 = File('${testDir.path}/image-1.jpg');
        await imageFile1.writeAsBytes(TestData.sampleImageBytes);

        final imageFile2 = File('${testDir.path}/image-2.jpg');
        await imageFile2.writeAsBytes(TestData.sampleImageBytes);

        // Act
        final result = await dataSource.getAllImages();

        // Assert - Should parse JSON correctly
        expect(result, hasLength(2));
        expect(
          result[0].sourceUrl,
          equals('https://coffee.alexflipnote.dev/image1.jpg'),
        );
        expect(
          result[1].sourceUrl,
          equals('https://coffee.alexflipnote.dev/image2.png'),
        );
      });
    });
  });
}
