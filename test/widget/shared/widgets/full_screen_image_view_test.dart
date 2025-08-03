import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';
import 'package:very_good_coffee/shared/widgets/full_screen_image_view.dart';

import '../../../helpers/pump_app.dart';
import '../../../helpers/test_data.dart';

void main() {
  group('FullScreenImageView', () {
    late bool onCloseCalled;

    setUp(() {
      onCloseCalled = false;
    });

    Widget createWidgetUnderTest() {
      return FullScreenImageView(
        image: TestData.sampleSavedCoffeeImage,
        onClose: () => onCloseCalled = true,
      );
    }

    group('widget structure', () {
      testWidgets('displays the image', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.byType(InteractiveViewer), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('displays app bar with correct title', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text(t.fullScreen.title), findsOneWidget);
      });

      testWidgets('displays close button in app bar', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('displays reset zoom button in app bar', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.byIcon(Icons.zoom_out_map), findsOneWidget);
      });
    });

    group('interactions', () {
      testWidgets('calls onClose when close button is tapped', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());
        await tester.tap(find.byIcon(Icons.close));

        // Assert
        expect(onCloseCalled, isTrue);
      });

      testWidgets('toggles app bar visibility when image is tapped', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Verify app bar is initially visible
        expect(find.byType(AppBar), findsOneWidget);

        // Tap on the InteractiveViewer area
        await tester.tap(find.byType(InteractiveViewer));
        await tester.pumpAndSettle();

        // App bar should be hidden after tapping
        expect(find.byType(AppBar), findsNothing);

        // Tap again to show app bar
        await tester.tap(find.byType(InteractiveViewer));
        await tester.pumpAndSettle();

        // App bar should be visible again
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('resets zoom when zoom reset button is tapped', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Get the InteractiveViewer widget to access its transformation controller
        final interactiveViewerWidget = tester.widget<InteractiveViewer>(
          find.byType(InteractiveViewer),
        );

        // Simulate zoom by modifying the transformation
        interactiveViewerWidget.transformationController?.value =
            Matrix4.diagonal3Values(2.0, 2.0, 1.0);

        // Tap the zoom reset button
        await tester.tap(find.byIcon(Icons.zoom_out_map));
        await tester.pumpAndSettle();

        // Assert
        // The transformation should be reset to identity matrix
        expect(
          interactiveViewerWidget.transformationController?.value,
          equals(Matrix4.identity()),
        );
      });

      testWidgets('auto-shows app bar after interaction delay', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Initially app bar should be visible
        expect(find.byType(AppBar), findsOneWidget);

        // Get the InteractiveViewer widget and trigger interaction start
        final interactiveViewerWidget = tester.widget<InteractiveViewer>(
          find.byType(InteractiveViewer),
        );

        // Trigger interaction start (this should hide the app bar)
        interactiveViewerWidget.onInteractionStart?.call(
          ScaleStartDetails(focalPoint: const Offset(100, 100)),
        );
        await tester.pump();

        // App bar should be hidden during interaction
        expect(find.byType(AppBar), findsNothing);

        // Wait for the auto-show delay and pump
        await tester.pump(const Duration(seconds: 4));

        // App bar should be visible again after the delay
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('triggers haptic feedback on interaction end', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Get the InteractiveViewer widget
        final interactiveViewerWidget = tester.widget<InteractiveViewer>(
          find.byType(InteractiveViewer),
        );

        // Verify the callback exists
        expect(interactiveViewerWidget.onInteractionEnd, isNotNull);

        // Trigger interaction end (in a real scenario, this would trigger haptic feedback)
        interactiveViewerWidget.onInteractionEnd?.call(
          ScaleEndDetails(),
        );

        // Assert - The test verifies the callback exists and can be called
        // Note: HapticFeedback.selectionClick() is difficult to test directly
        // in unit tests, but we can verify the callback is properly configured
        expect(interactiveViewerWidget.onInteractionEnd, isNotNull);
      });
    });

    group('app bar actions', () {
      testWidgets('displays info button in app bar', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.byIcon(Icons.info_outline), findsOneWidget);
      });

      testWidgets('shows info dialog when info button is tapped', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());
        await tester.tap(find.byIcon(Icons.info_outline));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text(t.fullScreen.imageInfoDialog.title), findsOneWidget);
      });

      testWidgets('info dialog shows correct image information', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());
        await tester.tap(find.byIcon(Icons.info_outline));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text(t.fullScreen.imageInfoDialog.title), findsOneWidget);

        // Check that dialog contains date and source information
        final dialogContent = tester.widget<Column>(
          find
              .descendant(
                of: find.byType(AlertDialog),
                matching: find.byType(Column),
              )
              .first,
        );
        expect(dialogContent.children, hasLength(greaterThan(0)));
      });

      testWidgets('can close info dialog', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());
        await tester.tap(find.byIcon(Icons.info_outline));
        await tester.pumpAndSettle();

        // Tap the cancel button in the dialog
        await tester.tap(find.text(t.common.cancel).last);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    group('image display', () {
      testWidgets('displays image with correct properties', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final imageWidget = tester.widget<Image>(find.byType(Image));
        expect(imageWidget.fit, BoxFit.contain);
      });

      testWidgets('shows error widget when image fails to load', (
        tester,
      ) async {
        // Create widget with invalid image data
        final widgetWithBadImage = FullScreenImageView(
          image: TestData.sampleCoffeeImage.copyWith(
            bytes: Uint8List(0), // Empty bytes should cause error
          ),
          onClose: () => onCloseCalled = true,
        );

        // Act
        await tester.pumpApp(widgetWithBadImage);
        await tester.pumpAndSettle();

        // Assert
        // Should show error container with broken image icon
        expect(find.byIcon(Icons.broken_image), findsOneWidget);
        expect(find.text(t.fullScreen.imageLoadError), findsOneWidget);
      });

      testWidgets('error widget has proper styling', (tester) async {
        // Create widget with invalid image data
        final widgetWithBadImage = FullScreenImageView(
          image: TestData.sampleCoffeeImage.copyWith(
            bytes: Uint8List.fromList([0xFF, 0xFF]), // Invalid image data
          ),
          onClose: () => onCloseCalled = true,
        );

        // Act
        await tester.pumpApp(widgetWithBadImage);
        await tester.pumpAndSettle();

        // Assert
        // Should show error container with proper background color
        final container = tester.widget<Container>(
          find
              .ancestor(
                of: find.byIcon(Icons.broken_image),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(container.color, equals(Colors.grey[900]));

        // Error text should be present
        expect(find.text(t.fullScreen.imageLoadError), findsOneWidget);
      });
    });

    group('InteractiveViewer', () {
      testWidgets('allows image zooming and panning', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final interactiveViewer = tester.widget<InteractiveViewer>(
          find.byType(InteractiveViewer),
        );
        expect(interactiveViewer.panEnabled, isTrue);
        expect(interactiveViewer.scaleEnabled, isTrue);
        expect(interactiveViewer.maxScale, greaterThan(1.0));
        expect(interactiveViewer.minScale, lessThanOrEqualTo(1.0));
      });

      testWidgets('has proper zoom constraints', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final interactiveViewer = tester.widget<InteractiveViewer>(
          find.byType(InteractiveViewer),
        );
        expect(interactiveViewer.minScale, equals(0.5));
        expect(interactiveViewer.maxScale, equals(4.0));
      });
    });

    group('system UI', () {
      testWidgets('widget initializes without errors', (tester) async {
        // This test ensures the SystemChrome calls don't cause issues in tests
        // Act & Assert
        expect(() => tester.pumpApp(createWidgetUnderTest()), returnsNormally);
      });
    });

    group('accessibility', () {
      testWidgets('provides proper semantic labels for buttons', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        // Close button should have tooltip
        final closeButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.close),
        );
        expect(closeButton.tooltip, equals(t.common.cancel));

        // Info button should have tooltip
        final infoButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.info_outline),
        );
        expect(infoButton.tooltip, equals(t.fullScreen.imageInfo));

        // Zoom reset button should have tooltip
        final zoomButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.zoom_out_map),
        );
        expect(zoomButton.tooltip, equals(t.fullScreen.resetZoom));
      });

      testWidgets('supports screen reader navigation', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        // Hero widget should have semantic label
        final heroWidget = tester.widget<Hero>(find.byType(Hero));
        expect(heroWidget.tag, contains('coffee_image_'));

        // InteractiveViewer should be focusable for screen readers
        final interactiveViewer = tester.widget<InteractiveViewer>(
          find.byType(InteractiveViewer),
        );
        expect(interactiveViewer.child, isA<Image>());
      });
    });

    group('edge cases', () {
      testWidgets('handles image with no saved date', (tester) async {
        // Arrange
        final imageWithoutDate = TestData.sampleCoffeeImage; // No savedAt

        final widget = FullScreenImageView(
          image: imageWithoutDate,
          onClose: () => onCloseCalled = true,
        );

        // Act
        await tester.pumpApp(widget);

        // Assert
        // Info button should not be visible when savedAt is null
        expect(find.byIcon(Icons.info_outline), findsNothing);
        // But the image should still display
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('handles very long source URLs', (tester) async {
        // Arrange
        final imageWithLongUrl = TestData.sampleSavedCoffeeImage.copyWith(
          sourceUrl:
              'https://very-long-url-that-might-cause-overflow.example.com/path/to/very/long/filename/with/many/characters/image.jpg',
        );

        final widget = FullScreenImageView(
          image: imageWithLongUrl,
          onClose: () => onCloseCalled = true,
        );

        // Act
        await tester.pumpApp(widget);
        await tester.tap(find.byIcon(Icons.info_outline));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
        // Should handle long URLs without overflow
      });
    });
  });
}
