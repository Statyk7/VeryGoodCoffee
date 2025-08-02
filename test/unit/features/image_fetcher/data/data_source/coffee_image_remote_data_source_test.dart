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
    late MockResponse<List<int>> mockResponse;

    setUpAll(initializeTestLogger);

    setUp(() {
      mockDio = MockDio();
      mockResponse = MockResponse<List<int>>();
      dataSource = CoffeeImageRemoteDataSource(mockDio);

      // Register fallback values
      registerFallbackValue(RequestOptions());
      registerFallbackValue(Options());
    });

    group('fetchRandomCoffeeImage', () {
      test('should return CoffeeImage when API call is successful', () async {
        // Arrange
        final expectedBytes = TestData.sampleImageBytes;
        const expectedUrl = '${AppConstants.coffeeApiUrl}/random';
        final realUri = Uri.parse(TestData.sampleImageUrl);

        when(() => mockResponse.data).thenReturn(expectedBytes);
        when(() => mockResponse.realUri).thenReturn(realUri);

        when(
          () => mockDio.get<List<int>>(
            expectedUrl,
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await dataSource.fetchRandomCoffeeImage();

        // Assert
        expect(result, isA<CoffeeImage>());
        expect(result.bytes, equals(Uint8List.fromList(expectedBytes)));
        expect(result.sourceUrl, equals(realUri.toString()));
        expect(result.id, isNull);
        expect(result.savedAt, isNull);

        verify(
          () => mockDio.get<List<int>>(
            expectedUrl,
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

      test('should throw Exception when response data is null', () async {
        // Arrange
        when(() => mockResponse.data).thenReturn(null);
        when(
          () => mockDio.get<List<int>>(
            any(),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => dataSource.fetchRandomCoffeeImage(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to fetch coffee image: No data received'),
            ),
          ),
        );
      });

      test(
        'should throw Exception with network error message on DioException',
        () async {
          // Arrange
          final dioException = DioException(
            requestOptions: RequestOptions(),
            message: 'Connection timeout',
            type: DioExceptionType.connectionTimeout,
          );

          when(
            () => mockDio.get<List<int>>(
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
        'should throw Exception with generic error on other exceptions',
        () async {
          // Arrange
          const errorMessage = 'Some unexpected error';
          when(
            () => mockDio.get<List<int>>(
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

      test('should use correct API endpoint', () async {
        // Arrange
        const expectedUrl = '${AppConstants.coffeeApiUrl}/random';
        when(() => mockResponse.data).thenReturn(TestData.sampleImageBytes);
        when(
          () => mockResponse.realUri,
        ).thenReturn(Uri.parse(TestData.sampleImageUrl));

        when(
          () => mockDio.get<List<int>>(
            any(),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await dataSource.fetchRandomCoffeeImage();

        // Assert
        verify(
          () => mockDio.get<List<int>>(
            expectedUrl,
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('should use ResponseType.bytes in options', () async {
        // Arrange
        when(() => mockResponse.data).thenReturn(TestData.sampleImageBytes);
        when(
          () => mockResponse.realUri,
        ).thenReturn(Uri.parse(TestData.sampleImageUrl));

        when(
          () => mockDio.get<List<int>>(
            any(),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await dataSource.fetchRandomCoffeeImage();

        // Assert
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
