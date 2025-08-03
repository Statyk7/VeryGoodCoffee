import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

/// Service for managing the local coffee image gallery.
/// 
/// Provides methods to store, retrieve, and remove coffee images from local
/// storage. Images are persisted with metadata and can be accessed offline.
abstract class ImageGalleryService {
  /// Retrieves all saved coffee images from local storage.
  /// 
  /// Returns a list of [CoffeeImage] objects that have been previously saved
  /// to the gallery. The list may be empty if no images have been saved.
  /// 
  /// Throws an exception if there's an error accessing local storage.
  Future<List<CoffeeImage>> getAllImages();

  /// Adds a new coffee image to the gallery.
  /// 
  /// The [image] parameter must contain image bytes and a source URL.
  /// A unique ID and timestamp will be assigned during the save process.
  /// 
  /// Throws an exception if the image cannot be saved to local storage.
  Future<void> addImage(CoffeeImage image);

  /// Removes a coffee image from the gallery by its ID.
  /// 
  /// The [imageId] parameter should match the ID of a previously saved image.
  /// If no image with the given ID exists, the operation completes silently.
  /// 
  /// Throws an exception if there's an error accessing local storage.
  Future<void> removeImage(String imageId);
}
