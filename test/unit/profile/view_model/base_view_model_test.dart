import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/profile/view_model/base_view_model.dart';

// Concrete implementation for testing abstract class
class TestBaseViewModel extends BaseViewModel {
  Future<String> testAsyncOperation() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return 'test result';
  }

  Future<void> testAsyncOperationWithError() async {
    await Future.delayed(const Duration(milliseconds: 10));
    throw Exception('Test error');
  }

  void testSetLoading(bool value) {
    setLoading(value);
  }

  void testShowError(BuildContext context, String message) {
    showError(context, message);
  }

  void testShowSuccess(BuildContext context, String message) {
    showSuccess(context, message);
  }

  Future<String> testWithLoading() async {
    return await withLoading(() async {
      await Future.delayed(const Duration(milliseconds: 10));
      return 'withLoading result';
    });
  }

  Future<void> testWithLoadingError() async {
    await withLoading(() async {
      await Future.delayed(const Duration(milliseconds: 10));
      throw Exception('withLoading error');
    });
  }

  @override
  void dispose() {
    // Override to avoid ChangeNotifier restrictions in tests
    super.dispose();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BaseViewModel Tests', () {
    late TestBaseViewModel viewModel;

    setUp(() {
      viewModel = TestBaseViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initialization Tests', () {
      test('should initialize with default loading state', () {
        // Assert
        expect(viewModel.loading, isFalse);
      });

      test('should be a ChangeNotifier', () {
        // Assert
        expect(viewModel, isA<ChangeNotifier>());
      });
    });

    group('Loading State Management Tests', () {
      test('should set loading state to true', () {
        // Act
        viewModel.testSetLoading(true);

        // Assert
        expect(viewModel.loading, isTrue);
      });

      test('should set loading state to false', () {
        // Arrange
        viewModel.testSetLoading(true);

        // Act
        viewModel.testSetLoading(false);

        // Assert
        expect(viewModel.loading, isFalse);
      });

      test('should notify listeners when loading state changes', () {
        // Arrange
        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        viewModel.testSetLoading(true);

        // Assert
        expect(listenerCalled, isTrue);
      });

      test('should handle multiple loading state changes', () {
        // Act & Assert
        expect(viewModel.loading, isFalse);

        viewModel.testSetLoading(true);
        expect(viewModel.loading, isTrue);

        viewModel.testSetLoading(false);
        expect(viewModel.loading, isFalse);

        viewModel.testSetLoading(true);
        expect(viewModel.loading, isTrue);
      });
    });

    group('WithLoading Utility Tests', () {
      test(
        'should execute async operation with loading state management',
        () async {
          // Act
          final result = await viewModel.testWithLoading();

          // Assert
          expect(result, equals('withLoading result'));
          expect(viewModel.loading, isFalse);
        },
      );

      test('should set loading to true before operation', () async {
        // Arrange
        bool loadingSet = false;
        viewModel.addListener(() {
          if (viewModel.loading) {
            loadingSet = true;
          }
        });

        // Act
        await viewModel.testWithLoading();

        // Assert
        expect(loadingSet, isTrue);
      });

      test('should set loading to false after operation completion', () async {
        // Act
        await viewModel.testWithLoading();

        // Assert
        expect(viewModel.loading, isFalse);
      });

      test('should set loading to false after operation error', () async {
        // Act
        try {
          await viewModel.testWithLoadingError();
        } catch (e) {
          // Expected error
        }

        // Assert
        expect(viewModel.loading, isFalse);
      });

      test('should return operation result correctly', () async {
        // Act
        final result = await viewModel.testWithLoading();

        // Assert
        expect(result, equals('withLoading result'));
      });

      test('should propagate operation errors', () async {
        // Act & Assert
        expect(
          () => viewModel.testWithLoadingError(),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle multiple withLoading operations', () async {
        // Act
        final result1 = await viewModel.testWithLoading();
        final result2 = await viewModel.testWithLoading();

        // Assert
        expect(result1, equals('withLoading result'));
        expect(result2, equals('withLoading result'));
        expect(viewModel.loading, isFalse);
      });
    });

    group('Integration Tests', () {
      test('should manage loading state during complex operation', () async {
        // Arrange
        bool loadingStarted = false;
        bool loadingFinished = false;
        viewModel.addListener(() {
          if (viewModel.loading) {
            loadingStarted = true;
          } else if (loadingStarted) {
            loadingFinished = true;
          }
        });

        // Act
        await viewModel.testWithLoading();

        // Assert
        expect(loadingStarted, isTrue);
        expect(loadingFinished, isTrue);
        expect(viewModel.loading, isFalse);
      });

      test('should handle rapid state changes', () {
        // Act
        for (int i = 0; i < 10; i++) {
          viewModel.testSetLoading(i.isEven);
        }

        // Assert
        expect(viewModel.loading, isFalse);
      });

      test('should maintain consistency during multiple operations', () async {
        // Act
        final futures = <Future<String>>[];
        for (int i = 0; i < 5; i++) {
          futures.add(viewModel.testWithLoading());
        }

        final results = await Future.wait(futures);

        // Assert
        expect(results.length, equals(5));
        expect(results.every((r) => r == 'withLoading result'), isTrue);
        expect(viewModel.loading, isFalse);
      });
    });

    group('withLoading Tests', () {
      test('should return result from async operation', () async {
        // Act
        final result = await viewModel.testWithLoading();

        // Assert
        expect(result, equals('withLoading result'));
        expect(viewModel.loading, isFalse);
      });

      test(
        'should set loading to false even when operation throws error',
        () async {
          // Act & Assert
          expect(() => viewModel.testWithLoadingError(), throwsException);

          // Wait a bit to ensure the finally block executes
          await Future.delayed(Duration(milliseconds: 50));
          expect(viewModel.loading, isFalse);
        },
      );

      test('should set loading to true during operation', () async {
        // Arrange
        bool loadingDuringOperation = false;
        viewModel.addListener(() {
          if (viewModel.loading) {
            loadingDuringOperation = true;
          }
        });

        // Act
        await viewModel.testWithLoading();

        // Assert
        expect(loadingDuringOperation, isTrue);
        expect(viewModel.loading, isFalse);
      });
    });

    group('Dispose Tests', () {
      test('should complete disposal without throwing', () {
        // Arrange
        final testViewModel = TestBaseViewModel();

        // Act & Assert - Dispose should not throw
        expect(() => testViewModel.dispose(), returnsNormally);
      });

      test('should handle disposal gracefully', () {
        // Arrange
        final testViewModel = TestBaseViewModel();

        // Act & Assert - Dispose should complete successfully
        testViewModel.dispose();
        expect(testViewModel, isNotNull);
      });
    });

    group('SnackBar Message Tests', () {
      testWidgets('should show error message in SnackBar', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () =>
                        viewModel.testShowError(context, 'Test error'),
                    child: Text('Show Error'),
                  );
                },
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Show Error'));
        await tester.pump();

        // Assert
        expect(find.text('Test error'), findsOneWidget);
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('should show success message in SnackBar', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () =>
                        viewModel.testShowSuccess(context, 'Test success'),
                    child: Text('Show Success'),
                  );
                },
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Show Success'));
        await tester.pump();

        // Assert
        expect(find.text('Test success'), findsOneWidget);
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('should show SnackBar with correct styling', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () =>
                        viewModel.testShowError(context, 'Styled error'),
                    child: Text('Show Styled Error'),
                  );
                },
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Show Styled Error'));
        await tester.pump();

        // Assert
        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.content, isA<Text>());
        expect((snackBar.content as Text).data, equals('Styled error'));
      });
    });

    group('Edge Cases Tests', () {
      test('should handle rapid loading state changes', () {
        // Act - Rapid state changes
        viewModel.testSetLoading(true);
        viewModel.testSetLoading(false);
        viewModel.testSetLoading(true);
        viewModel.testSetLoading(false);

        // Assert
        expect(viewModel.loading, isFalse);
      });

      test('should handle multiple listeners correctly', () {
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
        viewModel.testSetLoading(true);

        // Assert
        expect(listener1Count, equals(1));
        expect(listener2Count, equals(1));
      });

      test('should handle withLoading with very fast operations', () async {
        // Act
        final result = await viewModel.withLoading(() async {
          return 'fast result';
        });

        // Assert
        expect(result, equals('fast result'));
        expect(viewModel.loading, isFalse);
      });
    });
  });
}
