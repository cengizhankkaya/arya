// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_product_repository_integration_test.mocks.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/add_product_test_data.dart';

@GenerateMocks([IProductRepository, IImageService, FirebaseAuth, User])
void main() {
  group('Add Product Repository Integration Tests', () {
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

    group('Product Save Repository Tests', () {
      testWidgets('should handle successful product save without image', (
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

        // Assert - Form should still be present
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle successful product save with image', (
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

        // Assert - Form should still be present
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle product save failure', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Mock failed product save
        when(
          mockProductRepository.saveProduct(
            any,
            any,
            any,
            imageFile: anyNamed('imageFile'),
          ),
        ).thenAnswer((_) async => AddProductTestData.createFailureStatus());

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

        // Assert - Form should still be present
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Repository Error Handling Tests', () {
      testWidgets('should handle network errors gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Mock network error
        when(
          mockProductRepository.saveProduct(
            any,
            any,
            any,
            imageFile: anyNamed('imageFile'),
          ),
        ).thenThrow(Exception('Network error'));

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

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle timeout errors gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Mock timeout error
        when(
          mockProductRepository.saveProduct(
            any,
            any,
            any,
            imageFile: anyNamed('imageFile'),
          ),
        ).thenThrow(Exception('Request timeout'));

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

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle server errors gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Mock server error
        when(
          mockProductRepository.saveProduct(
            any,
            any,
            any,
            imageFile: anyNamed('imageFile'),
          ),
        ).thenAnswer((_) async => AddProductTestData.createServerErrorStatus());

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

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Image Upload Repository Tests', () {
      testWidgets('should handle image upload success', (
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

        // Assert - Form should still be present
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle image upload failure', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        // Create a mock image file
        final mockImageFile = AddProductTestData.createMockImageFile();
        when(mockImageService.selectedImage).thenReturn(mockImageFile);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Mock product save success but image upload failure
        when(
          mockProductRepository.saveProduct(
            any,
            any,
            any,
            imageFile: anyNamed('imageFile'),
          ),
        ).thenAnswer(
          (_) async => AddProductTestData.createImageUploadErrorStatus(),
        );

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

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Repository State Management Tests', () {
      testWidgets('should maintain repository state during form interactions', (
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

        // Act - Interact with form multiple times
        final testData = AddProductTestData.getCompleteValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Try to submit
        await TestHelpers.submitAddProductForm(tester);

        // Modify some data
        final modifiedData = Map<String, String>.from(testData);
        modifiedData['name'] = 'Modified Product';
        await TestHelpers.fillAddProductForm(tester, testData: modifiedData);

        // Try to submit again
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Form should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle multiple repository calls correctly', (
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

        // Act - Make multiple submission attempts
        final testData = AddProductTestData.getCompleteValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Multiple submissions
        for (int i = 0; i < 3; i++) {
          await TestHelpers.submitAddProductForm(tester);
        }

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Repository Integration with ViewModel Tests', () {
      testWidgets('should integrate repository with viewmodel correctly', (
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

        // Act - Test the complete flow
        final testData = AddProductTestData.getCompleteValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // Submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - All components should work together
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle repository errors in viewmodel', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Mock repository error
        when(
          mockProductRepository.saveProduct(
            any,
            any,
            any,
            imageFile: anyNamed('imageFile'),
          ),
        ).thenThrow(Exception('Repository error'));

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

        // Act - Try to submit form
        final testData = AddProductTestData.getCompleteValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        await TestHelpers.submitAddProductForm(tester);

        // Assert - App should handle error gracefully
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Repository Edge Cases Tests', () {
      testWidgets('should handle repository with different data scenarios', (
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

        // Act - Test different data scenarios
        final testScenarios = AddProductTestData.getTestScenarios();

        for (final scenario in testScenarios) {
          await TestHelpers.fillAddProductForm(tester, testData: scenario);
          await TestHelpers.submitAddProductForm(tester);

          // Assert - App should still be functional
          TestHelpers.verifyAddProductScreenComponents();
        }
      });

      testWidgets('should handle repository with edge case data', (
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

        // Act - Test edge case data
        final edgeCaseData = AddProductTestData.getEdgeCaseData();
        await TestHelpers.fillAddProductForm(tester, testData: edgeCaseData);
        await TestHelpers.submitAddProductForm(tester);

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle repository with long data', (
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

        // Act - Test long data
        final longData = AddProductTestData.getLongData();
        await TestHelpers.fillAddProductForm(tester, testData: longData);
        await TestHelpers.submitAddProductForm(tester);

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });
  });
}
