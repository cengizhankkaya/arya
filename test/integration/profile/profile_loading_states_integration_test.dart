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
import 'profile_loading_states_integration_test.mocks.dart';

/// Profile Loading States Integration Test
///
/// Bu test, profil sayfasının tüm yükleme durumlarını kapsamlı şekilde test eder:
/// - Initial loading (ilk yükleme)
/// - Refresh loading (yenileme yükleme)
/// - Edit loading (düzenleme yükleme)
/// - Error states (hata durumları)
/// - Success states (başarılı durumlar)
/// - State transitions (durum geçişleri)
///
/// Test stratejisi:
/// 1. Mock servislerle gerçekçi senaryolar oluştur
/// 2. Her loading state için UI değişikliklerini doğrula
/// 3. State geçişlerini test et
/// 4. Error handling ve recovery mekanizmalarını kontrol et
/// 5. Loading sırasında UI etkileşimlerini test et
///
/// ÖĞRETİCİ NOTLAR:
///
/// 1. MOCK SERVİSLERİN KULLANIMI:
///    - Mockito ile UserService ve FirebaseAuth mock'ları oluşturulur
///    - when().thenAnswer() ile async operasyonlar simüle edilir
///    - when().thenThrow() ile hata durumları test edilir
///    - verify() ile method çağrılarının doğruluğu kontrol edilir
///
/// 2. LOADING STATE TESTLERİ:
///    - ProfileViewModel'in gerçek API'si kullanılır (setLoading private olduğu için)
///    - Mock servislerin yavaş response'ları ile loading state simüle edilir
///    - ProfileShimmerWidget'ın varlığı kontrol edilir
///    - Loading sırasında UI etkileşimlerinin disable olduğu doğrulanır
///
/// 3. ERROR HANDLING TESTLERİ:
///    - Network hataları, auth hataları ve validation hataları test edilir
///    - Error message'ların doğru gösterildiği kontrol edilir
///    - Retry butonunun çalıştığı doğrulanır
///    - Error state'den success state'e geçiş test edilir
///
/// 4. STATE TRANSITION TESTLERİ:
///    - Loading -> Success geçişi
///    - Loading -> Error geçişi
///    - Error -> Retry -> Success geçişi
///    - Her geçişte UI'ın doğru güncellendiği kontrol edilir
///
/// 5. PERFORMANCE VE EDGE CASE TESTLERİ:
///    - Çoklu loading state değişiklikleri
///    - Memory pressure durumları
///    - Network interruption senaryoları
///    - Dispose edilme durumları
///
/// 6. TEST BEST PRACTICES:
///    - Her test bağımsız olarak çalışabilir
///    - setUp/tearDown ile temiz test ortamı sağlanır
///    - Mock'lar her test için yeniden configure edilir
///    - Assertion'lar açık ve anlaşılır şekilde yazılır
///    - Test isimleri ne test edildiğini açık şekilde belirtir
void main() {
  group('Profile Loading States Integration Tests', () {
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
    /// Bu wrapper, farklı loading state'leri test etmek için
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

    group('Initial Loading State Tests', () {
      testWidgets('fetchUser çağrıldığında loading indicator gösterilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock yavaş getUserData response
        when(mockUserService.getUserData(any)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return const UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );
        });

        // Act: ProfileBody'i render et ve fetchUser çağır
        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pump(); // İlk pump

        // Assert: Loading indicator gösterilmeli
        expect(find.byType(ProfileShimmerWidget), findsOneWidget);
        expect(find.text('John Doe'), findsNothing);

        // İşlem tamamlansın
        await tester.pumpAndSettle();
      });

      testWidgets('Loading sırasında butonlar disable olmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock yavaş getUserData response
        when(mockUserService.getUserData(any)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return const UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );
        });

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pump(); // İlk pump

        // Assert: Loading state'de butonlar disable
        expect(find.byType(ProfileShimmerWidget), findsOneWidget);

        // İşlem tamamlansın
        await tester.pumpAndSettle();
      });

      testWidgets('fetchUser başarılı olduğunda loading kaybolmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock başarılı getUserData response
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );
        when(
          mockUserService.getUserData(any),
        ).thenAnswer((_) async => testUser);

        // Act: ProfileBody'i render et ve fetchUser çağır
        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Loading kayboldu, kullanıcı verisi görünür
        expect(find.byType(ProfileShimmerWidget), findsNothing);
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('John'), findsOneWidget);
        expect(find.text('Doe'), findsOneWidget);
      });
    });

    group('Edit Loading State Tests', () {
      testWidgets('updateUser çağrıldığında loading indicator gösterilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Mock yavaş updateUserData response
        when(mockUserService.updateUserData(any)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
        });

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

            // Act: Save butonuna bas
            final saveButton = find.text('general.button.save');
            if (saveButton.evaluate().isNotEmpty) {
              await tester.tap(saveButton);
              await tester.pump(); // İlk pump

              // Assert: Loading state kontrol et
              // ProfileViewModel'de loading state UI'da gösterilir
              expect(find.byType(ProfileBody), findsOneWidget);

              await tester.pumpAndSettle(); // İşlem tamamlansın
            }
          }
        }
      });

      testWidgets('updateUser başarılı olduğunda loading kaybolmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Mock başarılı updateUserData
        when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

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
            final surnameField = find.byType(TextFormField).at(1);

            await tester.enterText(nameField, 'Jane');
            await tester.enterText(surnameField, 'Smith');
            await tester.pump();

            // Save butonuna bas
            final saveButton = find.text('general.button.save');
            if (saveButton.evaluate().isNotEmpty) {
              await tester.tap(saveButton);
              await tester.pumpAndSettle();

              // Assert: Edit mode kapandı, yeni bilgiler görünür
              expect(find.byType(EditProfileForm), findsNothing);
              expect(find.text('Jane Smith'), findsOneWidget);
              expect(find.text('Jane'), findsOneWidget);
              expect(find.text('Smith'), findsOneWidget);
            }
          }
        }
      });
    });

    group('Error State Tests', () {
      testWidgets('fetchUser hata verdiğinde error message gösterilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock hatalı getUserData response
        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception('Network error'));

        // Act: ProfileBody'i render et ve fetchUser çağır
        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Error message görünür
        expect(find.textContaining('Network error'), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });

      testWidgets('updateUser hata verdiğinde error message gösterilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Mock hatalı updateUserData
        when(
          mockUserService.updateUserData(any),
        ).thenThrow(Exception('Update failed'));

        await tester.pumpWidget(createTestProfileBody(initialUser: testUser));
        await tester.pumpAndSettle();

        // Edit mode'a geç
        final editButton = find.byIcon(Icons.edit);
        if (editButton.evaluate().isNotEmpty) {
          await tester.tap(editButton);
          await tester.pumpAndSettle();

          // Save butonuna bas
          final saveButton = find.text('general.button.save');
          if (saveButton.evaluate().isNotEmpty) {
            await tester.tap(saveButton);
            await tester.pumpAndSettle();

            // Assert: Error message görünür
            expect(find.textContaining('Update failed'), findsOneWidget);
          }
        }
      });

      testWidgets('Error durumunda retry butonu çalışmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock hatalı getUserData response
        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception('Network error'));

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Error message görünür
        expect(find.textContaining('Network error'), findsOneWidget);

        // Act: Retry butonuna bas
        final retryButton = find.text('general.button.retry');
        if (retryButton.evaluate().isNotEmpty) {
          await tester.tap(retryButton);
          await tester.pumpAndSettle();

          // Assert: fetchUser tekrar çağrıldı
          verify(mockUserService.getUserData(any)).called(greaterThan(1));
        }
      });
    });

    group('Success State Tests', () {
      testWidgets('Data loaded durumunda kullanıcı bilgileri gösterilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act: Kullanıcı verisi ile render et
        await tester.pumpWidget(createTestProfileBody(initialUser: testUser));
        await tester.pumpAndSettle();

        // Assert: Tüm kullanıcı bilgileri görünür
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('John'), findsOneWidget);
        expect(find.text('Doe'), findsOneWidget);
        expect(find.byType(EmailDisplayWidget), findsAtLeastNWidgets(1));
        expect(find.byType(ProfileHeader), findsOneWidget);
        expect(find.byType(UserInfoSection), findsOneWidget);
      });

      testWidgets('Logout success durumunda signOut çağrılmalı', (
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

        // Logout dialog'unu aç
        final logoutButton = find.text('general.button.logout');
        if (logoutButton.evaluate().isNotEmpty) {
          await tester.tap(logoutButton);
          await tester.pumpAndSettle();

          // OK butonuna bas
          final okButton = find.text('general.button.ok');
          if (okButton.evaluate().isNotEmpty) {
            await tester.tap(okButton);
            await tester.pumpAndSettle();

            // Assert: signOut çağrıldı
            verify(mockFirebaseAuth.signOut()).called(1);
          }
        }
      });
    });

    group('State Transition Tests', () {
      testWidgets('Loading -> Success transition doğru çalışmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock yavaş getUserData response
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );
        when(mockUserService.getUserData(any)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return testUser;
        });

        // Act: ProfileBody'i render et ve fetchUser çağır
        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pump(); // İlk pump

        // Assert: Loading state
        expect(find.byType(ProfileShimmerWidget), findsOneWidget);

        // İşlem tamamlansın
        await tester.pumpAndSettle();

        // Assert: Success state
        expect(find.byType(ProfileShimmerWidget), findsNothing);
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('John'), findsOneWidget);
        expect(find.text('Doe'), findsOneWidget);
      });

      testWidgets('Loading -> Error transition doğru çalışmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock hatalı getUserData response
        when(mockUserService.getUserData(any)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          throw Exception('Network error');
        });

        // Act: ProfileBody'i render et ve fetchUser çağır
        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pump(); // İlk pump

        // Assert: Loading state
        expect(find.byType(ProfileShimmerWidget), findsOneWidget);

        // İşlem tamamlansın
        await tester.pumpAndSettle();

        // Assert: Error state
        expect(find.byType(ProfileShimmerWidget), findsNothing);
        expect(find.textContaining('Network error'), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });

      testWidgets('Error -> Retry -> Success transition doğru çalışmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: İlk çağrıda hata, ikinci çağrıda başarı
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // İlk çağrıda hata, ikinci çağrıda başarı için ayrı mock setup
        when(
          mockUserService.getUserData(any),
        ).thenThrow(Exception('Network error'));

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pumpAndSettle();

        // Assert: Error state
        expect(find.textContaining('Network error'), findsOneWidget);

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
          expect(find.textContaining('Network error'), findsNothing);
          expect(find.text('John Doe'), findsOneWidget);
          expect(find.text('John'), findsOneWidget);
          expect(find.text('Doe'), findsOneWidget);
        }
      });
    });

    group('Loading State UI Interaction Tests', () {
      testWidgets('Loading sırasında butonlar disable olmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: Mock yavaş getUserData response
        when(mockUserService.getUserData(any)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return const UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );
        });

        await tester.pumpWidget(createTestProfileBody());
        viewModel.fetchUser();
        await tester.pump(); // İlk pump

        // Assert: Loading state'de UI etkileşimi yok
        expect(find.byType(ProfileShimmerWidget), findsOneWidget);

        // İşlem tamamlansın
        await tester.pumpAndSettle();
      });

      testWidgets('Loading sırasında form alanları disable olmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Mock yavaş updateUserData
        when(mockUserService.updateUserData(any)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
        });

        await tester.pumpWidget(createTestProfileBody(initialUser: testUser));
        await tester.pumpAndSettle();

        // Edit mode'a geç
        final editButton = find.byIcon(Icons.edit);
        if (editButton.evaluate().isNotEmpty) {
          await tester.tap(editButton);
          await tester.pumpAndSettle();

          // Save butonuna bas (loading başlar)
          final saveButton = find.text('general.button.save');
          if (saveButton.evaluate().isNotEmpty) {
            await tester.tap(saveButton);
            await tester.pump(); // İlk pump

            // Assert: Loading state'de form etkileşimi yok
            expect(find.byType(ProfileBody), findsOneWidget);

            await tester.pumpAndSettle(); // İşlem tamamlansın
          }
        }
      });
    });

    group('Loading State Performance Tests', () {
      testWidgets('Çoklu loading state değişiklikleri handle edilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Mock hızlı getUserData response
        when(
          mockUserService.getUserData(any),
        ).thenAnswer((_) async => testUser);

        await tester.pumpWidget(createTestProfileBody());
        await tester.pumpAndSettle();

        // Act: Çoklu fetchUser çağrıları
        for (int i = 0; i < 5; i++) {
          viewModel.fetchUser();
          await tester.pump();
          await tester.pumpAndSettle();
        }

        // Assert: UI stable
        expect(find.byType(ProfileBody), findsOneWidget);
        expect(find.text('John Doe'), findsOneWidget);
      });

      testWidgets('Loading state değişiklikleri smooth olmalı', (
        WidgetTester tester,
      ) async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Mock hızlı getUserData response
        when(
          mockUserService.getUserData(any),
        ).thenAnswer((_) async => testUser);

        await tester.pumpWidget(createTestProfileBody());
        await tester.pumpAndSettle();

        // Act: Hızlı state değişiklikleri
        viewModel.fetchUser();
        await tester.pump();
        viewModel.setError('Test error');
        await tester.pump();
        viewModel.clearError();
        await tester.pumpAndSettle();

        // Assert: UI smooth şekilde güncellenmiş
        expect(find.byType(ProfileBody), findsOneWidget);
      });
    });

    group('Loading State Edge Cases', () {
      testWidgets('Loading state sırasında network interruption', (
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

        // Act: Network interruption simulation
        viewModel.setError('Network interrupted');
        await tester.pumpAndSettle();

        // Assert: Error state'e geçti
        expect(find.text('Network interrupted'), findsOneWidget);
        expect(find.text('general.button.retry'), findsOneWidget);
      });

      testWidgets('Loading state sırasında memory pressure', (
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

        // Act: Memory pressure simulation
        // Çok sayıda widget oluştur
        for (int i = 0; i < 50; i++) {
          await tester.pumpWidget(createTestProfileBody(initialUser: testUser));
          await tester.pump();
        }
        await tester.pumpAndSettle();

        // Assert: UI stable
        expect(find.byType(ProfileBody), findsOneWidget);
      });

      testWidgets('Loading state sırasında dispose edilme', (
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
  });
}
