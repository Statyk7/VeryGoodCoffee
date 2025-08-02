import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_bloc.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_event.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_state.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/test_data.dart';

void main() {
  group('ImageGalleryBloc', () {
    late ImageGalleryBloc bloc;
    late MockImageGalleryService mockService;

    setUpAll(initializeTestLogger);

    setUp(() {
      mockService = MockImageGalleryService();
      bloc = ImageGalleryBloc(mockService);

      // Register fallback values
      registerFallbackValue(TestData.sampleCoffeeImage);
    });

    test('initial state is ImageGalleryInitial', () {
      expect(bloc.state, isA<ImageGalleryInitial>());
    });

    group('LoadGalleryImagesRequested', () {
      blocTest<ImageGalleryBloc, ImageGalleryState>(
        'emits [ImageGalleryLoading, ImageGalleryLoaded] when images '
        'are loaded successfully',
        build: () {
          when(
            () => mockService.getAllImages(),
          ).thenAnswer((_) async => TestData.sampleCoffeeImageList);
          return bloc;
        },
        act: (bloc) => bloc.add(LoadGalleryImagesRequested()),
        expect: () => [
          isA<ImageGalleryLoading>(),
          isA<ImageGalleryLoaded>().having(
            (state) => state.images,
            'images',
            TestData.sampleCoffeeImageList,
          ),
        ],
        verify: (bloc) {
          verify(() => mockService.getAllImages()).called(1);
        },
      );

      blocTest<ImageGalleryBloc, ImageGalleryState>(
        'emits [ImageGalleryLoading, ImageGalleryLoaded] '
        'with empty list when no images exist',
        build: () {
          when(
            () => mockService.getAllImages(),
          ).thenAnswer((_) async => <CoffeeImage>[]);
          return bloc;
        },
        act: (bloc) => bloc.add(LoadGalleryImagesRequested()),
        expect: () => [
          isA<ImageGalleryLoading>(),
          isA<ImageGalleryLoaded>().having(
            (state) => state.images,
            'images',
            isEmpty,
          ),
        ],
      );

      blocTest<ImageGalleryBloc, ImageGalleryState>(
        'emits [ImageGalleryLoading, ImageGalleryError] '
        'when service throws exception',
        build: () {
          when(
            () => mockService.getAllImages(),
          ).thenThrow(Exception('File system error'));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadGalleryImagesRequested()),
        expect: () => [
          isA<ImageGalleryLoading>(),
          isA<ImageGalleryError>().having(
            (state) => state.message,
            'message',
            t.gallery.error.failedToLoad,
          ),
        ],
      );
    });

    group('SaveImageRequested', () {
      blocTest<ImageGalleryBloc, ImageGalleryState>(
        'emits [ImageSaving, ImageSaved] when image is saved successfully',
        build: () {
          when(() => mockService.addImage(any())).thenAnswer((_) async {});
          return bloc;
        },
        act: (bloc) => bloc.add(SaveImageRequested(TestData.sampleCoffeeImage)),
        expect: () => [
          isA<ImageSaving>(),
          isA<ImageSaved>(),
        ],
        verify: (bloc) {
          verify(
            () => mockService.addImage(TestData.sampleCoffeeImage),
          ).called(1);
        },
      );

      blocTest<ImageGalleryBloc, ImageGalleryState>(
        'emits [ImageSaving, ImageSaveError] when service throws exception',
        build: () {
          when(
            () => mockService.addImage(any()),
          ).thenThrow(Exception('Storage full'));
          return bloc;
        },
        act: (bloc) => bloc.add(SaveImageRequested(TestData.sampleCoffeeImage)),
        expect: () => [
          isA<ImageSaving>(),
          isA<ImageSaveError>().having(
            (state) => state.message,
            'message',
            t.gallery.error.failedToSave,
          ),
        ],
      );

      blocTest<ImageGalleryBloc, ImageGalleryState>(
        'saves different image formats correctly',
        build: () {
          when(() => mockService.addImage(any())).thenAnswer((_) async {});
          return bloc;
        },
        act: (bloc) {
          for (final image in TestData.sampleCoffeeImageList) {
            bloc.add(SaveImageRequested(image));
          }
        },
        expect: () => [
          // First image
          isA<ImageSaving>(),
          isA<ImageSaved>(),
          // Second image
          isA<ImageSaving>(),
          isA<ImageSaved>(),
          // Third image
          isA<ImageSaving>(),
          isA<ImageSaved>(),
        ],
        verify: (bloc) {
          for (final image in TestData.sampleCoffeeImageList) {
            verify(() => mockService.addImage(image)).called(1);
          }
        },
      );
    });

    group('RemoveImageRequested', () {
      blocTest<ImageGalleryBloc, ImageGalleryState>(
        'removes image and reloads gallery when successful',
        build: () {
          when(() => mockService.removeImage(any())).thenAnswer((_) async {});
          when(
            () => mockService.getAllImages(),
          ).thenAnswer((_) async => TestData.sampleCoffeeImageList);
          return bloc;
        },
        act: (bloc) => bloc.add(RemoveImageRequested('test-image-123')),
        expect: () => [
          isA<ImageGalleryLoading>(),
          isA<ImageGalleryLoaded>().having(
            (state) => state.images,
            'images',
            TestData.sampleCoffeeImageList,
          ),
        ],
        verify: (bloc) {
          verify(() => mockService.removeImage('test-image-123')).called(1);
          verify(() => mockService.getAllImages()).called(1);
        },
      );

      blocTest<ImageGalleryBloc, ImageGalleryState>(
        'emits ImageGalleryError when removal fails',
        build: () {
          when(
            () => mockService.removeImage(any()),
          ).thenThrow(Exception('File not found'));
          return bloc;
        },
        act: (bloc) => bloc.add(RemoveImageRequested('non-existent-id')),
        expect: () => [
          isA<ImageGalleryError>().having(
            (state) => state.message,
            'message',
            t.gallery.error.failedToDelete,
          ),
        ],
        verify: (bloc) {
          verify(() => mockService.removeImage('non-existent-id')).called(1);
          verifyNever(() => mockService.getAllImages());
        },
      );

      blocTest<ImageGalleryBloc, ImageGalleryState>(
        'handles reload failure after successful removal',
        build: () {
          when(() => mockService.removeImage(any())).thenAnswer((_) async {});
          when(
            () => mockService.getAllImages(),
          ).thenThrow(Exception('Failed to reload'));
          return bloc;
        },
        act: (bloc) => bloc.add(RemoveImageRequested('test-image-123')),
        expect: () => [
          isA<ImageGalleryLoading>(),
          isA<ImageGalleryError>().having(
            (state) => state.message,
            'message',
            t.gallery.error.failedToLoad,
          ),
        ],
        verify: (bloc) {
          verify(() => mockService.removeImage('test-image-123')).called(1);
          verify(() => mockService.getAllImages()).called(1);
        },
      );
    });

    group('complex state transitions', () {
      blocTest<ImageGalleryBloc, ImageGalleryState>(
        'handles save then load sequence',
        build: () {
          when(() => mockService.addImage(any())).thenAnswer((_) async {});
          when(
            () => mockService.getAllImages(),
          ).thenAnswer((_) async => TestData.sampleCoffeeImageList);
          return bloc;
        },
        act: (bloc) {
          bloc
            ..add(SaveImageRequested(TestData.sampleCoffeeImage))
            ..add(LoadGalleryImagesRequested());
        },
        expect: () => [
          isA<ImageSaving>(),
          isA<ImageGalleryLoading>(),
          isA<ImageSaved>(),
          isA<ImageGalleryLoaded>(),
        ],
      );

      blocTest<ImageGalleryBloc, ImageGalleryState>(
        'handles save then remove sequence',
        build: () {
          when(() => mockService.addImage(any())).thenAnswer((_) async {});
          when(() => mockService.removeImage(any())).thenAnswer((_) async {});
          when(
            () => mockService.getAllImages(),
          ).thenAnswer((_) async => <CoffeeImage>[]);
          return bloc;
        },
        act: (bloc) {
          bloc
            ..add(SaveImageRequested(TestData.sampleCoffeeImage))
            ..add(RemoveImageRequested('test-image-123'));
        },
        expect: () => [
          isA<ImageSaving>(),
          isA<ImageSaved>(),
          isA<ImageGalleryLoading>(),
          isA<ImageGalleryLoaded>().having(
            (state) => state.images,
            'images',
            isEmpty,
          ),
        ],
      );
    });

    group('edge cases', () {
      blocTest<ImageGalleryBloc, ImageGalleryState>(
        'handles concurrent save operations',
        build: () {
          when(() => mockService.addImage(any())).thenAnswer((_) async {});
          return bloc;
        },
        act: (bloc) {
          bloc
            ..add(SaveImageRequested(TestData.sampleCoffeeImageList[0]))
            ..add(SaveImageRequested(TestData.sampleCoffeeImageList[1]));
        },
        expect: () => [
          isA<ImageSaving>(),
          isA<ImageSaved>(),
          isA<ImageSaving>(),
          isA<ImageSaved>(),
        ],
      );

      blocTest<ImageGalleryBloc, ImageGalleryState>(
        'handles empty image ID removal',
        build: () {
          when(() => mockService.removeImage(any())).thenAnswer((_) async {});
          when(
            () => mockService.getAllImages(),
          ).thenAnswer((_) async => TestData.sampleCoffeeImageList);
          return bloc;
        },
        act: (bloc) => bloc.add(RemoveImageRequested('')),
        expect: () => [
          isA<ImageGalleryLoading>(),
          isA<ImageGalleryLoaded>(),
        ],
        verify: (bloc) {
          verify(() => mockService.removeImage('')).called(1);
        },
      );
    });
  });
}
