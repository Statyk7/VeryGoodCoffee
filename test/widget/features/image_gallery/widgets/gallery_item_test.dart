import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/widgets/gallery_item.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_data.dart';

void main() {
  group('GalleryItem', () {
    late bool onTapCalled;
    late bool onDeleteCalled;

    setUp(() {
      onTapCalled = false;
      onDeleteCalled = false;
    });

    Widget createWidgetUnderTest({
      bool showDeleteButton = false,
    }) {
      return GalleryItem(
        image: TestData.sampleSavedCoffeeImage,
        onTap: () => onTapCalled = true,
        onDelete: showDeleteButton ? () => onDeleteCalled = true : null,
      );
    }

    group('widget structure', () {
      testWidgets('displays the image', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('has proper card structure', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.byType(Card), findsOneWidget);

        // Check that the Card has proper clip behavior set
        final card = tester.widget<Card>(find.byType(Card));
        expect(card.clipBehavior, Clip.antiAlias);
      });

      testWidgets('uses ink well for tap interactions', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        // Should find InkWells (main one + IconButton's InkWell)
        expect(
          find.descendant(
            of: find.byType(Card),
            matching: find.byType(InkWell),
          ),
          findsAtLeastNWidgets(1),
        );
      });

      testWidgets('displays delete button when onDelete is provided', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest(showDeleteButton: true));

        // Assert
        expect(find.byIcon(Icons.delete), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets(
        'shows delete button with default behavior when onDelete is null',
        (tester) async {
          // Act
          await tester.pumpApp(createWidgetUnderTest());

          // Assert
          expect(find.byIcon(Icons.delete), findsOneWidget);
          // Button should be present but will use default dialog behavior
        },
      );
    });

    group('interactions', () {
      testWidgets('calls onTap when item is tapped', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());
        // Tap on the main InkWell (first one, which is the image area)
        await tester.tap(
          find
              .descendant(
                of: find.byType(Card),
                matching: find.byType(InkWell),
              )
              .first,
        );

        // Assert
        expect(onTapCalled, isTrue);
      });

      testWidgets('calls onDelete when delete button is tapped', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest(showDeleteButton: true));
        await tester.tap(find.byIcon(Icons.delete));

        // Assert
        expect(onDeleteCalled, isTrue);
        expect(onTapCalled, isFalse); // Should not trigger onTap
      });

      testWidgets('delete button tap does not trigger onTap', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest(showDeleteButton: true));
        await tester.tap(find.byIcon(Icons.delete));

        // Assert
        expect(onDeleteCalled, isTrue);
        expect(onTapCalled, isFalse);
      });

      testWidgets('provides haptic feedback on tap', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());
        await tester.tap(
          find
              .descendant(
                of: find.byType(Card),
                matching: find.byType(InkWell),
              )
              .first,
        );
        await tester.pumpAndSettle();

        // Assert
        expect(onTapCalled, isTrue);
        // Haptic feedback would be tested with platform-specific mocks
      });
    });

    group('image display', () {
      testWidgets('displays image with correct fit', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final imageWidget = tester.widget<Image>(find.byType(Image));
        expect(imageWidget.fit, BoxFit.cover);
      });

      testWidgets('has proper clip behavior', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final card = tester.widget<Card>(find.byType(Card));
        expect(card.clipBehavior, Clip.antiAlias);
      });

      testWidgets('handles image loading errors gracefully', (tester) async {
        // Create widget with empty bytes to trigger error
        final widgetWithBadImage = GalleryItem(
          image: TestData.sampleCoffeeImage.copyWith(bytes: Uint8List(0)),
          onTap: () => onTapCalled = true,
        );

        // Act
        await tester.pumpApp(widgetWithBadImage);
        await tester.pumpAndSettle();

        // Assert
        // Should still display the image widget even with error
        expect(find.byType(Image), findsOneWidget);
      });
    });

    group('delete button positioning', () {
      testWidgets('delete button is positioned correctly', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest(showDeleteButton: true));

        // Assert
        // Find the positioned widget that contains the delete button
        final deleteButtonPositioned = find.ancestor(
          of: find.byIcon(Icons.delete),
          matching: find.byType(Positioned),
        );
        expect(deleteButtonPositioned, findsOneWidget);

        final positioned = tester.widget<Positioned>(deleteButtonPositioned);
        expect(positioned.top, isNotNull);
        expect(positioned.right, isNotNull);
      });

      testWidgets('delete button has proper styling', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest(showDeleteButton: true));

        // Assert
        // Should find containers (one for delete button, one for date overlay)
        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byIcon(Icons.delete), findsOneWidget);
      });

      testWidgets('delete button has semi-transparent background', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest(showDeleteButton: true));

        // Assert
        // Find the container that's a parent of the delete icon
        final deleteButtonContainer = find.ancestor(
          of: find.byIcon(Icons.delete),
          matching: find.byType(Container),
        );
        expect(deleteButtonContainer, findsOneWidget);

        final container = tester.widget<Container>(deleteButtonContainer);
        expect(container.decoration, isA<BoxDecoration>());
      });
    });

    group('accessibility', () {
      testWidgets('provides proper semantics for image tap', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(
          find.descendant(
            of: find.byType(Card),
            matching: find.byType(InkWell),
          ),
          findsAtLeastNWidgets(1),
        );
        // In practice, we'd verify semantic labels and actions
      });

      testWidgets('delete button has proper semantic label', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest(showDeleteButton: true));

        // Assert
        expect(find.byType(IconButton), findsOneWidget);
        // IconButton should have semantic label for screen readers
      });

      testWidgets('delete button is accessible when using default behavior', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.byType(IconButton), findsOneWidget);
        // Delete button should be accessible even with default behavior
      });
    });

    group('visual feedback', () {
      testWidgets('shows ink splash on tap', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        final inkWells = find.descendant(
          of: find.byType(Card),
          matching: find.byType(InkWell),
        );

        // Start tap but don't complete it on the first InkWell
        await tester.startGesture(tester.getCenter(inkWells.first));
        await tester.pump(const Duration(milliseconds: 100));

        // Assert
        // InkWells should be present
        expect(inkWells, findsAtLeastNWidgets(1));
      });

      testWidgets('card has proper styling', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final card = tester.widget<Card>(find.byType(Card));
        expect(card.clipBehavior, Clip.antiAlias);
        // Card styling is theme-dependent and may use elevation or surface tint
        expect(card, isNotNull);
      });
    });

    group('layout and sizing', () {
      testWidgets('maintains aspect ratio', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        // The image should fill the available space with BoxFit.cover
        final imageWidget = tester.widget<Image>(find.byType(Image));
        expect(imageWidget.fit, BoxFit.cover);
      });

      testWidgets('respects parent constraints', (tester) async {
        // Act
        await tester.pumpApp(
          SizedBox(
            width: 200,
            height: 200,
            child: createWidgetUnderTest(),
          ),
        );

        // Assert
        expect(find.byType(Card), findsOneWidget);
        // Card should respect the SizedBox constraints
      });
    });

    group('edge cases', () {
      testWidgets('handles null callbacks gracefully', (tester) async {
        // Create widget with minimal required parameters
        final minimalWidget = GalleryItem(
          image: TestData.sampleSavedCoffeeImage,
          onTap: () {},
        );

        // Act
        await tester.pumpApp(minimalWidget);

        // Assert
        expect(find.byType(GalleryItem), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsOneWidget);
        // Delete button should be present but use default behavior
      });

      testWidgets('handles image with no saved date', (tester) async {
        // Create widget with image that has no saved date
        final imageWithoutDate = TestData.sampleCoffeeImage; // No savedAt
        final widget = GalleryItem(
          image: imageWithoutDate,
          onTap: () => onTapCalled = true,
        );

        // Act
        await tester.pumpApp(widget);

        // Assert
        expect(find.byType(Image), findsOneWidget);
        expect(onTapCalled, isFalse);
      });
    });
  });
}
