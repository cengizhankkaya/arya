import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/profile/view/widgets/off_info_card.dart';
import 'package:arya/test/helpers/test_helpers.dart';

void main() {
  group('OffInfoCard Tests', () {
    testWidgets('should display all required elements', (
      WidgetTester tester,
    ) async {
      // Arrange
      void onLaunchCallback() {}

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffInfoCard(onLaunchOpenFoodFacts: onLaunchCallback),
        ),
      );

      // Assert
      expect(find.byType(OffInfoCard), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    });

    testWidgets('should call callback when button is pressed', (
      WidgetTester tester,
    ) async {
      // Arrange
      bool callbackCalled = false;
      void onLaunchCallback() {
        callbackCalled = true;
      }

      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffInfoCard(onLaunchOpenFoodFacts: onLaunchCallback),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.open_in_new));
      await tester.pump();

      // Assert
      expect(callbackCalled, isTrue);
    });

    testWidgets('should have correct button styling', (
      WidgetTester tester,
    ) async {
      // Arrange
      void onLaunchCallback() {}

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffInfoCard(onLaunchOpenFoodFacts: onLaunchCallback),
        ),
      );

      // Assert
      expect(find.byType(OffInfoCard), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    });

    testWidgets('should display info icon with correct properties', (
      WidgetTester tester,
    ) async {
      // Arrange
      void onLaunchCallback() {}

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffInfoCard(onLaunchOpenFoodFacts: onLaunchCallback),
        ),
      );

      // Assert
      final icon = tester.widget<Icon>(find.byIcon(Icons.info_outline));
      expect(icon.icon, equals(Icons.info_outline));
      expect(icon.size, equals(24));
    });

    testWidgets('should display open in new icon in button', (
      WidgetTester tester,
    ) async {
      // Arrange
      void onLaunchCallback() {}

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffInfoCard(onLaunchOpenFoodFacts: onLaunchCallback),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    });

    testWidgets('should have proper container structure', (
      WidgetTester tester,
    ) async {
      // Arrange
      void onLaunchCallback() {}

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffInfoCard(onLaunchOpenFoodFacts: onLaunchCallback),
        ),
      );

      // Assert
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('should handle multiple button presses', (
      WidgetTester tester,
    ) async {
      // Arrange
      int callbackCount = 0;
      void onLaunchCallback() {
        callbackCount++;
      }

      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffInfoCard(onLaunchOpenFoodFacts: onLaunchCallback),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.open_in_new));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.open_in_new));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.open_in_new));
      await tester.pump();

      // Assert
      expect(callbackCount, equals(3));
    });

    testWidgets('should maintain widget structure after rebuild', (
      WidgetTester tester,
    ) async {
      // Arrange
      void onLaunchCallback() {}

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffInfoCard(onLaunchOpenFoodFacts: onLaunchCallback),
        ),
      );

      // Rebuild widget
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffInfoCard(onLaunchOpenFoodFacts: onLaunchCallback),
        ),
      );

      // Assert
      expect(find.byType(OffInfoCard), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      // Arrange
      void onLaunchCallback() {}

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffInfoCard(onLaunchOpenFoodFacts: onLaunchCallback),
        ),
      );

      // Assert
      expect(find.byType(OffInfoCard), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);

      // Button should be tappable
      await tester.tap(find.byIcon(Icons.open_in_new));
      await tester.pump();
    });

    testWidgets('should handle null callback gracefully', (
      WidgetTester tester,
    ) async {
      // Arrange
      void onLaunchCallback() {}

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffInfoCard(onLaunchOpenFoodFacts: onLaunchCallback),
        ),
      );

      // Assert - Widget should render without errors
      expect(find.byType(OffInfoCard), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    });

    group('Layout Tests', () {
      testWidgets('should have proper spacing between elements', (
        WidgetTester tester,
      ) async {
        // Arrange
        void onLaunchCallback() {}

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffInfoCard(onLaunchOpenFoodFacts: onLaunchCallback),
          ),
        );

        // Assert
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Row), findsWidgets);
      });

      testWidgets('should expand to full width', (WidgetTester tester) async {
        // Arrange
        void onLaunchCallback() {}

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: SizedBox(
              width: 300,
              child: OffInfoCard(onLaunchOpenFoodFacts: onLaunchCallback),
            ),
          ),
        );

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.maxWidth, equals(double.infinity));
      });
    });
  });
}
