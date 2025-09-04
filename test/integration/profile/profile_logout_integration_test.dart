// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../helpers/test_helpers.dart';
import 'profile_logout_integration_test.mocks.dart';

@GenerateMocks([UserService, FirebaseAuth, User])
void main() {
  group('Profile Logout Integration Tests', () {
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

    testWidgets('Logout butonu doğru şekilde render edilir', (
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

      // Logout butonunun mevcut olduğunu kontrol et
      expect(find.text('Çıkış Yap'), findsOneWidget);

      // Logout butonunun ElevatedButton olduğunu kontrol et
      final logoutButton = find.widgetWithText(ElevatedButton, 'Çıkış Yap');
      expect(logoutButton, findsOneWidget);
    });

    testWidgets('Logout butonuna tıklandığında dialog gösterilir', (
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

      // Logout butonuna tıkla
      await tester.tap(find.text('Çıkış Yap'));
      await tester.pumpAndSettle();

      // Dialog'un gösterildiğini kontrol et
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text('Çıkış Yapmak İstediğinizden Emin misiniz?'),
        findsOneWidget,
      );
      expect(
        find.text('Çıkış yapmak istediğinizden emin misiniz?'),
        findsOneWidget,
      );
    });

    testWidgets(
      'Logout dialog\'unda Cancel butonuna tıklandığında dialog kapanır',
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

        // Logout butonuna tıkla
        await tester.tap(find.text('Çıkış Yap'));
        await tester.pumpAndSettle();

        // Cancel butonuna tıkla
        await tester.tap(find.text('İptal'));
        await tester.pumpAndSettle();

        // Dialog'un kapandığını kontrol et
        expect(find.byType(AlertDialog), findsNothing);
      },
    );

    testWidgets(
      'Logout dialog\'unda OK butonuna tıklandığında signOut çağrılır',
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

        // Mock successful signOut
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

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

        // Logout butonuna tıkla
        await tester.tap(find.text('Çıkış Yap'));
        await tester.pumpAndSettle();

        // OK butonuna tıkla
        await tester.tap(find.text('Tamam'));
        await tester.pumpAndSettle();

        // signOut'un çağrıldığını kontrol et
        verify(mockFirebaseAuth.signOut()).called(1);

        // Dialog'un kapandığını kontrol et
        expect(find.byType(AlertDialog), findsNothing);
      },
    );

    testWidgets('SignOut başarılı olduğunda kullanıcı verisi temizlenir', (
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

      // Mock successful signOut
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

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

      // Kullanıcı verisinin yüklendiğini kontrol et
      expect(viewModel.hasUser, isTrue);
      expect(viewModel.user?.name, equals('Test'));

      // SignOut işlemini başlat
      await viewModel.signOut();
      await tester.pump();

      // Kullanıcı verisinin temizlendiğini kontrol et
      expect(viewModel.hasUser, isFalse);
      expect(viewModel.user, isNull);
      expect(viewModel.isEditing, isFalse);
      expect(viewModel.errorMessage, isNull);
    });

    testWidgets('SignOut sırasında hata oluşursa error gösterilir', (
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

      // Kullanıcı verisinin hala mevcut olduğunu kontrol et
      expect(viewModel.hasUser, isTrue);
    });

    testWidgets('SignOut sırasında loading durumu doğru gösterilir', (
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

      // SignOut işlemini başlat
      final signOutFuture = viewModel.signOut();
      await tester.pump();

      // Loading durumunun aktif olduğunu kontrol et
      expect(viewModel.isLoading, isTrue);

      // SignOut tamamlanana kadar bekle
      await signOutFuture;
      await tester.pump();

      // Loading durumunun kapandığını kontrol et
      expect(viewModel.isLoading, isFalse);
    });

    testWidgets('Dispose edilmiş viewModel\'de signOut çağrılmaz', (
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

      // SignOut işlemini başlat
      await viewModel.signOut();
      await tester.pump();

      // signOut'un çağrılmadığını kontrol et
      verifyNever(mockFirebaseAuth.signOut());
    });

    testWidgets('Logout butonu loading durumunda disable olur', (
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

      // Loading durumunu aktif et
      // Loading state'i test etmek için signOut çağır
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
      });

      final signOutFuture = viewModel.signOut();
      await tester.pump();
      await tester.pump();

      // Logout butonunun disable olduğunu kontrol et
      final logoutButton = find.widgetWithText(ElevatedButton, 'Çıkış Yap');
      final buttonWidget = tester.widget<ElevatedButton>(logoutButton);
      expect(buttonWidget.onPressed, isNull);
    });
  });
}
