import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:very_good_coffee/features/image_fetcher/data/data_source/coffee_image_remote_data_source.dart';
import 'package:very_good_coffee/features/image_fetcher/data/services/image_fetcher_service_impl.dart';
import 'package:very_good_coffee/features/image_fetcher/domain/services/image_fetcher_service.dart';
import 'package:very_good_coffee/features/image_gallery/data/data_source/image_gallery_local_data_source.dart';
import 'package:very_good_coffee/features/image_gallery/data/services/image_gallery_service_impl.dart';
import 'package:very_good_coffee/features/image_gallery/domain/services/image_gallery_service.dart';
import 'package:very_good_coffee/shared/logging/app_logger.dart';

/// Alias for the Service Locator
final GetIt sl = GetIt.instance;

/// Setup Service Locator (DI), call once
Future<void> setupServiceLocator() async {
  // External dependencies
  sl
    ..registerLazySingleton<Dio>(() {
      final dio = Dio();
      dio.interceptors.add(
        TalkerDioLogger(
          talker: AppLogger.instance,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseMessage: false,
            printResponseData: false,
          ),
        ),
      );
      return dio;
    })
    // Data Sources
    // TODO(Remy): Use AppConstants.coffeeApiUrl in the constructor
    ..registerLazySingleton<CoffeeImageRemoteDataSource>(
      () => CoffeeImageRemoteDataSource(sl<Dio>()),
    )
    ..registerLazySingleton<ImageGalleryLocalDataSource>(
      ImageGalleryLocalDataSource.new,
    )
    // Services
    ..registerLazySingleton<ImageFetcherService>(
      () => ImageFetcherServiceImpl(sl<CoffeeImageRemoteDataSource>()),
    )
    ..registerLazySingleton<ImageGalleryService>(
      () => ImageGalleryServiceImpl(sl<ImageGalleryLocalDataSource>()),
    );
}
