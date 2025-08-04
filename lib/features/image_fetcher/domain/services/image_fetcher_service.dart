import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

/// Service for fetching coffee images from external APIs.
///
/// Provides methods to retrieve random coffee images from remote sources.
/// Images are downloaded with their metadata and ready for display or storage.
///
/// Following Clean Architecture guidelines, services are abstract.
// ignore: one_member_abstracts
abstract class ImageFetcherService {
  /// Fetches a new random coffee image from the API.
  ///
  /// Downloads a random coffee image with its bytes and metadata.
  /// Each call returns a different image from the coffee API.
  ///
  /// Returns a [CoffeeImage] containing the image bytes and source URL.
  ///
  /// Throws an exception if the network request fails or if the API
  /// returns invalid data.
  Future<CoffeeImage> getNewRandomImage();
}
