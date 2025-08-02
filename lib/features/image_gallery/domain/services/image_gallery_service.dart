import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

abstract class ImageGalleryService {
  Future<List<CoffeeImage>> getAllImages();

  Future<void> addImage(CoffeeImage image);

  Future<void> removeImage(String imageId);
}
