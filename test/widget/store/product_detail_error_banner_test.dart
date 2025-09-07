import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/store/view/widget/product_detail_error_banner.dart';

void main() {
  group('ProductDetailErrorBanner Widget Tests', () {
    late ColorScheme colorScheme;
    late String testErrorMessage;
    late VoidCallback mockOnClose;

    setUp(() {
      colorScheme = ColorScheme.fromSeed(seedColor: Colors.red);
      testErrorMessage = 'Test error message';
      mockOnClose = () {};
    });

    Widget createTestWidget({
      required String errorMessage,
      required VoidCallback onClose,
      required ColorScheme scheme,
    }) {
      return MaterialApp(
        theme: ThemeData(colorScheme: scheme),
        home: Scaffold(
          body: ProductDetailErrorBanner(
            errorMessage: errorMessage,
            onClose: onClose,
            scheme: scheme,
          ),
        ),
      );
    }

    group('Widget Rendering', () {
      testWidgets('should render ProductDetailErrorBanner correctly', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.byType(ProductDetailErrorBanner), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
      });

      testWidgets('should display error message text', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text(testErrorMessage), findsOneWidget);
      });

      testWidgets('should display error icon', (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('should display close button', (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.byIcon(Icons.close), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      });
    });

    group('Error Message Display', () {
      testWidgets('should display different error messages correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        const differentErrorMessage = 'Different error message';

        // Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: differentErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text(differentErrorMessage), findsOneWidget);
        expect(find.text(testErrorMessage), findsNothing);
      });

      testWidgets('should display long error messages correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        const longErrorMessage =
            'This is a very long error message that should be displayed correctly and should wrap to multiple lines if necessary to show the complete error information to the user';

        // Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: longErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text(longErrorMessage), findsOneWidget);
      });

      testWidgets('should display empty error message', (
        WidgetTester tester,
      ) async {
        // Arrange
        const emptyErrorMessage = '';

        // Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: emptyErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text(emptyErrorMessage), findsOneWidget);
      });
    });

    group('Close Button Functionality', () {
      testWidgets('should call onClose when close button is tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool onCloseCalled = false;
        VoidCallback onClose = () {
          onCloseCalled = true;
        };

        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: onClose,
            scheme: colorScheme,
          ),
        );

        // Act
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Assert
        expect(onCloseCalled, isTrue);
      });

      testWidgets('should not call onClose when other parts are tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool onCloseCalled = false;
        VoidCallback onClose = () {
          onCloseCalled = true;
        };

        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: onClose,
            scheme: colorScheme,
          ),
        );

        // Act
        await tester.tap(find.text(testErrorMessage));
        await tester.pumpAndSettle();

        // Assert
        expect(onCloseCalled, isFalse);
      });
    });

    group('Styling and Colors', () {
      testWidgets('should apply correct container styling', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.color, equals(colorScheme.errorContainer));
        expect(decoration.borderRadius, equals(BorderRadius.circular(16)));
        expect(decoration.border, isA<Border>());
      });

      testWidgets('should apply correct margin and padding', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        final container = tester.widget<Container>(find.byType(Container));

        expect(container.margin, equals(const EdgeInsets.all(12)));
        expect(container.padding, equals(const EdgeInsets.all(16)));
      });

      testWidgets('should apply correct icon colors', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        final errorIcon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
        final closeIcon = tester.widget<Icon>(find.byIcon(Icons.close));

        expect(errorIcon.color, equals(colorScheme.error));
        expect(closeIcon.color, equals(colorScheme.error));
      });

      testWidgets('should apply correct icon sizes', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        final errorIcon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
        final closeIcon = tester.widget<Icon>(find.byIcon(Icons.close));

        expect(errorIcon.size, equals(20));
        expect(closeIcon.size, equals(20));
      });

      testWidgets('should apply correct text color', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        final textWidget = tester.widget<Text>(find.text(testErrorMessage));
        final textStyle = textWidget.style;

        expect(textStyle?.color, equals(colorScheme.onErrorContainer));
      });
    });

    group('Layout and Structure', () {
      testWidgets('should have correct row structure', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        final row = tester.widget<Row>(find.byType(Row));
        expect(
          row.children.length,
          equals(4),
        ); // Icon, SizedBox, Expanded, IconButton
      });

      testWidgets('should have correct spacing between elements', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        final spacingSizedBox = sizedBoxes.firstWhere(
          (sizedBox) => sizedBox.width == 12,
          orElse: () => throw StateError('SizedBox with width 12 not found'),
        );
        expect(spacingSizedBox.width, equals(12));
      });

      testWidgets('should have expanded text widget', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.byType(Expanded), findsOneWidget);
        final expanded = tester.widget<Expanded>(find.byType(Expanded));
        expect(expanded.child, isA<Text>());
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantic labels', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.byType(IconButton), findsOneWidget);
        // IconButton should be accessible by default
      });

      testWidgets('should be accessible to screen readers', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text(testErrorMessage), findsOneWidget);
        // Text should be accessible by default
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null-like empty string error message', (
        WidgetTester tester,
      ) async {
        // Arrange
        const emptyErrorMessage = '';

        // Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: emptyErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text(emptyErrorMessage), findsOneWidget);
        expect(find.byType(ProductDetailErrorBanner), findsOneWidget);
      });

      testWidgets('should handle special characters in error message', (
        WidgetTester tester,
      ) async {
        // Arrange
        const specialCharErrorMessage = 'Error: @#\$%^&*()_+-=[]{}|;:,.<>?';

        // Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: specialCharErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text(specialCharErrorMessage), findsOneWidget);
      });

      testWidgets('should handle unicode characters in error message', (
        WidgetTester tester,
      ) async {
        // Arrange
        const unicodeErrorMessage = 'Hata: Türkçe karakterler çğşıöü';

        // Act
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: unicodeErrorMessage,
            onClose: mockOnClose,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text(unicodeErrorMessage), findsOneWidget);
      });
    });

    group('Theme Integration', () {
      testWidgets('should work with different color schemes', (
        WidgetTester tester,
      ) async {
        // Arrange
        final lightScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
        final darkScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );

        // Act - Light theme
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: lightScheme,
          ),
        );

        // Assert - Light theme
        expect(find.byType(ProductDetailErrorBanner), findsOneWidget);

        // Act - Dark theme
        await tester.pumpWidget(
          createTestWidget(
            errorMessage: testErrorMessage,
            onClose: mockOnClose,
            scheme: darkScheme,
          ),
        );

        // Assert - Dark theme
        expect(find.byType(ProductDetailErrorBanner), findsOneWidget);
      });
    });
  });
}
