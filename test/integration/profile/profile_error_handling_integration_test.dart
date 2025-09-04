// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../helpers/test_helpers.dart';
import 'profile_error_handling_integration_test.mocks.dart';

@GenerateMocks([UserService, FirebaseAuth, User])
void main() {
  group('Profile Error Handling Integration Tests', () {
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

    testWidgets('Network hatası durumunda error UI gösterilir', (
      WidgetTester tester,
    ) async {
      // Mock network error
      when(
        mockUserService.getUserData('user123'),
      ).thenThrow(Exception('Network connection failed'));

      await tester.pumpWidget(
        TestHelpers.createTestAppWithLocalization(
          ChangeNotifierProvider.value(
            value: viewModel,
            child: Scaffold(
              appBar: AppBar(title: const Text('Profil')),
              body: const ProfileBody(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      // Error UI'nin gösterildiğini kontrol et
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(
        find.textContaining('Kullanıcı verisi yüklenirken hata oluştu'),
        findsOneWidget,
      );
      expect(find.textContaining('Network connection failed'), findsOneWidget);

      // Retry butonunun mevcut olduğunu kontrol et
      expect(find.text('Tekrar Dene'), findsOneWidget);
    });

    testWidgets('Firebase Auth hatası durumunda error UI gösterilir', (
      WidgetTester tester,
    ) async {
      // Mock Firebase Auth error
      when(mockUserService.getUserData('user123')).thenThrow(
        FirebaseAuthException(
          code: 'permission-denied',
          message: 'Permission denied',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: viewModel,
            child: const ProfileScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      // Error UI'nin gösterildiğini kontrol et
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(
        find.textContaining('Kullanıcı verisi yüklenirken hata oluştu'),
        findsOneWidget,
      );
      expect(find.textContaining('Permission denied'), findsOneWidget);
    });

    testWidgets('Retry butonu çalışır ve yeni veri yüklemeyi dener', (
      WidgetTester tester,
    ) async {
      // İlk çağrıda hata, ikinci çağrıda başarı
      final userModel = UserModel(
        uid: 'user123',
        name: 'Test',
        surname: 'User',
        email: 'test@example.com',
      );

      when(
        mockUserService.getUserData('user123'),
      ).thenThrow(Exception('Network error'));

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: viewModel,
            child: const ProfileScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      // İlk hata durumunu kontrol et
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.textContaining('Network error'), findsOneWidget);

      // Retry butonuna tıkla
      await tester.tap(find.text('Tekrar Dene'));
      await tester.pump();
      await tester.pump();

      // Başarılı yükleme sonrası durumu kontrol et
      expect(find.byIcon(Icons.error_outline), findsNothing);
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('Update işlemi sırasında hata oluşursa error gösterilir', (
      WidgetTester tester,
    ) async {
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

      // Mock update error
      when(
        mockUserService.updateUserData(any),
      ).thenThrow(Exception('Update failed'));

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: viewModel,
            child: const ProfileScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      // Update işlemini başlat
      await viewModel.updateUser(
        name: 'Updated Name',
        surname: 'Updated Surname',
      );

      await tester.pump();

      // Error mesajının gösterildiğini kontrol et
      expect(viewModel.errorMessage, isNotNull);
      expect(
        viewModel.errorMessage,
        contains('Kullanıcı verisi güncellenirken hata oluştu'),
      );
      expect(viewModel.errorMessage, contains('Update failed'));
    });

    testWidgets(
      'Delete account işlemi sırasında hata oluşursa error gösterilir',
      (WidgetTester tester) async {
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

        // Mock delete error
        when(
          mockUserService.deleteUserData('user123'),
        ).thenThrow(Exception('Delete failed'));

        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider.value(
              value: viewModel,
              child: const ProfileScreen(),
            ),
          ),
        );

        await tester.pump();
        await tester.pump();

        // Delete account işlemini başlat
        await viewModel.deleteAccount();
        await tester.pump();

        // Error mesajının gösterildiğini kontrol et
        expect(viewModel.errorMessage, isNotNull);
        expect(
          viewModel.errorMessage,
          contains('Hesap silinirken hata oluştu'),
        );
        expect(viewModel.errorMessage, contains('Delete failed'));
      },
    );

    testWidgets('SignOut işlemi sırasında hata oluşursa error gösterilir', (
      WidgetTester tester,
    ) async {
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

      // Mock signOut error
      when(mockFirebaseAuth.signOut()).thenThrow(Exception('SignOut failed'));

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: viewModel,
            child: const ProfileScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      // SignOut işlemini başlat
      await viewModel.signOut();
      await tester.pump();

      // Error mesajının gösterildiğini kontrol et
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.errorMessage, contains('Çıkış yapılırken hata oluştu'));
      expect(viewModel.errorMessage, contains('SignOut failed'));
    });

    testWidgets('Error mesajı clearError ile temizlenebilir', (
      WidgetTester tester,
    ) async {
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

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: viewModel,
            child: const ProfileScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      // Error set etmek için update işlemi yap
      when(
        mockUserService.updateUserData(any),
      ).thenThrow(Exception('Test error'));

      await viewModel.updateUser(name: 'Test', surname: 'Error');
      await tester.pump();
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.errorMessage, contains('Test error'));

      // Error'ı temizle
      viewModel.clearError();
      expect(viewModel.errorMessage, isNull);
    });

    testWidgets('Dispose edilmiş viewModel\'de error işlemleri çalışmaz', (
      WidgetTester tester,
    ) async {
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

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: viewModel,
            child: const ProfileScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      // ViewModel'i dispose et
      viewModel.dispose();

      // Error işlemlerini dene (dispose edilmiş viewModel'de çalışmaz)
      when(
        mockUserService.updateUserData(any),
      ).thenThrow(Exception('Test error'));

      await viewModel.updateUser(name: 'Test', surname: 'Error');
      await tester.pump();
      viewModel.clearError();

      // Error işlemlerinin çalışmadığını kontrol et
      expect(viewModel.errorMessage, isNull);
    });

    testWidgets('Multiple error durumları sırayla handle edilir', (
      WidgetTester tester,
    ) async {
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

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: viewModel,
            child: const ProfileScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      // İlk error - update işlemi ile
      when(
        mockUserService.updateUserData(any),
      ).thenThrow(Exception('First error'));
      await viewModel.updateUser(name: 'Test1', surname: 'Error1');
      await tester.pump();
      expect(viewModel.errorMessage, contains('First error'));

      // İkinci error - update işlemi ile
      when(
        mockUserService.updateUserData(any),
      ).thenThrow(Exception('Second error'));
      await viewModel.updateUser(name: 'Test2', surname: 'Error2');
      await tester.pump();
      expect(viewModel.errorMessage, contains('Second error'));

      // Error temizle
      viewModel.clearError();
      expect(viewModel.errorMessage, isNull);
    });

    testWidgets('Error durumunda UI state korunur', (
      WidgetTester tester,
    ) async {
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

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: viewModel,
            child: const ProfileScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      // Edit mode'u aç
      viewModel.toggleEditMode();
      expect(viewModel.isEditing, isTrue);

      // Error set etmek için update işlemi yap
      when(
        mockUserService.updateUserData(any),
      ).thenThrow(Exception('Test error'));

      await viewModel.updateUser(name: 'Test', surname: 'Error');
      await tester.pump();
      expect(viewModel.errorMessage, isNotNull);

      // Edit mode'un korunduğunu kontrol et
      expect(viewModel.isEditing, isTrue);

      // Kullanıcı verisinin korunduğunu kontrol et
      expect(viewModel.hasUser, isTrue);
      expect(viewModel.user?.name, equals('Test'));
    });
  });
}
