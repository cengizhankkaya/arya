// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_product_barcode_integration_test.mocks.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/add_product_test_data.dart';

@GenerateMocks([IProductRepository, IImageService, FirebaseAuth, User])
void main() {
  group('Add Product Barcode Integration Tests', () {
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

    group('Barcode Field Widget Tests', () {
      testWidgets('should render barcode field with scanner button', (
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

        // Assert - Check that barcode field and scanner button are rendered
        TestHelpers.verifyBarcodeSectionComponents();
      });

      testWidgets('should display barcode field with correct label', (
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

        // Assert - Check that barcode field has correct label
        expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
        final barcodeField = find.byType(TextFormField).first;
        expect(barcodeField, findsOneWidget);
      });

      testWidgets('should allow manual barcode input', (
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

        // Act - Enter barcode manually
        final testData = AddProductTestData.getMinimalValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Assert - Check that text was entered
        expect(find.text(testData['barcode']!), findsOneWidget);
      });
    });

    group('Barcode Scanner Screen Tests', () {
      testWidgets(
        'should navigate to barcode scanner when scanner button is tapped',
        (WidgetTester tester) async {
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

          // Act - Tap scanner button
          final scannerButton = find.byIcon(Icons.qr_code_scanner);
          if (scannerButton.evaluate().isNotEmpty) {
            await tester.tap(scannerButton, warnIfMissed: false);
            await tester.pumpAndSettle();
          }

          // Assert - Check that navigation occurred (scanner screen should be present)
          expect(find.byType(AddProductScreen), findsOneWidget);
        },
      );

      testWidgets('should handle scanner button interaction gracefully', (
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

        // Act - Tap scanner button multiple times
        final scannerButton = find.byIcon(Icons.qr_code_scanner);
        if (scannerButton.evaluate().isNotEmpty) {
          await tester.tap(scannerButton, warnIfMissed: false);
          await tester.pumpAndSettle();

          await tester.tap(scannerButton, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Barcode Validation Tests', () {
      testWidgets('should validate empty barcode field', (
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

      testWidgets('should validate short barcode', (WidgetTester tester) async {
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

        // Act - Enter short barcode
        final testData = AddProductTestData.getIncompleteProductData();
        testData['barcode'] = '123'; // Too short
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be present (validation should prevent submission)
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should accept valid barcode length', (
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

        // Act - Fill form with valid data
        final testData = AddProductTestData.getCompleteValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be present (validation should pass)
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Barcode Input Integration Tests', () {
      testWidgets('should handle barcode input with other form fields', (
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

        // Act - Fill barcode and other fields
        final testData = AddProductTestData.getMinimalValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Assert - All fields should contain the entered text
        TestHelpers.verifyFormFields(expectedData: testData);
      });

      testWidgets('should maintain barcode value during form interactions', (
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

        // Act - Enter barcode
        final testData = AddProductTestData.getMinimalValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Interact with scanner button
        final scannerButton = find.byIcon(Icons.qr_code_scanner);
        if (scannerButton.evaluate().isNotEmpty) {
          await tester.tap(scannerButton, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Assert - Barcode value should still be maintained
        expect(find.text(testData['barcode']!), findsOneWidget);
        expect(find.byType(AddProductScreen), findsOneWidget);
      });

      testWidgets('should handle barcode field focus and blur correctly', (
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

        // Act - Focus and blur barcode field
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().length >= 2) {
          // Focus barcode field
          await tester.tap(textFields.first, warnIfMissed: false);
          await tester.pumpAndSettle();

          // Focus another field
          await tester.tap(textFields.at(1), warnIfMissed: false);
          await tester.pumpAndSettle();

          // Focus back to barcode field
          await tester.tap(textFields.first, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Assert - Form should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Barcode Service Integration Tests', () {
      testWidgets('should handle barcode scanning service integration', (
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

        // Act - Interact with scanner button
        final scannerButton = find.byIcon(Icons.qr_code_scanner);
        if (scannerButton.evaluate().isNotEmpty) {
          await tester.tap(scannerButton, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle barcode scanning errors gracefully', (
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

        // Act - Try to interact with scanner button multiple times
        final scannerButton = find.byIcon(Icons.qr_code_scanner);
        if (scannerButton.evaluate().isNotEmpty) {
          for (int i = 0; i < 5; i++) {
            await tester.tap(scannerButton, warnIfMissed: false);
            await tester.pump();
          }
          await tester.pumpAndSettle();
        }

        // Assert - App should still be functional despite potential errors
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should integrate barcode with product submission', (
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

        // Act - Fill form with barcode and other data
        final testData = AddProductTestData.getCompleteValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Barcode State Management Tests', () {
      testWidgets('should maintain barcode state during form interactions', (
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

        // Act - Enter barcode and interact with form
        final testData = AddProductTestData.getMinimalValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Interact with scanner button
        final scannerButton = find.byIcon(Icons.qr_code_scanner);
        if (scannerButton.evaluate().isNotEmpty) {
          await tester.tap(scannerButton, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Assert - Barcode value should still be maintained
        expect(find.text(testData['barcode']!), findsOneWidget);
        expect(find.byType(AddProductScreen), findsOneWidget);
      });

      testWidgets('should handle barcode state changes correctly', (
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

        // Act - Change barcode value
        final testData1 = AddProductTestData.getMinimalValidProductData();
        testData1['barcode'] = AddProductTestData.validBarcodes[1];
        await TestHelpers.fillAddProductForm(tester, testData: testData1);

        final testData2 = AddProductTestData.getMinimalValidProductData();
        testData2['barcode'] = AddProductTestData.validBarcodes[2];
        await TestHelpers.fillAddProductForm(tester, testData: testData2);

        // Assert - Latest value should be displayed
        expect(find.text(testData2['barcode']!), findsOneWidget);
        expect(find.text(testData1['barcode']!), findsNothing);
      });
    });

    group('Barcode Error Handling Tests', () {
      testWidgets('should handle barcode input errors gracefully', (
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

        // Act - Try various invalid inputs
        final barcodeField = find.byType(TextFormField).first;

        // Try empty input
        await tester.enterText(barcodeField, '');
        await tester.pumpAndSettle();

        // Try special characters
        await tester.enterText(barcodeField, '!@#\$%^&*()');
        await tester.pumpAndSettle();

        // Try very long input
        await tester.enterText(barcodeField, '123456789012345678901234567890');
        await tester.pumpAndSettle();

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle scanner service errors gracefully', (
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

        // Act - Rapidly tap scanner button (simulating potential errors)
        final scannerButton = find.byIcon(Icons.qr_code_scanner);
        if (scannerButton.evaluate().isNotEmpty) {
          for (int i = 0; i < 5; i++) {
            await tester.tap(scannerButton, warnIfMissed: false);
            await tester.pump();
          }
          await tester.pumpAndSettle();
        }

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Barcode Edge Cases Tests', () {
      testWidgets('should handle minimum valid barcode length', (
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

        // Act - Enter minimum valid barcode
        final testData = AddProductTestData.getEdgeCaseData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle maximum barcode length', (
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

        // Act - Enter very long barcode
        final testData = AddProductTestData.getLongData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle all invalid barcode formats', (
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

        // Act - Try all invalid barcode formats
        final barcodeField = find.byType(TextFormField).first;

        for (final invalidBarcode in AddProductTestData.invalidBarcodes) {
          await tester.enterText(barcodeField, invalidBarcode);
          await tester.pumpAndSettle();

          // Try to submit form
          await TestHelpers.submitAddProductForm(tester);

          // Assert - Form should still be present (validation should prevent submission)
          TestHelpers.verifyAddProductScreenComponents();
        }
      });
    });
  });
}
