import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

abstract class ImageGalleryState {}

class ImageGalleryInitial extends ImageGalleryState {}

class ImageGalleryLoading extends ImageGalleryState {}

class ImageGalleryLoaded extends ImageGalleryState {
  ImageGalleryLoaded(this.images);
  
  final List<CoffeeImage> images;
}

class ImageGalleryError extends ImageGalleryState {
  ImageGalleryError(this.message);
  
  final String message;
}

class ImageSaving extends ImageGalleryState {}

class ImageSaved extends ImageGalleryState {}

class ImageSaveError extends ImageGalleryState {
  ImageSaveError(this.message);
  
  final String message;
}