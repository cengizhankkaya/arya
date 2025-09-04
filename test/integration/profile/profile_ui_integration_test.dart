// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../helpers/firebase_options.dart';
import '../../helpers/test_helpers.dart';
import 'profile_ui_integration_test.mocks.dart';

@GenerateMocks([UserService, FirebaseAuth, User, FirebaseFirestore])
void main() {
  group('Profile UI Integration Tests', () {
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
              if (methodCall.method == 'Firebase#initializeApp') {
                return {
                  'name': '[DEFAULT]',
                  'options': {
                    'apiKey': 'test-api-key',
                    'appId': 'test-app-id',
                    'messagingSenderId': 'test-sender-id',
                    'projectId': 'test-project-id',
                  },
                  'pluginConstants': <String, dynamic>{},
                };
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

    testWidgets('Profile ekranı başarıyla yüklenir', (
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
        TestHelpers.createTestAppWithLocalization(
          Scaffold(
            appBar: AppBar(title: const Text('Profil')),
            body: ChangeNotifierProvider.value(
              value: viewModel,
              child: const ProfileBody(),
            ),
          ),
        ),
      );

      // fetchUser çağrısını başlat
      viewModel.fetchUser();

      // fetchUser çağrısını bekle
      await tester.pump();
      await tester.pump();

      // AppBar'ın doğru başlığa sahip olduğunu kontrol et
      expect(find.text('Profil'), findsOneWidget);

      // ProfileBody widget'ının render edildiğini kontrol et
      expect(find.byType(ProfileBody), findsOneWidget);
    });

    testWidgets('Profile ekranı loading durumunda shimmer gösterir', (
      WidgetTester tester,
    ) async {
      // fetchUser çağrısını geciktir
      when(mockUserService.getUserData('user123')).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return UserModel(
          uid: 'user123',
          name: 'Test',
          surname: 'User',
          email: 'test@example.com',
        );
      });

      await tester.pumpWidget(
        TestHelpers.createTestAppWithLocalization(
          Scaffold(
            appBar: AppBar(title: const Text('Profil')),
            body: ChangeNotifierProvider.value(
              value: viewModel,
              child: const ProfileBody(),
            ),
          ),
        ),
      );

      // fetchUser çağrısını başlat
      viewModel.fetchUser();

      // İlk pump - loading başlar
      await tester.pump();

      // Shimmer widget'ının gösterildiğini kontrol et
      expect(find.byType(ProfileShimmerWidget), findsOneWidget);

      // Loading tamamlanana kadar bekle
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // Shimmer kaybolur
      expect(find.byType(ProfileShimmerWidget), findsNothing);
    });

    testWidgets(
      'Profile ekranı hata durumunda error mesajı ve retry butonu gösterir',
      (WidgetTester tester) async {
        // Mock error
        when(
          mockUserService.getUserData('user123'),
        ).thenThrow(Exception('Network error'));

        await tester.pumpWidget(
          TestHelpers.createTestAppWithLocalization(
            Scaffold(
              appBar: AppBar(title: const Text('Profil')),
              body: ChangeNotifierProvider.value(
                value: viewModel,
                child: const ProfileBody(),
              ),
            ),
          ),
        );

        // fetchUser çağrısını başlat
        viewModel.fetchUser();

        await tester.pump();
        await tester.pump();

        // Error icon'unun gösterildiğini kontrol et
        expect(find.byIcon(Icons.error_outline), findsOneWidget);

        // Error mesajının gösterildiğini kontrol et
        expect(
          find.textContaining('Kullanıcı verisi yüklenirken hata oluştu'),
          findsOneWidget,
        );

        // Retry butonunun mevcut olduğunu kontrol et (lokalizasyon anahtarı çevrilmemiş)
        expect(find.text('general.button.retry'), findsOneWidget);
      },
    );

    testWidgets('Profile ekranı kullanıcı verisi yokken uygun mesaj gösterir', (
      WidgetTester tester,
    ) async {
      // Mock null user data
      when(
        mockUserService.getUserData('user123'),
      ).thenAnswer((_) async => null);

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

      // "Kullanıcı verisi bulunamadı" mesajının gösterildiğini kontrol et (lokalizasyon anahtarı çevrilmemiş)
      expect(find.textContaining('profile.no_user_data'), findsOneWidget);
    });

    testWidgets(
      'Profile ekranı FirebaseAuth currentUser null iken hata gösterir',
      (WidgetTester tester) async {
        // Mock null currentUser
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        await tester.pumpWidget(
          TestHelpers.createTestAppWithLocalization(
            Scaffold(
              appBar: AppBar(title: const Text('Profil')),
              body: ChangeNotifierProvider.value(
                value: viewModel,
                child: const ProfileBody(),
              ),
            ),
          ),
        );

        // fetchUser çağrısını başlat
        viewModel.fetchUser();

        await tester.pump();
        await tester.pump();

        // "Kullanıcı oturumu bulunamadı" mesajının gösterildiğini kontrol et
        expect(
          find.textContaining('Kullanıcı oturumu bulunamadı'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Profile ekranı tamamlanmamış kullanıcı için completion status gösterir',
      (WidgetTester tester) async {
        // Mock incomplete user data
        final incompleteUser = UserModel(
          uid: 'user123',
          name: 'Test',
          surname: '',
          email: 'test@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => incompleteUser);

        await tester.pumpWidget(
          TestHelpers.createTestAppWithLocalization(
            Scaffold(
              appBar: AppBar(title: const Text('Profil')),
              body: ChangeNotifierProvider.value(
                value: viewModel,
                child: const ProfileBody(),
              ),
            ),
          ),
        );

        // fetchUser çağrısını başlat
        viewModel.fetchUser();

        await tester.pump();
        await tester.pump();

        // Profile completion status widget'ının gösterildiğini kontrol et
        expect(find.byType(ProfileCompletionStatus), findsOneWidget);
      },
    );

    testWidgets(
      'Profile ekranı tamamlanmış kullanıcı için completion status göstermez',
      (WidgetTester tester) async {
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

        await tester.pumpWidget(
          TestHelpers.createTestAppWithLocalization(
            Scaffold(
              appBar: AppBar(title: const Text('Profil')),
              body: ChangeNotifierProvider.value(
                value: viewModel,
                child: const ProfileBody(),
              ),
            ),
          ),
        );

        // fetchUser çağrısını başlat
        viewModel.fetchUser();

        await tester.pump();
        await tester.pump();

        // Profile completion status widget'ının gösterilmediğini kontrol et
        expect(find.byType(ProfileCompletionStatus), findsNothing);
      },
    );

    testWidgets('Profile actions consumer doğru şekilde render edilir', (
      WidgetTester tester,
    ) async {
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
        TestHelpers.createTestAppWithLocalization(
          ChangeNotifierProvider.value(
            value: viewModel,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Profil'),
                actions: const [ProfileActionsConsumer()],
              ),
              body: const ProfileBody(),
            ),
          ),
        ),
      );

      // fetchUser çağrısını başlat
      viewModel.fetchUser();

      await tester.pump();
      await tester.pump();

      // ProfileActionsConsumer'ın AppBar'da render edildiğini kontrol et
      expect(find.byType(ProfileActionsConsumer), findsOneWidget);
    });
  });
}
