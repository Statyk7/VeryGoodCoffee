import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

abstract class ImageFetcherState {}

class ImageFetcherInitial extends ImageFetcherState {}

class ImageFetcherLoading extends ImageFetcherState {}

class ImageFetcherSuccess extends ImageFetcherState {
  ImageFetcherSuccess(this.image);
  
  final CoffeeImage image;
}

class ImageFetcherError extends ImageFetcherState {
  ImageFetcherError(this.message);
  
  final String message;
}
