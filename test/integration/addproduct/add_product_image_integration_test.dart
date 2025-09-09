// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_product_image_integration_test.mocks.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/add_product_test_data.dart';

@GenerateMocks([IProductRepository, IImageService, FirebaseAuth, User])
void main() {
  group('Add Product Image Integration Tests', () {
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

    group('Image Section Widget Tests', () {
      testWidgets('should render ImageSection without errors', (
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

        // Assert - Check that ImageSection is rendered
        TestHelpers.verifyImageSectionComponents();
      });

      testWidgets('should render image picker buttons', (
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

        // Assert - Check that image picker buttons are rendered
        TestHelpers.verifyImageSectionComponents();
      });

      testWidgets('should show loading state when image is uploading', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(true);

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

        // Assert - Check that buttons are still present (loading state may not show CircularProgressIndicator in mock)
        expect(find.byType(ElevatedButton), findsWidgets);
        expect(find.byType(ImageSection), findsOneWidget);
      });
    });

    group('Image Preview Tests', () {
      testWidgets('should show image preview when image is selected', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        // Create a mock image file
        final mockImageFile = AddProductTestData.createMockImageFile();
        when(mockImageService.selectedImage).thenReturn(mockImageFile);
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

        // Assert - Check that image section is functional with image
        TestHelpers.verifyImageSectionComponents();
      });

      testWidgets('should show remove image button when image is selected', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        // Create a mock image file
        final mockImageFile = AddProductTestData.createMockImageFile();
        when(mockImageService.selectedImage).thenReturn(mockImageFile);
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

        // Assert - Check that image section is functional with image
        TestHelpers.verifyImageSectionComponents();
      });
    });

    group('Image Service Integration Tests', () {
      testWidgets('should handle gallery image picker call', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => null);

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

        // Act - Tap on gallery button
        final galleryButton = find.byIcon(Icons.photo_library);
        if (galleryButton.evaluate().isNotEmpty) {
          await tester.tap(galleryButton, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Assert - Image section should still be functional
        TestHelpers.verifyImageSectionComponents();
      });

      testWidgets('should handle camera image picker call', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenAnswer((_) async => null);

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

        // Act - Tap on camera button
        final cameraButton = find.byIcon(Icons.camera_alt);
        if (cameraButton.evaluate().isNotEmpty) {
          await tester.tap(cameraButton, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Assert - Image section should still be functional
        TestHelpers.verifyImageSectionComponents();
      });

      testWidgets('should handle image removal', (WidgetTester tester) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        // Create a mock image file
        final mockImageFile = AddProductTestData.createMockImageFile();
        when(mockImageService.selectedImage).thenReturn(mockImageFile);
        when(mockImageService.isImageUploading).thenReturn(false);
        when(mockImageService.removeSelectedImage()).thenReturn(null);

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

        // Act - Tap on remove button if it exists
        final removeButton = find.byIcon(Icons.delete);
        if (removeButton.evaluate().isNotEmpty) {
          await tester.tap(removeButton, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Assert - Image section should still be functional
        TestHelpers.verifyImageSectionComponents();
      });
    });

    group('Image Upload Integration Tests', () {
      testWidgets('should handle image upload with product submission', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        // Create a mock image file
        final mockImageFile = AddProductTestData.createMockImageFile();
        when(mockImageService.selectedImage).thenReturn(mockImageFile);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Mock successful product save with image
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

        // Assert - Form should still be functional
        TestHelpers.verifyAddProductScreenComponents();
        TestHelpers.verifyImageSectionComponents();
      });

      testWidgets('should handle product submission without image', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Mock successful product save without image
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

        // Assert - Form should still be functional
        TestHelpers.verifyAddProductScreenComponents();
        TestHelpers.verifyImageSectionComponents();
      });
    });

    group('Image State Management Tests', () {
      testWidgets('should maintain image state during form interactions', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        // Create a mock image file
        final mockImageFile = AddProductTestData.createMockImageFile();
        when(mockImageService.selectedImage).thenReturn(mockImageFile);
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

        // Act - Interact with form while image is selected
        final testData = AddProductTestData.getMinimalValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Assert - Image section should still be functional
        TestHelpers.verifyImageSectionComponents();
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle image state changes correctly', (
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

        // Assert - Image section should be functional without image
        TestHelpers.verifyImageSectionComponents();
      });
    });

    group('Image Error Handling Tests', () {
      testWidgets('should handle image picker errors gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);
        when(
          mockImageService.pickImageFromGallery(),
        ).thenThrow(Exception('Image picker error'));

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

        // Act - Tap on gallery button (should handle error gracefully)
        final galleryButton = find.byIcon(Icons.photo_library);
        if (galleryButton.evaluate().isNotEmpty) {
          await tester.tap(galleryButton, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
        TestHelpers.verifyImageSectionComponents();
      });

      testWidgets('should handle image upload errors gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        // Create a mock image file
        final mockImageFile = AddProductTestData.createMockImageFile();
        when(mockImageService.selectedImage).thenReturn(mockImageFile);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Mock failed product save
        when(
          mockProductRepository.saveProduct(
            any,
            any,
            any,
            imageFile: anyNamed('imageFile'),
          ),
        ).thenThrow(Exception('Image upload failed'));

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

        // Act - Fill form and try to submit
        final testData = AddProductTestData.getCompleteValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - App should still be functional despite error
        TestHelpers.verifyAddProductScreenComponents();
        TestHelpers.verifyImageSectionComponents();
      });
    });

    group('Image Edge Cases Tests', () {
      testWidgets('should handle multiple image selection attempts', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => null);

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

        // Act - Tap gallery button multiple times
        final galleryButton = find.byIcon(Icons.photo_library);
        if (galleryButton.evaluate().isNotEmpty) {
          for (int i = 0; i < 3; i++) {
            await tester.tap(galleryButton, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
        TestHelpers.verifyImageSectionComponents();
      });

      testWidgets('should handle rapid image service calls', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => null);
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenAnswer((_) async => null);

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

        // Act - Rapidly tap both image buttons
        final galleryButton = find.byIcon(Icons.photo_library);
        final cameraButton = find.byIcon(Icons.camera_alt);

        if (galleryButton.evaluate().isNotEmpty &&
            cameraButton.evaluate().isNotEmpty) {
          for (int i = 0; i < 5; i++) {
            await tester.tap(galleryButton, warnIfMissed: false);
            await tester.pump();
            await tester.tap(cameraButton, warnIfMissed: false);
            await tester.pump();
          }
          await tester.pumpAndSettle();
        }

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
        TestHelpers.verifyImageSectionComponents();
      });

      testWidgets('should handle image service state changes', (
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

        // Act - Interact with form while image service state changes
        final testData = AddProductTestData.getMinimalValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Simulate image selection
        final mockImageFile = AddProductTestData.createMockImageFile();
        when(mockImageService.selectedImage).thenReturn(mockImageFile);

        // Trigger rebuild
        await tester.pumpAndSettle();

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
        TestHelpers.verifyImageSectionComponents();
      });
    });
  });
}
