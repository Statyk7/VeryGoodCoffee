import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/app/config/constants.dart';
import 'package:very_good_coffee/features/image_fetcher/data/data_source/coffee_image_remote_data_source.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/test_data.dart';

void main() {
  group('CoffeeImageRemoteDataSource', () {
    late CoffeeImageRemoteDataSource dataSource;
    late MockDio mockDio;
    late MockResponse<Map<String, dynamic>> mockJsonResponse;
    late MockResponse<List<int>> mockImageResponse;

    setUpAll(initializeTestLogger);

    setUp(() {
      mockDio = MockDio();
      mockJsonResponse = MockResponse<Map<String, dynamic>>();
      mockImageResponse = MockResponse<List<int>>();
      dataSource = CoffeeImageRemoteDataSource(
        mockDio,
        AppConstants.coffeeApiUrl,
      );

      // Register fallback values
      registerFallbackValue(RequestOptions());
      registerFallbackValue(Options());
    });

    group('fetchRandomCoffeeImage', () {
      test('should return CoffeeImage when API calls are successful', () async {
        // Arrange
        final expectedBytes = TestData.sampleImageBytes;
        const expectedJsonUrl = '${AppConstants.coffeeApiUrl}/random.json';
        const expectedImageUrl = TestData.sampleImageUrl;
        final jsonData = {'file': expectedImageUrl};

        when(() => mockJsonResponse.data).thenReturn(jsonData);
        when(() => mockImageResponse.data).thenReturn(expectedBytes);

        when(
          () => mockDio.get<Map<String, dynamic>>(
            expectedJsonUrl,
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockJsonResponse);

        when(
          () => mockDio.get<List<int>>(
            expectedImageUrl,
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockImageResponse);

        // Act
        final result = await dataSource.fetchRandomCoffeeImage();

        // Assert
        expect(result, isA<CoffeeImage>());
        expect(result.bytes, equals(Uint8List.fromList(expectedBytes)));
        expect(result.sourceUrl, equals(expectedImageUrl));
        expect(result.id, isNull);
        expect(result.savedAt, isNull);

        verify(
          () => mockDio.get<Map<String, dynamic>>(
            expectedJsonUrl,
            options: any(
              named: 'options',
              that: isA<Options>().having(
                (o) => o.responseType,
                'responseType',
                ResponseType.json,
              ),
            ),
          ),
        ).called(1);

        verify(
          () => mockDio.get<List<int>>(
            expectedImageUrl,
            options: any(
              named: 'options',
              that: isA<Options>().having(
                (o) => o.responseType,
                'responseType',
                ResponseType.bytes,
              ),
            ),
          ),
        ).called(1);
      });

      test('should throw Exception when JSON response data is null', () async {
        // Arrange
        when(() => mockJsonResponse.data).thenReturn(null);
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockJsonResponse);

        // Act & Assert
        expect(
          () => dataSource.fetchRandomCoffeeImage(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to fetch coffee image: No file URL received'),
            ),
          ),
        );
      });

      test(
        'should throw Exception when file key is missing from JSON',
        () async {
          // Arrange
          when(() => mockJsonResponse.data).thenReturn(<String, dynamic>{});
          when(
            () => mockDio.get<Map<String, dynamic>>(
              any(),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => mockJsonResponse);

          // Act & Assert
          expect(
            () => dataSource.fetchRandomCoffeeImage(),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Failed to fetch coffee image: No file URL received'),
              ),
            ),
          );
        },
      );

      test('should throw Exception when image response data is null', () async {
        // Arrange
        const expectedImageUrl = TestData.sampleImageUrl;
        final jsonData = {'file': expectedImageUrl};

        when(() => mockJsonResponse.data).thenReturn(jsonData);
        when(() => mockImageResponse.data).thenReturn(null);

        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockJsonResponse);

        when(
          () => mockDio.get<List<int>>(
            expectedImageUrl,
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockImageResponse);

        // Act & Assert
        expect(
          () => dataSource.fetchRandomCoffeeImage(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to download coffee image: No data received'),
            ),
          ),
        );
      });

      test(
        'should throw Exception on DioException during JSON fetch',
        () async {
          // Arrange
          final dioException = DioException(
            requestOptions: RequestOptions(),
            message: 'Connection timeout',
            type: DioExceptionType.connectionTimeout,
          );

          when(
            () => mockDio.get<Map<String, dynamic>>(
              any(),
              options: any(named: 'options'),
            ),
          ).thenThrow(dioException);

          // Act & Assert
          expect(
            () => dataSource.fetchRandomCoffeeImage(),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Network error: Connection timeout'),
              ),
            ),
          );
        },
      );

      test(
        'should throw Exception on DioException during image download',
        () async {
          // Arrange
          const expectedImageUrl = TestData.sampleImageUrl;
          final jsonData = {'file': expectedImageUrl};
          final dioException = DioException(
            requestOptions: RequestOptions(),
            message: 'Connection timeout',
            type: DioExceptionType.connectionTimeout,
          );

          when(() => mockJsonResponse.data).thenReturn(jsonData);
          when(
            () => mockDio.get<Map<String, dynamic>>(
              any(),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => mockJsonResponse);

          when(
            () => mockDio.get<List<int>>(
              expectedImageUrl,
              options: any(named: 'options'),
            ),
          ).thenThrow(dioException);

          // Act & Assert
          expect(
            () => dataSource.fetchRandomCoffeeImage(),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Network error: Connection timeout'),
              ),
            ),
          );
        },
      );

      test(
        'should throw Exception with generic error on other exceptions',
        () async {
          // Arrange
          const errorMessage = 'Some unexpected error';
          when(
            () => mockDio.get<Map<String, dynamic>>(
              any(),
              options: any(named: 'options'),
            ),
          ).thenThrow(Exception(errorMessage));

          // Act & Assert
          expect(
            () => dataSource.fetchRandomCoffeeImage(),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains(
                  'Failed to fetch coffee image: Exception: $errorMessage',
                ),
              ),
            ),
          );
        },
      );

      test('should use correct API endpoints', () async {
        // Arrange
        const expectedJsonUrl = '${AppConstants.coffeeApiUrl}/random.json';
        const expectedImageUrl = TestData.sampleImageUrl;
        final jsonData = {'file': expectedImageUrl};

        when(() => mockJsonResponse.data).thenReturn(jsonData);
        when(
          () => mockImageResponse.data,
        ).thenReturn(TestData.sampleImageBytes);

        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockJsonResponse);

        when(
          () => mockDio.get<List<int>>(
            any(),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockImageResponse);

        // Act
        await dataSource.fetchRandomCoffeeImage();

        // Assert
        verify(
          () => mockDio.get<Map<String, dynamic>>(
            expectedJsonUrl,
            options: any(named: 'options'),
          ),
        ).called(1);

        verify(
          () => mockDio.get<List<int>>(
            expectedImageUrl,
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('should use correct ResponseType for each call', () async {
        // Arrange
        const expectedImageUrl = TestData.sampleImageUrl;
        final jsonData = {'file': expectedImageUrl};

        when(() => mockJsonResponse.data).thenReturn(jsonData);
        when(
          () => mockImageResponse.data,
        ).thenReturn(TestData.sampleImageBytes);

        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockJsonResponse);

        when(
          () => mockDio.get<List<int>>(
            any(),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockImageResponse);

        // Act
        await dataSource.fetchRandomCoffeeImage();

        // Assert
        verify(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            options: any(
              named: 'options',
              that: isA<Options>().having(
                (o) => o.responseType,
                'responseType',
                ResponseType.json,
              ),
            ),
          ),
        ).called(1);

        verify(
          () => mockDio.get<List<int>>(
            any(),
            options: any(
              named: 'options',
              that: isA<Options>().having(
                (o) => o.responseType,
                'responseType',
                ResponseType.bytes,
              ),
            ),
          ),
        ).called(1);
      });
    });
  });
}
