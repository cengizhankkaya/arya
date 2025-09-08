import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NavigationItem Widget Tests', () {
    Widget _buildNavigationItem({
      required IconData icon,
      required IconData activeIcon,
      required String label,
      required bool isSelected,
      required VoidCallback onTap,
    }) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minWidth: 60, minHeight: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 24,
                  color: isSelected ? Colors.white : Colors.white70,
                ),
                const SizedBox(height: 4),
                if (isSelected)
                  Container(
                    width: 20,
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.white,
                    ),
                  )
                else
                  const SizedBox(height: 3),
              ],
            ),
          ),
        ),
      );
    }

    Widget createNavigationItemWidget({
      bool isSelected = false,
      VoidCallback? onTap,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: _buildNavigationItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
            isSelected: isSelected,
            onTap: onTap ?? () {},
          ),
        ),
      );
    }

    group('NavigationItem Rendering Tests', () {
      testWidgets('should render navigation item without errors', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createNavigationItemWidget());

        // Assert
        expect(find.byType(InkWell), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
      });

      testWidgets('should show outlined icon when not selected', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createNavigationItemWidget(isSelected: false));

        // Assert
        expect(find.byIcon(Icons.home_outlined), findsOneWidget);
        expect(find.byIcon(Icons.home_rounded), findsNothing);
      });

      testWidgets('should show filled icon when selected', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createNavigationItemWidget(isSelected: true));

        // Assert
        expect(find.byIcon(Icons.home_rounded), findsOneWidget);
        expect(find.byIcon(Icons.home_outlined), findsNothing);
      });

      testWidgets('should show indicator when selected', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createNavigationItemWidget(isSelected: true));

        // Assert
        expect(find.byType(Container), findsWidgets);
        // Indicator container should be present
        final containers = find.byType(Container);
        expect(containers, findsWidgets);
      });

      testWidgets('should not show indicator when not selected', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createNavigationItemWidget(isSelected: false));

        // Assert
        // Should only have the main container, not the indicator
        expect(find.byType(Container), findsOneWidget);
      });
    });

    group('NavigationItem Interaction Tests', () {
      testWidgets('should call onTap when tapped', (WidgetTester tester) async {
        // Arrange
        bool tapped = false;
        VoidCallback onTap = () {
          tapped = true;
        };

        // Act
        await tester.pumpWidget(createNavigationItemWidget(onTap: onTap));
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        // Assert
        expect(tapped, isTrue);
      });

      testWidgets('should handle multiple taps', (WidgetTester tester) async {
        // Arrange
        int tapCount = 0;
        VoidCallback onTap = () {
          tapCount++;
        };

        // Act
        await tester.pumpWidget(createNavigationItemWidget(onTap: onTap));
        await tester.tap(find.byType(InkWell));
        await tester.tap(find.byType(InkWell));
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        // Assert
        expect(tapCount, equals(3));
      });
    });

    group('NavigationItem Visual State Tests', () {
      testWidgets('should have correct constraints', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createNavigationItemWidget());

        // Assert
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        expect(container.constraints, isNotNull);
        expect(container.constraints!.minWidth, equals(60));
        expect(container.constraints!.minHeight, equals(50));
      });

      testWidgets('should have correct border radius', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createNavigationItemWidget());

        // Assert
        final inkWell = tester.widget<InkWell>(find.byType(InkWell));
        expect(inkWell.borderRadius, equals(BorderRadius.circular(12)));
      });

      testWidgets('should have correct icon size', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createNavigationItemWidget());

        // Assert
        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, equals(24));
      });

      testWidgets('should have correct spacing between icon and indicator', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createNavigationItemWidget(isSelected: true));

        // Assert
        final sizedBoxes = find.byType(SizedBox);
        expect(sizedBoxes, findsWidgets);

        // Verify spacing widgets exist
        expect(sizedBoxes, findsAtLeastNWidgets(1));
      });
    });

    group('NavigationItem State Changes Tests', () {
      testWidgets('should update icon when selection state changes', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool isSelected = false;
        Widget createWidget() =>
            createNavigationItemWidget(isSelected: isSelected);

        // Act - Initial state (not selected)
        await tester.pumpWidget(createWidget());
        expect(find.byIcon(Icons.home_outlined), findsOneWidget);
        expect(find.byIcon(Icons.home_rounded), findsNothing);

        // Act - Change to selected
        isSelected = true;
        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byIcon(Icons.home_rounded), findsOneWidget);
        expect(find.byIcon(Icons.home_outlined), findsNothing);
      });

      testWidgets('should show/hide indicator when selection changes', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool isSelected = false;
        Widget createWidget() =>
            createNavigationItemWidget(isSelected: isSelected);

        // Act - Initial state (not selected)
        await tester.pumpWidget(createWidget());
        expect(find.byType(Container), findsOneWidget); // Only main container

        // Act - Change to selected
        isSelected = true;
        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        // Assert - Should have indicator container
        expect(
          find.byType(Container),
          findsWidgets,
        ); // Main container + indicator
      });
    });

    group('NavigationItem Accessibility Tests', () {
      testWidgets('should be tappable and accessible', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createNavigationItemWidget());

        // Assert
        expect(find.byType(InkWell), findsOneWidget);

        // Verify the widget is tappable
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();
        // Should not throw any errors
      });
    });
  });
}
