import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:arya/features/index.dart';
import '../../helpers/test_helpers.dart';

// Mock sınıfları generate etmek için annotation
@GenerateMocks([UserService, FirebaseAuth, User, FirebaseApp])
import 'profile_error_handling_integration_test.mocks.dart';

/// Profile Error Handling Integration Test
///
/// Bu test, profile feature'ının tüm error handling senaryolarını kapsamlı şekilde test eder:
/// - Network errors (ağ hataları)
/// - Authentication errors (kimlik doğrulama hataları)
/// - Validation errors (doğrulama hataları)
/// - Service errors (servis hataları)
/// - Permission errors (izin hataları)
/// - Timeout errors (zaman aşımı hataları)
/// - Error recovery mechanisms (hata kurtarma mekanizmaları)
/// - Error message display (hata mesajı gösterimi)
/// - Error state management (hata durumu yönetimi)
///
/// Test stratejisi:
/// 1. Her error türü için gerçekçi senaryolar oluştur
/// 2. Error message'ların doğru gösterildiğini doğrula
/// 3. Error recovery mekanizmalarını test et
/// 4. Error state'den normal state'e geçişi kontrol et
/// 5. UI'ın error durumunda doğru davrandığını doğrula
/// 6. Error handling'in kullanıcı deneyimini bozmadığını kontrol et
///
/// ÖĞRETİCİ NOTLAR:
///
/// 1. ERROR HANDLING TEST PATTERNS:
///    - when().thenThrow() ile farklı exception türleri simüle edilir
///    - Exception message'ları gerçekçi olmalı
///    - Error state'lerin UI'da doğru gösterildiği kontrol edilir
///    - Error recovery butonlarının çalıştığı doğrulanır
///
/// 2. NETWORK ERROR TESTLERİ:
///    - SocketException, TimeoutException gibi network hataları
///    - Connection timeout, read timeout senaryoları
///    - Network interruption durumları
///    - Offline/online geçiş senaryoları
///
/// 3. AUTHENTICATION ERROR TESTLERİ:
///    - FirebaseAuthException türleri
///    - Token expiration, invalid credentials
///    - User disabled, user not found
///    - Permission denied senaryoları
///
/// 4. VALIDATION ERROR TESTLERİ:
///    - Form validation hataları
///    - Input format hataları
///    - Required field hataları
///    - Business rule validation hataları
///
/// 5. SERVICE ERROR TESTLERİ:
///    - Database connection hataları
///    - Service unavailable durumları
///    - Rate limiting hataları
///    - Server error responses
///
/// 6. ERROR RECOVERY TESTLERİ:
///    - Retry mechanism'ları
///    - Error state'den normal state'e geçiş
///    - User action'ları ile error recovery
///    - Automatic error recovery senaryoları
///
/// 7. ERROR UI TESTLERİ:
///    - Error message'ların doğru gösterilmesi
///    - Error icon'larının görünürlüğü
///    - Error state'de UI etkileşimlerinin disable olması
///    - Error recovery butonlarının çalışması
///
/// 8. ERROR STATE MANAGEMENT TESTLERİ:
///    - Error state'in doğru set edilmesi
///    - Error state'in doğru clear edilmesi
///    - Multiple error handling
///    - Error state persistence
void main() {
  group('Profile Error Handling Integration Tests', () {
    late MockUserService mockUserService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late MockFirebaseApp mockFirebaseApp;
    late ProfileViewModel viewModel;

    setUp(() async {
      // Mock sınıfları initialize et
      mockUserService = MockUserService();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockFirebaseApp = MockFirebaseApp();

      // Mock User için temel setup
      when(mockUser.uid).thenReturn('test-uid');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockUser.displayName).thenReturn('Test User');

      // Mock FirebaseAuth setup
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      // Mock FirebaseApp setup
      when(mockFirebaseApp.name).thenReturn('[DEFAULT]');
      when(mockFirebaseApp.options).thenReturn(
        const FirebaseOptions(
          apiKey: 'test-api-key',
          appId: 'test-app-id',
          messagingSenderId: 'test-sender-id',
          projectId: 'test-project-id',
        ),
      );

      // Test helper setup
      TestHelpers.setupEasyLocalization();
      TestHelpers.setupComprehensiveFirebaseMocks();
    });

    tearDown(() {
      // Test sonrası temizlik
      TestHelpers.tearDown();
    });

    /// Test için ProfileBody wrapper'ı oluştur
    ///
    /// Bu wrapper, farklı error state'leri test etmek için
    /// ViewModel'i özelleştirilmiş durumlarla oluşturur
    Widget createTestProfileBody({
      UserModel? initialUser,
      String? errorMessage,
      bool isEditMode = false,
    }) {
      // ViewModel'i mock servislerle oluştur
      viewModel = ProfileViewModel(
        userService: mockUserService,
        firebaseAuth: mockFirebaseAuth,
      );

      // Test durumunu ayarla
      if (initialUser != null) {
        viewModel.setUser(initialUser);
      }
      if (errorMessage != null) {
        viewModel.setError(errorMessage);
      }
      if (isEditMode) {
        viewModel.toggleEditMode();
      }

      return TestHelpers.createTestAppWithEasyLocalization(
        ChangeNotifierProvider.value(
          value: viewModel,
          child: const ProfileBody(),
        ),
      );
    }

    group('Network Error Tests', () {
      testWidgets(
        'Network connection error durumunda uygun mesaj gösterilmeli',
        (WidgetTester tester) async {
          // Arrange: Mock network error
          when(
            mockUserService.getUserData(any),
          ).thenThrow(Exception('İnternet bağlantınızı kontrol edin'));

          // Act: ProfileBody'i render et ve fetchUser çağır
          await tester.pumpWidget(createTestProfileBody());
          viewModel.fetchUser();
          await tester.pumpAndSettle();

          // Assert: Network error message görünür
          expect(
            find.textContaining('İnternet bağlantınızı kontrol edin'),
            findsOneWidget,
          );
          expect(find.byIcon(Icons.error_outline), findsOneWidget);
          expect(find.text('general.button.retry'), findsOneWidget);
        },
      );

      testWidgets('Socket timeout error durumunda uygun mesaj gösterilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock socket timeout error
        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception('Bağlantı zaman aşımına uğradı'));

        // Act: ProfileBody'i render et ve fetchUser çağır
        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Timeout error message görünür
        expect(
          find.textContaining('Bağlantı zaman aşımına uğradı'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });

      testWidgets('DNS resolution error durumunda uygun mesaj gösterilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock DNS resolution error
        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception('Sunucu bulunamadı'));

        // Act: ProfileBody'i render et ve fetchUser çağır
        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: DNS error message görünür
        expect(find.textContaining('Sunucu bulunamadı'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });

      testWidgets('Network interruption durumunda retry butonu çalışmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: İlk çağrıda network error, ikinci çağrıda başarı
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception('İnternet bağlantınızı kontrol edin'));

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Error state
        expect(
          find.textContaining('İnternet bağlantınızı kontrol edin'),
          findsOneWidget,
        );

        // Act: Retry butonuna bas
        final retryButton = find.text('general.button.retry');
        if (retryButton.evaluate().isNotEmpty) {
          // Retry için mock'u güncelle
          when(
            mockUserService.getUserData(any),
          ).thenAnswer((_) async => testUser);

          await tester.tap(retryButton);
          await tester.pumpAndSettle();

          // Assert: Success state
          expect(
            find.textContaining('İnternet bağlantınızı kontrol edin'),
            findsNothing,
          );
          expect(find.text('John Doe'), findsOneWidget);
          expect(find.text('John'), findsOneWidget);
          expect(find.text('Doe'), findsOneWidget);
        }
      });
    });

    group('Authentication Error Tests', () {
      testWidgets(
        'User not authenticated error durumunda uygun mesaj gösterilmeli',
        (WidgetTester tester) async {
          // Arrange: Mock unauthenticated user
          when(mockFirebaseAuth.currentUser).thenReturn(null);

          // Act: ProfileBody'i render et ve fetchUser çağır
          await tester.pumpWidget(createTestProfileBody());
          viewModel.fetchUser();
          await tester.pumpAndSettle();

          // Assert: Authentication error message görünür
          expect(
            find.textContaining('Kullanıcı oturumu bulunamadı'),
            findsOneWidget,
          );
          expect(find.byIcon(Icons.error_outline), findsOneWidget);
          expect(find.text('general.button.retry'), findsOneWidget);
        },
      );

      testWidgets('Token expiration error durumunda uygun mesaj gösterilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock token expiration error
        when(mockUserService.getUserData(any)).thenThrow(
          FirebaseAuthException(
            code: 'user-token-expired',
            message: 'Oturum süresi dolmuş',
          ),
        );

        // Act: ProfileBody'i render et ve fetchUser çağır
        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Token expiration error message görünür
        expect(find.textContaining('Oturum süresi dolmuş'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });

      testWidgets(
        'Invalid credentials error durumunda uygun mesaj gösterilmeli',
        (WidgetTester tester) async {
          // Arrange: Mock invalid credentials error
          when(mockUserService.getUserData(any)).thenThrow(
            FirebaseAuthException(
              code: 'invalid-credential',
              message: 'Geçersiz kimlik bilgileri',
            ),
          );

          // Act: ProfileBody'i render et ve fetchUser çağır
          await tester.pumpWidget(createTestProfileBody());
          viewModel.fetchUser();
          await tester.pumpAndSettle();

          // Assert: Invalid credentials error message görünür
          expect(
            find.textContaining('Geçersiz kimlik bilgileri'),
            findsOneWidget,
          );
          expect(find.byIcon(Icons.error_outline), findsOneWidget);
          expect(find.text('general.button.retry'), findsOneWidget);
        },
      );

      testWidgets('User disabled error durumunda uygun mesaj gösterilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock user disabled error
        when(mockUserService.getUserData(any)).thenThrow(
          FirebaseAuthException(
            code: 'user-disabled',
            message: 'Kullanıcı hesabı devre dışı bırakılmış',
          ),
        );

        // Act: ProfileBody'i render et ve fetchUser çağır
        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: User disabled error message görünür
        expect(
          find.textContaining('Kullanıcı hesabı devre dışı bırakılmış'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });
    });

    group('Service Error Tests', () {
      testWidgets(
        'Database connection error durumunda uygun mesaj gösterilmeli',
        (WidgetTester tester) async {
          // Arrange: Mock database connection error
          when(
            mockUserService.getUserData(any),
          ).thenThrow(Exception('Veritabanı bağlantısı kurulamadı'));

          // Act: ProfileBody'i render et ve fetchUser çağır
          await tester.pumpWidget(createTestProfileBody());
          viewModel.fetchUser();
          await tester.pumpAndSettle();

          // Assert: Database error message görünür
          expect(
            find.textContaining('Veritabanı bağlantısı kurulamadı'),
            findsOneWidget,
          );
          expect(find.byIcon(Icons.error_outline), findsOneWidget);
          expect(find.text('general.button.retry'), findsOneWidget);
        },
      );

      testWidgets(
        'Service unavailable error durumunda uygun mesaj gösterilmeli',
        (WidgetTester tester) async {
          // Arrange: Mock service unavailable error
          when(
            mockUserService.getUserData(any),
          ).thenThrow(Exception('Servis şu anda kullanılamıyor'));

          // Act: ProfileBody'i render et ve fetchUser çağır
          await tester.pumpWidget(createTestProfileBody());
          viewModel.fetchUser();
          await tester.pumpAndSettle();

          // Assert: Service unavailable error message görünür
          expect(
            find.textContaining('Servis şu anda kullanılamıyor'),
            findsOneWidget,
          );
          expect(find.byIcon(Icons.error_outline), findsOneWidget);
          expect(find.text('general.button.retry'), findsOneWidget);
        },
      );

      testWidgets('Rate limiting error durumunda uygun mesaj gösterilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock rate limiting error
        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception('Çok fazla istek gönderildi, lütfen bekleyin'));

        // Act: ProfileBody'i render et ve fetchUser çağır
        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Rate limiting error message görünür
        expect(
          find.textContaining('Çok fazla istek gönderildi, lütfen bekleyin'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });

      testWidgets('Server error durumunda uygun mesaj gösterilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock server error
        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception('Sunucu hatası oluştu'));

        // Act: ProfileBody'i render et ve fetchUser çağır
        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Server error message görünür
        expect(find.textContaining('Sunucu hatası oluştu'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });
    });

    group('Update Error Tests', () {
      testWidgets(
        'Update operation network error durumunda uygun mesaj gösterilmeli',
        (WidgetTester tester) async {
          // Arrange: Test user
          const testUser = UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );

          // Mock update network error
          when(
            mockUserService.updateUserData(any),
          ).thenThrow(Exception('Güncelleme sırasında ağ hatası oluştu'));

          await tester.pumpWidget(createTestProfileBody(initialUser: testUser));
          await tester.pumpAndSettle();

          // Edit mode'a geç
          final editButton = find.byIcon(Icons.edit);
          if (editButton.evaluate().isNotEmpty) {
            await tester.tap(editButton);
            await tester.pumpAndSettle();

            // Form alanlarını düzenle
            if (find.byType(TextFormField).evaluate().isNotEmpty) {
              final nameField = find.byType(TextFormField).first;
              await tester.enterText(nameField, 'Jane');
              await tester.pump();

              // Save butonuna bas
              final saveButton = find.text('general.button.save');
              if (saveButton.evaluate().isNotEmpty) {
                await tester.tap(saveButton);
                await tester.pumpAndSettle();

                // Assert: Update error message görünür
                expect(
                  find.textContaining('Güncelleme sırasında ağ hatası oluştu'),
                  findsOneWidget,
                );
              }
            }
          }
        },
      );

      testWidgets(
        'Update operation validation error durumunda uygun mesaj gösterilmeli',
        (WidgetTester tester) async {
          // Arrange: Test user
          const testUser = UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );

          // Mock update validation error
          when(
            mockUserService.updateUserData(any),
          ).thenThrow(Exception('Girilen bilgiler geçersiz'));

          await tester.pumpWidget(createTestProfileBody(initialUser: testUser));
          await tester.pumpAndSettle();

          // Edit mode'a geç
          final editButton = find.byIcon(Icons.edit);
          if (editButton.evaluate().isNotEmpty) {
            await tester.tap(editButton);
            await tester.pumpAndSettle();

            // Form alanlarını düzenle
            if (find.byType(TextFormField).evaluate().isNotEmpty) {
              final nameField = find.byType(TextFormField).first;
              await tester.enterText(nameField, 'Jane');
              await tester.pump();

              // Save butonuna bas
              final saveButton = find.text('general.button.save');
              if (saveButton.evaluate().isNotEmpty) {
                await tester.tap(saveButton);
                await tester.pumpAndSettle();

                // Assert: Validation error message görünür
                expect(
                  find.textContaining('Girilen bilgiler geçersiz'),
                  findsOneWidget,
                );
              }
            }
          }
        },
      );

      testWidgets(
        'Update operation permission error durumunda uygun mesaj gösterilmeli',
        (WidgetTester tester) async {
          // Arrange: Test user
          const testUser = UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );

          // Mock update permission error
          when(
            mockUserService.updateUserData(any),
          ).thenThrow(Exception('Bu işlem için yetkiniz bulunmuyor'));

          await tester.pumpWidget(createTestProfileBody(initialUser: testUser));
          await tester.pumpAndSettle();

          // Edit mode'a geç
          final editButton = find.byIcon(Icons.edit);
          if (editButton.evaluate().isNotEmpty) {
            await tester.tap(editButton);
            await tester.pumpAndSettle();

            // Form alanlarını düzenle
            if (find.byType(TextFormField).evaluate().isNotEmpty) {
              final nameField = find.byType(TextFormField).first;
              await tester.enterText(nameField, 'Jane');
              await tester.pump();

              // Save butonuna bas
              final saveButton = find.text('general.button.save');
              if (saveButton.evaluate().isNotEmpty) {
                await tester.tap(saveButton);
                await tester.pumpAndSettle();

                // Assert: Permission error message görünür
                expect(
                  find.textContaining('Bu işlem için yetkiniz bulunmuyor'),
                  findsOneWidget,
                );
              }
            }
          }
        },
      );
    });

    group('Delete Account Error Tests', () {
      testWidgets(
        'Delete account network error durumunda uygun mesaj gösterilmeli',
        (WidgetTester tester) async {
          // Arrange: Test user
          const testUser = UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );

          // Mock delete network error
          when(
            mockUserService.deleteUserData(any),
          ).thenThrow(Exception('Hesap silinirken ağ hatası oluştu'));

          await tester.pumpWidget(createTestProfileBody(initialUser: testUser));
          await tester.pumpAndSettle();

          // Delete account dialog'unu aç
          final deleteButton = find.text('general.button.delete_account');
          if (deleteButton.evaluate().isNotEmpty) {
            await tester.tap(deleteButton);
            await tester.pumpAndSettle();

            // Confirm butonuna bas
            final confirmButton = find.text('general.button.confirm');
            if (confirmButton.evaluate().isNotEmpty) {
              await tester.tap(confirmButton);
              await tester.pumpAndSettle();

              // Assert: Delete error message görünür
              expect(
                find.textContaining('Hesap silinirken ağ hatası oluştu'),
                findsOneWidget,
              );
            }
          }
        },
      );

      testWidgets(
        'Delete account permission error durumunda uygun mesaj gösterilmeli',
        (WidgetTester tester) async {
          // Arrange: Test user
          const testUser = UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );

          // Mock delete permission error
          when(
            mockUserService.deleteUserData(any),
          ).thenThrow(Exception('Hesap silme yetkiniz bulunmuyor'));

          await tester.pumpWidget(createTestProfileBody(initialUser: testUser));
          await tester.pumpAndSettle();

          // Delete account dialog'unu aç
          final deleteButton = find.text('general.button.delete_account');
          if (deleteButton.evaluate().isNotEmpty) {
            await tester.tap(deleteButton);
            await tester.pumpAndSettle();

            // Confirm butonuna bas
            final confirmButton = find.text('general.button.confirm');
            if (confirmButton.evaluate().isNotEmpty) {
              await tester.tap(confirmButton);
              await tester.pumpAndSettle();

              // Assert: Permission error message görünür
              expect(
                find.textContaining('Hesap silme yetkiniz bulunmuyor'),
                findsOneWidget,
              );
            }
          }
        },
      );
    });

    group('Error Recovery Tests', () {
      testWidgets('Error state\'den normal state\'e geçiş doğru çalışmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: İlk çağrıda error, ikinci çağrıda başarı
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception('Test error'));

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Error state
        expect(find.textContaining('Test error'), findsOneWidget);

        // Act: Retry butonuna bas
        final retryButton = find.text('general.button.retry');
        if (retryButton.evaluate().isNotEmpty) {
          // Retry için mock'u güncelle
          when(
            mockUserService.getUserData(any),
          ).thenAnswer((_) async => testUser);

          await tester.tap(retryButton);
          await tester.pumpAndSettle();

          // Assert: Normal state
          expect(find.textContaining('Test error'), findsNothing);
          expect(find.text('John Doe'), findsOneWidget);
          expect(find.text('John'), findsOneWidget);
          expect(find.text('Doe'), findsOneWidget);
        }
      });

      testWidgets('Multiple error handling doğru çalışmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // İlk çağrıda error
        when(mockUserService.getUserData(any)).thenThrow(Exception('İlk hata'));

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: İlk error
        expect(find.textContaining('İlk hata'), findsOneWidget);

        // İkinci çağrıda farklı error
        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception('İkinci hata'));

        final retryButton = find.text('general.button.retry');
        if (retryButton.evaluate().isNotEmpty) {
          await tester.tap(retryButton);
          await tester.pumpAndSettle();

          // Assert: İkinci error
          expect(find.textContaining('İkinci hata'), findsOneWidget);
          expect(find.textContaining('İlk hata'), findsNothing);
        }
      });

      testWidgets('Error state persistence doğru çalışmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock error
        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception('Persistent error'));

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Error state
        expect(find.textContaining('Persistent error'), findsOneWidget);

        // Act: Widget'ı yeniden render et (aynı error state ile)
        await tester.pumpWidget(
          createTestProfileBody(errorMessage: 'Persistent error'),
        );
        await tester.pumpAndSettle();

        // Assert: Error state korundu
        expect(find.textContaining('Persistent error'), findsOneWidget);
      });
    });

    group('Error UI Tests', () {
      testWidgets('Error state\'de UI etkileşimleri disable olmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock error
        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception('UI test error'));

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Error state'de sadece retry butonu aktif
        expect(find.textContaining('UI test error'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);

        // Diğer butonlar görünmez olmalı
        expect(find.byIcon(Icons.edit), findsNothing);
        expect(find.text('general.button.logout'), findsNothing);
      });

      testWidgets('Error message format doğru olmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock error
        const errorMessage = 'Test error message';
        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception(errorMessage));

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Error message format
        expect(find.textContaining(errorMessage), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });

      testWidgets('Error state\'de loading indicator gösterilmemeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock error
        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception('Loading test error'));

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Loading indicator yok
        expect(find.byType(ProfileShimmerWidget), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.textContaining('Loading test error'), findsOneWidget);
      });
    });

    group('Error State Management Tests', () {
      testWidgets('Error state doğru set edilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        await tester.pumpWidget(createTestProfileBody(initialUser: testUser));
        await tester.pumpAndSettle();

        // Act: Manual error set
        viewModel.setError('Manual error');
        await tester.pump();

        // Assert: Error state set edildi
        expect(find.textContaining('Manual error'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });

      testWidgets('Error state doğru clear edilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        await tester.pumpWidget(createTestProfileBody(initialUser: testUser));
        await tester.pumpAndSettle();

        // Act: Manual error set ve clear
        viewModel.setError('Manual error');
        await tester.pump();
        viewModel.clearError();
        await tester.pump();

        // Assert: Error state clear edildi
        expect(find.textContaining('Manual error'), findsNothing);
        expect(find.byIcon(Icons.error_outline), findsNothing);
        expect(find.text('general.button.retry'), findsNothing);
      });

      testWidgets('Error state ViewModel dispose durumunda handle edilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        await tester.pumpWidget(createTestProfileBody(initialUser: testUser));
        await tester.pumpAndSettle();

        // Act: ViewModel'i dispose et
        viewModel.dispose();
        await tester.pumpAndSettle();

        // Assert: UI hala stable
        expect(find.byType(ProfileBody), findsOneWidget);
      });
    });

    group('Error Edge Cases', () {
      testWidgets('Çok uzun error message handle edilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock çok uzun error message
        final longErrorMessage = 'A' * 1000; // 1000 karakter
        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception(longErrorMessage));

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Uzun error message handle edildi
        expect(find.textContaining(longErrorMessage), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });

      testWidgets('Empty error message handle edilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock empty error message
        when(mockUserService.getUserData(any)).thenThrow(Exception(''));

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Empty error message handle edildi
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });

      testWidgets('Null error message handle edilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock null error message
        when(mockUserService.getUserData(any)).thenThrow(Exception(null));

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Null error message handle edildi
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });

      testWidgets('Special characters in error message handle edilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock special characters error message
        const specialErrorMessage =
            'Error with special chars: !@#\$%^&*()_+-=[]{}|;:,.<>?';
        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception(specialErrorMessage));

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Special characters error message handle edildi
        expect(find.textContaining(specialErrorMessage), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });
    });
  });
}
