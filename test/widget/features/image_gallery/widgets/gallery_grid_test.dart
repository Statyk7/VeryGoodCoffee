import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/widgets/gallery_empty_state.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/widgets/gallery_grid.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/widgets/gallery_item.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_data.dart';

void main() {
  group('GalleryGrid', () {
    late CoffeeImage? tappedImage;
    late CoffeeImage? deletedImage;

    setUp(() {
      tappedImage = null;
      deletedImage = null;
    });

    Widget createWidgetUnderTest({
      List<CoffeeImage>? images,
      bool showDeleteButtons = false,
    }) {
      return GalleryGrid(
        images: images ?? TestData.sampleCoffeeImageList,
        onImageTap: (image) => tappedImage = image,
        onImageDelete: showDeleteButtons
            ? (image) => deletedImage = image
            : null,
      );
    }

    group('empty state', () {
      testWidgets('displays empty state when no images provided', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest(images: []));

        // Assert
        expect(find.byType(GalleryEmptyState), findsOneWidget);
        expect(find.byType(GridView), findsNothing);
      });

      testWidgets('displays empty state when images list is empty', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest(images: []));

        // Assert
        expect(find.byType(GalleryEmptyState), findsOneWidget);
        expect(find.byType(GridView), findsNothing);
      });
    });

    group('grid display', () {
      testWidgets('displays grid when images are available', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.byType(GridView), findsOneWidget);
        expect(find.byType(GalleryEmptyState), findsNothing);
      });

      testWidgets('displays correct number of gallery items', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(
          find.byType(GalleryItem),
          findsNWidgets(TestData.sampleCoffeeImageList.length),
        );
      });

      testWidgets('displays single image correctly', (tester) async {
        // Act
        await tester.pumpApp(
          createWidgetUnderTest(
            images: [TestData.sampleSavedCoffeeImage],
          ),
        );

        // Assert
        expect(find.byType(GalleryItem), findsOneWidget);
        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('handles large number of images', (tester) async {
        // Create a large list of images
        final manyImages = List.generate(
          50,
          (index) => TestData.sampleCoffeeImage.copyWith(id: 'image-$index'),
        );

        // Act
        await tester.pumpApp(createWidgetUnderTest(images: manyImages));

        // Assert
        expect(find.byType(GridView), findsOneWidget);
        // Should be able to scroll to see more items
      });
    });

    group('grid configuration', () {
      testWidgets('uses correct grid properties', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

        expect(delegate.crossAxisCount, 2);
        expect(delegate.crossAxisSpacing, 8);
        expect(delegate.mainAxisSpacing, 8);
        expect(delegate.childAspectRatio, 1);
      });

      testWidgets('has proper padding', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final galleryGrid = find.byType(GalleryGrid);
        final paddingWidget = tester.widget<Padding>(
          find
              .descendant(
                of: galleryGrid,
                matching: find.byType(Padding),
              )
              .first,
        );
        expect(paddingWidget.padding, const EdgeInsets.all(8));
      });
    });

    group('interactions', () {
      testWidgets('calls onImageTap with correct image when item is tapped', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Tap the first item
        await tester.tap(find.byType(GalleryItem).first);

        // Assert
        expect(tappedImage, TestData.sampleCoffeeImageList[0]);
      });

      testWidgets('calls onImageTap with correct image for different items', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Tap the second item
        await tester.tap(find.byType(GalleryItem).at(1));

        // Assert
        expect(tappedImage, TestData.sampleCoffeeImageList[1]);
      });

      testWidgets('calls onImageDelete with correct image', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest(showDeleteButtons: true));

        // Find and tap the delete button of the first item
        await tester.tap(find.byIcon(Icons.delete).first);

        // Assert
        expect(deletedImage, TestData.sampleCoffeeImageList[0]);
      });

      testWidgets(
        'delete buttons are visible but use default behavior '
            'when onImageDelete is null',
        (tester) async {
          // Act
          await tester.pumpApp(createWidgetUnderTest());

          // Assert
          expect(
            find.byIcon(Icons.delete),
            findsNWidgets(TestData.sampleCoffeeImageList.length),
          );
        },
      );

      testWidgets('delete buttons are visible when onImageDelete is provided', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest(showDeleteButtons: true));

        // Assert
        expect(
          find.byIcon(Icons.delete),
          findsNWidgets(TestData.sampleCoffeeImageList.length),
        );
      });
    });

    group('scrolling behavior', () {
      testWidgets('grid is scrollable', (tester) async {
        // Create enough images to require scrolling
        final manyImages = List.generate(
          20,
          (index) => TestData.sampleCoffeeImage.copyWith(id: 'image-$index'),
        );

        // Act
        await tester.pumpApp(createWidgetUnderTest(images: manyImages));

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView.physics, isNotNull);
      });

      testWidgets('can scroll to reveal more items', (tester) async {
        // Create enough images to require scrolling
        final manyImages = List.generate(
          20,
          (index) => TestData.sampleCoffeeImage.copyWith(id: 'image-$index'),
        );

        // Act
        await tester.pumpApp(createWidgetUnderTest(images: manyImages));

        // Initially should see some items
        expect(find.byType(GalleryItem), findsWidgets);

        // Scroll down
        await tester.fling(find.byType(GridView), const Offset(0, -500), 1000);
        await tester.pumpAndSettle();

        // Should still see items (different ones after scrolling)
        expect(find.byType(GalleryItem), findsWidgets);
      });
    });

    group('item layout', () {
      testWidgets('items maintain aspect ratio', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        expect(delegate.childAspectRatio, 1); // Square items
      });

      testWidgets('items are spaced correctly', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        expect(delegate.crossAxisSpacing, 8);
        expect(delegate.mainAxisSpacing, 8);
      });
    });

    group('performance', () {
      testWidgets('uses efficient list building', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        // GridView should be using an efficient builder pattern
        expect(gridView.childrenDelegate, isA<SliverChildBuilderDelegate>());
      });

      testWidgets('handles item count correctly', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.childrenDelegate as SliverChildBuilderDelegate;
        expect(
          delegate.estimatedChildCount,
          TestData.sampleCoffeeImageList.length,
        );
      });
    });

    group('responsive design', () {
      testWidgets('uses 2 columns by default', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        expect(delegate.crossAxisCount, 2);
      });

      testWidgets('maintains consistent spacing', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        expect(delegate.crossAxisSpacing, delegate.mainAxisSpacing);
      });
    });

    group('edge cases', () {
      testWidgets('handles mixed image types', (tester) async {
        // Create mixed list with different image formats
        final mixedImages = [
          TestData.sampleCoffeeImage,
          TestData.sampleSavedCoffeeImage,
          TestData.sampleCoffeeImageList[1], // Different format
        ];

        // Act
        await tester.pumpApp(createWidgetUnderTest(images: mixedImages));

        // Assert
        expect(find.byType(GalleryItem), findsNWidgets(3));
      });

      testWidgets('handles rapid tap interactions', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Rapidly tap different items
        await tester.tap(find.byType(GalleryItem).first);
        await tester.tap(find.byType(GalleryItem).at(1));
        await tester.pump();

        // Assert
        expect(
          tappedImage,
          TestData.sampleCoffeeImageList[1],
        ); // Should reflect the last tap
      });

      testWidgets('handles deletion of items gracefully', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest(showDeleteButtons: true));

        // Delete an item
        await tester.tap(find.byIcon(Icons.delete).first);

        // Assert
        expect(deletedImage, isNotNull);
        // In practice, the parent would update the list and rebuild
      });
    });
  });
}
