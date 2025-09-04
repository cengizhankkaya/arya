// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../helpers/test_helpers.dart';
import 'profile_delete_account_integration_test.mocks.dart';

@GenerateMocks([UserService, FirebaseAuth, User])
void main() {
  group('Profile Delete Account Integration Tests', () {
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

    testWidgets('Delete account işlemi başarıyla çalışır', (
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

      // Mock successful delete operations
      when(mockUserService.deleteUserData('user123')).thenAnswer((_) async {});
      when(mockFirebaseAuth.currentUser?.delete()).thenAnswer((_) async {});

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

      // Delete işlemlerinin çağrıldığını kontrol et
      verify(mockUserService.deleteUserData('user123')).called(1);
      verify(mockFirebaseAuth.currentUser?.delete()).called(1);

      // Kullanıcı verisinin temizlendiğini kontrol et
      expect(viewModel.hasUser, isFalse);
      expect(viewModel.user, isNull);
      expect(viewModel.isEditing, isFalse);
    });

    testWidgets(
      'Delete account işlemi sırasında loading state doğru gösterilir',
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

        // Mock delayed delete operations
        when(mockUserService.deleteUserData('user123')).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 500));
        });
        when(mockFirebaseAuth.currentUser?.delete()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
        });

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
        final deleteFuture = viewModel.deleteAccount();
        await tester.pump();

        // Loading state'in aktif olduğunu kontrol et
        expect(viewModel.isLoading, isTrue);

        // Delete tamamlanana kadar bekle
        await deleteFuture;
        await tester.pump();

        // Loading state'in kapandığını kontrol et
        expect(viewModel.isLoading, isFalse);
      },
    );

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

        // Kullanıcı verisinin korunduğunu kontrol et
        expect(viewModel.hasUser, isTrue);
        expect(viewModel.user?.name, equals('Test'));
      },
    );

    testWidgets('Delete account işlemi kullanıcı verisi yokken hata verir', (
      WidgetTester tester,
    ) async {
      // Mock null user data
      when(
        mockUserService.getUserData('user123'),
      ).thenAnswer((_) async => null);

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
        contains('Silinecek kullanıcı verisi bulunamadı'),
      );

      // Delete işlemlerinin çağrılmadığını kontrol et
      verifyNever(mockUserService.deleteUserData(any));
      verifyNever(mockFirebaseAuth.currentUser?.delete());
    });

    testWidgets('Delete account işlemi kullanıcı UID yokken hata verir', (
      WidgetTester tester,
    ) async {
      // Mock user data without UID
      final userModelWithoutUid = UserModel(
        uid: null,
        name: 'Test',
        surname: 'User',
        email: 'test@example.com',
      );

      when(
        mockUserService.getUserData('user123'),
      ).thenAnswer((_) async => userModelWithoutUid);

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
        contains('Silinecek kullanıcı verisi bulunamadı'),
      );

      // Delete işlemlerinin çağrılmadığını kontrol et
      verifyNever(mockUserService.deleteUserData(any));
      verifyNever(mockFirebaseAuth.currentUser?.delete());
    });

    testWidgets(
      'Delete account işlemi Firebase Auth hatası durumunda error gösterilir',
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

        // Mock successful user data delete but failed Firebase Auth delete
        when(
          mockUserService.deleteUserData('user123'),
        ).thenAnswer((_) async {});
        when(mockFirebaseAuth.currentUser?.delete()).thenThrow(
          FirebaseAuthException(
            code: 'requires-recent-login',
            message:
                'This operation is sensitive and requires recent authentication',
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

        // Delete account işlemini başlat
        await viewModel.deleteAccount();
        await tester.pump();

        // Error mesajının gösterildiğini kontrol et
        expect(viewModel.errorMessage, isNotNull);
        expect(
          viewModel.errorMessage,
          contains('Hesap silinirken hata oluştu'),
        );
        expect(viewModel.errorMessage, contains('requires-recent-login'));
      },
    );

    testWidgets(
      'Delete account işlemi dispose edilmiş viewModel\'de çalışmaz',
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

        // Delete account işlemini başlat
        await viewModel.deleteAccount();
        await tester.pump();

        // Delete işlemlerinin çağrılmadığını kontrol et
        verifyNever(mockUserService.deleteUserData(any));
        verifyNever(mockFirebaseAuth.currentUser?.delete());
      },
    );

    testWidgets('Delete account işlemi sırasında UI state korunur', (
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

      // Mock delayed delete operations
      when(mockUserService.deleteUserData('user123')).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 500));
      });
      when(mockFirebaseAuth.currentUser?.delete()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
      });

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

      // Delete account işlemini başlat
      final deleteFuture = viewModel.deleteAccount();
      await tester.pump();

      // Loading state'in aktif olduğunu kontrol et
      expect(viewModel.isLoading, isTrue);

      // Delete tamamlanana kadar bekle
      await deleteFuture;
      await tester.pump();

      // Edit mode'un kapandığını kontrol et
      expect(viewModel.isEditing, isFalse);
    });

    testWidgets('Delete account işlemi sırasında error temizlenir', (
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

      // Mock successful delete operations
      when(mockUserService.deleteUserData('user123')).thenAnswer((_) async {});
      when(mockFirebaseAuth.currentUser?.delete()).thenAnswer((_) async {});

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
      ).thenThrow(Exception('Previous error'));

      await viewModel.updateUser(name: 'Test', surname: 'Error');
      await tester.pump();
      expect(viewModel.errorMessage, contains('Previous error'));

      // Delete account işlemini başlat
      await viewModel.deleteAccount();
      await tester.pump();

      // Error'ın temizlendiğini kontrol et
      expect(viewModel.errorMessage, isNull);
    });
  });
}
