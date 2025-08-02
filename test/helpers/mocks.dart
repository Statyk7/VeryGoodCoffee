import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:very_good_coffee/features/image_fetcher/data/data_source/coffee_image_remote_data_source.dart';
import 'package:very_good_coffee/features/image_fetcher/domain/services/image_fetcher_service.dart';
import 'package:very_good_coffee/features/image_gallery/data/data_source/image_gallery_local_data_source.dart';
import 'package:very_good_coffee/features/image_gallery/domain/services/image_gallery_service.dart';
import 'package:very_good_coffee/shared/logging/app_logger.dart';

import 'test_data.dart';


// Dio mocks
class MockDio extends Mock implements Dio {}

class MockResponse<T> extends Mock implements Response<T> {}

// Service mocks  
class MockImageFetcherService extends Mock implements ImageFetcherService {}

class MockImageGalleryService extends Mock implements ImageGalleryService {}

// Data source mocks
class MockCoffeeImageRemoteDataSource extends Mock 
    implements CoffeeImageRemoteDataSource {}

class MockImageGalleryLocalDataSource extends Mock 
    implements ImageGalleryLocalDataSource {}

// File system mocks
class MockFile extends Mock implements File {}

class MockDirectory extends Mock implements Directory {}

// Talker mock
class MockTalker extends Mock implements Talker {}

// Helper function to register fallback values for mocktail
void registerFallbackValues() {
  registerFallbackValue(Uint8List(0));
  registerFallbackValue(RequestOptions(path: ''));
  registerFallbackValue(Options());
}

// Helper function to initialize AppLogger for tests
void initializeTestLogger() {
  if (!AppLogger.isInitialized) {
    AppLogger.init();
  }
}

// Helper function to setup path_provider mock for tests
void setupPathProviderMock() {
  const testMockStorage = TestData.testMockStorageDirectory;
  
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    return testMockStorage;
  });
}
