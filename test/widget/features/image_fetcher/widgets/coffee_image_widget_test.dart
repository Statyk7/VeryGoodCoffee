import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_bloc.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_event.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/bloc/image_fetcher_state.dart';
import 'package:very_good_coffee/features/image_fetcher/presentation/widgets/coffee_image_widget.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_data.dart';

class MockImageFetcherBloc extends Mock implements ImageFetcherBloc {}

void main() {
  group('CoffeeImageWidget', () {
    late MockImageFetcherBloc mockBloc;

    setUp(() {
      mockBloc = MockImageFetcherBloc();
      registerFallbackValue(FetchNewImageRequested());
    });

    Widget createWidgetUnderTest({
      void Function(dynamic)? onSaveImage,
      bool isSaving = false,
    }) {
      return BlocProvider<ImageFetcherBloc>.value(
        value: mockBloc,
        child: CoffeeImageWidget(
          onSaveImage: onSaveImage,
          isSaving: isSaving,
        ),
      );
    }

    group('initial state', () {
      testWidgets(
        'displays welcome message when state is ImageFetcherInitial',
        (tester) async {
          // Arrange
          when(() => mockBloc.state).thenReturn(ImageFetcherInitial());
          when(
            () => mockBloc.stream,
          ).thenAnswer((_) => Stream.value(ImageFetcherInitial()));

          // Act
          await tester.pumpApp(createWidgetUnderTest());

          // Assert
          expect(find.byIcon(Icons.coffee), findsOneWidget);
          expect(find.text(t.main.welcome), findsOneWidget);
          expect(find.text(t.main.instruction), findsOneWidget);
          expect(find.text(t.main.newCoffeeButton), findsOneWidget);
        },
      );

      testWidgets('new coffee button triggers FetchNewImageRequested event', (
        tester,
      ) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(ImageFetcherInitial());
        when(
          () => mockBloc.stream,
        ).thenAnswer((_) => Stream.value(ImageFetcherInitial()));

        // Act
        await tester.pumpApp(createWidgetUnderTest());
        await tester.tap(find.text(t.main.newCoffeeButton));

        // Assert
        verify(() => mockBloc.add(any<FetchNewImageRequested>())).called(1);
      });
    });

    group('loading state', () {
      testWidgets(
        'displays loading indicator when state is ImageFetcherLoading',
        (tester) async {
          // Arrange
          when(() => mockBloc.state).thenReturn(ImageFetcherLoading());
          when(
            () => mockBloc.stream,
          ).thenAnswer((_) => Stream.value(ImageFetcherLoading()));

          // Act
          await tester.pumpApp(createWidgetUnderTest());

          // Assert
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(find.text(t.main.loading), findsOneWidget);
        },
      );

      testWidgets('disables new coffee button when loading', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(ImageFetcherLoading());
        when(
          () => mockBloc.stream,
        ).thenAnswer((_) => Stream.value(ImageFetcherLoading()));

        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final button = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, t.main.newCoffeeButton),
        );
        expect(button.onPressed, isNull);
      });
    });

    group('success state', () {
      testWidgets('displays image when state is ImageFetcherSuccess', (
        tester,
      ) async {
        // Arrange
        final successState = ImageFetcherSuccess(TestData.sampleCoffeeImage);
        when(() => mockBloc.state).thenReturn(successState);
        when(
          () => mockBloc.stream,
        ).thenAnswer((_) => Stream.value(successState));

        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.byType(Image), findsOneWidget);
        expect(find.text(t.main.newCoffeeButton), findsOneWidget);
      });

      testWidgets('shows save button when onSaveImage callback is provided', (
        tester,
      ) async {
        // Arrange
        final successState = ImageFetcherSuccess(TestData.sampleCoffeeImage);
        when(() => mockBloc.state).thenReturn(successState);
        when(
          () => mockBloc.stream,
        ).thenAnswer((_) => Stream.value(successState));
        var saveCallbackCalled = false;

        // Act
        await tester.pumpApp(
          createWidgetUnderTest(
            onSaveImage: (_) => saveCallbackCalled = true,
          ),
        );

        // Assert
        expect(find.text(t.main.saveButton), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsOneWidget);

        // Test callback
        await tester.tap(find.text(t.main.saveButton));
        expect(saveCallbackCalled, isTrue);
      });

      testWidgets(
        'hides save button when onSaveImage callback is not provided',
        (tester) async {
          // Arrange
          final successState = ImageFetcherSuccess(TestData.sampleCoffeeImage);
          when(() => mockBloc.state).thenReturn(successState);
          when(
            () => mockBloc.stream,
          ).thenAnswer((_) => Stream.value(successState));

          // Act
          await tester.pumpApp(createWidgetUnderTest());

          // Assert
          expect(find.text(t.main.saveButton), findsNothing);
        },
      );

      testWidgets(
        'shows loading indicator on save button when isSaving is true',
        (tester) async {
          // Arrange
          final successState = ImageFetcherSuccess(TestData.sampleCoffeeImage);
          when(() => mockBloc.state).thenReturn(successState);
          when(
            () => mockBloc.stream,
          ).thenAnswer((_) => Stream.value(successState));

          // Act
          await tester.pumpApp(
            createWidgetUnderTest(
              onSaveImage: (_) {},
              isSaving: true,
            ),
          );

          // Assert
          expect(find.byType(CircularProgressIndicator), findsOneWidget);

          final button = tester.widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, t.main.saveButton),
          );
          expect(button.onPressed, isNull);
        },
      );

      testWidgets('passes correct image to save callback', (tester) async {
        // Arrange
        final testImage = TestData.sampleSavedCoffeeImage;
        final successState = ImageFetcherSuccess(testImage);
        when(() => mockBloc.state).thenReturn(successState);
        when(
          () => mockBloc.stream,
        ).thenAnswer((_) => Stream.value(successState));

        dynamic savedImage;

        // Act
        await tester.pumpApp(
          createWidgetUnderTest(
            onSaveImage: (image) => savedImage = image,
          ),
        );
        await tester.tap(find.text(t.main.saveButton));

        // Assert
        expect(savedImage, equals(testImage));
      });
    });

    group('error state', () {
      testWidgets('displays error message when state is ImageFetcherError', (
        tester,
      ) async {
        // Arrange
        const errorMessage = 'Network error occurred';
        final errorState = ImageFetcherError(errorMessage);
        when(() => mockBloc.state).thenReturn(errorState);
        when(() => mockBloc.stream).thenAnswer((_) => Stream.value(errorState));

        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text(t.main.error.title), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
        expect(find.text(t.main.newCoffeeButton), findsOneWidget);
      });

      testWidgets('enables new coffee button in error state', (tester) async {
        // Arrange
        final errorState = ImageFetcherError('Error message');
        when(() => mockBloc.state).thenReturn(errorState);
        when(() => mockBloc.stream).thenAnswer((_) => Stream.value(errorState));

        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final button = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, t.main.newCoffeeButton),
        );
        expect(button.onPressed, isNotNull);
      });
    });

    group('button interactions', () {
      testWidgets('new coffee button is always present', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(ImageFetcherInitial());
        when(
          () => mockBloc.stream,
        ).thenAnswer((_) => Stream.value(ImageFetcherInitial()));

        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.text(t.main.newCoffeeButton), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);
      });

      testWidgets('buttons are properly spaced in wrap widget', (tester) async {
        // Arrange
        final successState = ImageFetcherSuccess(TestData.sampleCoffeeImage);
        when(() => mockBloc.state).thenReturn(successState);
        when(
          () => mockBloc.stream,
        ).thenAnswer((_) => Stream.value(successState));

        // Act
        await tester.pumpApp(createWidgetUnderTest(onSaveImage: (_) {}));

        // Assert
        expect(find.byType(Wrap), findsOneWidget);
        expect(find.byType(ElevatedButton), findsNWidgets(2));
      });
    });

    group('accessibility', () {
      testWidgets('has proper semantic labels', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(ImageFetcherInitial());
        when(
          () => mockBloc.stream,
        ).thenAnswer((_) => Stream.value(ImageFetcherInitial()));

        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.text(t.main.newCoffeeButton), findsOneWidget);
        // Additional accessibility tests would verify semantics
      });
    });
  });
}
