import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/appshell/view_model/app_shell_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  group('AppShellView Bottom Navigation Tests', () {
    late AppShellViewModel viewModel;

    setUp(() {
      viewModel = AppShellViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });
    Widget _buildNavItem({
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

    Widget _buildTestBottomNavigation() {
      return Consumer<AppShellViewModel>(
        builder: (context, vm, child) {
          return Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: vm.selectedIndex == 0,
                  onTap: () => vm.onItemTapped(0),
                ),
                _buildNavItem(
                  icon: Icons.store_outlined,
                  activeIcon: Icons.store_rounded,
                  label: 'Store',
                  isSelected: vm.selectedIndex == 1,
                  onTap: () => vm.onItemTapped(1),
                ),
                _buildNavItem(
                  icon: Icons.shopping_cart_outlined,
                  activeIcon: Icons.shopping_cart_rounded,
                  label: 'Cart',
                  isSelected: vm.selectedIndex == 2,
                  onTap: () => vm.onItemTapped(2),
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                  isSelected: vm.selectedIndex == 3,
                  onTap: () => vm.onItemTapped(3),
                ),
              ],
            ),
          );
        },
      );
    }

    Widget createBottomNavigationWidget(AppShellViewModel viewModel) {
      return ChangeNotifierProvider<AppShellViewModel>.value(
        value: viewModel,
        child: MaterialApp(
          home: Scaffold(
            body: Container(),
            bottomNavigationBar: _buildTestBottomNavigation(),
          ),
        ),
      );
    }

    group('Bottom Navigation Rendering Tests', () {
      testWidgets('should render bottom navigation without errors', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createBottomNavigationWidget(viewModel));

        // Assert
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byIcon(Icons.home_rounded), findsOneWidget);
        expect(find.byIcon(Icons.store_outlined), findsOneWidget);
        expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
      });

      testWidgets('should show correct active tab indicator', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createBottomNavigationWidget(viewModel));
        await tester.pumpAndSettle();

        // Assert - First tab should be active by default
        expect(find.byIcon(Icons.home_rounded), findsOneWidget);
        expect(find.byIcon(Icons.home_outlined), findsNothing);
      });
    });

    group('Bottom Navigation Interaction Tests', () {
      testWidgets('should switch to store tab when tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createBottomNavigationWidget(viewModel));
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.byIcon(Icons.store_outlined));
        await tester.pumpAndSettle();

        // Assert
        expect(viewModel.selectedIndex, equals(1));
        expect(find.byIcon(Icons.store_rounded), findsOneWidget);
        expect(find.byIcon(Icons.store_outlined), findsNothing);
      });

      testWidgets('should switch to cart tab when tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createBottomNavigationWidget(viewModel));
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
        await tester.pumpAndSettle();

        // Assert
        expect(viewModel.selectedIndex, equals(2));
        expect(find.byIcon(Icons.shopping_cart_rounded), findsOneWidget);
        expect(find.byIcon(Icons.shopping_cart_outlined), findsNothing);
      });

      testWidgets('should switch to profile tab when tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createBottomNavigationWidget(viewModel));
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.byIcon(Icons.person_outline));
        await tester.pumpAndSettle();

        // Assert
        expect(viewModel.selectedIndex, equals(3));
        expect(find.byIcon(Icons.person_rounded), findsOneWidget);
        expect(find.byIcon(Icons.person_outline), findsNothing);
      });

      testWidgets('should return to home tab when tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createBottomNavigationWidget(viewModel));
        await tester.pumpAndSettle();

        // First switch to another tab
        await tester.tap(find.byIcon(Icons.store_outlined));
        await tester.pumpAndSettle();
        expect(viewModel.selectedIndex, equals(1));

        // Act - Tap on home tab (which should be outlined now)
        await tester.tap(find.byIcon(Icons.home_outlined));
        await tester.pumpAndSettle();

        // Assert
        expect(viewModel.selectedIndex, equals(0));
        expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      });
    });

    group('State Management Tests', () {
      testWidgets('should maintain state across widget rebuilds', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createBottomNavigationWidget(viewModel));
        await tester.pumpAndSettle();

        // Act - Switch to cart tab
        await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
        await tester.pumpAndSettle();
        expect(viewModel.selectedIndex, equals(2));

        // Rebuild widget
        await tester.pumpWidget(createBottomNavigationWidget(viewModel));
        await tester.pumpAndSettle();

        // Assert - State should be maintained
        expect(viewModel.selectedIndex, equals(2));
        expect(find.byIcon(Icons.shopping_cart_rounded), findsOneWidget);
      });

      testWidgets('should handle multiple rapid tab switches', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createBottomNavigationWidget(viewModel));
        await tester.pumpAndSettle();

        // Act - Rapid tab switching
        await tester.tap(find.byIcon(Icons.store_outlined));
        await tester.pump();
        await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
        await tester.pump();
        await tester.tap(find.byIcon(Icons.person_outline));
        await tester.pumpAndSettle();

        // Assert - Should end up on profile tab
        expect(viewModel.selectedIndex, equals(3));
        expect(find.byIcon(Icons.person_rounded), findsOneWidget);
      });
    });
  });
}
