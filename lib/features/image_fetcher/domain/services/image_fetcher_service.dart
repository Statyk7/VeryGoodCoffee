import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

// Following Clean Architecture guidelines, service are abstract.
// ignore: one_member_abstracts
abstract class ImageFetcherService {

  Future<CoffeeImage> getNewRandomImage();
}
