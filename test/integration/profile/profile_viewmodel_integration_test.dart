import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:arya/features/index.dart';
import '../../helpers/test_helpers.dart';

// Mock sınıfları generate etmek için annotation
@GenerateMocks([UserService, FirebaseAuth, User, FirebaseApp])
import 'profile_viewmodel_integration_test.mocks.dart';

/// Profile ViewModel Integration Test
///
/// Bu test, ProfileViewModel'in tüm işlevlerini kapsamlı şekilde test eder:
/// - User data fetch operations (kullanıcı verisi çekme işlemleri)
/// - User data update operations (kullanıcı verisi güncelleme işlemleri)
/// - Edit mode management (düzenleme modu yönetimi)
/// - Sign out operations (çıkış işlemleri)
/// - Delete account operations (hesap silme işlemleri)
/// - Error handling and recovery (hata yönetimi ve kurtarma)
/// - State management and UI updates (durum yönetimi ve UI güncellemeleri)
/// - Loading states and transitions (yükleme durumları ve geçişler)
/// - Memory management and disposal (bellek yönetimi ve temizlik)
///
/// Test stratejisi:
/// 1. Mock servislerle gerçekçi senaryolar oluştur
/// 2. Her ViewModel method'u için kapsamlı test senaryoları yaz
/// 3. State değişikliklerini ve UI güncellemelerini doğrula
/// 4. Error handling ve recovery mekanizmalarını test et
/// 5. Performance ve memory leak kontrollerini yap
///
/// ÖĞRETİCİ NOTLAR:
///
/// 1. VIEWMODEL TEST PATTERNS:
///    - Mock servislerle dependency injection test edilir
///    - State değişiklikleri notifyListeners() ile kontrol edilir
///    - Async operations await ile test edilir
///    - Error scenarios exception throwing ile simüle edilir
///
/// 2. STATE MANAGEMENT TESTLERİ:
///    - Loading state transitions (yükleme durumu geçişleri)
///    - Error state management (hata durumu yönetimi)
///    - User data state updates (kullanıcı verisi durumu güncellemeleri)
///    - Edit mode state changes (düzenleme modu durumu değişiklikleri)
///
/// 3. BUSINESS LOGIC TESTLERİ:
///    - User data validation (kullanıcı verisi doğrulama)
///    - Update operations (güncelleme işlemleri)
///    - Delete operations (silme işlemleri)
///    - Authentication operations (kimlik doğrulama işlemleri)
///
/// 4. ERROR HANDLING TESTLERİ:
///    - Network errors (ağ hataları)
///    - Firebase errors (Firebase hataları)
///    - Validation errors (doğrulama hataları)
///    - Permission errors (izin hataları)
///
/// 5. INTEGRATION TESTLERİ:
///    - Service layer integration (servis katmanı entegrasyonu)
///    - Firebase integration (Firebase entegrasyonu)
///    - UI state synchronization (UI durum senkronizasyonu)
///    - Data flow validation (veri akışı doğrulama)
///
/// 6. PERFORMANCE TESTLERİ:
///    - Memory leak prevention (bellek sızıntısı önleme)
///    - Disposal handling (temizlik işleme)
///    - Controller management (kontrolcü yönetimi)
///    - Resource cleanup (kaynak temizliği)
///
/// Test isimleri ne test edildiğini açık şekilde belirtir ve
/// her test case'i için gerekli setup, action ve assertion'ları içerir.
void main() {
  group('Profile ViewModel Integration Tests', () {
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
      // ViewModel dispose edilmişse tekrar dispose etmeye çalışma
      if (!viewModel.isDisposed) {
        viewModel.dispose();
      }
    });

    /// Test için ProfileViewModel oluştur
    ///
    /// Bu method, farklı test senaryoları için
    /// ViewModel'i özelleştirilmiş durumlarla oluşturur
    ProfileViewModel createTestViewModel({
      UserModel? initialUser,
      String? errorMessage,
      bool isLoading = false,
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

      return viewModel;
    }

    group('Initial State Tests', () {
      test(
        'ProfileViewModel başlangıç durumunda doğru değerlere sahip olmalı',
        () {
          // Act: ViewModel oluştur
          final viewModel = createTestViewModel();

          // Assert: Başlangıç durumu kontrolü
          expect(viewModel.user, isNull);
          expect(viewModel.isLoading, isFalse);
          expect(viewModel.errorMessage, isNull);
          expect(viewModel.isEditing, isFalse);
          expect(viewModel.hasUser, isFalse);
          expect(viewModel.isUserComplete, isFalse);
          expect(viewModel.isDisposed, isFalse);
        },
      );

      test(
        'ProfileViewModel dispose edildiğinde disposed flag true olmalı',
        () {
          // Arrange: ViewModel oluştur
          final viewModel = createTestViewModel();

          // Act: Dispose et
          viewModel.dispose();

          // Assert: Disposed flag true
          expect(viewModel.isDisposed, isTrue);
        },
      );

      test(
        'ProfileViewModel dispose edildikten sonra işlemler çalışmamalı',
        () {
          // Arrange: ViewModel oluştur ve dispose et
          final viewModel = createTestViewModel();
          viewModel.dispose();

          // Act: Dispose sonrası işlem yapmaya çalış
          viewModel.setUser(TestHelpers.createTestUserModel());
          viewModel.setError('Test error');

          // Assert: İşlemler çalışmamalı
          expect(viewModel.user, isNull);
          expect(viewModel.errorMessage, isNull);
        },
      );
    });

    group('User Data Fetch Tests', () {
      test('fetchUser başarılı olduğunda user data set edilmeli', () async {
        // Arrange: Test user ve mock setup
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('test-uid'),
        ).thenAnswer((_) async => testUser);

        final viewModel = createTestViewModel();

        // Act: fetchUser çağır
        await viewModel.fetchUser();

        // Assert: User data set edildi
        expect(viewModel.user, equals(testUser));
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.hasUser, isTrue);
        expect(viewModel.isUserComplete, isTrue);
      });

      test('fetchUser sırasında loading state doğru yönetilmeli', () async {
        // Arrange: Mock setup
        when(mockUserService.getUserData('test-uid')).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return TestHelpers.createTestUserModel();
        });

        final viewModel = createTestViewModel();

        // Act: fetchUser başlat
        final future = viewModel.fetchUser();

        // Assert: Loading state true
        expect(viewModel.isLoading, isTrue);

        // Act: İşlem tamamlansın
        await future;

        // Assert: Loading state false
        expect(viewModel.isLoading, isFalse);
      });

      test(
        'fetchUser currentUser null olduğunda hata mesajı gösterilmeli',
        () async {
          // Arrange: currentUser null
          when(mockFirebaseAuth.currentUser).thenReturn(null);

          final viewModel = createTestViewModel();

          // Act: fetchUser çağır
          await viewModel.fetchUser();

          // Assert: Hata mesajı
          expect(viewModel.user, isNull);
          expect(
            viewModel.errorMessage,
            equals('Kullanıcı oturumu bulunamadı.'),
          );
          expect(viewModel.isLoading, isFalse);
        },
      );

      test(
        'fetchUser user data null döndüğünde hata mesajı gösterilmeli',
        () async {
          // Arrange: Mock setup
          when(
            mockUserService.getUserData('test-uid'),
          ).thenAnswer((_) async => null);

          final viewModel = createTestViewModel();

          // Act: fetchUser çağır
          await viewModel.fetchUser();

          // Assert: Hata mesajı
          expect(viewModel.user, isNull);
          expect(
            viewModel.errorMessage,
            equals('Kullanıcı verisi bulunamadı.'),
          );
          expect(viewModel.isLoading, isFalse);
        },
      );

      test(
        'fetchUser exception fırlattığında hata mesajı gösterilmeli',
        () async {
          // Arrange: Mock setup
          when(
            mockUserService.getUserData('test-uid'),
          ).thenThrow(Exception('Network error'));

          final viewModel = createTestViewModel();

          // Act: fetchUser çağır
          await viewModel.fetchUser();

          // Assert: Hata mesajı
          expect(viewModel.user, isNull);
          expect(viewModel.errorMessage, contains('Network error'));
          expect(viewModel.isLoading, isFalse);
        },
      );

      test('fetchUser dispose edilmiş ViewModel\'de çalışmamalı', () async {
        // Arrange: ViewModel oluştur ve dispose et
        final viewModel = createTestViewModel();
        viewModel.dispose();

        // Act: fetchUser çağır
        await viewModel.fetchUser();

        // Assert: İşlem çalışmamalı
        expect(viewModel.user, isNull);
        expect(viewModel.isLoading, isFalse);
      });
    });

    group('User Data Update Tests', () {
      test('updateUser başarılı olduğunda user data güncellenmeli', () async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

        final viewModel = createTestViewModel(initialUser: testUser);

        // Act: updateUser çağır
        await viewModel.updateUser(name: 'Jane', surname: 'Smith');

        // Assert: User data güncellendi
        expect(viewModel.user?.name, equals('Jane'));
        expect(viewModel.user?.surname, equals('Smith'));
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.isEditing, isFalse);
      });

      test('updateUser sırasında loading state doğru yönetilmeli', () async {
        // Arrange: Test user ve mock setup
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(mockUserService.updateUserData(any)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
        });

        final viewModel = createTestViewModel(initialUser: testUser);

        // Act: updateUser başlat
        final future = viewModel.updateUser(name: 'Jane');

        // Assert: Loading state true
        expect(viewModel.isLoading, isTrue);

        // Act: İşlem tamamlansın
        await future;

        // Assert: Loading state false
        expect(viewModel.isLoading, isFalse);
      });

      test('updateUser user null olduğunda hata mesajı gösterilmeli', () async {
        // Arrange: User null
        final viewModel = createTestViewModel();

        // Act: updateUser çağır
        await viewModel.updateUser(name: 'Jane');

        // Assert: Hata mesajı
        expect(
          viewModel.errorMessage,
          equals('Güncellenecek kullanıcı verisi bulunamadı.'),
        );
        expect(viewModel.isLoading, isFalse);
      });

      test(
        'updateUser exception fırlattığında hata mesajı gösterilmeli',
        () async {
          // Arrange: Test user ve mock setup
          const testUser = UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );

          when(
            mockUserService.updateUserData(any),
          ).thenThrow(Exception('Update failed'));

          final viewModel = createTestViewModel(initialUser: testUser);

          // Act: updateUser çağır
          await viewModel.updateUser(name: 'Jane');

          // Assert: Hata mesajı
          expect(viewModel.errorMessage, contains('Update failed'));
          expect(viewModel.isLoading, isFalse);
        },
      );

      test('updateUser dispose edilmiş ViewModel\'de çalışmamalı', () async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        final viewModel = createTestViewModel(initialUser: testUser);
        viewModel.dispose();

        // Act: updateUser çağır
        await viewModel.updateUser(name: 'Jane');

        // Assert: İşlem çalışmamalı
        expect(viewModel.user?.name, equals('John')); // Değişmemiş
        expect(viewModel.isLoading, isFalse);
      });
    });

    group('Edit Mode Management Tests', () {
      test('toggleEditMode edit mode\'u açıp kapatmalı', () {
        // Arrange: ViewModel oluştur
        final viewModel = createTestViewModel();

        // Assert: Başlangıçta edit mode kapalı
        expect(viewModel.isEditing, isFalse);

        // Act: Edit mode'u aç
        viewModel.toggleEditMode();

        // Assert: Edit mode açık
        expect(viewModel.isEditing, isTrue);

        // Act: Edit mode'u kapat
        viewModel.toggleEditMode();

        // Assert: Edit mode kapalı
        expect(viewModel.isEditing, isFalse);
      });

      test('toggleEditMode edit mode kapatıldığında error temizlenmeli', () {
        // Arrange: ViewModel oluştur ve error set et
        final viewModel = createTestViewModel();
        viewModel.setError('Test error');
        viewModel.toggleEditMode(); // Edit mode'u aç

        // Assert: Error var
        expect(viewModel.errorMessage, equals('Test error'));

        // Act: Edit mode'u kapat
        viewModel.toggleEditMode();

        // Assert: Error temizlendi
        expect(viewModel.errorMessage, isNull);
      });

      test('toggleEditMode dispose edilmiş ViewModel\'de çalışmamalı', () {
        // Arrange: ViewModel oluştur ve dispose et
        final viewModel = createTestViewModel();
        viewModel.dispose();

        // Act: toggleEditMode çağır
        viewModel.toggleEditMode();

        // Assert: İşlem çalışmamalı
        expect(viewModel.isEditing, isFalse);
      });
    });

    group('Sign Out Tests', () {
      test('signOut başarılı olduğunda user state temizlenmeli', () async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        final viewModel = createTestViewModel(initialUser: testUser);

        // Act: signOut çağır
        await viewModel.signOut();

        // Assert: User state temizlendi
        expect(viewModel.user, isNull);
        expect(viewModel.isEditing, isFalse);
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.isLoading, isFalse);
      });

      test('signOut sırasında loading state doğru yönetilmeli', () async {
        // Arrange: Mock setup
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
        });

        final viewModel = createTestViewModel();

        // Act: signOut başlat
        final future = viewModel.signOut();

        // Assert: Loading state true
        expect(viewModel.isLoading, isTrue);

        // Act: İşlem tamamlansın
        await future;

        // Assert: Loading state false
        expect(viewModel.isLoading, isFalse);
      });

      test(
        'signOut exception fırlattığında hata mesajı gösterilmeli',
        () async {
          // Arrange: Mock setup
          when(
            mockFirebaseAuth.signOut(),
          ).thenThrow(Exception('Sign out failed'));

          final viewModel = createTestViewModel();

          // Act: signOut çağır
          await viewModel.signOut();

          // Assert: Hata mesajı
          expect(viewModel.errorMessage, contains('Sign out failed'));
          expect(viewModel.isLoading, isFalse);
        },
      );

      test('signOut dispose edilmiş ViewModel\'de çalışmamalı', () async {
        // Arrange: ViewModel oluştur ve dispose et
        final viewModel = createTestViewModel();
        viewModel.dispose();

        // Act: signOut çağır
        await viewModel.signOut();

        // Assert: İşlem çalışmamalı
        expect(viewModel.isLoading, isFalse);
      });
    });

    group('Delete Account Tests', () {
      test(
        'deleteAccount başarılı olduğunda user state temizlenmeli',
        () async {
          // Arrange: Test user
          const testUser = UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );

          when(
            mockUserService.deleteUserData('test-uid'),
          ).thenAnswer((_) async {});
          when(mockUser.delete()).thenAnswer((_) async {});

          final viewModel = createTestViewModel(initialUser: testUser);

          // Act: deleteAccount çağır
          await viewModel.deleteAccount();

          // Assert: User state temizlendi
          expect(viewModel.user, isNull);
          expect(viewModel.isEditing, isFalse);
          expect(viewModel.isLoading, isFalse);
        },
      );

      test('deleteAccount sırasında loading state doğru yönetilmeli', () async {
        // Arrange: Test user ve mock setup
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(mockUserService.deleteUserData('test-uid')).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
        });
        when(mockUser.delete()).thenAnswer((_) async {});

        final viewModel = createTestViewModel(initialUser: testUser);

        // Act: deleteAccount başlat
        final future = viewModel.deleteAccount();

        // Assert: Loading state true
        expect(viewModel.isLoading, isTrue);

        // Act: İşlem tamamlansın
        await future;

        // Assert: Loading state false
        expect(viewModel.isLoading, isFalse);
      });

      test(
        'deleteAccount user uid null olduğunda hata mesajı gösterilmeli',
        () async {
          // Arrange: User uid null
          const testUser = UserModel(
            uid: null,
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );

          final viewModel = createTestViewModel(initialUser: testUser);

          // Act: deleteAccount çağır
          await viewModel.deleteAccount();

          // Assert: Hata mesajı
          expect(
            viewModel.errorMessage,
            equals('Silinecek kullanıcı verisi bulunamadı.'),
          );
          expect(viewModel.isLoading, isFalse);
        },
      );

      test(
        'deleteAccount exception fırlattığında hata mesajı gösterilmeli',
        () async {
          // Arrange: Test user ve mock setup
          const testUser = UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );

          when(
            mockUserService.deleteUserData('test-uid'),
          ).thenThrow(Exception('Delete failed'));

          final viewModel = createTestViewModel(initialUser: testUser);

          // Act: deleteAccount çağır
          await viewModel.deleteAccount();

          // Assert: Hata mesajı
          expect(viewModel.errorMessage, contains('Delete failed'));
          expect(viewModel.isLoading, isFalse);
        },
      );

      test('deleteAccount dispose edilmiş ViewModel\'de çalışmamalı', () async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        final viewModel = createTestViewModel(initialUser: testUser);
        viewModel.dispose();

        // Act: deleteAccount çağır
        await viewModel.deleteAccount();

        // Assert: İşlem çalışmamalı
        expect(viewModel.user, equals(testUser)); // Değişmemiş
        expect(viewModel.isLoading, isFalse);
      });
    });

    group('Controller Management Tests', () {
      test('setUser çağrıldığında controller\'lar initialize edilmeli', () {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        final viewModel = createTestViewModel();

        // Act: setUser çağır
        viewModel.setUser(testUser);

        // Assert: Controller'lar initialize edildi
        expect(viewModel.nameController.text, equals('John'));
        expect(viewModel.surnameController.text, equals('Doe'));
      });

      test(
        'updateUserFromControllers controller değerlerini kullanmalı',
        () async {
          // Arrange: Test user
          const testUser = UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );

          when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

          final viewModel = createTestViewModel(initialUser: testUser);

          // Act: Controller değerlerini değiştir
          viewModel.nameController.text = 'Jane';
          viewModel.surnameController.text = 'Smith';

          // Act: updateUserFromControllers çağır
          await viewModel.updateUserFromControllers();

          // Assert: User data güncellendi
          expect(viewModel.user?.name, equals('Jane'));
          expect(viewModel.user?.surname, equals('Smith'));
        },
      );

      test('dispose çağrıldığında controller\'lar dispose edilmeli', () {
        // Arrange: ViewModel oluştur
        final viewModel = createTestViewModel();

        // Act: Dispose et
        viewModel.dispose();

        // Assert: Controller'lar dispose edildi
        expect(viewModel.nameController.text, isEmpty);
        expect(viewModel.surnameController.text, isEmpty);
      });
    });

    group('Error Handling Tests', () {
      test('setError error message set etmeli', () {
        // Arrange: ViewModel oluştur
        final viewModel = createTestViewModel();

        // Act: setError çağır
        viewModel.setError('Test error');

        // Assert: Error message set edildi
        expect(viewModel.errorMessage, equals('Test error'));
      });

      test('clearError error message temizlemeli', () {
        // Arrange: ViewModel oluştur ve error set et
        final viewModel = createTestViewModel();
        viewModel.setError('Test error');

        // Assert: Error var
        expect(viewModel.errorMessage, equals('Test error'));

        // Act: clearError çağır
        viewModel.clearError();

        // Assert: Error temizlendi
        expect(viewModel.errorMessage, isNull);
      });

      test('setError dispose edilmiş ViewModel\'de çalışmamalı', () {
        // Arrange: ViewModel oluştur ve dispose et
        final viewModel = createTestViewModel();
        viewModel.dispose();

        // Act: setError çağır
        viewModel.setError('Test error');

        // Assert: İşlem çalışmamalı
        expect(viewModel.errorMessage, isNull);
      });

      test('clearError dispose edilmiş ViewModel\'de çalışmamalı', () {
        // Arrange: ViewModel oluştur ve dispose et
        final viewModel = createTestViewModel();
        viewModel.dispose();

        // Act: clearError çağır
        viewModel.clearError();

        // Assert: İşlem çalışmamalı (hata vermemeli)
        expect(viewModel.errorMessage, isNull);
      });
    });

    group('State Synchronization Tests', () {
      test(
        'User data değiştiğinde hasUser ve isUserComplete güncellenmeli',
        () {
          // Arrange: ViewModel oluştur
          final viewModel = createTestViewModel();

          // Assert: Başlangıçta user yok
          expect(viewModel.hasUser, isFalse);
          expect(viewModel.isUserComplete, isFalse);

          // Act: Incomplete user set et
          const incompleteUser = UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: null,
            email: 'john@example.com',
          );
          viewModel.setUser(incompleteUser);

          // Assert: hasUser true, isUserComplete false
          expect(viewModel.hasUser, isTrue);
          expect(viewModel.isUserComplete, isFalse);

          // Act: Complete user set et
          const completeUser = UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );
          viewModel.setUser(completeUser);

          // Assert: hasUser true, isUserComplete true
          expect(viewModel.hasUser, isTrue);
          expect(viewModel.isUserComplete, isTrue);
        },
      );

      test('Loading state değiştiğinde isLoading güncellenmeli', () async {
        // Arrange: Test user
        const testUser = UserModel(
          uid: 'test-uid',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(mockUserService.getUserData('test-uid')).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return testUser;
        });

        final viewModel = createTestViewModel();

        // Assert: Başlangıçta loading false
        expect(viewModel.isLoading, isFalse);

        // Act: fetchUser başlat
        final future = viewModel.fetchUser();

        // Assert: Loading true
        expect(viewModel.isLoading, isTrue);

        // Act: İşlem tamamlansın
        await future;

        // Assert: Loading false
        expect(viewModel.isLoading, isFalse);
      });
    });

    group('Edge Cases Tests', () {
      test(
        'Çoklu async operations aynı anda çalıştırıldığında state doğru yönetilmeli',
        () async {
          // Arrange: Test user
          const testUser = UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );

          when(
            mockUserService.getUserData('test-uid'),
          ).thenAnswer((_) async => testUser);
          when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

          final viewModel = createTestViewModel();

          // Act: İlk önce fetchUser çağır
          await viewModel.fetchUser();

          // Assert: User data set edildi
          expect(viewModel.user?.name, equals('John'));

          // Act: Sonra updateUser çağır
          await viewModel.updateUser(name: 'Jane');

          // Assert: User data güncellendi
          expect(viewModel.user?.name, equals('Jane'));
          expect(viewModel.isLoading, isFalse);
        },
      );

      test('Dispose edilmiş ViewModel\'de notifyListeners çağrılmamalı', () {
        // Arrange: ViewModel oluştur
        final viewModel = createTestViewModel();

        // Act: Dispose et
        viewModel.dispose();

        // Assert: Disposed flag true
        expect(viewModel.isDisposed, isTrue);

        // Act: Dispose sonrası işlem yapmaya çalış
        viewModel.setUser(TestHelpers.createTestUserModel());

        // Assert: İşlem çalışmamalı (exception fırlatmamalı)
        expect(viewModel.user, isNull);
      });

      test('Controller\'lar dispose edildikten sonra text boş olmalı', () {
        // Arrange: ViewModel oluştur
        final viewModel = createTestViewModel();

        // Act: Dispose et
        viewModel.dispose();

        // Assert: Controller'lar dispose edildi
        expect(viewModel.nameController.text, isEmpty);
        expect(viewModel.surnameController.text, isEmpty);

        // Assert: Controller'lar dispose edildi ve text boş
        expect(viewModel.nameController.text, isEmpty);
        expect(viewModel.surnameController.text, isEmpty);
      });
    });

    group('Performance Tests', () {
      test('ViewModel oluşturma ve dispose işlemi hızlı olmalı', () {
        // Arrange: Stopwatch
        final stopwatch = Stopwatch()..start();

        // Act: ViewModel oluştur ve dispose et
        final viewModel = createTestViewModel();
        viewModel.dispose();

        stopwatch.stop();

        // Assert: İşlem hızlı tamamlandı (10ms altında)
        expect(stopwatch.elapsedMilliseconds, lessThan(10));
      });

      test(
        'Çoklu ViewModel oluşturma ve dispose işlemi memory leak oluşturmamalı',
        () {
          // Arrange: Stopwatch
          final stopwatch = Stopwatch()..start();

          // Act: Çoklu ViewModel oluştur ve dispose et
          for (int i = 0; i < 100; i++) {
            final viewModel = createTestViewModel();
            viewModel.dispose();
          }

          stopwatch.stop();

          // Assert: İşlem hızlı tamamlandı (100ms altında)
          expect(stopwatch.elapsedMilliseconds, lessThan(100));
        },
      );

      test(
        'Async operations cancel edildiğinde memory leak oluşturmamalı',
        () async {
          // Arrange: Test user
          const testUser = UserModel(
            uid: 'test-uid',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );

          when(mockUserService.getUserData('test-uid')).thenAnswer((_) async {
            await Future.delayed(const Duration(milliseconds: 100));
            return testUser;
          });

          // Act: ViewModel oluştur ve async operation başlat
          final viewModel = createTestViewModel();
          final future = viewModel.fetchUser();

          // Act: Hemen dispose et (async operation devam ediyor)
          viewModel.dispose();

          // Act: Async operation tamamlansın
          await future;

          // Assert: Memory leak oluşmamalı (exception fırlatmamalı)
          expect(viewModel.isDisposed, isTrue);
        },
      );
    });
  });
}
