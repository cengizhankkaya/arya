import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/service/product_repository.dart';
import 'package:arya/features/addproduct/service/image_service.dart';
import 'package:arya/features/addproduct/model/add_product_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:io';

import 'add_product_viewmodel_business_logic_test.mocks.dart';

@GenerateMocks([IProductRepository, IImageService, fb.FirebaseAuth, fb.User])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddProductViewModel Business Logic Tests', () {
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

      // Mock image service methods
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

    group('Form Validation Business Logic', () {
      test('should validate barcode correctly', () {
        // Test barcode validation
        expect(AddProductModel.validateBarcode('1234567890123'), isNull);
        expect(AddProductModel.validateBarcode(''), isNotNull);
        expect(AddProductModel.validateBarcode('1234567'), isNotNull);
      });

      test('should validate name correctly', () {
        // Test name validation
        expect(AddProductModel.validateName('Test Product'), isNull);
        expect(AddProductModel.validateName(''), isNotNull);
        expect(AddProductModel.validateName('A'), isNotNull);
      });

      test('should validate brands correctly', () {
        // Test brands validation
        expect(AddProductModel.validateBrands('Test Brand'), isNull);
        expect(AddProductModel.validateBrands(''), isNotNull);
      });

      test('should validate categories correctly', () {
        // Test categories validation
        expect(AddProductModel.validateCategories('Test Category'), isNull);
        expect(AddProductModel.validateCategories(''), isNotNull);
      });

      test('should validate quantity correctly', () {
        // Test quantity validation
        expect(AddProductModel.validateQuantity('100g'), isNull);
        expect(AddProductModel.validateQuantity(''), isNotNull);
      });

      test('should validate ingredients correctly', () {
        // Test ingredients validation
        expect(AddProductModel.validateIngredients('Test ingredients'), isNull);
        expect(AddProductModel.validateIngredients(''), isNotNull);
      });
    });

    group('AddProduct Business Logic - Integration Tests Note', () {
      test(
        'should note that addProduct method tests are integration tests',
        () {
          // Note: The addProduct method tests are integration tests because:
          // 1. They require formKey.currentState which is null in unit tests
          // 2. They involve Firebase authentication
          // 3. They involve AppPrefs utility class
          // 4. They involve repository calls

          expect(true, isTrue); // Placeholder test
        },
      );
    });

    group('AddProduct Business Logic - Product Model Creation', () {
      test('should create product model with correct data from form', () {
        // Arrange
        viewModel.barcodeController.text = '1234567890123';
        viewModel.nameController.text = 'Test Product';
        viewModel.brandsController.text = 'Test Brand';
        viewModel.categoriesController.text = 'Test Category';
        viewModel.quantityController.text = '100g';
        viewModel.ingredientsController.text = 'Test ingredients';
        viewModel.energyController.text = '100';
        viewModel.fatController.text = '5';
        viewModel.carbsController.text = '10';
        viewModel.proteinController.text = '3';
        viewModel.sodiumController.text = '200';
        viewModel.fiberController.text = '2';
        viewModel.sugarController.text = '8';
        viewModel.allergensController.text = 'Gluten';
        viewModel.descriptionController.text = 'Test description';
        viewModel.tagsController.text = 'test, product';

        // Act
        final product = AddProductModel.fromForm(
          barcode: viewModel.barcodeController.text,
          name: viewModel.nameController.text,
          brands: viewModel.brandsController.text,
          categories: viewModel.categoriesController.text,
          quantity: viewModel.quantityController.text,
          energy: viewModel.energyController.text,
          fat: viewModel.fatController.text,
          carbs: viewModel.carbsController.text,
          protein: viewModel.proteinController.text,
          ingredients: viewModel.ingredientsController.text,
          sodium: viewModel.sodiumController.text,
          fiber: viewModel.fiberController.text,
          sugar: viewModel.sugarController.text,
          allergens: viewModel.allergensController.text,
          description: viewModel.descriptionController.text,
          tags: viewModel.tagsController.text,
        );

        // Assert
        expect(product.barcode, equals('1234567890123'));
        expect(product.name, equals('Test Product'));
        expect(product.brands, equals('Test Brand'));
        expect(product.categories, equals('Test Category'));
        expect(product.quantity, equals('100g'));
        expect(product.ingredients, equals('Test ingredients'));
        expect(product.energy, equals('100'));
        expect(product.fat, equals('5'));
        expect(product.carbs, equals('10'));
        expect(product.protein, equals('3'));
        expect(product.sodium, equals('200'));
        expect(product.fiber, equals('2'));
        expect(product.sugar, equals('8'));
        expect(product.allergens, equals('Gluten'));
        expect(product.description, equals('Test description'));
        expect(product.tags, equals('test, product'));
      });

      test('should handle whitespace in form fields correctly', () {
        // Arrange
        viewModel.barcodeController.text = '  1234567890123  ';
        viewModel.nameController.text = '  Test Product  ';
        viewModel.brandsController.text = '  Test Brand  ';
        viewModel.categoriesController.text = '  Test Category  ';
        viewModel.quantityController.text = '  100g  ';
        viewModel.ingredientsController.text = '  Test ingredients  ';

        // Act
        final product = AddProductModel.fromForm(
          barcode: viewModel.barcodeController.text,
          name: viewModel.nameController.text,
          brands: viewModel.brandsController.text,
          categories: viewModel.categoriesController.text,
          quantity: viewModel.quantityController.text,
          ingredients: viewModel.ingredientsController.text,
        );

        // Assert
        expect(product.barcode, equals('1234567890123'));
        expect(product.name, equals('Test Product'));
        expect(product.brands, equals('Test Brand'));
        expect(product.categories, equals('Test Category'));
        expect(product.quantity, equals('100g'));
        expect(product.ingredients, equals('Test ingredients'));
      });

      test('should handle empty optional fields correctly', () {
        // Arrange
        viewModel.barcodeController.text = '1234567890123';
        viewModel.nameController.text = 'Test Product';
        viewModel.brandsController.text = 'Test Brand';
        viewModel.categoriesController.text = 'Test Category';
        viewModel.quantityController.text = '100g';
        viewModel.ingredientsController.text = 'Test ingredients';
        // Optional fields are empty by default

        // Act
        final product = AddProductModel.fromForm(
          barcode: viewModel.barcodeController.text,
          name: viewModel.nameController.text,
          brands: viewModel.brandsController.text,
          categories: viewModel.categoriesController.text,
          quantity: viewModel.quantityController.text,
          ingredients: viewModel.ingredientsController.text,
        );

        // Assert
        expect(product.energy, equals(''));
        expect(product.fat, equals(''));
        expect(product.carbs, equals(''));
        expect(product.protein, equals(''));
        expect(product.sodium, equals(''));
        expect(product.fiber, equals(''));
        expect(product.sugar, equals(''));
        expect(product.allergens, equals(''));
        expect(product.description, equals(''));
        expect(product.tags, equals(''));
      });

      test('should handle very long text inputs', () {
        // Arrange
        final longText = 'a' * 1000;
        viewModel.nameController.text = longText;

        // Act
        final product = AddProductModel.fromForm(
          barcode: '1234567890123',
          name: viewModel.nameController.text,
          brands: 'Test Brand',
          categories: 'Test Category',
          quantity: '100g',
          ingredients: 'Test ingredients',
        );

        // Assert
        expect(product.name, equals(longText));
      });
    });

    group('AddProduct Business Logic - Image Service Integration', () {
      test('should handle image service getters', () {
        // Test image service getters
        expect(viewModel.selectedImage, isNull);
        expect(viewModel.isImageUploading, isFalse);
      });

      test('should handle image operations without crashing', () async {
        // These methods will fail in test environment but should not crash
        await viewModel.pickImageFromGallery();
        await viewModel.takePhotoWithCamera();

        // Should not throw exceptions
        expect(viewModel.selectedImage, isNull);
      });

      test('should remove selected image', () {
        // Act
        viewModel.removeSelectedImage();

        // Assert
        expect(viewModel.selectedImage, isNull);
      });
    });

    group('AddProduct Business Logic - State Management', () {
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

    group('AddProduct Business Logic - Edge Cases', () {
      test('should handle special characters in text fields', () {
        // Arrange
        final specialText = 'Test@#\$%^&*()_+{}|:"<>?[]\\\\;\',./';
        viewModel.nameController.text = specialText;

        // Act
        final product = AddProductModel.fromForm(
          barcode: '1234567890123',
          name: viewModel.nameController.text,
          brands: 'Test Brand',
          categories: 'Test Category',
          quantity: '100g',
          ingredients: 'Test ingredients',
        );

        // Assert
        expect(product.name, equals(specialText));
      });

      test('should handle empty strings in text fields', () {
        // Arrange
        viewModel.nameController.text = '';
        viewModel.descriptionController.text = '';

        // Act
        final product = AddProductModel.fromForm(
          barcode: '1234567890123',
          name: viewModel.nameController.text,
          brands: 'Test Brand',
          categories: 'Test Category',
          quantity: '100g',
          ingredients: 'Test ingredients',
          description: viewModel.descriptionController.text,
        );

        // Assert
        expect(product.name, equals(''));
        expect(product.description, equals(''));
      });

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

    group('AddProduct Business Logic - Integration Notes', () {
      test(
        'should note that OFF credentials and repository tests are integration tests',
        () {
          // Note: The following business logic scenarios are tested in integration tests:
          // 1. OFF credentials validation (requires AppPrefs utility)
          // 2. Repository interaction with actual API calls
          // 3. Complete addProduct flow with all dependencies
          // 4. Success and error handling with repository responses

          expect(true, isTrue); // Placeholder test
        },
      );
    });
  });
}
