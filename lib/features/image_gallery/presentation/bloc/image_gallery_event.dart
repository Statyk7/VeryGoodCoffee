import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

abstract class ImageGalleryEvent {}

class LoadGalleryImagesRequested extends ImageGalleryEvent {}

class SaveImageRequested extends ImageGalleryEvent {
  SaveImageRequested(this.image);
  
  final CoffeeImage image;
}

class RemoveImageRequested extends ImageGalleryEvent {
  RemoveImageRequested(this.imageId);
  
  final String imageId;
}