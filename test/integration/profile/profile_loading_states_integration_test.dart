// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../helpers/firebase_options.dart';
import '../../helpers/test_helpers.dart';
import 'profile_loading_states_integration_test.mocks.dart';

@GenerateMocks([UserService, FirebaseAuth, User, FirebaseFirestore])
void main() {
  group('Profile Loading States Integration Tests', () {
    late MockUserService mockUserService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late MockFirebaseFirestore mockFirestore;
    late ProfileViewModel viewModel;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Test helpers setup
      TestHelpers.setupFirebaseMocks();
      TestHelpers.setupEasyLocalization();
      TestHelpers.setupPlatformChannels();
      TestHelpers.mockAssetBundle();

      // Firebase'i test ortamında mock'la
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/firebase_core'),
            (MethodCall methodCall) async {
              if (methodCall.method == 'Firebase#initializeCore') {
                return [
                  {
                    'name': '[DEFAULT]',
                    'options': {
                      'apiKey': 'test-api-key',
                      'appId': 'test-app-id',
                      'messagingSenderId': 'test-sender-id',
                      'projectId': 'test-project-id',
                    },
                    'pluginConstants': <String, dynamic>{},
                  },
                ];
              }
              return null;
            },
          );
    });

    setUp(() {
      mockUserService = MockUserService();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockFirestore = MockFirebaseFirestore();

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

    testWidgets('Initial loading state doğru gösterilir', (
      WidgetTester tester,
    ) async {
      // Mock delayed user data
      final userModel = UserModel(
        uid: 'user123',
        name: 'Test',
        surname: 'User',
        email: 'test@example.com',
      );

      when(mockUserService.getUserData('user123')).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 500));
        return userModel;
      });

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: viewModel,
            child: const ProfileScreen(),
          ),
        ),
      );

      // İlk pump - loading başlar
      await tester.pump();

      // Loading state'in aktif olduğunu kontrol et
      expect(viewModel.isLoading, isTrue);
      expect(find.byType(ProfileShimmerWidget), findsOneWidget);

      // Loading tamamlanana kadar bekle
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      // Loading state'in kapandığını kontrol et
      expect(viewModel.isLoading, isFalse);
      expect(find.byType(ProfileShimmerWidget), findsNothing);
      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('Update işlemi sırasında loading state doğru gösterilir', (
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

      // Mock delayed update
      when(mockUserService.updateUserData(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 500));
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

      // Update işlemini başlat
      final updateFuture = viewModel.updateUser(
        name: 'Updated Name',
        surname: 'Updated Surname',
      );

      await tester.pump();

      // Loading state'in aktif olduğunu kontrol et
      expect(viewModel.isLoading, isTrue);

      // Update tamamlanana kadar bekle
      await updateFuture;
      await tester.pump();

      // Loading state'in kapandığını kontrol et
      expect(viewModel.isLoading, isFalse);
    });

    testWidgets('SignOut işlemi sırasında loading state doğru gösterilir', (
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

      // Mock delayed signOut
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 500));
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

      // SignOut işlemini başlat
      final signOutFuture = viewModel.signOut();
      await tester.pump();

      // Loading state'in aktif olduğunu kontrol et
      expect(viewModel.isLoading, isTrue);

      // SignOut tamamlanana kadar bekle
      await signOutFuture;
      await tester.pump();

      // Loading state'in kapandığını kontrol et
      expect(viewModel.isLoading, isFalse);
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

        // Mock delayed delete
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

    testWidgets('Loading state sırasında UI elementleri disable olur', (
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

      // Loading state'i test etmek için update işlemi yap
      when(mockUserService.updateUserData(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
      });

      final updateFuture = viewModel.updateUser(
        name: 'Test',
        surname: 'Loading',
      );
      await tester.pump();

      // Logout butonunun disable olduğunu kontrol et
      final logoutButton = find.widgetWithText(ElevatedButton, 'Çıkış Yap');
      final buttonWidget = tester.widget<ElevatedButton>(logoutButton);
      expect(buttonWidget.onPressed, isNull);
    });

    testWidgets('Loading state sırasında edit mode değişmez', (
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

      // Loading state'i test etmek için update işlemi yap
      when(mockUserService.updateUserData(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
      });

      final updateFuture = viewModel.updateUser(
        name: 'Test',
        surname: 'Loading',
      );
      await tester.pump();

      // Edit mode'un korunduğunu kontrol et
      expect(viewModel.isEditing, isTrue);
    });

    testWidgets('Loading state sırasında error mesajı korunur', (
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
      expect(viewModel.errorMessage, contains('Test error'));

      // Loading state'i test etmek için yeni update işlemi yap
      when(mockUserService.updateUserData(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
      });

      final updateFuture = viewModel.updateUser(
        name: 'Test2',
        surname: 'Loading',
      );
      await tester.pump();

      // Error mesajının korunduğunu kontrol et
      expect(viewModel.errorMessage, contains('Test error'));
    });

    testWidgets('Dispose edilmiş viewModel\'de loading state değişmez', (
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

      // Loading state'i değiştirmeye çalış (dispose edilmiş viewModel'de çalışmaz)
      when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

      await viewModel.updateUser(name: 'Test', surname: 'Disposed');
      await tester.pump();

      // Loading state'in değişmediğini kontrol et
      expect(viewModel.isLoading, isFalse);
    });

    testWidgets('Multiple loading işlemleri sırayla handle edilir', (
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

      when(mockUserService.updateUserData(any)).thenAnswer((_) async {
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

      // İlk update işlemi
      final update1 = viewModel.updateUser(name: 'Name1');
      await tester.pump();
      expect(viewModel.isLoading, isTrue);

      // İlk update tamamlanana kadar bekle
      await update1;
      await tester.pump();
      expect(viewModel.isLoading, isFalse);

      // İkinci update işlemi
      final update2 = viewModel.updateUser(name: 'Name2');
      await tester.pump();
      expect(viewModel.isLoading, isTrue);

      // İkinci update tamamlanana kadar bekle
      await update2;
      await tester.pump();
      expect(viewModel.isLoading, isFalse);
    });

    testWidgets('Loading state sırasında shimmer widget gösterilir', (
      WidgetTester tester,
    ) async {
      // Mock user data
      final userModel = UserModel(
        uid: 'user123',
        name: 'Test',
        surname: 'User',
        email: 'test@example.com',
      );

      when(mockUserService.getUserData('user123')).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 500));
        return userModel;
      });

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: viewModel,
            child: const ProfileScreen(),
          ),
        ),
      );

      // İlk pump - loading başlar
      await tester.pump();

      // Shimmer widget'ının gösterildiğini kontrol et
      expect(find.byType(ProfileShimmerWidget), findsOneWidget);

      // Loading tamamlanana kadar bekle
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      // Shimmer widget'ının kaybolduğunu kontrol et
      expect(find.byType(ProfileShimmerWidget), findsNothing);
    });
  });
}
