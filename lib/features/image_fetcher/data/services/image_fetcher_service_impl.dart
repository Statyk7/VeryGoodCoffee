import 'package:very_good_coffee/features/image_fetcher/data/data_source/coffee_image_remote_data_source.dart';
import 'package:very_good_coffee/features/image_fetcher/domain/services/image_fetcher_service.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

class ImageFetcherServiceImpl implements ImageFetcherService {
  ImageFetcherServiceImpl(this._remoteDataSource);

  final CoffeeImageRemoteDataSource _remoteDataSource;

  @override
  Future<CoffeeImage> getNewRandomImage() async {
    return _remoteDataSource.fetchRandomCoffeeImage();
  }
}
