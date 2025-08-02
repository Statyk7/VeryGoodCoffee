import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';
import 'package:very_good_coffee/shared/logging/app_logger.dart';

class ImageGalleryLocalDataSource {
  static const String _imagesDirectoryName = 'coffee_images';
  static const String _metadataFileName = 'images_metadata.json';

  Future<String> get _imagesDirectoryPath async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/$_imagesDirectoryName');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    return imagesDir.path;
  }

  Future<String> get _metadataFilePath async {
    final dirPath = await _imagesDirectoryPath;
    return '$dirPath/$_metadataFileName';
  }

  Future<List<CoffeeImage>> getAllImages() async {
    try {
      final metadataFile = File(await _metadataFilePath);
      
      if (!await metadataFile.exists()) {
        return [];
      }

      final metadataJson = await metadataFile.readAsString();
      final metadataList = json.decode(metadataJson) as List<dynamic>;
      
      final images = <CoffeeImage>[];
      
      for (final metadata in metadataList) {
        final imageMap = metadata as Map<String, dynamic>;
        final imageId = imageMap['id'] as String;
        final sourceUrl = imageMap['sourceUrl'] as String;
        final savedAtString = imageMap['savedAt'] as String;
        final savedAt = DateTime.parse(savedAtString);
        
        final imagePath = '${await _imagesDirectoryPath}/$imageId.jpg';
        final imageFile = File(imagePath);
        
        if (await imageFile.exists()) {
          final bytes = await imageFile.readAsBytes();
          images.add(CoffeeImage(
            id: imageId,
            bytes: bytes,
            sourceUrl: sourceUrl,
            savedAt: savedAt,
          ));
        }
      }
      
      AppLogger.info('Retrieved ${images.length} images from local storage');
      return images;
    } catch (e, stackTrace) {
      AppLogger.error('Error retrieving images from local storage', e, stackTrace);
      return [];
    }
  }

  Future<void> saveImage(CoffeeImage image) async {
    try {
      final imageId = DateTime.now().millisecondsSinceEpoch.toString();
      final imagePath = '${await _imagesDirectoryPath}/$imageId.jpg';
      
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image.bytes);
      
      final savedImage = image.copyWith(
        id: imageId,
        savedAt: DateTime.now(),
      );
      
      await _updateMetadata(savedImage);
      
      AppLogger.info('Saved coffee image with ID: $imageId');
    } catch (e, stackTrace) {
      AppLogger.error('Error saving image to local storage', e, stackTrace);
      throw Exception('Failed to save image: $e');
    }
  }

  Future<void> removeImage(String imageId) async {
    try {
      final imagePath = '${await _imagesDirectoryPath}/$imageId.jpg';
      final imageFile = File(imagePath);
      
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
      
      await _removeFromMetadata(imageId);
      
      AppLogger.info('Removed coffee image with ID: $imageId');
    } catch (e, stackTrace) {
      AppLogger.error('Error removing image from local storage', e, stackTrace);
      throw Exception('Failed to remove image: $e');
    }
  }

  Future<void> _updateMetadata(CoffeeImage image) async {
    final metadataFile = File(await _metadataFilePath);
    
    List<Map<String, dynamic>> metadataList = [];
    
    if (await metadataFile.exists()) {
      final metadataJson = await metadataFile.readAsString();
      final existingData = json.decode(metadataJson) as List<dynamic>;
      metadataList = existingData.cast<Map<String, dynamic>>();
    }
    
    metadataList.add({
      'id': image.id,
      'sourceUrl': image.sourceUrl,
      'savedAt': image.savedAt!.toIso8601String(),
    });
    
    await metadataFile.writeAsString(json.encode(metadataList));
  }

  Future<void> _removeFromMetadata(String imageId) async {
    final metadataFile = File(await _metadataFilePath);
    
    if (!await metadataFile.exists()) {
      return;
    }
    
    final metadataJson = await metadataFile.readAsString();
    final metadataList = json.decode(metadataJson) as List<dynamic>;
    
    metadataList.removeWhere((metadata) {
      final imageMap = metadata as Map<String, dynamic>;
      return imageMap['id'] == imageId;
    });
    
    await metadataFile.writeAsString(json.encode(metadataList));
  }
}