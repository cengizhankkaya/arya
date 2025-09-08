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

      test('should not notify listeners when same tab is selected', () {
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

      test('should handle valid tab indices (0-3)', () {
        // Test valid tab indices
        for (int i = 0; i <= 3; i++) {
          viewModel.onItemTapped(i);
          expect(viewModel.selectedIndex, equals(i));
        }
      });

      test('should handle invalid negative index', () {
        // Act
        viewModel.onItemTapped(-1);

        // Assert - Should accept the invalid index (current implementation behavior)
        expect(viewModel.selectedIndex, equals(-1));
      });

      test('should handle invalid large index', () {
        // Act
        viewModel.onItemTapped(999);

        // Assert - Should accept the invalid index (current implementation behavior)
        expect(viewModel.selectedIndex, equals(999));
      });

      test('should handle edge case index 0', () {
        // Arrange
        viewModel.selectedIndex = 2;

        // Act
        viewModel.onItemTapped(0);

        // Assert
        expect(viewModel.selectedIndex, equals(0));
      });

      test('should handle edge case index 3', () {
        // Arrange
        viewModel.selectedIndex = 0;

        // Act
        viewModel.onItemTapped(3);

        // Assert
        expect(viewModel.selectedIndex, equals(3));
      });
    });

    group('Listener Management Tests', () {
      test('should notify multiple listeners when tab changes', () {
        // Arrange
        bool listener1Called = false;
        bool listener2Called = false;
        bool listener3Called = false;

        viewModel.addListener(() {
          listener1Called = true;
        });
        viewModel.addListener(() {
          listener2Called = true;
        });
        viewModel.addListener(() {
          listener3Called = true;
        });

        // Act
        viewModel.onItemTapped(2);

        // Assert
        expect(listener1Called, isTrue);
        expect(listener2Called, isTrue);
        expect(listener3Called, isTrue);
        expect(viewModel.selectedIndex, equals(2));
      });

      test('should not notify removed listeners', () {
        // Arrange
        bool listener1Called = false;
        bool listener2Called = false;

        VoidCallback listener1 = () {
          listener1Called = true;
        };
        VoidCallback listener2 = () {
          listener2Called = true;
        };

        viewModel.addListener(listener1);
        viewModel.addListener(listener2);

        // Remove first listener
        viewModel.removeListener(listener1);

        // Act
        viewModel.onItemTapped(1);

        // Assert
        expect(listener1Called, isFalse);
        expect(listener2Called, isTrue);
        expect(viewModel.selectedIndex, equals(1));
      });

      test('should handle listener removal gracefully', () {
        // Arrange
        VoidCallback listener = () {};

        // Act & Assert - Should not throw
        expect(() => viewModel.removeListener(listener), returnsNormally);
      });
    });

    group('Dispose Tests', () {
      test('should handle operations before dispose', () {
        // Arrange
        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act - Operations before dispose should work
        viewModel.onItemTapped(1);

        // Assert
        expect(viewModel.selectedIndex, equals(1));
        expect(listenerCalled, isTrue);
      });
    });

    group('State Persistence Tests', () {
      test('should maintain state across multiple rapid changes', () {
        // Act - Rapid state changes
        viewModel.onItemTapped(1);
        viewModel.onItemTapped(2);
        viewModel.onItemTapped(3);
        viewModel.onItemTapped(0);
        viewModel.onItemTapped(2);

        // Assert
        expect(viewModel.selectedIndex, equals(2));
      });

      test('should handle same index selection multiple times', () {
        // Arrange
        viewModel.selectedIndex = 1;
        int notificationCount = 0;
        viewModel.addListener(() {
          notificationCount++;
        });

        // Act - Select same index multiple times
        viewModel.onItemTapped(1);
        viewModel.onItemTapped(1);
        viewModel.onItemTapped(1);

        // Assert
        expect(viewModel.selectedIndex, equals(1));
        expect(notificationCount, equals(0)); // Should not notify
      });
    });
  });
}
