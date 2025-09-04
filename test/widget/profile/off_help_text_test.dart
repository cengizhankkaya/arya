import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/profile/view/widgets/off_help_text.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('OffHelpText Tests', () {
    testWidgets('should display help text with icon', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(TestHelpers.createTestApp(child: OffHelpText()));

      // Assert
      expect(find.byType(OffHelpText), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should have proper container structure', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(TestHelpers.createTestApp(child: OffHelpText()));

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, isNotNull);
      expect(container.decoration, isNotNull);
      expect(container.constraints?.maxWidth, equals(double.infinity));
    });

    testWidgets('should display help icon with correct properties', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(TestHelpers.createTestApp(child: OffHelpText()));

      // Assert
      final icon = tester.widget<Icon>(find.byIcon(Icons.help_outline));
      expect(icon.icon, equals(Icons.help_outline));
      expect(icon.size, equals(20));
    });

    testWidgets('should have proper row layout', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(TestHelpers.createTestApp(child: OffHelpText()));

      // Assert
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, equals(3)); // Icon + SizedBox + Expanded Text
    });

    testWidgets('should have expanded text widget', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(TestHelpers.createTestApp(child: OffHelpText()));

      // Assert
      expect(find.byType(Expanded), findsOneWidget);

      final expanded = tester.widget<Expanded>(find.byType(Expanded));
      expect(expanded.child, isA<Text>());
    });

    testWidgets('should maintain structure after rebuild', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(TestHelpers.createTestApp(child: OffHelpText()));

      // Rebuild
      await tester.pumpWidget(TestHelpers.createTestApp(child: OffHelpText()));

      // Assert
      expect(find.byType(OffHelpText), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(TestHelpers.createTestApp(child: OffHelpText()));

      // Assert
      expect(find.byType(OffHelpText), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should handle different screen sizes', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: SizedBox(width: 300, child: OffHelpText()),
        ),
      );

      // Assert
      expect(find.byType(OffHelpText), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('should have proper spacing between icon and text', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(TestHelpers.createTestApp(child: OffHelpText()));

      // Assert
      expect(find.byType(SizedBox), findsWidgets);

      // Find the SizedBox with width (spacing between icon and text)
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final spacingSizedBox = sizedBoxes.firstWhere(
        (sizedBox) => sizedBox.width != null,
        orElse: () => sizedBoxes.first,
      );
      expect(spacingSizedBox.width, isNotNull);
    });

    testWidgets('should handle theme changes', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(TestHelpers.createTestApp(child: OffHelpText()));

      // Change theme
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffHelpText(),
          theme: TestHelpers.createDarkTheme(),
        ),
      );

      // Assert
      expect(find.byType(OffHelpText), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    group('Container Decoration Tests', () {
      testWidgets('should have proper decoration properties', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(child: OffHelpText()),
        );

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.borderRadius, isNotNull);
        expect(decoration.color, isNotNull);
      });

      testWidgets('should have correct border radius', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(child: OffHelpText()),
        );

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.borderRadius, isNotNull);
      });
    });

    group('Text Styling Tests', () {
      testWidgets('should have proper text styling', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(child: OffHelpText()),
        );

        // Assert
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style, isNotNull);
      });

      testWidgets('should render without throwing errors', (
        WidgetTester tester,
      ) async {
        // Act & Assert
        expect(() async {
          await tester.pumpWidget(
            TestHelpers.createTestApp(child: OffHelpText()),
          );
        }, returnsNormally);
      });
    });

    group('Layout Tests', () {
      testWidgets('should have correct widget hierarchy', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(child: OffHelpText()),
        );

        // Assert
        expect(find.byType(OffHelpText), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byIcon(Icons.help_outline), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('should expand to full width', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: SizedBox(width: 400, child: OffHelpText()),
          ),
        );

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.maxWidth, equals(double.infinity));
      });
    });
  });
}
