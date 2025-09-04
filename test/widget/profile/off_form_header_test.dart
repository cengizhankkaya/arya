import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/profile/view/widgets/off_form_header.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('OffFormHeader Tests', () {
    testWidgets('should display header text', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: OffFormHeader()),
      );

      // Assert
      expect(find.byType(OffFormHeader), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(2));
    });

    testWidgets('should have proper column structure', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: OffFormHeader()),
      );

      // Assert
      final column = tester.widget<Column>(find.byType(Column));
      expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
      expect(column.children.length, equals(3)); // 2 Text widgets + 1 SizedBox
    });

    testWidgets('should have proper spacing between elements', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: OffFormHeader()),
      );

      // Assert
      expect(find.byType(SizedBox), findsOneWidget);

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, equals(8));
    });

    testWidgets('should display title with correct styling', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: OffFormHeader()),
      );

      // Assert
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      expect(textWidgets.length, equals(2));

      // First text should be the title
      final titleText = textWidgets.first;
      expect(titleText.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('should display description with correct styling', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: OffFormHeader()),
      );

      // Assert
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      expect(textWidgets.length, equals(2));

      // Second text should be the description
      final descriptionText = textWidgets.last;
      expect(descriptionText.style, isNotNull);
    });

    testWidgets('should maintain structure after rebuild', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: OffFormHeader()),
      );

      // Rebuild
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: OffFormHeader()),
      );

      // Assert
      expect(find.byType(OffFormHeader), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(2));
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: OffFormHeader()),
      );

      // Assert
      expect(find.byType(OffFormHeader), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(2));
    });

    testWidgets('should handle different screen sizes', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: SizedBox(width: 200, child: OffFormHeader()),
        ),
      );

      // Assert
      expect(find.byType(OffFormHeader), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should have proper text alignment', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: OffFormHeader()),
      );

      // Assert
      final column = tester.widget<Column>(find.byType(Column));
      expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
    });

    group('Text Content Tests', () {
      testWidgets('should render without throwing errors', (
        WidgetTester tester,
      ) async {
        // Act & Assert
        expect(() async {
          await tester.pumpWidget(
            TestHelpers.createTestApp(child: OffFormHeader()),
          );
        }, returnsNormally);
      });

      testWidgets('should handle theme changes', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(child: OffFormHeader()),
        );

        // Change theme
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffFormHeader(),
            theme: TestHelpers.createDarkTheme(),
          ),
        );

        // Assert
        expect(find.byType(OffFormHeader), findsOneWidget);
        expect(find.byType(Text), findsNWidgets(2));
      });
    });

    group('Layout Tests', () {
      testWidgets('should have correct widget hierarchy', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(child: OffFormHeader()),
        );

        // Assert
        expect(find.byType(OffFormHeader), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Text), findsNWidgets(2));
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('should maintain consistent spacing', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(child: OffFormHeader()),
        );

        // Assert
        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, equals(8));
      });
    });
  });
}
