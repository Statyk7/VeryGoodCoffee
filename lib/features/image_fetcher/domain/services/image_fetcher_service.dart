import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';


abstract class ImageFetcherService {

  Future<CoffeeImage> getNewRandomImage();
}
