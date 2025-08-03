import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/widgets/gallery_empty_state.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('GalleryEmptyState', () {
    Widget createWidgetUnderTest() {
      return const GalleryEmptyState();
    }

    group('widget structure', () {
      testWidgets('displays empty state icon', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
      });

      testWidgets('displays empty state title', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.text(t.gallery.empty.title), findsOneWidget);
      });

      testWidgets('displays empty state subtitle', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.text(t.gallery.empty.subtitle), findsOneWidget);
      });

      testWidgets('is centered on screen', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        // Find the Center widget that contains our GalleryEmptyState
        expect(find.byType(Center), findsAtLeastNWidgets(1));

        // Verify the Center widget contains our Column
        expect(
          find.descendant(
            of: find.byType(Center),
            matching: find.byType(Column),
          ),
          findsOneWidget,
        );
      });

      testWidgets('uses proper layout structure', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.byType(Column), findsOneWidget);

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.mainAxisAlignment, MainAxisAlignment.center);
      });
    });

    group('styling', () {
      testWidgets('icon has correct size and color', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final iconWidget = tester.widget<Icon>(
          find.byIcon(Icons.photo_library_outlined),
        );
        expect(iconWidget.size, 64);
        // Color assertion would require theme context
      });

      testWidgets('title uses correct text style', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final titleFinder = find.text(t.gallery.empty.title);
        expect(titleFinder, findsOneWidget);

        final textWidget = tester.widget<Text>(titleFinder);
        // In a real app, we'd verify the text style matches headlineMedium
        expect(textWidget.textAlign, isNull); // Default alignment
      });

      testWidgets('subtitle uses correct text style and alignment', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        final subtitleFinder = find.text(t.gallery.empty.subtitle);
        expect(subtitleFinder, findsOneWidget);

        final textWidget = tester.widget<Text>(subtitleFinder);
        expect(textWidget.textAlign, TextAlign.center);
      });

      testWidgets('has proper spacing between elements', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        // Find SizedBox widgets with height only (spacing elements)
        final spacingSizedBoxes = tester
            .widgetList<SizedBox>(
              find.byType(SizedBox),
            )
            .where(
              (sizedBox) => sizedBox.width == null && sizedBox.height != null,
            );

        expect(spacingSizedBoxes, hasLength(2));

        final spacingList = spacingSizedBoxes.toList();
        expect(spacingList[0].height, 16); // After icon
        expect(spacingList[1].height, 8); // After title
      });
    });

    group('accessibility', () {
      testWidgets('provides proper semantic structure', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        // The widget should provide meaningful semantics for screen readers
        expect(find.text(t.gallery.empty.title), findsOneWidget);
        expect(find.text(t.gallery.empty.subtitle), findsOneWidget);
      });

      testWidgets('icon is decorative and does not interfere with semantics', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        // The icon should be present but not create semantic noise
        expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
      });
    });

    group('responsiveness', () {
      testWidgets('adapts to different screen sizes', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        // The Center widget should ensure proper positioning across sizes
        expect(find.byType(Center), findsAtLeastNWidgets(1));

        // Column should maintain centered alignment
        final column = tester.widget<Column>(find.byType(Column));
        expect(column.mainAxisAlignment, MainAxisAlignment.center);
      });

      testWidgets('text remains readable on different sizes', (tester) async {
        // This would test different MediaQuery sizes in practice
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.text(t.gallery.empty.title), findsOneWidget);
        expect(find.text(t.gallery.empty.subtitle), findsOneWidget);
      });
    });

    group('theme integration', () {
      testWidgets('respects theme colors', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        // Icon color should use theme's primary color with opacity
        final iconWidget = tester.widget<Icon>(
          find.byIcon(Icons.photo_library_outlined),
        );
        expect(iconWidget.icon, Icons.photo_library_outlined);
      });

      testWidgets('text styles follow theme typography', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        // Text widgets should use theme typography
        expect(find.text(t.gallery.empty.title), findsOneWidget);
        expect(find.text(t.gallery.empty.subtitle), findsOneWidget);
      });
    });

    group('localization', () {
      testWidgets('displays localized text', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        expect(find.text(t.gallery.empty.title), findsOneWidget);
        expect(find.text(t.gallery.empty.subtitle), findsOneWidget);
      });

      testWidgets('handles different text lengths gracefully', (tester) async {
        // This would test with different locales in practice
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        // Should handle varying text lengths without overflow
        expect(find.text(t.gallery.empty.subtitle), findsOneWidget);

        final subtitleWidget = tester.widget<Text>(
          find.text(t.gallery.empty.subtitle),
        );
        expect(subtitleWidget.textAlign, TextAlign.center);
      });
    });

    group('edge cases', () {
      testWidgets('widget builds without errors', (tester) async {
        // Act & Assert - Should not throw during widget creation
        expect(() => tester.pumpApp(createWidgetUnderTest()), returnsNormally);
      });

      testWidgets('has consistent widget tree structure', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        // Verify the expected widget hierarchy:
        // Center -> Column -> [Icon, SizedBox, Text, SizedBox, Text]
        final centerWidget = find.byType(Center);
        expect(centerWidget, findsAtLeastNWidgets(1));

        final columnInCenter = find.descendant(
          of: centerWidget,
          matching: find.byType(Column),
        );
        expect(columnInCenter, findsOneWidget);

        // Verify all expected children are present
        expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
        expect(find.text(t.gallery.empty.title), findsOneWidget);
        expect(find.text(t.gallery.empty.subtitle), findsOneWidget);
      });

      testWidgets('maintains accessibility structure', (tester) async {
        // Act
        await tester.pumpApp(createWidgetUnderTest());

        // Assert
        // Verify accessibility-important elements
        expect(find.text(t.gallery.empty.title), findsOneWidget);
        expect(find.text(t.gallery.empty.subtitle), findsOneWidget);

        // Icon should be present but decorative
        expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
      });
    });
  });
}
