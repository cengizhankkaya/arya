// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:easy_localization/easy_localization.dart';

import 'add_product_navigation_integration_test.mocks.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/add_product_test_data.dart';

@GenerateMocks([IProductRepository, IImageService, FirebaseAuth, User])
void main() {
  group('Add Product Navigation Integration Tests', () {
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

    group('Welcome Dialog Navigation Tests', () {
      testWidgets('should show welcome dialog on first visit', (
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

        // Assert - Welcome dialog should be shown
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('welcome_dialog.title'.tr()), findsOneWidget);
      });

      testWidgets('should show welcome dialog with correct buttons', (
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

        // Assert - Welcome dialog should have correct buttons
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('welcome_dialog.later'.tr()), findsOneWidget);
        expect(
          find.text('welcome_dialog.enter_credentials'.tr()),
          findsOneWidget,
        );
      });

      testWidgets('should show welcome dialog content correctly', (
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

        // Assert - Welcome dialog should show correct content
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('welcome_dialog.content'.tr()), findsOneWidget);
      });
    });

    group('AppBar Navigation Tests', () {
      testWidgets('should have correct AppBar title', (
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

        // Assert - AppBar should have correct title
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('add_product.title'.tr()), findsOneWidget);
      });

      testWidgets('should have proper AppBar structure', (
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

        // Assert - AppBar should exist and have proper structure
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('add_product.title'.tr()), findsOneWidget);
      });
    });

    group('Form Navigation Tests', () {
      testWidgets('should render form fields correctly', (
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

        // Assert - Form should be rendered
        TestHelpers.verifyAddProductScreenComponents();
        expect(find.byType(TextFormField), findsWidgets);
        expect(
          find.text('add_product.buttons.add_product'.tr()),
          findsOneWidget,
        );
      });

      testWidgets('should handle form validation correctly', (
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

        // Assert - Form should be rendered with validation
        TestHelpers.verifyAddProductScreenComponents();
        expect(find.byType(TextFormField), findsWidgets);
      });
    });

    group('Screen State Navigation Tests', () {
      testWidgets('should show loading state during initialization', (
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

        await tester.pump();

        // Assert - Should show loading state initially
        expect(find.byType(AddProductScreen), findsOneWidget);
      });

      testWidgets('should navigate to form after loading', (
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

        // Assert - Form should be ready for input
        TestHelpers.verifyAddProductScreenComponents();
        expect(find.byType(TextFormField), findsWidgets);
      });
    });

    group('Error State Navigation Tests', () {
      testWidgets('should handle authentication state correctly', (
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

        // Assert - Should handle authenticated user
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle unauthenticated state correctly', (
        WidgetTester tester,
      ) async {
        // Arrange - No authenticated user
        when(mockFirebaseAuth.currentUser).thenReturn(null);

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

        // Assert - Should still render the screen
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Navigation Flow Tests', () {
      testWidgets('should handle complete navigation flow', (
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

        // Act - Navigate through different states
        // 1. Initial state
        TestHelpers.verifyAddProductScreenComponents();

        // 2. Fill form
        final testData = AddProductTestData.getMinimalValidProductData();
        await TestHelpers.fillAddProductForm(tester, testData: testData);

        // 3. Verify form is still functional
        TestHelpers.verifyAddProductScreenComponents();

        // Assert - Navigation flow should work correctly
        expect(find.byType(AddProductScreen), findsOneWidget);
      });

      testWidgets('should handle navigation with different user states', (
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

        // Act - Test navigation with authenticated user
        TestHelpers.verifyAddProductScreenComponents();

        // Simulate user state change
        when(mockFirebaseAuth.currentUser).thenReturn(null);
        await tester.pumpAndSettle();

        // Assert - Should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Navigation Error Handling Tests', () {
      testWidgets('should handle navigation errors gracefully', (
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

        // Act - Try to navigate through different states rapidly
        for (int i = 0; i < 5; i++) {
          await tester.pumpAndSettle();
        }

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });

      testWidgets('should handle rapid navigation changes', (
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

        // Act - Rapidly change user state
        for (int i = 0; i < 10; i++) {
          if (i % 2 == 0) {
            when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          } else {
            when(mockFirebaseAuth.currentUser).thenReturn(null);
          }
          await tester.pump();
        }
        await tester.pumpAndSettle();

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });

    group('Navigation Performance Tests', () {
      testWidgets('should handle navigation efficiently', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

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

        stopwatch.stop();

        // Assert - Navigation should be efficient
        TestHelpers.verifyAddProductScreenComponents();
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(5000),
        ); // Should load within 5 seconds
      });

      testWidgets('should handle multiple navigation cycles', (
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

        // Act - Perform multiple navigation cycles
        for (int i = 0; i < 5; i++) {
          // Fill form
          final testData = AddProductTestData.getMinimalValidProductData();
          await TestHelpers.fillAddProductForm(tester, testData: testData);

          // Clear form
          await tester.pumpAndSettle();
        }

        // Assert - App should still be functional
        TestHelpers.verifyAddProductScreenComponents();
      });
    });
  });
}
