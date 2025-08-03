import 'package:very_good_coffee/features/image_gallery/data/data_source/image_gallery_local_data_source.dart';
import 'package:very_good_coffee/features/image_gallery/domain/services/image_gallery_service.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

/// Implementation of ImageGalleryService using a ImageGalleryDataSource.
class ImageGalleryServiceImpl implements ImageGalleryService {
  ImageGalleryServiceImpl(this._localDataSource);

  final ImageGalleryLocalDataSource _localDataSource;

  @override
  Future<List<CoffeeImage>> getAllImages() async {
    return _localDataSource.getAllImages();
  }

  @override
  Future<void> addImage(CoffeeImage image) async {
    return _localDataSource.saveImage(image);
  }

  @override
  Future<void> removeImage(String imageId) async {
    return _localDataSource.removeImage(imageId);
  }
}
