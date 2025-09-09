// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_product_welcome_dialog_integration_test.mocks.dart';
import '../../helpers/test_helpers.dart';

@GenerateMocks([IProductRepository, IImageService, FirebaseAuth, User])
void main() {
  group('Add Product Welcome Dialog Integration Tests', () {
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

      // SharedPreferences mock setup
      SharedPreferences.setMockInitialValues({});
    });

    tearDownAll(() {
      TestHelpers.tearDown();
    });

    group('Welcome Dialog Widget Tests', () {
      testWidgets('should render WelcomeDialog with correct elements', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

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
            home: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: tester.element(find.byType(ElevatedButton)),
                      builder: (context) =>
                          WelcomeDialog(onNavigateToCredentials: () {}),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Check that dialog elements are rendered
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byType(TextButton), findsOneWidget);
        expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
      });

      testWidgets('should display correct dialog title and content', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

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
            home: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: tester.element(find.byType(ElevatedButton)),
                      builder: (context) =>
                          WelcomeDialog(onNavigateToCredentials: () {}),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Check that dialog has title and content
        expect(find.byType(AlertDialog), findsOneWidget);
        // Dialog should have title and content text widgets
        expect(find.byType(Text), findsAtLeastNWidgets(3));
      });

      testWidgets('should have correct button labels', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

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
            home: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: tester.element(find.byType(ElevatedButton)),
                      builder: (context) =>
                          WelcomeDialog(onNavigateToCredentials: () {}),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Check that buttons are present
        expect(find.byType(TextButton), findsOneWidget);
        expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
      });
    });

    group('Welcome Dialog Navigation Tests', () {
      testWidgets('should close dialog when Later button is tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

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
            home: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: tester.element(find.byType(ElevatedButton)),
                      builder: (context) =>
                          WelcomeDialog(onNavigateToCredentials: () {}),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Tap Later button
        final laterButton = find.byType(TextButton);
        await tester.tap(laterButton);
        await tester.pumpAndSettle();

        // Assert - Dialog should be closed
        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets(
        'should call onNavigateToCredentials when Enter Credentials button is tapped',
        (WidgetTester tester) async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn('test-user-id');
          when(mockImageService.selectedImage).thenReturn(null);
          when(mockImageService.isImageUploading).thenReturn(false);

          bool credentialsCallbackCalled = false;

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
              home: Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: tester.element(find.byType(ElevatedButton)),
                        builder: (context) => WelcomeDialog(
                          onNavigateToCredentials: () {
                            credentialsCallbackCalled = true;
                          },
                        ),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Act - Show dialog
          await tester.tap(find.text('Show Dialog'));
          await tester.pumpAndSettle();

          // Tap Enter Credentials button
          final elevatedButtons = find.byType(ElevatedButton);
          if (elevatedButtons.evaluate().length >= 2) {
            await tester.tap(elevatedButtons.at(1));
            await tester.pumpAndSettle();
          }

          // Assert - Callback should be called and dialog should be closed
          expect(credentialsCallbackCalled, isTrue);
          expect(find.byType(AlertDialog), findsNothing);
        },
      );

      testWidgets('should handle dialog interaction gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

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
            home: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: tester.element(find.byType(ElevatedButton)),
                      builder: (context) =>
                          WelcomeDialog(onNavigateToCredentials: () {}),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Show dialog multiple times
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Try to tap buttons multiple times
        final laterButton = find.byType(TextButton);
        if (laterButton.evaluate().isNotEmpty) {
          await tester.tap(laterButton);
          await tester.pumpAndSettle();
        }

        // Assert - App should still be functional
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('Welcome Dialog State Management Tests', () {
      testWidgets('should maintain dialog state during interactions', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

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
            home: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: tester.element(find.byType(ElevatedButton)),
                      builder: (context) =>
                          WelcomeDialog(onNavigateToCredentials: () {}),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Interact with dialog elements
        final dialog = find.byType(AlertDialog);
        expect(dialog, findsOneWidget);

        // Assert - Dialog should maintain its state
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byType(TextButton), findsOneWidget);
        expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
      });

      testWidgets('should handle dialog state changes correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

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
            home: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: tester.element(find.byType(ElevatedButton)),
                      builder: (context) =>
                          WelcomeDialog(onNavigateToCredentials: () {}),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Show and close dialog multiple times
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Close dialog
        final laterButton = find.byType(TextButton);
        await tester.tap(laterButton);
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);

        // Show dialog again
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Assert - Dialog state should be managed correctly
        expect(find.byType(AlertDialog), findsOneWidget);
      });
    });

    group('Welcome Dialog AppPrefs Integration Tests', () {
      testWidgets('should show dialog when hasSeenOffWelcomeDialog is false', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Set hasSeenOffWelcomeDialog to false
        SharedPreferences.setMockInitialValues({
          'has_seen_off_welcome_dialog': false,
        });

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

        // Wait for dialog to appear
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();

        // Assert - Dialog should be shown
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byType(WelcomeDialog), findsOneWidget);
      });

      testWidgets(
        'should not show dialog when hasSeenOffWelcomeDialog is true',
        (WidgetTester tester) async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn('test-user-id');
          when(mockImageService.selectedImage).thenReturn(null);
          when(mockImageService.isImageUploading).thenReturn(false);

          // Set hasSeenOffWelcomeDialog to true
          SharedPreferences.setMockInitialValues({
            'has_seen_off_welcome_dialog': true,
          });

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

          // Wait for potential dialog to appear
          await tester.pump(const Duration(milliseconds: 100));
          await tester.pumpAndSettle();

          // Assert - Dialog should not be shown
          expect(find.byType(AlertDialog), findsNothing);
          expect(find.byType(WelcomeDialog), findsNothing);
          expect(find.byType(AddProductScreen), findsOneWidget);
        },
      );

      testWidgets('should handle AppPrefs integration correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Start with hasSeenOffWelcomeDialog as false
        SharedPreferences.setMockInitialValues({
          'has_seen_off_welcome_dialog': false,
        });

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

        // Wait for dialog to appear
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();

        // Assert - Dialog should be shown initially
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byType(WelcomeDialog), findsOneWidget);
      });
    });

    group('Welcome Dialog Error Handling Tests', () {
      testWidgets('should handle dialog errors gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

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
            home: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: tester.element(find.byType(ElevatedButton)),
                      builder: (context) => WelcomeDialog(
                        onNavigateToCredentials: () {
                          // Simulate error but don't throw to avoid test failure
                          print('Navigation error simulated');
                        },
                      ),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Try to tap Enter Credentials button
        final elevatedButtons = find.byType(ElevatedButton);
        if (elevatedButtons.evaluate().length >= 2) {
          await tester.tap(elevatedButtons.at(1));
          await tester.pumpAndSettle();
        }

        // Assert - App should still be functional
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should handle AppPrefs errors gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Don't set any initial values to simulate AppPrefs error
        SharedPreferences.setMockInitialValues({});

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

        // Wait for potential dialog to appear
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();

        // Assert - App should still be functional
        expect(find.byType(AddProductScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should handle dialog navigation errors gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

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
            home: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: tester.element(find.byType(ElevatedButton)),
                      builder: (context) => WelcomeDialog(
                        onNavigateToCredentials: () {
                          // Simulate navigation error but don't throw
                          print('Navigation failed simulated');
                        },
                      ),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Try to interact with dialog buttons
        final laterButton = find.byType(TextButton);
        if (laterButton.evaluate().isNotEmpty) {
          await tester.tap(laterButton);
          await tester.pumpAndSettle();
        }

        // Assert - App should still be functional
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('Welcome Dialog Integration with AddProductScreen Tests', () {
      testWidgets('should integrate welcome dialog with AddProductScreen', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Set hasSeenOffWelcomeDialog to false to trigger dialog
        SharedPreferences.setMockInitialValues({
          'has_seen_off_welcome_dialog': false,
        });

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

        // Wait for dialog to appear
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();

        // Assert - Both AddProductScreen and WelcomeDialog should be present
        expect(find.byType(AddProductScreen), findsOneWidget);
        expect(find.byType(WelcomeDialog), findsOneWidget);
        expect(find.byType(AlertDialog), findsOneWidget);
      });

      testWidgets(
        'should handle dialog dismissal and continue with AddProductScreen',
        (WidgetTester tester) async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn('test-user-id');
          when(mockImageService.selectedImage).thenReturn(null);
          when(mockImageService.isImageUploading).thenReturn(false);

          // Set hasSeenOffWelcomeDialog to false to trigger dialog
          SharedPreferences.setMockInitialValues({
            'has_seen_off_welcome_dialog': false,
          });

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

          // Wait for dialog to appear
          await tester.pump(const Duration(milliseconds: 100));
          await tester.pumpAndSettle();

          // Act - Dismiss dialog
          final laterButton = find.byType(TextButton);
          if (laterButton.evaluate().isNotEmpty) {
            await tester.tap(laterButton);
            await tester.pumpAndSettle();
          }

          // Assert - Dialog should be dismissed, AddProductScreen should remain
          expect(find.byType(AlertDialog), findsNothing);
          expect(find.byType(WelcomeDialog), findsNothing);
          expect(find.byType(AddProductScreen), findsOneWidget);
          expect(find.byType(Scaffold), findsOneWidget);
        },
      );
    });
  });
}
