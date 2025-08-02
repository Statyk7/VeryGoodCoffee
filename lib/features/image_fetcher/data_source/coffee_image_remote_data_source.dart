import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:very_good_coffee/app/config/constants.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';
import 'package:very_good_coffee/shared/logging/app_logger.dart';

class CoffeeImageRemoteDataSource {
  CoffeeImageRemoteDataSource(this._dio);

  final Dio _dio;

  Future<CoffeeImage> fetchRandomCoffeeImage() async {
    try {
      AppLogger.info('Fetching random coffee image from API');
      
      final response = await _dio.get<List<int>>(
        '${AppConstants.coffeeApiUrl}/random',
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.data == null) {
        throw Exception('Failed to fetch coffee image: No data received');
      }

      final bytes = Uint8List.fromList(response.data!);
      final sourceUrl = response.realUri.toString();
      
      AppLogger.info('Successfully fetched coffee image from: $sourceUrl');
      
      return CoffeeImage(
        bytes: bytes,
        sourceUrl: sourceUrl,
      );
    } on DioException catch (e) {
      AppLogger.error('Network error fetching coffee image', e);
      throw Exception('Network error: ${e.message}');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error fetching coffee image', e, stackTrace);
      throw Exception('Failed to fetch coffee image: $e');
    }
  }
}