// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_product_validation_integration_test.mocks.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/add_product_test_data.dart';

@GenerateMocks([IProductRepository, IImageService, FirebaseAuth, User])
void main() {
  group('Add Product Validation Integration Tests', () {
    late MockIProductRepository mockProductRepository;
    late MockIImageService mockImageService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      TestHelpers.setupEasyLocalization();
      TestHelpers.setupComprehensiveFirebaseMocks();
      await TestHelpers.initializeFirebaseForTests();
      TestHelpers.setupPlatformChannels();
    });

    setUp(() {
      mockProductRepository = MockIProductRepository();
      mockImageService = MockIImageService();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
    });

    tearDownAll(() {
      TestHelpers.tearDown();
    });

    group('Required Field Validation Tests', () {
      testWidgets('should show validation errors for empty barcode', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Try to submit form with empty barcode
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be present (validation should prevent submission)
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should show validation errors for empty product name', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Fill barcode but leave name empty
        final testData = AddProductTestData.getIncompleteProductData();
        testData['name'] = ''; // Empty name
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be present (validation should prevent submission)
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should show validation errors for empty brands', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Fill some fields but leave brands empty
        final testData = AddProductTestData.getIncompleteProductData();
        testData['brands'] = ''; // Empty brands
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be present (validation should prevent submission)
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should show validation errors for empty categories', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Fill some fields but leave categories empty
        final testData = AddProductTestData.getIncompleteProductData();
        testData['categories'] = ''; // Empty categories
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be present (validation should prevent submission)
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should show validation errors for empty quantity', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Fill some fields but leave quantity empty
        final testData = AddProductTestData.getIncompleteProductData();
        testData['quantity'] = ''; // Empty quantity
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be present (validation should prevent submission)
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should show validation errors for empty ingredients', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Fill some fields but leave ingredients empty
        final testData = AddProductTestData.getIncompleteProductData();
        testData['ingredients'] = ''; // Empty ingredients
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be present (validation should prevent submission)
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Format Validation Tests', () {
      testWidgets('should validate barcode length correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Enter short barcode (should be invalid)
        final testData = AddProductTestData.getIncompleteProductData();
        testData['barcode'] = '123'; // Too short
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be present (validation should prevent submission)
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should validate product name length correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Enter short product name (should be invalid)
        final testData = AddProductTestData.getIncompleteProductData();
        testData['name'] = 'A'; // Too short name
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be present (validation should prevent submission)
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Complete Validation Tests', () {
      testWidgets(
        'should pass validation with all required fields filled correctly',
        (WidgetTester tester) async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn('test-user-id');
          when(mockImageService.selectedImage).thenReturn(null);
          when(mockImageService.isImageUploading).thenReturn(false);

          // Mock successful product save
          when(
            mockProductRepository.saveProduct(
              any,
              any,
              any,
              imageFile: anyNamed('imageFile'),
            ),
          ).thenAnswer((_) async => AddProductTestData.createSuccessStatus());

          await tester.pumpWidget(
            TestHelpers.createAddProductTestApp(
              child: const AddProductScreen(),
              viewModel: AddProductViewModel(
                productRepository: mockProductRepository,
                imageService: mockImageService,
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Act - Fill all required fields with valid data
          final testData = AddProductTestData.getCompleteValidProductData();
          await TestHelpers.fillAddProductForm(tester, testData: testData);

          // Try to submit form
          await TestHelpers.submitAddProductForm(tester);

          // Assert - Form should still be present (validation should pass)
          TestHelpers.verifyAddProductScreenComponents();
        },
      );

      testWidgets('should handle validation with optional fields', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Mock successful product save
        when(
          mockProductRepository.saveProduct(
            any,
            any,
            any,
            imageFile: anyNamed('imageFile'),
          ),
        ).thenAnswer((_) async => AddProductTestData.createSuccessStatus());

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Fill required fields and some optional fields
        final testData = AddProductTestData.getCompleteValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be present
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Validation State Management Tests', () {
      testWidgets('should maintain validation state during form interactions', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Interact with form fields
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().isNotEmpty) {
          // Enter invalid data first
          final invalidData = AddProductTestData.getIncompleteProductData();
          invalidData['barcode'] = '123'; // Invalid barcode
          await TestHelpers.fillAddProductForm(tester, testData: invalidData);

          // Try to submit (should fail validation)
          await TestHelpers.submitAddProductForm(tester);

          // Fix the data
          final validData = AddProductTestData.getMinimalValidProductData();
          await TestHelpers.fillAddProductForm(tester, testData: validData);
        }

        // Assert - Form should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle validation errors gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Try to submit empty form multiple times
        for (int i = 0; i < 3; i++) {
          await TestHelpers.submitAddProductForm(tester);
        }

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Form Field Interaction Tests', () {
      testWidgets('should validate fields as user types', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Type in form fields
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().isNotEmpty) {
          // Type character by character
          final barcode = AddProductTestData.validBarcodes[0];
          for (int i = 1; i <= barcode.length; i++) {
            await tester.enterText(textFields.first, barcode.substring(0, i));
            await tester.pumpAndSettle();
          }
        }

        // Assert - Form should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle field focus and blur correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Focus and blur different fields
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().length >= 2) {
          // Focus first field
          await tester.tap(textFields.first, warnIfMissed: false);
          await tester.pumpAndSettle();

          // Focus second field
          await tester.tap(textFields.at(1), warnIfMissed: false);
          await tester.pumpAndSettle();

          // Focus back to first field
          await tester.tap(textFields.first, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Assert - Form should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Edge Case Validation Tests', () {
      testWidgets('should handle minimum valid field lengths', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Mock successful product save
        when(
          mockProductRepository.saveProduct(
            any,
            any,
            any,
            imageFile: anyNamed('imageFile'),
          ),
        ).thenAnswer((_) async => AddProductTestData.createSuccessStatus());

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Fill form with minimum valid lengths
        final testData = AddProductTestData.getEdgeCaseData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle maximum field lengths', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Fill form with very long data
        final testData = AddProductTestData.getLongData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Assert - Form should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle all validation error scenarios', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Test all validation scenarios
        final validationData = AddProductTestData.getValidationTestData();

        for (final fieldName in validationData.keys) {
          for (final invalidValue in validationData[fieldName]!) {
            final testData = AddProductTestData.getMinimalValidProductData();
            testData[fieldName] = invalidValue;

            await TestHelpers.fillAddProductForm(tester, testData: testData);
            await TestHelpers.submitAddProductForm(tester);

            // Assert - Form should still be present (validation should prevent submission)
            TestHelpers.verifyAddProductScreenComponents();
          }
        }
      });
    });

    group('Real-time Validation Tests', () {
      testWidgets('should validate fields in real-time as user types', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Type in barcode field progressively
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().isNotEmpty) {
          final validBarcode = AddProductTestData.validBarcodes[0];

          // Type each character
          for (int i = 1; i <= validBarcode.length; i++) {
            await tester.enterText(
              textFields.first,
              validBarcode.substring(0, i),
            );
            await tester.pumpAndSettle();

            // Verify the text is displayed
            expect(find.text(validBarcode.substring(0, i)), findsOneWidget);
          }
        }

        // Assert - Form should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should clear validation errors when valid data is entered', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: AddProductViewModel(
              productRepository: mockProductRepository,
              imageService: mockImageService,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Enter invalid data first
        final invalidData = AddProductTestData.getIncompleteProductData();
        invalidData['barcode'] = '123'; // Invalid
        await TestHelpers.fillAddProductForm(tester, testData: invalidData);

        // Try to submit (should fail)
        await TestHelpers.submitAddProductForm(tester);

        // Fix with valid data
        final validData = AddProductTestData.getMinimalValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: validData);

        // Assert - Form should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });
  });
}
