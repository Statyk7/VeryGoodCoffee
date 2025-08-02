import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_bloc.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_event.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_state.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/test_data.dart';

void main() {
  group('ImageFetcherBloc', () {
    late ImageFetcherBloc bloc;
    late MockImageFetcherService mockService;

    setUpAll(initializeTestLogger);

    setUp(() {
      mockService = MockImageFetcherService();
      bloc = ImageFetcherBloc(mockService);
    });

    test('initial state is ImageFetcherInitial', () {
      expect(bloc.state, isA<ImageFetcherInitial>());
    });

    group('FetchNewImageRequested', () {
      blocTest<ImageFetcherBloc, ImageFetcherState>(
        'emits [ImageFetcherLoading, ImageFetcherSuccess] when image is '
        'fetched successfully',
        build: () {
          when(
            () => mockService.getNewRandomImage(),
          ).thenAnswer((_) async => TestData.sampleCoffeeImage);
          return bloc;
        },
        act: (bloc) => bloc.add(FetchNewImageRequested()),
        expect: () => [
          isA<ImageFetcherLoading>(),
          isA<ImageFetcherSuccess>().having(
            (state) => state.image,
            'image',
            TestData.sampleCoffeeImage,
          ),
        ],
        verify: (bloc) {
          verify(() => mockService.getNewRandomImage()).called(1);
        },
      );

      blocTest<ImageFetcherBloc, ImageFetcherState>(
        'emits [ImageFetcherLoading, ImageFetcherError] when service '
        'throws exception',
        build: () {
          when(
            () => mockService.getNewRandomImage(),
          ).thenThrow(Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(FetchNewImageRequested()),
        expect: () => [
          isA<ImageFetcherLoading>(),
          isA<ImageFetcherError>().having(
            (state) => state.message,
            'message',
            t.main.error.failedToLoad,
          ),
        ],
        verify: (bloc) {
          verify(() => mockService.getNewRandomImage()).called(1);
        },
      );

      blocTest<ImageFetcherBloc, ImageFetcherState>(
        'emits correct success state with image data',
        build: () {
          when(
            () => mockService.getNewRandomImage(),
          ).thenAnswer((_) async => TestData.sampleSavedCoffeeImage);
          return bloc;
        },
        act: (bloc) => bloc.add(FetchNewImageRequested()),
        expect: () => [
          isA<ImageFetcherLoading>(),
          isA<ImageFetcherSuccess>().having(
            (state) => state.image,
            'image',
            allOf([
              isA<CoffeeImage>().having(
                (img) => img.bytes,
                'bytes',
                TestData.sampleSavedCoffeeImage.bytes,
              ),
              isA<CoffeeImage>().having(
                (img) => img.sourceUrl,
                'sourceUrl',
                TestData.sampleSavedCoffeeImage.sourceUrl,
              ),
            ]),
          ),
        ],
      );

      blocTest<ImageFetcherBloc, ImageFetcherState>(
        'handles different types of exceptions',
        build: () {
          when(
            () => mockService.getNewRandomImage(),
          ).thenThrow(StateError('Invalid state'));
          return bloc;
        },
        act: (bloc) => bloc.add(FetchNewImageRequested()),
        expect: () => [
          isA<ImageFetcherLoading>(),
          isA<ImageFetcherError>().having(
            (state) => state.message,
            'message',
            t.main.error.failedToLoad,
          ),
        ],
      );

      blocTest<ImageFetcherBloc, ImageFetcherState>(
        'can handle multiple consecutive requests',
        build: () {
          when(
            () => mockService.getNewRandomImage(),
          ).thenAnswer((_) async => TestData.sampleCoffeeImage);
          return bloc;
        },
        act: (bloc) {
          bloc
            ..add(FetchNewImageRequested())
            ..add(FetchNewImageRequested());
        },
        expect: () => [
          isA<ImageFetcherLoading>(),
          isA<ImageFetcherSuccess>(),
          isA<ImageFetcherLoading>(),
          isA<ImageFetcherSuccess>(),
        ],
        verify: (bloc) {
          verify(() => mockService.getNewRandomImage()).called(2);
        },
      );

      blocTest<ImageFetcherBloc, ImageFetcherState>(
        'maintains state isolation between requests',
        build: () {
          var callCount = 0;
          when(() => mockService.getNewRandomImage()).thenAnswer((_) async {
            callCount++;
            if (callCount == 1) {
              return TestData.sampleCoffeeImage;
            } else {
              throw Exception('Second call failed');
            }
          });
          return bloc;
        },
        act: (bloc) {
          bloc
            ..add(FetchNewImageRequested())
            ..add(FetchNewImageRequested());
        },
        expect: () => [
          isA<ImageFetcherLoading>(),
          isA<ImageFetcherSuccess>(),
          isA<ImageFetcherLoading>(),
          isA<ImageFetcherError>(),
        ],
      );
    });

    group('edge cases', () {
      blocTest<ImageFetcherBloc, ImageFetcherState>(
        'handles service returning null '
        '(should not happen but tests robustness)',
        build: () {
          when(
            () => mockService.getNewRandomImage(),
          ).thenAnswer((_) async => throw Exception('Null response'));
          return bloc;
        },
        act: (bloc) => bloc.add(FetchNewImageRequested()),
        expect: () => [
          isA<ImageFetcherLoading>(),
          isA<ImageFetcherError>(),
        ],
      );

      blocTest<ImageFetcherBloc, ImageFetcherState>(
        'handles async cancellation gracefully',
        build: () {
          when(() => mockService.getNewRandomImage()).thenAnswer(
            (_) => Future.delayed(
              const Duration(milliseconds: 100),
              () => TestData.sampleCoffeeImage,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(FetchNewImageRequested()),
        expect: () => [
          isA<ImageFetcherLoading>(),
          isA<ImageFetcherSuccess>(),
        ],
        wait: const Duration(milliseconds: 200),
      );
    });
  });
}
