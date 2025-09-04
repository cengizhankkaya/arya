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
import 'profile_edit_flow_integration_test.mocks.dart';

@GenerateMocks([UserService, FirebaseAuth, User, FirebaseFirestore])
void main() {
  group('Profile Edit Flow Integration Tests', () {
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

    testWidgets('Edit mode toggle düzgün çalışır', (WidgetTester tester) async {
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

      // Başlangıçta edit mode kapalı
      expect(viewModel.isEditing, isFalse);
      expect(find.byType(UserInfoSection), findsOneWidget);
      expect(find.byType(EditProfileForm), findsNothing);

      // Edit mode'u aç
      viewModel.toggleEditMode();
      await tester.pump();

      // Edit mode açık
      expect(viewModel.isEditing, isTrue);
      expect(find.byType(UserInfoSection), findsNothing);
      expect(find.byType(EditProfileForm), findsOneWidget);

      // Edit mode'u kapat
      viewModel.toggleEditMode();
      await tester.pump();

      // Edit mode kapalı
      expect(viewModel.isEditing, isFalse);
      expect(find.byType(UserInfoSection), findsOneWidget);
      expect(find.byType(EditProfileForm), findsNothing);
    });

    testWidgets('Kullanıcı bilgileri başarıyla güncellenir', (
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

      // Mock successful update
      when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

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
      await tester.pump();

      // Text field'ları bul ve değerleri güncelle
      final nameField = find.byType(TextFormField).first;
      final surnameField = find.byType(TextFormField).last;

      await tester.enterText(nameField, 'Updated Name');
      await tester.enterText(surnameField, 'Updated Surname');

      // Update işlemini başlat
      await viewModel.updateUser(
        name: 'Updated Name',
        surname: 'Updated Surname',
      );

      await tester.pump();

      // Update işleminin başarılı olduğunu kontrol et
      verify(mockUserService.updateUserData(any)).called(1);
      expect(viewModel.isEditing, isFalse);
      expect(viewModel.user?.name, equals('Updated Name'));
      expect(viewModel.user?.surname, equals('Updated Surname'));
    });

    testWidgets(
      'Kullanıcı bilgileri güncellenirken hata oluşursa error gösterilir',
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
        expect(viewModel.isEditing, isTrue); // Edit mode açık kalır
      },
    );

    testWidgets('Controller\'lar doğru şekilde initialize edilir', (
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

      // Controller'ların doğru değerlerle initialize edildiğini kontrol et
      expect(viewModel.nameController.text, equals('Test'));
      expect(viewModel.surnameController.text, equals('User'));
    });

    testWidgets('updateUserFromControllers doğru çalışır', (
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

      // Mock successful update
      when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

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

      // Controller değerlerini güncelle
      viewModel.nameController.text = 'Controller Name';
      viewModel.surnameController.text = 'Controller Surname';

      // updateUserFromControllers çağır
      await viewModel.updateUserFromControllers();
      await tester.pump();

      // Update işleminin başarılı olduğunu kontrol et
      verify(mockUserService.updateUserData(any)).called(1);
      expect(viewModel.user?.name, equals('Controller Name'));
      expect(viewModel.user?.surname, equals('Controller Surname'));
    });

    testWidgets('Kullanıcı verisi yokken update işlemi hata verir', (
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
        contains('Güncellenecek kullanıcı verisi bulunamadı'),
      );
      verifyNever(mockUserService.updateUserData(any));
    });

    testWidgets('Edit mode kapatıldığında error temizlenir', (
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
      await tester.pump();

      // Error set etmek için update işlemi yap
      when(
        mockUserService.updateUserData(any),
      ).thenThrow(Exception('Test error'));

      await viewModel.updateUser(name: 'Test', surname: 'Error');
      await tester.pump();
      expect(viewModel.errorMessage, isNotNull);

      // Edit mode'u kapat
      viewModel.toggleEditMode();
      await tester.pump();

      // Error'ın temizlendiğini kontrol et
      expect(viewModel.errorMessage, isNull);
    });

    testWidgets('Loading durumu update sırasında doğru gösterilir', (
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
        await Future.delayed(const Duration(seconds: 1));
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

      // Loading durumunun aktif olduğunu kontrol et
      expect(viewModel.isLoading, isTrue);

      // Update tamamlanana kadar bekle
      await updateFuture;
      await tester.pump();

      // Loading durumunun kapandığını kontrol et
      expect(viewModel.isLoading, isFalse);
    });
  });
}
