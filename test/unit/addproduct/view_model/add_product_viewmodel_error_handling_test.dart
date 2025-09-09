import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/service/product_repository.dart';
import 'package:arya/features/addproduct/service/image_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';

import 'add_product_viewmodel_error_handling_test.mocks.dart';

@GenerateMocks([
  IProductRepository,
  IImageService,
  fb.FirebaseAuth,
  fb.User,
  Dio,
  DioException,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddProductViewModel Error Handling Tests', () {
    late AddProductViewModel viewModel;
    late MockIProductRepository mockProductRepository;
    late MockIImageService mockImageService;

    setUp(() {
      mockProductRepository = MockIProductRepository();
      mockImageService = MockIImageService();

      // Default mock setup
      when(mockImageService.selectedImage).thenReturn(null);
      when(mockImageService.isImageUploading).thenReturn(false);
      when(
        mockImageService.pickImageFromGallery(),
      ).thenAnswer((_) async => null);
      when(
        mockImageService.takePhotoWithCamera(),
      ).thenAnswer((_) async => null);
      when(mockImageService.removeSelectedImage()).thenReturn(null);

      viewModel = AddProductViewModel(
        productRepository: mockProductRepository,
        imageService: mockImageService,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Error State Management Tests', () {
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

      test('should clear error message when setting success', () {
        // Arrange
        viewModel.setError('Test error message');

        // Act
        viewModel.setSuccess('Test success message');

        // Assert
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.successMessage, equals('Test success message'));
      });

      test('should clear success message when setting error', () {
        // Arrange
        viewModel.setSuccess('Test success message');

        // Act
        viewModel.setError('Test error message');

        // Assert
        expect(viewModel.successMessage, isNull);
        expect(viewModel.errorMessage, equals('Test error message'));
      });

      test('should clear both messages when clearing messages', () {
        // Arrange
        viewModel.setError('Test error message');
        viewModel.setSuccess('Test success message');

        // Act
        viewModel.clearMessages();

        // Assert
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.successMessage, isNull);
      });

      test('should set loading state correctly', () {
        // Act
        viewModel.setLoading(true);

        // Assert
        expect(viewModel.isLoading, isTrue);
      });

      test('should set loading to false when error occurs', () {
        // Arrange
        viewModel.setLoading(true);

        // Act
        viewModel.setError('Test error');

        // Assert
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.errorMessage, equals('Test error'));
      });

      test('should set loading to false when success occurs', () {
        // Arrange
        viewModel.setLoading(true);

        // Act
        viewModel.setSuccess('Test success');

        // Assert
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.successMessage, equals('Test success'));
      });
    });

    group('Image Service Error Tests', () {
      test('should handle image picker exception from gallery', () async {
        // Arrange
        when(
          mockImageService.pickImageFromGallery(),
        ).thenThrow(Exception('Gallery access denied'));

        // Act & Assert
        expect(
          () async => await viewModel.pickImageFromGallery(),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle image picker exception from camera', () async {
        // Arrange
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenThrow(Exception('Camera access denied'));

        // Act & Assert
        expect(
          () async => await viewModel.takePhotoWithCamera(),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle image service null return', () async {
        // Arrange
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => null);

        // Act
        await viewModel.pickImageFromGallery();

        // Assert
        expect(viewModel.selectedImage, isNull);
        verify(mockImageService.pickImageFromGallery()).called(1);
      });

      test('should handle image service operations without crashing', () async {
        // Arrange
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => null);
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenAnswer((_) async => null);

        // Act
        await viewModel.pickImageFromGallery();
        await viewModel.takePhotoWithCamera();
        viewModel.removeSelectedImage();

        // Assert
        expect(viewModel.selectedImage, isNull);
        verify(mockImageService.pickImageFromGallery()).called(1);
        verify(mockImageService.takePhotoWithCamera()).called(1);
        verify(mockImageService.removeSelectedImage()).called(1);
      });
    });

    group('Form State Tests', () {
      test('should have form controllers', () {
        // Assert
        expect(viewModel.barcodeController, isNotNull);
        expect(viewModel.nameController, isNotNull);
        expect(viewModel.brandsController, isNotNull);
        expect(viewModel.categoriesController, isNotNull);
        expect(viewModel.quantityController, isNotNull);
        expect(viewModel.ingredientsController, isNotNull);
      });

      test('should clear form controllers', () {
        // Arrange
        viewModel.barcodeController.text = '1234567890123';
        viewModel.nameController.text = 'Test Product';
        viewModel.brandsController.text = 'Test Brand';
        viewModel.categoriesController.text = 'Test Category';
        viewModel.quantityController.text = '100g';
        viewModel.ingredientsController.text = 'Test ingredients';

        // Act
        viewModel.clearForm();

        // Assert
        expect(viewModel.barcodeController.text, isEmpty);
        expect(viewModel.nameController.text, isEmpty);
        expect(viewModel.brandsController.text, isEmpty);
        expect(viewModel.categoriesController.text, isEmpty);
        expect(viewModel.quantityController.text, isEmpty);
        expect(viewModel.ingredientsController.text, isEmpty);
      });

      test('should handle text input changes', () {
        // Act
        viewModel.barcodeController.text = '1234567890123';
        viewModel.nameController.text = 'Test Product';

        // Assert
        expect(viewModel.barcodeController.text, equals('1234567890123'));
        expect(viewModel.nameController.text, equals('Test Product'));
      });

      test('should handle special characters in text fields', () {
        // Act
        final specialText = 'Test@#\$%^&*()_+{}|:"<>?[]\\\\;\',./';
        viewModel.nameController.text = specialText;

        // Assert
        expect(viewModel.nameController.text, equals(specialText));
      });

      test('should handle very long text inputs', () {
        // Act
        final longText = 'a' * 1000;
        viewModel.nameController.text = longText;

        // Assert
        expect(viewModel.nameController.text, equals(longText));
      });
    });

    group('Dependency Injection Tests', () {
      test('should use injected dependencies', () {
        // Arrange
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Assert
        expect(viewModel, isNotNull);
        expect(viewModel.selectedImage, isNull);
        expect(viewModel.isImageUploading, isFalse);
      });

      test('should handle image service getters', () {
        // Arrange
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Assert
        expect(viewModel.selectedImage, isNull);
        expect(viewModel.isImageUploading, isFalse);
      });
    });

    group('Edge Cases Tests', () {
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
      test('should handle rapid error/success state changes', () {
        final stopwatch = Stopwatch()..start();

        // Rapidly change error/success states
        for (int i = 0; i < 50; i++) {
          viewModel.setError('Error $i');
          viewModel.setSuccess('Success $i');
        }

        stopwatch.stop();

        // Should complete within reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
      });

      test('should handle rapid loading state changes', () {
        final stopwatch = Stopwatch()..start();

        // Rapidly change loading states
        for (int i = 0; i < 100; i++) {
          viewModel.setLoading(true);
          viewModel.setLoading(false);
        }

        stopwatch.stop();

        // Should complete within reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });

    group('Error Recovery Tests', () {
      test('should allow state changes after error', () {
        // Arrange
        viewModel.setError('Test error');

        // Act
        viewModel.setSuccess('Test success');

        // Assert
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.successMessage, equals('Test success'));
      });

      test('should allow state changes after success', () {
        // Arrange
        viewModel.setSuccess('Test success');

        // Act
        viewModel.setError('Test error');

        // Assert
        expect(viewModel.successMessage, isNull);
        expect(viewModel.errorMessage, equals('Test error'));
      });

      test('should handle multiple error messages', () {
        // Act
        viewModel.setError('First error');
        viewModel.setError('Second error');
        viewModel.setError('Third error');

        // Assert
        expect(viewModel.errorMessage, equals('Third error'));
        expect(viewModel.successMessage, isNull);
      });

      test('should handle multiple success messages', () {
        // Act
        viewModel.setSuccess('First success');
        viewModel.setSuccess('Second success');
        viewModel.setSuccess('Third success');

        // Assert
        expect(viewModel.successMessage, equals('Third success'));
        expect(viewModel.errorMessage, isNull);
      });
    });
  });
}
