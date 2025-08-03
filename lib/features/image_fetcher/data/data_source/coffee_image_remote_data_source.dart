import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';
import 'package:very_good_coffee/shared/logging/app_logger.dart';

class CoffeeImageRemoteDataSource {
  CoffeeImageRemoteDataSource(this._dio, this._baseUrl);

  final Dio _dio;
  final String _baseUrl;

  Future<CoffeeImage> fetchRandomCoffeeImage() async {
    try {
      AppLogger.info('Fetching random coffee image from API');

      // First, get the JSON response with the image URL
      final jsonResponse = await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/random.json',
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      if (jsonResponse.data == null || jsonResponse.data!['file'] == null) {
        throw Exception('Failed to fetch coffee image: No file URL received');
      }

      final imageUrl = jsonResponse.data!['file'] as String;
      AppLogger.info('Got image URL from JSON API: $imageUrl');

      // Then download the actual image bytes
      final imageResponse = await _dio.get<List<int>>(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (imageResponse.data == null) {
        throw Exception('Failed to download coffee image: No data received');
      }

      final bytes = Uint8List.fromList(imageResponse.data!);

      AppLogger.info('Successfully downloaded coffee image from: $imageUrl');

      return CoffeeImage(
        bytes: bytes,
        sourceUrl: imageUrl,
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
