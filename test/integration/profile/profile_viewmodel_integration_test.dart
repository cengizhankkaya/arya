// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helpers.dart';
import 'profile_viewmodel_integration_test.mocks.dart';

@GenerateMocks([UserService, FirebaseAuth, User])
void main() {
  group('Profile ViewModel Integration Tests', () {
    late MockUserService mockUserService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late ProfileViewModel viewModel;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Test helpers setup
      TestHelpers.setupFirebaseMocks();
      TestHelpers.setupEasyLocalization();
      TestHelpers.setupPlatformChannels();
      TestHelpers.mockAssetBundle();
    });

    setUp(() {
      mockUserService = MockUserService();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();

      // Mock FirebaseAuth.currentUser
      when(mockUser.uid).thenReturn('user123');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      // Create ProfileViewModel with mocked dependencies
      viewModel = ProfileViewModel(
        userService: mockUserService,
        firebaseAuth: mockFirebaseAuth,
      );
    });

    test('fetchUser başarıyla kullanıcı verisini getirir', () async {
      // Mock user data
      final userModel = UserModel(
        uid: 'user123',
        name: 'Test',
        surname: 'User',
        email: 'test@example.com',
      );

      when(
        mockUserService.getUserData('user123'),
      ).thenAnswer((_) async => userModel);

      // fetchUser çağır
      await viewModel.fetchUser();

      // Sonuçları kontrol et
      expect(viewModel.user, isNotNull);
      expect(viewModel.user?.name, equals('Test'));
      expect(viewModel.user?.surname, equals('User'));
      expect(viewModel.user?.email, equals('test@example.com'));
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
    });

    test('fetchUser hata durumunda error mesajı set eder', () async {
      // Mock error
      when(
        mockUserService.getUserData('user123'),
      ).thenThrow(Exception('Network error'));

      // fetchUser çağır
      await viewModel.fetchUser();

      // Sonuçları kontrol et
      expect(viewModel.user, isNull);
      expect(viewModel.isLoading, isFalse);
      expect(
        viewModel.errorMessage,
        contains('Kullanıcı verisi yüklenirken hata oluştu'),
      );
    });

    test('fetchUser kullanıcı verisi yokken error mesajı set eder', () async {
      // Mock null user data
      when(
        mockUserService.getUserData('user123'),
      ).thenAnswer((_) async => null);

      // fetchUser çağır
      await viewModel.fetchUser();

      // Sonuçları kontrol et
      expect(viewModel.user, isNull);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, equals('Kullanıcı verisi bulunamadı.'));
    });

    test('fetchUser currentUser null iken error mesajı set eder', () async {
      // Mock null currentUser
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      // fetchUser çağır
      await viewModel.fetchUser();

      // Sonuçları kontrol et
      expect(viewModel.user, isNull);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, equals('Kullanıcı oturumu bulunamadı.'));
    });

    test('updateUser başarıyla kullanıcı verisini günceller', () async {
      // Mock user data
      final userModel = UserModel(
        uid: 'user123',
        name: 'Test',
        surname: 'User',
        email: 'test@example.com',
      );

      when(
        mockUserService.getUserData('user123'),
      ).thenAnswer((_) async => userModel);
      when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

      // fetchUser çağır
      await viewModel.fetchUser();

      // updateUser çağır
      await viewModel.updateUser(
        name: 'Updated Name',
        surname: 'Updated Surname',
      );

      // Sonuçları kontrol et
      expect(viewModel.user?.name, equals('Updated Name'));
      expect(viewModel.user?.surname, equals('Updated Surname'));
      expect(viewModel.isEditing, isFalse);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
    });

    test('updateUser hata durumunda error mesajı set eder', () async {
      // Mock user data
      final userModel = UserModel(
        uid: 'user123',
        name: 'Test',
        surname: 'User',
        email: 'test@example.com',
      );

      when(
        mockUserService.getUserData('user123'),
      ).thenAnswer((_) async => userModel);
      when(
        mockUserService.updateUserData(any),
      ).thenThrow(Exception('Update failed'));

      // fetchUser çağır
      await viewModel.fetchUser();

      // updateUser çağır
      await viewModel.updateUser(
        name: 'Updated Name',
        surname: 'Updated Surname',
      );

      // Sonuçları kontrol et
      expect(viewModel.user?.name, equals('Test')); // Değişmez
      expect(viewModel.user?.surname, equals('User')); // Değişmez
      expect(viewModel.isEditing, isFalse); // Edit mode kapanır
      expect(viewModel.isLoading, isFalse);
      expect(
        viewModel.errorMessage,
        contains('Kullanıcı verisi güncellenirken hata oluştu'),
      );
    });

    test('toggleEditMode doğru çalışır', () {
      // Başlangıçta edit mode kapalı
      expect(viewModel.isEditing, isFalse);

      // Edit mode'u aç
      viewModel.toggleEditMode();
      expect(viewModel.isEditing, isTrue);

      // Edit mode'u kapat
      viewModel.toggleEditMode();
      expect(viewModel.isEditing, isFalse);
    });

    test('signOut başarıyla çıkış yapar', () async {
      // Mock user data
      final userModel = UserModel(
        uid: 'user123',
        name: 'Test',
        surname: 'User',
        email: 'test@example.com',
      );

      when(
        mockUserService.getUserData('user123'),
      ).thenAnswer((_) async => userModel);
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      // fetchUser çağır
      await viewModel.fetchUser();

      // signOut çağır
      await viewModel.signOut();

      // Sonuçları kontrol et
      expect(viewModel.user, isNull);
      expect(viewModel.isEditing, isFalse);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
    });

    test('deleteAccount başarıyla hesabı siler', () async {
      // Mock user data
      final userModel = UserModel(
        uid: 'user123',
        name: 'Test',
        surname: 'User',
        email: 'test@example.com',
      );

      when(
        mockUserService.getUserData('user123'),
      ).thenAnswer((_) async => userModel);
      when(mockUserService.deleteUserData('user123')).thenAnswer((_) async {});
      when(mockUser.delete()).thenAnswer((_) async {});

      // fetchUser çağır
      await viewModel.fetchUser();

      // deleteAccount çağır
      await viewModel.deleteAccount();

      // Sonuçları kontrol et
      expect(viewModel.user, isNull);
      expect(viewModel.isEditing, isFalse);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
    });

    test('isUserComplete doğru çalışır', () async {
      // Mock incomplete user data
      final incompleteUser = UserModel(
        uid: 'user123',
        name: 'Test',
        surname: '', // Boş surname
        email: 'test@example.com',
      );

      when(
        mockUserService.getUserData('user123'),
      ).thenAnswer((_) async => incompleteUser);

      // fetchUser çağır
      await viewModel.fetchUser();

      // Sonuçları kontrol et
      expect(viewModel.isUserComplete, isFalse);

      // Mock complete user data
      final completeUser = UserModel(
        uid: 'user123',
        name: 'Test',
        surname: 'User',
        email: 'test@example.com',
      );

      when(
        mockUserService.getUserData('user123'),
      ).thenAnswer((_) async => completeUser);

      // fetchUser çağır
      await viewModel.fetchUser();

      // Sonuçları kontrol et
      expect(viewModel.isUserComplete, isTrue);
    });

    test('clearError error mesajını temizler', () async {
      // Mock error
      when(
        mockUserService.getUserData('user123'),
      ).thenThrow(Exception('Test error'));

      // fetchUser çağır
      await viewModel.fetchUser();
      expect(viewModel.errorMessage, isNotNull);

      // clearError çağır
      viewModel.clearError();

      // Sonuçları kontrol et
      expect(viewModel.errorMessage, isNull);
    });

    test('dispose edilmiş viewModel\'de işlemler çalışmaz', () async {
      // Mock user data
      final userModel = UserModel(
        uid: 'user123',
        name: 'Test',
        surname: 'User',
        email: 'test@example.com',
      );

      when(
        mockUserService.getUserData('user123'),
      ).thenAnswer((_) async => userModel);

      // fetchUser çağır
      await viewModel.fetchUser();

      // ViewModel'i dispose et
      viewModel.dispose();

      // Dispose edilmiş viewModel'de işlem yapmaya çalış
      await viewModel.updateUser(name: 'Test', surname: 'Disposed');

      // Sonuçları kontrol et
      expect(viewModel.isDisposed, isTrue);
      expect(viewModel.user?.name, equals('Test')); // Değişmez
    });
  });
}
