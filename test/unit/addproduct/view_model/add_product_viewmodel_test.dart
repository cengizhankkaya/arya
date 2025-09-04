import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddProductViewModel Tests', () {
    late AddProductViewModel viewModel;

    setUp(() {
      viewModel = AddProductViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initialization Tests', () {
      test('should be a ChangeNotifier', () {
        expect(viewModel, isA<ChangeNotifier>());
      });

      test('should have form controllers', () {
        expect(viewModel.nameController, isNotNull);
        expect(viewModel.descriptionController, isNotNull);
        expect(viewModel.barcodeController, isNotNull);
        expect(viewModel.brandsController, isNotNull);
        expect(viewModel.categoriesController, isNotNull);
        expect(viewModel.quantityController, isNotNull);
        expect(viewModel.energyController, isNotNull);
        expect(viewModel.fatController, isNotNull);
        expect(viewModel.carbsController, isNotNull);
        expect(viewModel.proteinController, isNotNull);
        expect(viewModel.ingredientsController, isNotNull);
      });
    });

    group('Form State Management Tests', () {
      test('should set loading state correctly', () {
        // Act
        viewModel.setLoading(true);

        // Assert
        expect(viewModel.isLoading, isTrue);
      });

      test('should set error message correctly', () {
        // Act
        const errorMessage = 'Test error message';
        viewModel.setError(errorMessage);

        // Assert
        expect(viewModel.errorMessage, equals(errorMessage));
        expect(viewModel.successMessage, isNull);
        expect(viewModel.isLoading, isFalse);
      });

      test('should set success message correctly', () {
        // Act
        const successMessage = 'Test success message';
        viewModel.setSuccess(successMessage);

        // Assert
        expect(viewModel.successMessage, equals(successMessage));
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.isLoading, isFalse);
      });

      test('should clear messages correctly', () {
        // Arrange
        viewModel.setError('Error message');
        viewModel.setSuccess('Success message');

        // Act
        viewModel.clearMessages();

        // Assert
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.successMessage, isNull);
      });
    });

    group('Edge Cases Tests', () {
      test('should handle very long text inputs', () {
        // Act
        final longText = 'a' * 1000;
        viewModel.nameController.text = longText;

        // Assert
        expect(viewModel.nameController.text, equals(longText));
      });

      test('should handle special characters in text fields', () {
        // Act
        final specialText = 'Test@#\$%^&*()_+{}|:"<>?[]\\\\;\',./';
        viewModel.nameController.text = specialText;

        // Assert
        expect(viewModel.nameController.text, equals(specialText));
      });

      test('should handle empty strings in text fields', () {
        // Act
        viewModel.nameController.text = '';
        viewModel.descriptionController.text = '';

        // Assert
        expect(viewModel.nameController.text, isEmpty);
        expect(viewModel.descriptionController.text, isEmpty);
      });
    });

    group('Performance Tests', () {
      test('should handle rapid state changes efficiently', () {
        final stopwatch = Stopwatch()..start();

        // Rapidly change states
        for (int i = 0; i < 100; i++) {
          viewModel.setLoading(true);
          viewModel.setLoading(false);
        }

        stopwatch.stop();

        // Should complete within reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('should handle multiple listeners efficiently', () {
        // Add many listeners
        for (int i = 0; i < 50; i++) {
          viewModel.addListener(() {});
        }

        // Change state
        viewModel.setLoading(true);

        // Should not crash or cause issues
        expect(viewModel.isLoading, isTrue);
      });
    });
  });
}
