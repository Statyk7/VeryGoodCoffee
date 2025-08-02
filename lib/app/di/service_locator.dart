import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:very_good_coffee/features/image_fetcher/data_source/coffee_image_remote_data_source.dart';
import 'package:very_good_coffee/features/image_fetcher/service/image_fetcher_service.dart';
import 'package:very_good_coffee/features/image_gallery/data_source/image_gallery_local_data_source.dart';
import 'package:very_good_coffee/features/image_gallery/service/image_gallery_service.dart';
import 'package:very_good_coffee/shared/logging/app_logger.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External dependencies
  sl..registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.interceptors.add(
      TalkerDioLogger(
        talker: AppLogger.instance,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: false,
          printResponseMessage: false,
        ),
      ),
    );
    return dio;
  })

  // Data sources
  ..registerLazySingleton<CoffeeImageRemoteDataSource>(
    () => CoffeeImageRemoteDataSource(sl<Dio>()),
  )
  
  ..registerLazySingleton<ImageGalleryLocalDataSource>(
    ImageGalleryLocalDataSource.new,
  )

  // Services
  ..registerLazySingleton<ImageFetcherService>(
    () => ImageFetcherService(sl<CoffeeImageRemoteDataSource>()),
  )
  
  ..registerLazySingleton<ImageGalleryService>(
    () => ImageGalleryService(sl<ImageGalleryLocalDataSource>()),
  );
}