import 'package:very_good_coffee/features/image_fetcher/data_source/coffee_image_remote_data_source.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

class ImageFetcherService {
  ImageFetcherService(this._remoteDataSource);

  final CoffeeImageRemoteDataSource _remoteDataSource;

  Future<CoffeeImage> getNewRandomImage() async {
    return _remoteDataSource.fetchRandomCoffeeImage();
  }
}