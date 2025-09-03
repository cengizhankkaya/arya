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
  });
}
