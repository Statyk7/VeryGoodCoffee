import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:very_good_coffee/app/di/service_locator.dart';
import 'package:very_good_coffee/features/image_fetcher/data/data_source/coffee_image_remote_data_source.dart';
import 'package:very_good_coffee/features/image_fetcher/data/services/image_fetcher_service_impl.dart';
import 'package:very_good_coffee/features/image_fetcher/domain/services/image_fetcher_service.dart';
import 'package:very_good_coffee/features/image_gallery/data/data_source/image_gallery_local_data_source.dart';
import 'package:very_good_coffee/features/image_gallery/data/services/image_gallery_service_impl.dart';
import 'package:very_good_coffee/features/image_gallery/domain/services/image_gallery_service.dart';

import '../../../helpers/mocks.dart';

void main() {
  group('ServiceLocator', () {
    setUp(() {
      // Initialize Flutter binding and logger for tests
      TestWidgetsFlutterBinding.ensureInitialized();
      initializeTestLogger();
    });

    tearDown(sl.reset);

    test('should setup all dependencies correctly', () async {
      // Act
      await setupServiceLocator();

      // Assert - Verify all dependencies are registered
      expect(sl.isRegistered<Dio>(), isTrue);
      expect(sl.isRegistered<CoffeeImageRemoteDataSource>(), isTrue);
      expect(sl.isRegistered<ImageGalleryLocalDataSource>(), isTrue);
      expect(sl.isRegistered<ImageFetcherService>(), isTrue);
      expect(sl.isRegistered<ImageGalleryService>(), isTrue);
    });

    test('should register Dio with correct configuration', () async {
      // Act
      await setupServiceLocator();

      // Assert
      final dio = sl<Dio>();
      expect(dio, isA<Dio>());
      expect(dio.interceptors, isNotEmpty);

      // Verify TalkerDioLogger is added as interceptor
      final talkerInterceptor = dio.interceptors
          .whereType<TalkerDioLogger>()
          .firstOrNull;
      expect(talkerInterceptor, isNotNull);
    });

    test(
      'should register CoffeeImageRemoteDataSource with Dio dependency',
      () async {
        // Act
        await setupServiceLocator();

        // Assert
        final dataSource = sl<CoffeeImageRemoteDataSource>();
        expect(dataSource, isA<CoffeeImageRemoteDataSource>());
      },
    );

    test('should register ImageGalleryLocalDataSource', () async {
      // Act
      await setupServiceLocator();

      // Assert
      final dataSource = sl<ImageGalleryLocalDataSource>();
      expect(dataSource, isA<ImageGalleryLocalDataSource>());
    });

    test(
      'should register ImageFetcherService with correct implementation',
      () async {
        // Act
        await setupServiceLocator();

        // Assert
        final service = sl<ImageFetcherService>();
        expect(service, isA<ImageFetcherServiceImpl>());
      },
    );

    test(
      'should register ImageGalleryService with correct implementation',
      () async {
        // Act
        await setupServiceLocator();

        // Assert
        final service = sl<ImageGalleryService>();
        expect(service, isA<ImageGalleryServiceImpl>());
      },
    );

    test('should register dependencies as lazy singletons', () async {
      // Act
      await setupServiceLocator();

      // Assert - Same instance should be returned on multiple calls
      final dio1 = sl<Dio>();
      final dio2 = sl<Dio>();
      expect(identical(dio1, dio2), isTrue);

      final dataSource1 = sl<CoffeeImageRemoteDataSource>();
      final dataSource2 = sl<CoffeeImageRemoteDataSource>();
      expect(identical(dataSource1, dataSource2), isTrue);

      final service1 = sl<ImageFetcherService>();
      final service2 = sl<ImageFetcherService>();
      expect(identical(service1, service2), isTrue);
    });

    test('should properly resolve dependency chain', () async {
      // Act
      await setupServiceLocator();

      // Assert - Verify the entire dependency chain works
      final imageFetcherService = sl<ImageFetcherService>();
      final imageGalleryService = sl<ImageGalleryService>();

      expect(imageFetcherService, isNotNull);
      expect(imageGalleryService, isNotNull);

      // Services should be usable (this tests the dependency injection works)
      expect(imageFetcherService.toString, returnsNormally);
      expect(imageGalleryService.toString, returnsNormally);
    });
  });
}
