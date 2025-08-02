import 'dart:typed_data';

import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

class TestData {
  // Test Mock Storage Directory
  static const testMockStorageDirectory = './test/fixtures/storage';

  // Sample image bytes
  static final sampleImageBytes = Uint8List.fromList([
    0xFF, 0xD8, 0xFF, 0xE0, // JPEG header
    0x00, 0x10, 0x4A, 0x46,
    0x49, 0x46, 0x00, 0x01,
    // Additional JPEG data...
    0x01, 0x01, 0x00, 0x48,
    0x00, 0x48, 0x00, 0x00,
    0xFF, 0xD9, // JPEG footer
  ]);

  // Sample coffee images
  static CoffeeImage get sampleCoffeeImage => CoffeeImage(
    bytes: sampleImageBytes,
    sourceUrl: 'https://coffee.alexflipnote.dev/sample.jpg',
  );

  static CoffeeImage get sampleSavedCoffeeImage => CoffeeImage(
    id: 'test-image-123',
    bytes: sampleImageBytes,
    sourceUrl: 'https://coffee.alexflipnote.dev/sample.jpg',
    savedAt: DateTime(2024, 1, 15, 10, 30),
  );

  static List<CoffeeImage> get sampleCoffeeImageList => [
    CoffeeImage(
      id: 'image-1',
      bytes: sampleImageBytes,
      sourceUrl: 'https://coffee.alexflipnote.dev/image1.jpg',
      savedAt: DateTime(2024, 1, 15, 10, 30),
    ),
    CoffeeImage(
      id: 'image-2',
      bytes: Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]), // PNG header
      sourceUrl: 'https://coffee.alexflipnote.dev/image2.png',
      savedAt: DateTime(2024, 1, 16, 14, 45),
    ),
    CoffeeImage(
      id: 'image-3',
      bytes: sampleImageBytes,
      sourceUrl: 'https://coffee.alexflipnote.dev/image3.jpg',
      savedAt: DateTime(2024, 1, 17, 9, 15),
    ),
  ];

  // Error messages
  static const networkErrorMessage = 'Network error: Connection timeout';
  static const fileSystemErrorMessage =
      'Failed to save image: Permission denied';
  static const genericErrorMessage = 'Something went wrong';

  // API URLs
  static const coffeeApiUrl = 'https://coffee.alexflipnote.dev';
  static const sampleImageUrl = '$coffeeApiUrl/sample.jpg';

  // Metadata JSON
  static const sampleMetadataJson = '''
[
  {
    "id": "image-1",
    "sourceUrl": "https://coffee.alexflipnote.dev/image1.jpg",
    "savedAt": "2024-01-15T10:30:00.000Z"
  },
  {
    "id": "image-2", 
    "sourceUrl": "https://coffee.alexflipnote.dev/image2.png",
    "savedAt": "2024-01-16T14:45:00.000Z"
  }
]''';
}
