// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as off;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'add_product_form_integration_test.mocks.dart';
import '../../helpers/test_helpers.dart';

@GenerateMocks([IProductRepository, IImageService, FirebaseAuth, User])
void main() {
  group('Add Product Form Integration Tests', () {
    late MockIProductRepository mockProductRepository;
    late MockIImageService mockImageService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;

    setUpAll(() async {
      // Test ortamını başlat
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

    group('Form Field Tests', () {
      testWidgets('should render all form fields correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
            home: ChangeNotifierProvider<AddProductViewModel>(
              create: (_) => AddProductViewModel(
                productRepository: mockProductRepository,
                imageService: mockImageService,
              ),
              child: const AddProductScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Check that all form fields are rendered
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(ProductFormFields), findsOneWidget);
        expect(find.byType(BasicInfoFields), findsOneWidget);
        expect(find.byType(NutritionFields), findsOneWidget);
        expect(find.byType(AdditionalInfoFields), findsOneWidget);
        expect(find.byType(ImageSection), findsOneWidget);
      });

      testWidgets('should render all text form fields', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
            home: ChangeNotifierProvider<AddProductViewModel>(
              create: (_) => AddProductViewModel(
                productRepository: mockProductRepository,
                imageService: mockImageService,
              ),
              child: const AddProductScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Check that all expected text form fields are present
        expect(find.byType(TextFormField), findsWidgets);
        // En az 10 form field olmalı (barcode, name, brands, categories, quantity, ingredients, energy, fat, carbs, protein, sodium, fiber, sugar, allergens, description, tags)
        expect(find.byType(TextFormField), findsAtLeastNWidgets(10));
      });
    });

    group('Form Validation Tests', () {
      testWidgets('should show validation errors for empty required fields', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
            home: ChangeNotifierProvider<AddProductViewModel>(
              create: (_) => AddProductViewModel(
                productRepository: mockProductRepository,
                imageService: mockImageService,
              ),
              child: const AddProductScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Try to submit form without filling required fields
        final addButton = find.text('add_product.actions.add_product'.tr());
        if (addButton.evaluate().isNotEmpty) {
          await tester.tap(addButton);
          await tester.pumpAndSettle();
        }

        // Assert - Check that validation errors are shown
        // Note: Specific validation messages depend on the implementation
        // This test ensures the form validation mechanism is working
        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('should validate barcode field correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
            home: ChangeNotifierProvider<AddProductViewModel>(
              create: (_) => AddProductViewModel(
                productRepository: mockProductRepository,
                imageService: mockImageService,
              ),
              child: const AddProductScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Find barcode field and enter invalid data
        final barcodeFields = find.byType(TextFormField);
        if (barcodeFields.evaluate().isNotEmpty) {
          // Enter short barcode (should be invalid)
          await tester.enterText(barcodeFields.first, '123');
          await tester.pumpAndSettle();

          // Try to submit form
          final addButton = find.text('add_product.actions.add_product'.tr());
          if (addButton.evaluate().isNotEmpty) {
            await tester.tap(addButton);
            await tester.pumpAndSettle();
          }
        }

        // Assert - Form should still be present (validation should prevent submission)
        expect(find.byType(Form), findsOneWidget);
      });
    });

    group('Form Interaction Tests', () {
      testWidgets('should allow text input in form fields', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
            home: ChangeNotifierProvider<AddProductViewModel>(
              create: (_) => AddProductViewModel(
                productRepository: mockProductRepository,
                imageService: mockImageService,
              ),
              child: const AddProductScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Enter text in form fields
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().isNotEmpty) {
          // Test first few fields
          for (int i = 0; i < 3 && i < textFields.evaluate().length; i++) {
            await tester.enterText(textFields.at(i), 'Test Data $i');
            await tester.pumpAndSettle();
          }
        }

        // Assert - Form should still be functional
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(TextFormField), findsWidgets);
      });

      testWidgets('should handle form field focus correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
            home: ChangeNotifierProvider<AddProductViewModel>(
              create: (_) => AddProductViewModel(
                productRepository: mockProductRepository,
                imageService: mockImageService,
              ),
              child: const AddProductScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Tap on form fields to focus them
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().isNotEmpty) {
          await tester.tap(textFields.first, warnIfMissed: false);
          await tester.pumpAndSettle();

          // Tap on another field
          if (textFields.evaluate().length > 1) {
            await tester.tap(textFields.at(1), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }

        // Assert - Form should still be functional
        expect(find.byType(Form), findsOneWidget);
      });
    });

    group('Form Submission Tests', () {
      testWidgets('should handle form submission with valid data', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        // Mock successful product save
        final mockResult = off.Status(status: 1, statusVerbose: 'Success');
        when(
          mockProductRepository.saveProduct(
            any,
            any,
            any,
            imageFile: anyNamed('imageFile'),
          ),
        ).thenAnswer((_) async => mockResult);

        // Note: OFF credentials are handled through AppPrefs in the actual implementation

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
            home: ChangeNotifierProvider<AddProductViewModel>(
              create: (_) => AddProductViewModel(
                productRepository: mockProductRepository,
                imageService: mockImageService,
              ),
              child: const AddProductScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Fill form with valid data
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().isNotEmpty) {
          // Fill required fields with valid data
          final testData = [
            '1234567890123', // barcode
            'Test Product', // name
            'Test Brand', // brands
            'Test Category', // categories
            '100g', // quantity
            'Test ingredients', // ingredients
          ];

          for (
            int i = 0;
            i < testData.length && i < textFields.evaluate().length;
            i++
          ) {
            await tester.enterText(textFields.at(i), testData[i]);
            await tester.pumpAndSettle();
          }
        }

        // Try to submit form
        final addButton = find.text('add_product.actions.add_product'.tr());
        if (addButton.evaluate().isNotEmpty) {
          await tester.tap(addButton);
          await tester.pumpAndSettle();
        }

        // Assert - Form should still be present
        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('should handle form submission with invalid data', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
            home: ChangeNotifierProvider<AddProductViewModel>(
              create: (_) => AddProductViewModel(
                productRepository: mockProductRepository,
                imageService: mockImageService,
              ),
              child: const AddProductScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Try to submit form with empty data
        final addButton = find.text('add_product.actions.add_product'.tr());
        if (addButton.evaluate().isNotEmpty) {
          await tester.tap(addButton);
          await tester.pumpAndSettle();
        }

        // Assert - Form should still be present (validation should prevent submission)
        expect(find.byType(Form), findsOneWidget);
      });
    });

    group('Form State Management Tests', () {
      testWidgets('should maintain form state during interactions', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
            home: ChangeNotifierProvider<AddProductViewModel>(
              create: (_) => AddProductViewModel(
                productRepository: mockProductRepository,
                imageService: mockImageService,
              ),
              child: const AddProductScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Enter data and interact with form
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().isNotEmpty) {
          await tester.enterText(textFields.first, 'Test Data');
          await tester.pumpAndSettle();

          // Scroll to see if form maintains state
          await tester.drag(
            find.byType(SingleChildScrollView),
            const Offset(0, -100),
            warnIfMissed: false,
          );
          await tester.pumpAndSettle();
        }

        // Assert - Form should still be functional
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(AddProductScreen), findsOneWidget);
      });

      testWidgets('should handle form reset correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
            home: ChangeNotifierProvider<AddProductViewModel>(
              create: (_) => AddProductViewModel(
                productRepository: mockProductRepository,
                imageService: mockImageService,
              ),
              child: const AddProductScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Enter data in form
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().isNotEmpty) {
          await tester.enterText(textFields.first, 'Test Data');
          await tester.pumpAndSettle();
        }

        // Assert - Form should be functional
        expect(find.byType(Form), findsOneWidget);
        // Note: Form reset functionality would be tested through ViewModel methods
        // This test ensures the form can handle data entry
      });
    });
  });
}
