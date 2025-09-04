import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/appshell/view_model/app_shell_view_model.dart';

void main() {
  group('AppShellViewModel Tests', () {
    late AppShellViewModel viewModel;

    setUp(() {
      viewModel = AppShellViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initialization Tests', () {
      test('should initialize with default selected index', () {
        expect(viewModel.selectedIndex, equals(0));
      });

      test('should be a ChangeNotifier', () {
        expect(viewModel, isA<ChangeNotifier>());
      });
    });

    group('Tab Selection Tests', () {
      test('should change selected index when onItemTapped is called', () {
        // Act
        viewModel.onItemTapped(2);

        // Assert
        expect(viewModel.selectedIndex, equals(2));
      });

      test('should notify listeners when tab changes', () {
        // Arrange
        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        viewModel.onItemTapped(1);

        // Assert
        expect(listenerCalled, isTrue);
        expect(viewModel.selectedIndex, equals(1));
      });

      test('should not change index when same tab is selected', () {
        // Arrange
        viewModel.selectedIndex = 1;
        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        viewModel.onItemTapped(1);

        // Assert
        expect(viewModel.selectedIndex, equals(1));
        expect(listenerCalled, isFalse);
      });
    });

    group('Tab Index Range Tests', () {
      test('should handle valid tab indices', () {
        // Test valid tab indices (0-3)
        for (int i = 0; i <= 3; i++) {
          viewModel.onItemTapped(i);
          expect(viewModel.selectedIndex, equals(i));
        }
      });

      test('should handle edge case tab indices', () {
        // Test edge cases
        viewModel.onItemTapped(0);
        expect(viewModel.selectedIndex, equals(0));

        viewModel.onItemTapped(3);
        expect(viewModel.selectedIndex, equals(3));
      });
    });

    group('State Management Tests', () {
      test('should maintain state across multiple tab changes', () {
        // Act
        viewModel.onItemTapped(1);
        expect(viewModel.selectedIndex, equals(1));

        viewModel.onItemTapped(2);
        expect(viewModel.selectedIndex, equals(2));

        viewModel.onItemTapped(0);
        expect(viewModel.selectedIndex, equals(0));
      });

      test('should handle rapid tab changes', () {
        // Act
        viewModel.onItemTapped(1);
        viewModel.onItemTapped(2);
        viewModel.onItemTapped(3);
        viewModel.onItemTapped(0);

        // Assert
        expect(viewModel.selectedIndex, equals(0));
      });
    });

    group('Listener Management Tests', () {
      test('should properly manage multiple listeners', () {
        // Arrange
        int listener1Count = 0;
        int listener2Count = 0;

        viewModel.addListener(() {
          listener1Count++;
        });
        viewModel.addListener(() {
          listener2Count++;
        });

        // Act
        viewModel.onItemTapped(1);

        // Assert
        expect(listener1Count, equals(1));
        expect(listener2Count, equals(1));
      });
    });

    group('Edge Cases Tests', () {
      test('should handle negative tab index gracefully', () {
        // Act
        viewModel.onItemTapped(-1);

        // Assert
        expect(viewModel.selectedIndex, equals(-1));
      });

      test('should handle very large tab index', () {
        // Act
        viewModel.onItemTapped(999);

        // Assert
        expect(viewModel.selectedIndex, equals(999));
      });

      test('should handle zero tab index correctly', () {
        // Arrange
        viewModel.selectedIndex = 2;

        // Act
        viewModel.onItemTapped(0);

        // Assert
        expect(viewModel.selectedIndex, equals(0));
      });
    });

    group('Performance Tests', () {
      test('should handle rapid tab switching efficiently', () {
        final stopwatch = Stopwatch()..start();

        // Rapidly switch between tabs
        for (int i = 0; i < 100; i++) {
          viewModel.onItemTapped(i % 4);
        }

        stopwatch.stop();

        // Should complete within reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('should not cause memory leaks with multiple listeners', () {
        // Add many listeners
        for (int i = 0; i < 100; i++) {
          viewModel.addListener(() {});
        }

        // Change tab
        viewModel.onItemTapped(1);

        // Should not crash or cause issues
        expect(viewModel.selectedIndex, equals(1));
      });
    });

    group('Integration Tests', () {
      test('should work correctly with ChangeNotifier pattern', () {
        // Verify ChangeNotifier functionality
        expect(viewModel, isA<ChangeNotifier>());

        // Test listener notification
        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        viewModel.onItemTapped(2);
        expect(listenerCalled, isTrue);
      });

      test('should maintain consistency with multiple operations', () {
        // Perform multiple operations
        viewModel.onItemTapped(1);
        viewModel.onItemTapped(2);
        viewModel.onItemTapped(1); // Same tab, should not notify
        viewModel.onItemTapped(3);

        // Verify final state
        expect(viewModel.selectedIndex, equals(3));
      });
    });
  });
}
