import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/service/product_repository.dart';
import 'package:arya/features/addproduct/service/image_service.dart';
import 'package:arya/features/addproduct/model/add_product_model.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as off;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'add_product_viewmodel_test.mocks.dart';

@GenerateMocks([IProductRepository, IImageService, fb.FirebaseAuth, fb.User])
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
        expect(viewModel.sodiumController, isNotNull);
        expect(viewModel.fiberController, isNotNull);
        expect(viewModel.sugarController, isNotNull);
        expect(viewModel.allergensController, isNotNull);
        expect(viewModel.tagsController, isNotNull);
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

    group('Form Validation Tests', () {
      test('should have form key', () {
        // Assert
        expect(viewModel.formKey, isNotNull);
        expect(viewModel.formKey, isA<GlobalKey<FormState>>());
      });

      test('should validate individual fields correctly', () {
        // Test barcode validation
        expect(AddProductModel.validateBarcode('1234567890123'), isNull);
        expect(AddProductModel.validateBarcode(''), isNotNull);
        expect(AddProductModel.validateBarcode('1234567'), isNotNull);

        // Test name validation
        expect(AddProductModel.validateName('Test Product'), isNull);
        expect(AddProductModel.validateName(''), isNotNull);
        expect(AddProductModel.validateName('A'), isNotNull);

        // Test brands validation
        expect(AddProductModel.validateBrands('Test Brand'), isNull);
        expect(AddProductModel.validateBrands(''), isNotNull);

        // Test categories validation
        expect(AddProductModel.validateCategories('Test Category'), isNull);
        expect(AddProductModel.validateCategories(''), isNotNull);

        // Test quantity validation
        expect(AddProductModel.validateQuantity('100g'), isNull);
        expect(AddProductModel.validateQuantity(''), isNotNull);

        // Test ingredients validation
        expect(AddProductModel.validateIngredients('Test ingredients'), isNull);
        expect(AddProductModel.validateIngredients(''), isNotNull);
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

    group('Image Management Tests', () {
      test('should have image management getters', () {
        // Assert
        expect(viewModel.selectedImage, isNull);
        expect(viewModel.isImageUploading, isFalse);
      });

      test('should remove selected image', () {
        // Act
        viewModel.removeSelectedImage();

        // Assert
        expect(viewModel.selectedImage, isNull);
      });

      test('should handle image operations without crashing', () async {
        // These methods will fail in test environment but should not crash
        await viewModel.pickImageFromGallery();
        await viewModel.takePhotoWithCamera();

        // Should not throw exceptions
        expect(viewModel.selectedImage, isNull);
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

  group('AddProductViewModel with Mocks Tests', () {
    late AddProductViewModel viewModel;
    late MockIProductRepository mockProductRepository;
    late MockIImageService mockImageService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;

    setUp(() {
      mockProductRepository = MockIProductRepository();
      mockImageService = MockIImageService();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();

      viewModel = AddProductViewModel(
        productRepository: mockProductRepository,
        imageService: mockImageService,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Dependency Injection Tests', () {
      test('should use injected dependencies', () {
        // Arrange
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Assert
        expect(viewModel, isNotNull);
        // ViewModel should be created with mock dependencies
        expect(viewModel.selectedImage, isNull);
        expect(viewModel.isImageUploading, isFalse);
      });

      test('should handle image service operations', () async {
        // Arrange
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => null);
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenAnswer((_) async => null);
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act
        await viewModel.pickImageFromGallery();
        await viewModel.takePhotoWithCamera();
        viewModel.removeSelectedImage();

        // Assert
        verify(mockImageService.pickImageFromGallery()).called(1);
        verify(mockImageService.takePhotoWithCamera()).called(1);
        verify(mockImageService.removeSelectedImage()).called(1);
      });
    });

    group('AddProduct Method Tests', () {
      test('should have addProduct method', () {
        // Assert
        expect(viewModel.addProduct, isNotNull);
        expect(viewModel.addProduct, isA<Function>());
      });
    });

    group('Form Reset Tests', () {
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
    });
  });
}
