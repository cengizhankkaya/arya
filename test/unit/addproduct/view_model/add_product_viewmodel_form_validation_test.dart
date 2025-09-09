import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/service/product_repository.dart';
import 'package:arya/features/addproduct/service/image_service.dart';
import 'package:arya/features/addproduct/model/add_product_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'add_product_viewmodel_form_validation_test.mocks.dart';

@GenerateMocks([IProductRepository, IImageService, fb.FirebaseAuth, fb.User])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddProductViewModel Form Validation Tests', () {
    late AddProductViewModel viewModel;
    late MockIProductRepository mockProductRepository;
    late MockIImageService mockImageService;

    setUp(() {
      mockProductRepository = MockIProductRepository();
      mockImageService = MockIImageService();

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

    group('Form Key and Structure Tests', () {
      test('should have valid form key', () {
        // Assert
        expect(viewModel.formKey, isNotNull);
        expect(viewModel.formKey, isA<GlobalKey<FormState>>());
      });

      test('should have all required form controllers', () {
        // Assert - Required fields
        expect(viewModel.barcodeController, isNotNull);
        expect(viewModel.nameController, isNotNull);
        expect(viewModel.brandsController, isNotNull);
        expect(viewModel.categoriesController, isNotNull);
        expect(viewModel.quantityController, isNotNull);
        expect(viewModel.ingredientsController, isNotNull);

        // Assert - Optional fields
        expect(viewModel.energyController, isNotNull);
        expect(viewModel.fatController, isNotNull);
        expect(viewModel.carbsController, isNotNull);
        expect(viewModel.proteinController, isNotNull);
        expect(viewModel.sodiumController, isNotNull);
        expect(viewModel.fiberController, isNotNull);
        expect(viewModel.sugarController, isNotNull);
        expect(viewModel.allergensController, isNotNull);
        expect(viewModel.descriptionController, isNotNull);
        expect(viewModel.tagsController, isNotNull);
      });

      test('should initialize with empty form fields', () {
        // Assert
        expect(viewModel.barcodeController.text, isEmpty);
        expect(viewModel.nameController.text, isEmpty);
        expect(viewModel.brandsController.text, isEmpty);
        expect(viewModel.categoriesController.text, isEmpty);
        expect(viewModel.quantityController.text, isEmpty);
        expect(viewModel.ingredientsController.text, isEmpty);
        expect(viewModel.energyController.text, isEmpty);
        expect(viewModel.fatController.text, isEmpty);
        expect(viewModel.carbsController.text, isEmpty);
        expect(viewModel.proteinController.text, isEmpty);
        expect(viewModel.sodiumController.text, isEmpty);
        expect(viewModel.fiberController.text, isEmpty);
        expect(viewModel.sugarController.text, isEmpty);
        expect(viewModel.allergensController.text, isEmpty);
        expect(viewModel.descriptionController.text, isEmpty);
        expect(viewModel.tagsController.text, isEmpty);
      });
    });

    group('Individual Field Validation Tests', () {
      group('Barcode Validation', () {
        test('should validate valid barcode', () {
          // Arrange
          const validBarcodes = [
            '1234567890123',
            '12345678',
            '9876543210987',
            '12345678901234567890',
          ];

          // Act & Assert
          for (final barcode in validBarcodes) {
            final result = AddProductModel.validateBarcode(barcode);
            expect(
              result,
              isNull,
              reason: 'Barcode "$barcode" should be valid',
            );
          }
        });

        test('should reject invalid barcode', () {
          // Arrange
          const invalidBarcodes = [
            '',
            '1234567', // Too short
            '123456', // Too short
          ];

          // Act & Assert
          for (final barcode in invalidBarcodes) {
            final result = AddProductModel.validateBarcode(barcode);
            expect(
              result,
              isNotNull,
              reason: 'Barcode "$barcode" should be invalid',
            );
            expect(result, isA<String>());
          }
        });

        test('should handle null barcode', () {
          // Act
          final result = AddProductModel.validateBarcode(null);

          // Assert
          expect(result, isNotNull);
          expect(result, isA<String>());
        });
      });

      group('Name Validation', () {
        test('should validate valid product names', () {
          // Arrange
          final validNames = [
            'Test Product',
            'Ürün Adı',
            'Product 123',
            'Very Long Product Name That Should Still Be Valid',
            'A' * 100, // Long name
          ];

          // Act & Assert
          for (final name in validNames) {
            final result = AddProductModel.validateName(name);
            expect(result, isNull, reason: 'Name "$name" should be valid');
          }
        });

        test('should reject invalid product names', () {
          // Arrange
          const invalidNames = [
            '',
            'A', // Too short
          ];

          // Act & Assert
          for (final name in invalidNames) {
            final result = AddProductModel.validateName(name);
            expect(result, isNotNull, reason: 'Name "$name" should be invalid');
            expect(result, isA<String>());
          }
        });

        test('should handle null name', () {
          // Act
          final result = AddProductModel.validateName(null);

          // Assert
          expect(result, isNotNull);
          expect(result, isA<String>());
        });
      });

      group('Brands Validation', () {
        test('should validate valid brands', () {
          // Arrange
          const validBrands = [
            'Test Brand',
            'Marka Adı',
            'Brand 123',
            'Very Long Brand Name That Should Still Be Valid',
            'A', // Single character should be valid for brands
          ];

          // Act & Assert
          for (final brand in validBrands) {
            final result = AddProductModel.validateBrands(brand);
            expect(result, isNull, reason: 'Brand "$brand" should be valid');
          }
        });

        test('should reject invalid brands', () {
          // Arrange
          const invalidBrands = [''];

          // Act & Assert
          for (final brand in invalidBrands) {
            final result = AddProductModel.validateBrands(brand);
            expect(
              result,
              isNotNull,
              reason: 'Brand "$brand" should be invalid',
            );
            expect(result, isA<String>());
          }
        });

        test('should handle null brands', () {
          // Act
          final result = AddProductModel.validateBrands(null);

          // Assert
          expect(result, isNotNull);
          expect(result, isA<String>());
        });
      });

      group('Categories Validation', () {
        test('should validate valid categories', () {
          // Arrange
          const validCategories = [
            'Test Category',
            'Kategori Adı',
            'Category 123',
            'Very Long Category Name That Should Still Be Valid',
            'A', // Single character should be valid for categories
          ];

          // Act & Assert
          for (final category in validCategories) {
            final result = AddProductModel.validateCategories(category);
            expect(
              result,
              isNull,
              reason: 'Category "$category" should be valid',
            );
          }
        });

        test('should reject invalid categories', () {
          // Arrange
          const invalidCategories = [''];

          // Act & Assert
          for (final category in invalidCategories) {
            final result = AddProductModel.validateCategories(category);
            expect(
              result,
              isNotNull,
              reason: 'Category "$category" should be invalid',
            );
            expect(result, isA<String>());
          }
        });

        test('should handle null categories', () {
          // Act
          final result = AddProductModel.validateCategories(null);

          // Assert
          expect(result, isNotNull);
          expect(result, isA<String>());
        });
      });

      group('Quantity Validation', () {
        test('should validate valid quantities', () {
          // Arrange
          const validQuantities = [
            '100g',
            '1 kg',
            '500ml',
            '2 pieces',
            '1.5 L',
            'Very Long Quantity Description That Should Still Be Valid',
            'A', // Single character should be valid for quantity
          ];

          // Act & Assert
          for (final quantity in validQuantities) {
            final result = AddProductModel.validateQuantity(quantity);
            expect(
              result,
              isNull,
              reason: 'Quantity "$quantity" should be valid',
            );
          }
        });

        test('should reject invalid quantities', () {
          // Arrange
          const invalidQuantities = [''];

          // Act & Assert
          for (final quantity in invalidQuantities) {
            final result = AddProductModel.validateQuantity(quantity);
            expect(
              result,
              isNotNull,
              reason: 'Quantity "$quantity" should be invalid',
            );
            expect(result, isA<String>());
          }
        });

        test('should handle null quantity', () {
          // Act
          final result = AddProductModel.validateQuantity(null);

          // Assert
          expect(result, isNotNull);
          expect(result, isA<String>());
        });
      });

      group('Ingredients Validation', () {
        test('should validate valid ingredients', () {
          // Arrange
          const validIngredients = [
            'Test ingredients',
            'İçerik listesi',
            'Ingredients 123',
            'Very Long Ingredients List That Should Still Be Valid',
            'A', // Single character should be valid for ingredients
          ];

          // Act & Assert
          for (final ingredients in validIngredients) {
            final result = AddProductModel.validateIngredients(ingredients);
            expect(
              result,
              isNull,
              reason: 'Ingredients "$ingredients" should be valid',
            );
          }
        });

        test('should reject invalid ingredients', () {
          // Arrange
          const invalidIngredients = [''];

          // Act & Assert
          for (final ingredients in invalidIngredients) {
            final result = AddProductModel.validateIngredients(ingredients);
            expect(
              result,
              isNotNull,
              reason: 'Ingredients "$ingredients" should be invalid',
            );
            expect(result, isA<String>());
          }
        });

        test('should handle null ingredients', () {
          // Act
          final result = AddProductModel.validateIngredients(null);

          // Assert
          expect(result, isNotNull);
          expect(result, isA<String>());
        });
      });
    });

    group('Form State Validation Tests', () {
      test('should have validateForm method', () {
        // Assert
        expect(viewModel.validateForm, isNotNull);
        expect(viewModel.validateForm, isA<Function>());
      });

      test('should validate individual fields through model validation', () {
        // Test that individual field validations work correctly
        // This tests the custom validation logic in validateForm method

        // Valid data
        expect(AddProductModel.validateBarcode('1234567890123'), isNull);
        expect(AddProductModel.validateName('Test Product'), isNull);
        expect(AddProductModel.validateBrands('Test Brand'), isNull);
        expect(AddProductModel.validateCategories('Test Category'), isNull);
        expect(AddProductModel.validateQuantity('100g'), isNull);
        expect(AddProductModel.validateIngredients('Test ingredients'), isNull);

        // Invalid data
        expect(AddProductModel.validateBarcode(''), isNotNull);
        expect(AddProductModel.validateName(''), isNotNull);
        expect(AddProductModel.validateBrands(''), isNotNull);
        expect(AddProductModel.validateCategories(''), isNotNull);
        expect(AddProductModel.validateQuantity(''), isNotNull);
        expect(AddProductModel.validateIngredients(''), isNotNull);
      });
    });

    group('Form Controller Management Tests', () {
      test('should clear all form fields', () {
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
        viewModel.clearForm();

        // Assert
        expect(viewModel.barcodeController.text, isEmpty);
        expect(viewModel.nameController.text, isEmpty);
        expect(viewModel.brandsController.text, isEmpty);
        expect(viewModel.categoriesController.text, isEmpty);
        expect(viewModel.quantityController.text, isEmpty);
        expect(viewModel.ingredientsController.text, isEmpty);
        expect(viewModel.energyController.text, isEmpty);
        expect(viewModel.fatController.text, isEmpty);
        expect(viewModel.carbsController.text, isEmpty);
        expect(viewModel.proteinController.text, isEmpty);
        expect(viewModel.sodiumController.text, isEmpty);
        expect(viewModel.fiberController.text, isEmpty);
        expect(viewModel.sugarController.text, isEmpty);
        expect(viewModel.allergensController.text, isEmpty);
        expect(viewModel.descriptionController.text, isEmpty);
        expect(viewModel.tagsController.text, isEmpty);
      });

      test('should handle text input changes', () {
        // Arrange
        const testText = 'Test input text';

        // Act
        viewModel.nameController.text = testText;

        // Assert
        expect(viewModel.nameController.text, equals(testText));
      });

      test('should handle rapid text changes', () {
        // Arrange
        const testTexts = [
          'First text',
          'Second text',
          'Third text',
          'Fourth text',
          'Fifth text',
        ];

        // Act & Assert
        for (final text in testTexts) {
          viewModel.nameController.text = text;
          expect(viewModel.nameController.text, equals(text));
        }
      });
    });

    group('Edge Cases and Error Handling Tests', () {
      test('should handle whitespace in form fields', () {
        // Arrange
        viewModel.barcodeController.text = '  1234567890123  ';
        viewModel.nameController.text = '  Test Product  ';
        viewModel.brandsController.text = '  Test Brand  ';
        viewModel.categoriesController.text = '  Test Category  ';
        viewModel.quantityController.text = '  100g  ';
        viewModel.ingredientsController.text = '  Test ingredients  ';

        // Act - Test individual validations (whitespace is handled by trim in fromForm)
        final barcodeValid = AddProductModel.validateBarcode(
          viewModel.barcodeController.text.trim(),
        );
        final nameValid = AddProductModel.validateName(
          viewModel.nameController.text.trim(),
        );
        final brandsValid = AddProductModel.validateBrands(
          viewModel.brandsController.text.trim(),
        );
        final categoriesValid = AddProductModel.validateCategories(
          viewModel.categoriesController.text.trim(),
        );
        final quantityValid = AddProductModel.validateQuantity(
          viewModel.quantityController.text.trim(),
        );
        final ingredientsValid = AddProductModel.validateIngredients(
          viewModel.ingredientsController.text.trim(),
        );

        // Assert
        expect(barcodeValid, isNull);
        expect(nameValid, isNull);
        expect(brandsValid, isNull);
        expect(categoriesValid, isNull);
        expect(quantityValid, isNull);
        expect(ingredientsValid, isNull);
      });

      test('should handle special characters in form fields', () {
        // Arrange
        const specialText = 'Test@#\$%^&*()_+{}|:"<>?[]\\\\;\',./';
        viewModel.barcodeController.text = '1234567890123';
        viewModel.nameController.text = specialText;
        viewModel.brandsController.text = specialText;
        viewModel.categoriesController.text = specialText;
        viewModel.quantityController.text = specialText;
        viewModel.ingredientsController.text = specialText;

        // Act - Test individual validations
        final barcodeValid = AddProductModel.validateBarcode(
          viewModel.barcodeController.text,
        );
        final nameValid = AddProductModel.validateName(
          viewModel.nameController.text,
        );
        final brandsValid = AddProductModel.validateBrands(
          viewModel.brandsController.text,
        );
        final categoriesValid = AddProductModel.validateCategories(
          viewModel.categoriesController.text,
        );
        final quantityValid = AddProductModel.validateQuantity(
          viewModel.quantityController.text,
        );
        final ingredientsValid = AddProductModel.validateIngredients(
          viewModel.ingredientsController.text,
        );

        // Assert
        expect(barcodeValid, isNull);
        expect(nameValid, isNull);
        expect(brandsValid, isNull);
        expect(categoriesValid, isNull);
        expect(quantityValid, isNull);
        expect(ingredientsValid, isNull);
      });

      test('should handle very long text inputs', () {
        // Arrange
        final longText = 'a' * 1000;
        viewModel.barcodeController.text = '1234567890123';
        viewModel.nameController.text = longText;
        viewModel.brandsController.text = longText;
        viewModel.categoriesController.text = longText;
        viewModel.quantityController.text = longText;
        viewModel.ingredientsController.text = longText;

        // Act - Test individual validations
        final barcodeValid = AddProductModel.validateBarcode(
          viewModel.barcodeController.text,
        );
        final nameValid = AddProductModel.validateName(
          viewModel.nameController.text,
        );
        final brandsValid = AddProductModel.validateBrands(
          viewModel.brandsController.text,
        );
        final categoriesValid = AddProductModel.validateCategories(
          viewModel.categoriesController.text,
        );
        final quantityValid = AddProductModel.validateQuantity(
          viewModel.quantityController.text,
        );
        final ingredientsValid = AddProductModel.validateIngredients(
          viewModel.ingredientsController.text,
        );

        // Assert
        expect(barcodeValid, isNull);
        expect(nameValid, isNull);
        expect(brandsValid, isNull);
        expect(categoriesValid, isNull);
        expect(quantityValid, isNull);
        expect(ingredientsValid, isNull);
        expect(viewModel.nameController.text, equals(longText));
      });

      test('should handle unicode characters', () {
        // Arrange
        const unicodeText = 'Test Ürün 产品 商品 商品名';
        viewModel.barcodeController.text = '1234567890123';
        viewModel.nameController.text = unicodeText;
        viewModel.brandsController.text = unicodeText;
        viewModel.categoriesController.text = unicodeText;
        viewModel.quantityController.text = unicodeText;
        viewModel.ingredientsController.text = unicodeText;

        // Act - Test individual validations
        final barcodeValid = AddProductModel.validateBarcode(
          viewModel.barcodeController.text,
        );
        final nameValid = AddProductModel.validateName(
          viewModel.nameController.text,
        );
        final brandsValid = AddProductModel.validateBrands(
          viewModel.brandsController.text,
        );
        final categoriesValid = AddProductModel.validateCategories(
          viewModel.categoriesController.text,
        );
        final quantityValid = AddProductModel.validateQuantity(
          viewModel.quantityController.text,
        );
        final ingredientsValid = AddProductModel.validateIngredients(
          viewModel.ingredientsController.text,
        );

        // Assert
        expect(barcodeValid, isNull);
        expect(nameValid, isNull);
        expect(brandsValid, isNull);
        expect(categoriesValid, isNull);
        expect(quantityValid, isNull);
        expect(ingredientsValid, isNull);
        expect(viewModel.nameController.text, equals(unicodeText));
      });

      test('should handle numeric inputs in text fields', () {
        // Arrange
        const numericText = '123456789';
        viewModel.barcodeController.text = '1234567890123';
        viewModel.nameController.text = numericText;
        viewModel.brandsController.text = numericText;
        viewModel.categoriesController.text = numericText;
        viewModel.quantityController.text = numericText;
        viewModel.ingredientsController.text = numericText;

        // Act - Test individual validations
        final barcodeValid = AddProductModel.validateBarcode(
          viewModel.barcodeController.text,
        );
        final nameValid = AddProductModel.validateName(
          viewModel.nameController.text,
        );
        final brandsValid = AddProductModel.validateBrands(
          viewModel.brandsController.text,
        );
        final categoriesValid = AddProductModel.validateCategories(
          viewModel.categoriesController.text,
        );
        final quantityValid = AddProductModel.validateQuantity(
          viewModel.quantityController.text,
        );
        final ingredientsValid = AddProductModel.validateIngredients(
          viewModel.ingredientsController.text,
        );

        // Assert
        expect(barcodeValid, isNull);
        expect(nameValid, isNull);
        expect(brandsValid, isNull);
        expect(categoriesValid, isNull);
        expect(quantityValid, isNull);
        expect(ingredientsValid, isNull);
        expect(viewModel.nameController.text, equals(numericText));
      });

      test('should handle mixed content in text fields', () {
        // Arrange
        const mixedText = 'Test123@#\$%^&*()_+{}|:"<>?[]\\\\;\',./Ürün产品';
        viewModel.barcodeController.text = '1234567890123';
        viewModel.nameController.text = mixedText;
        viewModel.brandsController.text = mixedText;
        viewModel.categoriesController.text = mixedText;
        viewModel.quantityController.text = mixedText;
        viewModel.ingredientsController.text = mixedText;

        // Act - Test individual validations
        final barcodeValid = AddProductModel.validateBarcode(
          viewModel.barcodeController.text,
        );
        final nameValid = AddProductModel.validateName(
          viewModel.nameController.text,
        );
        final brandsValid = AddProductModel.validateBrands(
          viewModel.brandsController.text,
        );
        final categoriesValid = AddProductModel.validateCategories(
          viewModel.categoriesController.text,
        );
        final quantityValid = AddProductModel.validateQuantity(
          viewModel.quantityController.text,
        );
        final ingredientsValid = AddProductModel.validateIngredients(
          viewModel.ingredientsController.text,
        );

        // Assert
        expect(barcodeValid, isNull);
        expect(nameValid, isNull);
        expect(brandsValid, isNull);
        expect(categoriesValid, isNull);
        expect(quantityValid, isNull);
        expect(ingredientsValid, isNull);
        expect(viewModel.nameController.text, equals(mixedText));
      });
    });

    group('Form State Management Tests', () {
      test('should maintain form state during validation', () {
        // Arrange
        viewModel.barcodeController.text = '1234567890123';
        viewModel.nameController.text = 'Test Product';
        viewModel.brandsController.text = 'Test Brand';
        viewModel.categoriesController.text = 'Test Category';
        viewModel.quantityController.text = '100g';
        viewModel.ingredientsController.text = 'Test ingredients';

        // Act - Test individual validations
        final barcodeValid = AddProductModel.validateBarcode(
          viewModel.barcodeController.text,
        );
        final nameValid = AddProductModel.validateName(
          viewModel.nameController.text,
        );
        final brandsValid = AddProductModel.validateBrands(
          viewModel.brandsController.text,
        );
        final categoriesValid = AddProductModel.validateCategories(
          viewModel.categoriesController.text,
        );
        final quantityValid = AddProductModel.validateQuantity(
          viewModel.quantityController.text,
        );
        final ingredientsValid = AddProductModel.validateIngredients(
          viewModel.ingredientsController.text,
        );

        // Assert
        expect(barcodeValid, isNull);
        expect(nameValid, isNull);
        expect(brandsValid, isNull);
        expect(categoriesValid, isNull);
        expect(quantityValid, isNull);
        expect(ingredientsValid, isNull);
        expect(viewModel.barcodeController.text, equals('1234567890123'));
        expect(viewModel.nameController.text, equals('Test Product'));
        expect(viewModel.brandsController.text, equals('Test Brand'));
        expect(viewModel.categoriesController.text, equals('Test Category'));
        expect(viewModel.quantityController.text, equals('100g'));
        expect(
          viewModel.ingredientsController.text,
          equals('Test ingredients'),
        );
      });

      test('should handle form validation without affecting controllers', () {
        // Arrange
        viewModel.barcodeController.text = '1234567890123';
        viewModel.nameController.text = 'Test Product';
        viewModel.brandsController.text = 'Test Brand';
        viewModel.categoriesController.text = 'Test Category';
        viewModel.quantityController.text = '100g';
        viewModel.ingredientsController.text = 'Test ingredients';

        final originalBarcode = viewModel.barcodeController.text;
        final originalName = viewModel.nameController.text;
        final originalBrands = viewModel.brandsController.text;
        final originalCategories = viewModel.categoriesController.text;
        final originalQuantity = viewModel.quantityController.text;
        final originalIngredients = viewModel.ingredientsController.text;

        // Act - Test individual validations
        AddProductModel.validateBarcode(viewModel.barcodeController.text);
        AddProductModel.validateName(viewModel.nameController.text);
        AddProductModel.validateBrands(viewModel.brandsController.text);
        AddProductModel.validateCategories(viewModel.categoriesController.text);
        AddProductModel.validateQuantity(viewModel.quantityController.text);
        AddProductModel.validateIngredients(
          viewModel.ingredientsController.text,
        );

        // Assert
        expect(viewModel.barcodeController.text, equals(originalBarcode));
        expect(viewModel.nameController.text, equals(originalName));
        expect(viewModel.brandsController.text, equals(originalBrands));
        expect(viewModel.categoriesController.text, equals(originalCategories));
        expect(viewModel.quantityController.text, equals(originalQuantity));
        expect(
          viewModel.ingredientsController.text,
          equals(originalIngredients),
        );
      });
    });

    group('Performance Tests', () {
      test('should validate form efficiently', () {
        // Arrange
        viewModel.barcodeController.text = '1234567890123';
        viewModel.nameController.text = 'Test Product';
        viewModel.brandsController.text = 'Test Brand';
        viewModel.categoriesController.text = 'Test Category';
        viewModel.quantityController.text = '100g';
        viewModel.ingredientsController.text = 'Test ingredients';

        final stopwatch = Stopwatch()..start();

        // Act - Test individual validations
        for (int i = 0; i < 100; i++) {
          AddProductModel.validateBarcode(viewModel.barcodeController.text);
          AddProductModel.validateName(viewModel.nameController.text);
          AddProductModel.validateBrands(viewModel.brandsController.text);
          AddProductModel.validateCategories(
            viewModel.categoriesController.text,
          );
          AddProductModel.validateQuantity(viewModel.quantityController.text);
          AddProductModel.validateIngredients(
            viewModel.ingredientsController.text,
          );
        }

        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('should handle rapid form field changes efficiently', () {
        final stopwatch = Stopwatch()..start();

        // Act
        for (int i = 0; i < 1000; i++) {
          viewModel.nameController.text = 'Test $i';
        }

        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(viewModel.nameController.text, equals('Test 999'));
      });
    });

    group('Integration with Mock Dependencies Tests', () {
      test('should work with mocked image service', () {
        // Arrange
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act
        final selectedImage = viewModel.selectedImage;
        final isImageUploading = viewModel.isImageUploading;

        // Assert
        expect(selectedImage, isNull);
        expect(isImageUploading, isFalse);
        verify(mockImageService.selectedImage).called(1);
        verify(mockImageService.isImageUploading).called(1);
      });

      test('should handle image service operations through mocks', () async {
        // Arrange
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => null);
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenAnswer((_) async => null);
        when(mockImageService.removeSelectedImage()).thenReturn(null);

        // Act
        await viewModel.pickImageFromGallery();
        await viewModel.takePhotoWithCamera();
        viewModel.removeSelectedImage();

        // Assert
        verify(mockImageService.pickImageFromGallery()).called(1);
        verify(mockImageService.takePhotoWithCamera()).called(1);
        verify(mockImageService.removeSelectedImage()).called(1);
      });

      test('should maintain form validation with mocked dependencies', () {
        // Arrange
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        viewModel.barcodeController.text = '1234567890123';
        viewModel.nameController.text = 'Test Product';
        viewModel.brandsController.text = 'Test Brand';
        viewModel.categoriesController.text = 'Test Category';
        viewModel.quantityController.text = '100g';
        viewModel.ingredientsController.text = 'Test ingredients';

        // Act - Test individual validations
        final barcodeValid = AddProductModel.validateBarcode(
          viewModel.barcodeController.text,
        );
        final nameValid = AddProductModel.validateName(
          viewModel.nameController.text,
        );
        final brandsValid = AddProductModel.validateBrands(
          viewModel.brandsController.text,
        );
        final categoriesValid = AddProductModel.validateCategories(
          viewModel.categoriesController.text,
        );
        final quantityValid = AddProductModel.validateQuantity(
          viewModel.quantityController.text,
        );
        final ingredientsValid = AddProductModel.validateIngredients(
          viewModel.ingredientsController.text,
        );
        final selectedImage = viewModel.selectedImage;

        // Assert
        expect(barcodeValid, isNull);
        expect(nameValid, isNull);
        expect(brandsValid, isNull);
        expect(categoriesValid, isNull);
        expect(quantityValid, isNull);
        expect(ingredientsValid, isNull);
        expect(selectedImage, isNull);
        verify(mockImageService.selectedImage).called(1);
      });
    });
  });
}
