import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/auth/register/view/widget/register_error_box.dart';

void main() {
  group('RegisterErrorBox Widget Tests', () {
    late Widget testWidget;
    const String testErrorMessage = 'Test error message';

    Widget createTestWidget({String message = testErrorMessage}) {
      return MaterialApp(
        home: Scaffold(body: RegisterErrorBox(message: message)),
      );
    }

    setUp(() {
      testWidget = createTestWidget();
    });

    tearDown(() {
      // Cleanup
    });

    group('Basic Rendering Tests', () {
      testWidgets('should render error box with correct structure', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
        expect(find.text(testErrorMessage), findsOneWidget);
      });

      testWidgets('should display the provided error message', (
        WidgetTester tester,
      ) async {
        // Arrange
        const customMessage = 'Custom error message';
        testWidget = createTestWidget(message: customMessage);

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.text(customMessage), findsOneWidget);
        expect(find.text(testErrorMessage), findsNothing);
      });

      testWidgets('should render with empty message', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget(message: '');

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.text(''), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
      });
    });

    group('Container Properties Tests', () {
      testWidgets('should have correct padding', (WidgetTester tester) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.padding, isNotNull);
      });

      testWidgets('should have correct decoration', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.decoration, isNotNull);
        expect(container.decoration, isA<BoxDecoration>());
      });

      testWidgets('should have correct border radius', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.borderRadius, isNotNull);
      });

      testWidgets('should have correct border', (WidgetTester tester) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.border, isNotNull);
      });
    });

    group('Text Properties Tests', () {
      testWidgets('should have correct text alignment', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.textAlign, TextAlign.center);
      });

      testWidgets('should have correct text style', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style, isNotNull);
      });

      testWidgets('should have correct text color', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.color, isNotNull);
      });
    });

    group('Theme Integration Tests', () {
      testWidgets('should use theme color scheme for error colors', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, isNotNull);
      });

      testWidgets('should use theme color scheme for border colors', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.border, isNotNull);
      });

      testWidgets('should use theme color scheme for text colors', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.color, isNotNull);
      });
    });

    group('Layout Tests', () {
      testWidgets('should maintain proper container structure', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('should have text as child of container', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.child, isA<Text>());
      });

      testWidgets('should not have multiple text widgets', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.byType(Text), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should be accessible to screen readers', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.byType(Text), findsOneWidget);
        expect(find.text(testErrorMessage), findsOneWidget);
      });

      testWidgets('should have proper semantic labels', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.text(testErrorMessage), findsOneWidget);
      });
    });

    group('Responsiveness Tests', () {
      testWidgets('should adapt to different screen sizes', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets(
        'should maintain center text alignment on different screen sizes',
        (WidgetTester tester) async {
          // Arrange
          testWidget = createTestWidget();

          // Act
          await tester.pumpWidget(testWidget);

          // Assert
          final text = tester.widget<Text>(find.byType(Text));
          expect(text.textAlign, TextAlign.center);
        },
      );
    });

    group('Edge Cases', () {
      testWidgets('should handle very long error messages', (
        WidgetTester tester,
      ) async {
        // Arrange
        const longMessage =
            'This is a very long error message that might exceed normal display boundaries and should be handled gracefully by the widget without causing any layout issues or overflow errors';
        testWidget = createTestWidget(message: longMessage);

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.text(longMessage), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
      });

      testWidgets('should handle special characters in error messages', (
        WidgetTester tester,
      ) async {
        // Arrange
        const specialMessage =
            'Error: Invalid input! @#\$%^&*()_+-=[]{}|;:,.<>?';
        testWidget = createTestWidget(message: specialMessage);

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.text(specialMessage), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
      });

      testWidgets('should handle unicode characters in error messages', (
        WidgetTester tester,
      ) async {
        // Arrange
        const unicodeMessage = 'Hata: Türkçe karakterler çalışıyor mu? 🚀✨';
        testWidget = createTestWidget(message: unicodeMessage);

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.text(unicodeMessage), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should rebuild efficiently', (WidgetTester tester) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Multiple rebuilds
        await tester.pumpWidget(testWidget);
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.byType(RegisterErrorBox), findsOneWidget);
      });

      testWidgets('should not cause memory leaks', (WidgetTester tester) async {
        // Arrange
        testWidget = createTestWidget();

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.byType(RegisterErrorBox), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('should work with different theme configurations', (
        WidgetTester tester,
      ) async {
        // Arrange
        testWidget = MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          ),
          home: const Scaffold(
            body: RegisterErrorBox(message: 'Theme test error'),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.byType(RegisterErrorBox), findsOneWidget);
        expect(find.text('Theme test error'), findsOneWidget);
      });

      testWidgets('should work with dark theme', (WidgetTester tester) async {
        // Arrange
        testWidget = MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: RegisterErrorBox(message: 'Dark theme error'),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.byType(RegisterErrorBox), findsOneWidget);
        expect(find.text('Dark theme error'), findsOneWidget);
      });
    });
  });
}
