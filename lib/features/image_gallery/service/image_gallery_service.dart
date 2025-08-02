import 'package:very_good_coffee/features/image_gallery/data_source/image_gallery_local_data_source.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

class ImageGalleryService {
  ImageGalleryService(this._localDataSource);

  final ImageGalleryLocalDataSource _localDataSource;

  Future<List<CoffeeImage>> getAllImages() async {
    return _localDataSource.getAllImages();
  }

  Future<void> addImage(CoffeeImage image) async {
    return _localDataSource.saveImage(image);
  }

  Future<void> removeImage(String imageId) async {
    return _localDataSource.removeImage(imageId);
  }
}