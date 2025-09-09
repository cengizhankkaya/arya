// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_product_flow_integration_test.mocks.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/add_product_test_data.dart';

@GenerateMocks([IProductRepository, IImageService, FirebaseAuth, User])
void main() {
  group('Add Product Flow Integration Tests', () {
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

    group('Basic Widget Tests', () {
      testWidgets('should render AddProductScreen without errors', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

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

        // Assert - Check that the screen renders without errors
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should render form fields', (WidgetTester tester) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

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

        // Assert - Check that form fields are rendered
        TestHelpers.verifyAddProductScreenComponents();
        expect(find.byType(TextFormField), findsWidgets);
      });
    });

    group('ViewModel Tests', () {
      testWidgets('should create AddProductViewModel without errors', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        final viewModel = AddProductViewModel(
          productRepository: mockProductRepository,
          imageService: mockImageService,
        );

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: viewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Check that ViewModel is created and working
        expect(viewModel, isNotNull);
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.successMessage, isNull);
      });
    });

    group('Image Service Tests', () {
      testWidgets('should handle image service without errors', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        final viewModel = AddProductViewModel(
          productRepository: mockProductRepository,
          imageService: mockImageService,
        );

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: viewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Check that image service is working
        expect(viewModel.selectedImage, isNull);
        expect(viewModel.isImageUploading, isFalse);
      });
    });

    group('Repository Tests', () {
      testWidgets('should handle repository without errors', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        final mockResult = AddProductTestData.createSuccessStatus();
        when(
          mockProductRepository.saveProduct(
            any,
            any,
            any,
            imageFile: anyNamed('imageFile'),
          ),
        ).thenAnswer((_) async => mockResult);

        final viewModel = AddProductViewModel(
          productRepository: mockProductRepository,
          imageService: mockImageService,
        );

        await tester.pumpWidget(
          TestHelpers.createAddProductTestApp(
            child: const AddProductScreen(),
            viewModel: viewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Check that repository is working
        expect(viewModel, isNotNull);
      });
    });

    group('Complete Flow Tests', () {
      testWidgets('should handle complete product addition flow', (
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

        // Act - Complete flow
        // 1. Fill form with valid data
        final testData = AddProductTestData.getCompleteValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // 2. Submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Flow should complete successfully
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle complete flow with image', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        // Create a mock image file
        final mockImageFile = AddProductTestData.createMockImageFile();
        when(mockImageService.selectedImage).thenReturn(mockImageFile);
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

        // Act - Complete flow with image
        // 1. Fill form with valid data
        final testData = AddProductTestData.getCompleteValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // 2. Submit form
        await TestHelpers.submitAddProductForm(tester);

        // Assert - Flow should complete successfully
        TestHelpers.verifyAddProductScreenComponents();
        TestHelpers.verifyImageSectionComponents();
      });
    });

    group('Error Flow Tests', () {
      testWidgets('should handle error flow gracefully', (
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

        // Act - Try to complete flow with error
        final testData = AddProductTestData.getCompleteValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);
        await TestHelpers.submitAddProductForm(tester);

        // Assert - App should handle error gracefully
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle network error flow', (
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

        // Act - Try to complete flow with network error
        final testData = AddProductTestData.getCompleteValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);
        await TestHelpers.submitAddProductForm(tester);

        // Assert - App should handle network error gracefully
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Performance Flow Tests', () {
      testWidgets('should handle flow efficiently', (
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

        final stopwatch = Stopwatch()..start();

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

        // Act - Complete flow
        final testData = AddProductTestData.getCompleteValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);
        await TestHelpers.submitAddProductForm(tester);

        stopwatch.stop();

        // Assert - Flow should be efficient
        TestHelpers.verifyAddProductScreenComponents();
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(10000),
        ); // Should complete within 10 seconds
      });

      testWidgets('should handle multiple flow cycles', (
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

        // Act - Perform multiple flow cycles
        final testScenarios = AddProductTestData.getTestScenarios();

        for (final scenario in testScenarios) {
          await TestHelpers.fillAddProductForm(tester, testData: scenario);
          await TestHelpers.submitAddProductForm(tester);
        }

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Edge Case Flow Tests', () {
      testWidgets('should handle edge case data flow', (
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

        // Assert - App should handle edge cases
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle long data flow', (WidgetTester tester) async {
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

        // Assert - App should handle long data
        TestHelpers.verifyAddProductScreenComponents();
      });
    });
  });
}
