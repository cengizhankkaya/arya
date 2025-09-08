// ignore_for_file: prefer_const_constructors

import 'package:arya/features/appshell/view_model/app_shell_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Navigation Flow Integration Tests', () {
    late AppShellViewModel viewModel;

    setUp(() {
      viewModel = AppShellViewModel();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Selected Index: ${viewModel.selectedIndex}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            viewModel.onItemTapped(0);
                            setState(() {});
                          },
                          child: Text('Home'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            viewModel.onItemTapped(1);
                            setState(() {});
                          },
                          child: Text('Store'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            viewModel.onItemTapped(2);
                            setState(() {});
                          },
                          child: Text('Cart'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            viewModel.onItemTapped(3);
                            setState(() {});
                          },
                          child: Text('Profile'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }

    testWidgets('should start with home tab selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Home tab should be selected by default
      expect(viewModel.selectedIndex, 0);
      expect(find.text('Selected Index: 0'), findsOneWidget);
    });

    testWidgets('should navigate to store tab when tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap store button
      final storeButton = find.text('Store');
      expect(storeButton, findsOneWidget);

      await tester.tap(storeButton);
      await tester.pumpAndSettle();

      // Store tab should be selected
      expect(viewModel.selectedIndex, 1);
      expect(find.text('Selected Index: 1'), findsOneWidget);
    });

    testWidgets('should navigate to cart tab when tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap cart button
      final cartButton = find.text('Cart');
      expect(cartButton, findsOneWidget);

      await tester.tap(cartButton);
      await tester.pumpAndSettle();

      // Cart tab should be selected
      expect(viewModel.selectedIndex, 2);
      expect(find.text('Selected Index: 2'), findsOneWidget);
    });

    testWidgets('should navigate to profile tab when tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap profile button
      final profileButton = find.text('Profile');
      expect(profileButton, findsOneWidget);

      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Profile tab should be selected
      expect(viewModel.selectedIndex, 3);
      expect(find.text('Selected Index: 3'), findsOneWidget);
    });

    testWidgets('should maintain state when switching between tabs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Navigate to store tab
      final storeButton = find.text('Store');
      await tester.tap(storeButton);
      await tester.pumpAndSettle();
      expect(viewModel.selectedIndex, 1);

      // Navigate to cart tab
      final cartButton = find.text('Cart');
      await tester.tap(cartButton);
      await tester.pumpAndSettle();
      expect(viewModel.selectedIndex, 2);

      // Navigate back to home tab
      final homeButton = find.text('Home');
      await tester.tap(homeButton);
      await tester.pumpAndSettle();
      expect(viewModel.selectedIndex, 0);

      // Navigate to profile tab
      final profileButton = find.text('Profile');
      await tester.tap(profileButton);
      await tester.pumpAndSettle();
      expect(viewModel.selectedIndex, 3);
    });

    testWidgets('should not change selection when tapping same tab', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Initially on home tab
      expect(viewModel.selectedIndex, 0);

      // Tap home button again
      final homeButton = find.text('Home');
      await tester.tap(homeButton);
      await tester.pumpAndSettle();

      // Should still be on home tab
      expect(viewModel.selectedIndex, 0);
    });

    testWidgets('should display all navigation buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check all navigation buttons are present
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Store'), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('should handle rapid tab switching', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Rapidly switch between tabs
      final storeButton = find.text('Store');
      final cartButton = find.text('Cart');
      final profileButton = find.text('Profile');
      final homeButton = find.text('Home');

      await tester.tap(storeButton);
      await tester.pump();
      await tester.tap(cartButton);
      await tester.pump();
      await tester.tap(profileButton);
      await tester.pump();
      await tester.tap(homeButton);
      await tester.pumpAndSettle();

      // Should end up on home tab
      expect(viewModel.selectedIndex, 0);
      expect(find.text('Selected Index: 0'), findsOneWidget);
    });

    testWidgets('should update UI when viewModel changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Initially should show index 0
      expect(find.text('Selected Index: 0'), findsOneWidget);

      // Use button to change viewModel (which triggers setState)
      final cartButton = find.text('Cart');
      await tester.tap(cartButton);
      await tester.pumpAndSettle();

      // UI should update to show index 2
      expect(find.text('Selected Index: 2'), findsOneWidget);
    });

    testWidgets('should handle edge case navigation indices', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test navigation to all valid indices using buttons
      final buttons = ['Home', 'Store', 'Cart', 'Profile'];
      for (int i = 0; i < 4; i++) {
        final button = find.text(buttons[i]);
        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(viewModel.selectedIndex, i);
        expect(find.text('Selected Index: $i'), findsOneWidget);
      }
    });

    testWidgets('should maintain consistent state across multiple taps', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Navigate to different tabs multiple times
      final buttons = ['Home', 'Store', 'Cart', 'Profile'];
      final expectedIndices = [0, 1, 2, 3];

      for (int round = 0; round < 3; round++) {
        for (int i = 0; i < buttons.length; i++) {
          final button = find.text(buttons[i]);
          await tester.tap(button);
          await tester.pumpAndSettle();

          expect(viewModel.selectedIndex, expectedIndices[i]);
          expect(
            find.text('Selected Index: ${expectedIndices[i]}'),
            findsOneWidget,
          );
        }
      }
    });
  });
}
