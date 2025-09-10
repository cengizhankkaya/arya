import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arya/features/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:auto_route/auto_route.dart';

/// Mock RouterConfig sınıfı test ortamı için
class MockRouterConfig extends RouterConfig<Object> {
  final Widget child;

  MockRouterConfig(this.child)
    : super(
        routeInformationProvider: MockRouteInformationProvider(),
        routeInformationParser: MockRouteInformationParser(),
        routerDelegate: MockRouterDelegate(child),
      );
}

/// Mock RouteInformationProvider
class MockRouteInformationProvider extends RouteInformationProvider {
  @override
  RouteInformation get value => RouteInformation(uri: Uri.parse('/'));

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}

/// Mock RouteInformationParser
class MockRouteInformationParser extends RouteInformationParser<Object> {
  @override
  Future<Object> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    return routeInformation.uri.path;
  }

  @override
  RouteInformation restoreRouteInformation(Object configuration) {
    return RouteInformation(uri: Uri.parse(configuration.toString()));
  }
}

/// Mock RouterDelegate
class MockRouterDelegate extends RouterDelegate<Object> {
  final Widget child;

  MockRouterDelegate(this.child);

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {}

  @override
  Object get currentConfiguration => '/';

  @override
  Future<bool> popRoute() async => false;

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}

/// Mock AutoRouter sınıfı test ortamı için
class MockAutoRouter extends StatelessWidget {
  final Widget child;

  const MockAutoRouter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Mock AutoRouter extension'ı
extension MockAutoRouterExtension on BuildContext {
  MockAutoRouterX get router => MockAutoRouterX();
}

/// Mock AutoRouterX sınıfı
class MockAutoRouterX {
  Future<T?> push<T extends Object?>(PageRouteInfo route) async {
    // Test ortamında navigation'ı mock'la
    return null;
  }

  Future<T?> pushAndClearStack<T extends Object?>(PageRouteInfo route) async {
    return null;
  }

  Future<T?> replace<T extends Object?>(PageRouteInfo route) async {
    return null;
  }

  Future<bool> pop<T extends Object?>([T? result]) async {
    return true;
  }

  void popUntil(RoutePredicate predicate) {}

  void popUntilRoot() {}

  Future<T?> pushNamed<T extends Object?>(
    String path, {
    Object? arguments,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) async {
    return null;
  }
}

/// Mock SharedPreferences sınıfı test ortamı için
class MockSharedPreferences {
  static final Map<String, Object> _storage = <String, Object>{};

  static void clear() {
    _storage.clear();
  }

  static void setMockValue(String key, Object value) {
    _storage[key] = value;
  }

  static Object? getMockValue(String key) {
    return _storage[key];
  }

  static bool containsKey(String key) {
    return _storage.containsKey(key);
  }

  static Set<String> getKeys() {
    return _storage.keys.toSet();
  }
}

/// Test helper'ları için widget wrapper'ları ve utility methodları
///
/// Bu sınıf test ortamında widget testleri için gerekli olan
/// tüm yardımcı methodları içerir.
///
/// Örnek kullanım:
/// ```dart
/// TestHelpers.setupEasyLocalization();
/// await tester.pumpWidget(TestHelpers.createTestApp(child: MyWidget()));
/// ```
class TestHelpers {
  TestHelpers._(); // Private constructor to prevent instantiation

  // ==================== SETUP METHODS ====================

  /// Test için Easy Localization setup'ı
  static void setupEasyLocalization() {
    // Flutter binding'i initialize et
    TestWidgetsFlutterBinding.ensureInitialized();

    // SharedPreferences için mock değerler ayarla
    SharedPreferences.setMockInitialValues({
      'language_code': 'tr',
      'country_code': 'TR',
    });

    EasyLocalization.logger.enableBuildModes = [];
    // Test ortamında EasyLocalization'ı başlat
    try {
      EasyLocalization.ensureInitialized();
    } catch (e) {
      // Test ortamında hata olması normal
    }
  }

  /// Theme setup'ı test ortamı için
  static ThemeData createTestTheme() {
    return ThemeData(
      extensions: <ThemeExtension<dynamic>>[AppColors.light],
      useMaterial3: true,
    );
  }

  /// Test için Easy Localization ile MaterialApp oluşturur
  static Widget createTestAppWithEasyLocalization(Widget child) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('tr'),
      startLocale: const Locale('tr'),
      useOnlyLangCode: true,
      child: MaterialApp(
        theme: _createDefaultTheme(),
        home: Scaffold(body: child),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('tr')],
        locale: const Locale('tr'),
      ),
    );
  }

  /// Test için platform channel setup'ı
  static void setupPlatformChannels() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/shared_preferences', (
          message,
        ) async {
          return null;
        });
  }

  /// Test ortamını temizle
  static void tearDown() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/shared_preferences', null);
  }

  /// Test için asset bundle mock'u
  static void mockAssetBundle() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
          return null;
        });
  }

  /// Test için asset yükleme sorunlarını çözen mock
  static void setupAssetMocks() {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

    // Tüm asset isteklerini null döndür - test ortamında asset'leri yok say
    messenger.setMockMessageHandler('flutter/assets', (message) async {
      return null;
    });

    // Platform asset bundle mock'u
    messenger.setMockMessageHandler('flutter/platform_assets', (message) async {
      return null;
    });

    // Font manifest mock'u
    messenger.setMockMessageHandler('flutter/fonts', (message) async {
      return null;
    });
  }

  /// Firebase mock setup'ı - Geliştirilmiş versiyon
  static void setupFirebaseMocks() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Firebase Core method channel mock - daha kapsamlı
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/firebase_core'),
          (MethodCall methodCall) async {
            switch (methodCall.method) {
              case 'Firebase#initializeCore':
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
              case 'Firebase#initializeApp':
                return {
                  'name': methodCall.arguments['appName'] ?? '[DEFAULT]',
                  'options':
                      methodCall.arguments['options'] ??
                      {
                        'apiKey': 'test-api-key',
                        'appId': 'test-app-id',
                        'messagingSenderId': 'test-sender-id',
                        'projectId': 'test-project-id',
                      },
                  'pluginConstants': <String, dynamic>{},
                };
              case 'Firebase#app':
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
              case 'Firebase#delete':
                return null;
              default:
                return null;
            }
          },
        );

    // Firestore mock setup
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/cloud_firestore'),
          (MethodCall methodCall) async {
            // Firestore method calls için mock responses
            switch (methodCall.method) {
              case 'DocumentReference#get':
                return {
                  'data': <String, dynamic>{},
                  'metadata': {'hasPendingWrites': false, 'isFromCache': false},
                };
              case 'Query#get':
                return {
                  'documents': <Map<String, dynamic>>[],
                  'metadata': {'hasPendingWrites': false, 'isFromCache': false},
                };
              default:
                return null;
            }
          },
        );

    // Firebase Auth mock setup
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/firebase_auth'),
          (MethodCall methodCall) async {
            // Auth method calls için mock responses
            switch (methodCall.method) {
              case 'Auth#currentUser':
                return null; // No user logged in
              case 'Auth#signInAnonymously':
                return {
                  'user': {'uid': 'test-uid', 'isAnonymous': true},
                };
              default:
                return null;
            }
          },
        );
  }

  /// Firebase'i test ortamında başlat
  static Future<void> initializeFirebaseForTesting() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Firebase Core mock setup
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
                'name': methodCall.arguments['appName'] ?? '[DEFAULT]',
                'options':
                    methodCall.arguments['options'] ??
                    {
                      'apiKey': 'test-api-key',
                      'appId': 'test-app-id',
                      'messagingSenderId': 'test-sender-id',
                      'projectId': 'test-project-id',
                    },
                'pluginConstants': <String, dynamic>{},
              };
            }
            if (methodCall.method == 'Firebase#app') {
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

    // Firestore mock setup
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/cloud_firestore'),
          (MethodCall methodCall) async {
            // Firestore method calls için mock responses
            return null;
          },
        );

    // Firebase Auth mock setup
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/firebase_auth'),
          (MethodCall methodCall) async {
            // Auth method calls için mock responses
            return null;
          },
        );

    try {
      await Firebase.initializeApp();
    } catch (e) {
      // Firebase zaten başlatılmış olabilir
    }
  }

  /// AppShell test'leri için özel test widget'ı oluştur - Geliştirilmiş versiyon
  static Widget createAppShellTestWidget({
    required Widget child,
    Map<Type, dynamic>? providers,
  }) {
    return createTestAppWithEasyLocalization(
      MultiProvider(
        providers: [
          if (providers != null)
            ...providers.entries.map(
              (entry) => ChangeNotifierProvider.value(value: entry.value),
            ),
        ],
        child: child,
      ),
    );
  }

  /// Mock ViewModel'ler ile AppShell test widget'ı oluştur
  static Widget createAppShellTestWidgetWithMocks({
    required Widget child,
    required Map<String, dynamic> mockViewModels,
  }) {
    return createTestAppWithEasyLocalization(
      MultiProvider(
        providers: [
          // AppShellViewModel - Type-specific provider
          if (mockViewModels.containsKey('AppShellViewModel'))
            ChangeNotifierProvider<AppShellViewModel>.value(
              value: mockViewModels['AppShellViewModel'] as AppShellViewModel,
            ),
          // CartViewModel - Type-specific provider
          if (mockViewModels.containsKey('CartViewModel'))
            ChangeNotifierProvider<CartViewModel>.value(
              value: mockViewModels['CartViewModel'] as CartViewModel,
            ),
          // ProfileViewModel - Type-specific provider
          if (mockViewModels.containsKey('ProfileViewModel'))
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModels['ProfileViewModel'] as ProfileViewModel,
            ),
          // HomeViewModel - Type-specific provider
          if (mockViewModels.containsKey('HomeViewModel'))
            ChangeNotifierProvider<HomeViewModel>.value(
              value: mockViewModels['HomeViewModel'] as HomeViewModel,
            ),
          // StoreViewModel - Type-specific provider
          if (mockViewModels.containsKey('StoreViewModel'))
            ChangeNotifierProvider<StoreViewModel>.value(
              value: mockViewModels['StoreViewModel'] as StoreViewModel,
            ),
        ],
        child: child,
      ),
    );
  }

  /// Firebase bağımlılığı olmadan AppShell test widget'ı oluştur
  static Widget createFirebaseFreeAppShellTestWidget({
    required Widget child,
    required Map<String, dynamic> mockViewModels,
  }) {
    return createTestAppWithEasyLocalization(
      MultiProvider(
        providers: [
          // AppShellViewModel - Type-specific provider
          if (mockViewModels.containsKey('AppShellViewModel'))
            ChangeNotifierProvider<AppShellViewModel>.value(
              value: mockViewModels['AppShellViewModel'] as AppShellViewModel,
            ),
          // CartViewModel - Type-specific provider
          if (mockViewModels.containsKey('CartViewModel'))
            ChangeNotifierProvider<CartViewModel>.value(
              value: mockViewModels['CartViewModel'] as CartViewModel,
            ),
          // ProfileViewModel - Type-specific provider
          if (mockViewModels.containsKey('ProfileViewModel'))
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModels['ProfileViewModel'] as ProfileViewModel,
            ),
          // HomeViewModel - Type-specific provider
          if (mockViewModels.containsKey('HomeViewModel'))
            ChangeNotifierProvider<HomeViewModel>.value(
              value: mockViewModels['HomeViewModel'] as HomeViewModel,
            ),
          // StoreViewModel - Type-specific provider
          if (mockViewModels.containsKey('StoreViewModel'))
            ChangeNotifierProvider<StoreViewModel>.value(
              value: mockViewModels['StoreViewModel'] as StoreViewModel,
            ),
        ],
        child: child,
      ),
    );
  }

  /// Firebase-free test widget'ı - tüm gerekli provider'ları içerir
  static Widget createCompleteFirebaseFreeTestWidget({
    required Widget child,
    required Map<String, dynamic> mockViewModels,
  }) {
    return createTestAppWithEasyLocalization(
      MockAutoRouter(
        child: MultiProvider(
          providers: [
            // AppShellViewModel
            if (mockViewModels.containsKey('AppShellViewModel'))
              ChangeNotifierProvider<AppShellViewModel>.value(
                value: mockViewModels['AppShellViewModel'] as AppShellViewModel,
              ),
            // CartViewModel
            if (mockViewModels.containsKey('CartViewModel'))
              ChangeNotifierProvider<CartViewModel>.value(
                value: mockViewModels['CartViewModel'] as CartViewModel,
              ),
            // ProfileViewModel
            if (mockViewModels.containsKey('ProfileViewModel'))
              ChangeNotifierProvider<ProfileViewModel>.value(
                value: mockViewModels['ProfileViewModel'] as ProfileViewModel,
              ),
            // HomeViewModel
            if (mockViewModels.containsKey('HomeViewModel'))
              ChangeNotifierProvider<HomeViewModel>.value(
                value: mockViewModels['HomeViewModel'] as HomeViewModel,
              ),
            // StoreViewModel
            if (mockViewModels.containsKey('StoreViewModel'))
              ChangeNotifierProvider<StoreViewModel>.value(
                value: mockViewModels['StoreViewModel'] as StoreViewModel,
              ),
          ],
          child: child,
        ),
      ),
    );
  }

  /// Mock ProfileScreen widget'ı - Firebase bağımlılığı olmadan
  static Widget createMockProfileScreen() {
    return const Scaffold(body: Center(child: Text('Mock Profile Screen')));
  }

  /// Mock HomeScreen widget'ı
  static Widget createMockHomeScreen() {
    return const Scaffold(body: Center(child: Text('Mock Home Screen')));
  }

  /// Mock StoreScreen widget'ı
  static Widget createMockStoreScreen() {
    return const Scaffold(body: Center(child: Text('Mock Store Screen')));
  }

  /// Mock CartScreen widget'ı
  static Widget createMockCartScreen() {
    return const Scaffold(body: Center(child: Text('Mock Cart Screen')));
  }

  /// Test ortamı için mock image widget'ı
  static Widget createMockImage(String assetPath) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }

  /// Firebase'i test ortamında tam olarak başlat
  static Future<void> initializeFirebaseCompletely() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Firebase Core mock setup
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
                'name': methodCall.arguments['appName'] ?? '[DEFAULT]',
                'options':
                    methodCall.arguments['options'] ??
                    {
                      'apiKey': 'test-api-key',
                      'appId': 'test-app-id',
                      'messagingSenderId': 'test-sender-id',
                      'projectId': 'test-project-id',
                    },
                'pluginConstants': <String, dynamic>{},
              };
            }
            if (methodCall.method == 'Firebase#app') {
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

    // Firebase Firestore mock setup
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/cloud_firestore'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'Firestore#enableNetwork') {
              return null;
            }
            if (methodCall.method == 'Firestore#disableNetwork') {
              return null;
            }
            if (methodCall.method == 'Query#get') {
              return {
                'documents': [],
                'metadata': {'hasPendingWrites': false, 'isFromCache': false},
              };
            }
            if (methodCall.method == 'DocumentReference#get') {
              return {
                'data': null,
                'metadata': {'hasPendingWrites': false, 'isFromCache': false},
              };
            }
            if (methodCall.method == 'DocumentReference#set') {
              return null;
            }
            if (methodCall.method == 'DocumentReference#update') {
              return null;
            }
            if (methodCall.method == 'DocumentReference#delete') {
              return null;
            }
            return null;
          },
        );

    // Firebase Auth mock setup
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/firebase_auth'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'Auth#signInAnonymously') {
              return {
                'user': {'uid': 'test-uid', 'isAnonymous': true},
              };
            }
            if (methodCall.method == 'Auth#signOut') {
              return null;
            }
            if (methodCall.method == 'Auth#currentUser') {
              return null;
            }
            if (methodCall.method == 'Auth#authStateChanges') {
              return null;
            }
            return null;
          },
        );
  }

  /// Firebase mock setup'ını daha kapsamlı hale getir
  static void setupComprehensiveFirebaseMocks() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Firebase Core mock setup
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
                'name': methodCall.arguments['appName'] ?? '[DEFAULT]',
                'options':
                    methodCall.arguments['options'] ??
                    {
                      'apiKey': 'test-api-key',
                      'appId': 'test-app-id',
                      'messagingSenderId': 'test-sender-id',
                      'projectId': 'test-project-id',
                    },
                'pluginConstants': <String, dynamic>{},
              };
            }
            if (methodCall.method == 'Firebase#app') {
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

    // Firebase Auth mock setup
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/firebase_auth'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'Auth#registerIdTokenListener') {
              return null;
            }
            if (methodCall.method == 'Auth#registerAuthStateListener') {
              return null;
            }
            if (methodCall.method == 'User#reload') {
              return null;
            }
            if (methodCall.method == 'User#delete') {
              return null;
            }
            if (methodCall.method == 'User#getIdToken') {
              return 'mock-token';
            }
            if (methodCall.method == 'Auth#signOut') {
              return null;
            }
            if (methodCall.method == 'Auth#signInWithEmailAndPassword') {
              return {
                'user': {
                  'uid': 'test-uid',
                  'email': 'test@example.com',
                  'displayName': 'Test User',
                },
                'additionalUserInfo': <String, dynamic>{},
              };
            }
            return null;
          },
        );

    // Firebase Firestore mock setup
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/cloud_firestore'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'Firestore#enableNetwork') {
              return null;
            }
            if (methodCall.method == 'Firestore#disableNetwork') {
              return null;
            }
            if (methodCall.method == 'DocumentReference#set') {
              return null;
            }
            if (methodCall.method == 'DocumentReference#get') {
              return {
                'data': <String, dynamic>{
                  'uid': 'test-uid',
                  'name': 'Test',
                  'surname': 'User',
                  'email': 'test@example.com',
                },
                'metadata': <String, dynamic>{
                  'hasPendingWrites': false,
                  'isFromCache': false,
                },
              };
            }
            if (methodCall.method == 'DocumentReference#update') {
              return null;
            }
            if (methodCall.method == 'DocumentReference#delete') {
              return null;
            }
            return null;
          },
        );
  }

  /// Firebase Core mock setup helper
  static void setupFirebaseCoreMocks() {
    // Firebase Core platform interface mock
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
                'name': methodCall.arguments['appName'] ?? '[DEFAULT]',
                'options':
                    methodCall.arguments['options'] ??
                    {
                      'apiKey': 'test-api-key',
                      'appId': 'test-app-id',
                      'messagingSenderId': 'test-sender-id',
                      'projectId': 'test-project-id',
                    },
                'pluginConstants': <String, dynamic>{},
              };
            }
            if (methodCall.method == 'Firebase#app') {
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
  }

  /// Firebase Auth mock setup helper
  static void setupFirebaseAuthMocks() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/firebase_auth'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'Auth#registerIdTokenListener') {
              return null;
            }
            if (methodCall.method == 'Auth#registerAuthStateListener') {
              return null;
            }
            if (methodCall.method == 'User#reload') {
              return null;
            }
            if (methodCall.method == 'User#delete') {
              return null;
            }
            if (methodCall.method == 'User#getIdToken') {
              return 'mock-token';
            }
            return null;
          },
        );
  }

  /// Firebase Firestore mock setup helper
  static void setupFirebaseFirestoreMocks() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/cloud_firestore'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'Firestore#enableNetwork') {
              return null;
            }
            if (methodCall.method == 'Firestore#disableNetwork') {
              return null;
            }
            if (methodCall.method == 'DocumentReference#set') {
              return null;
            }
            if (methodCall.method == 'DocumentReference#get') {
              return {
                'data': <String, dynamic>{},
                'metadata': <String, dynamic>{
                  'hasPendingWrites': false,
                  'isFromCache': false,
                },
              };
            }
            if (methodCall.method == 'DocumentReference#update') {
              return null;
            }
            if (methodCall.method == 'DocumentReference#delete') {
              return null;
            }
            return null;
          },
        );
  }

  // ==================== WIDGET WRAPPERS ====================

  /// Easy Localization ile MaterialApp oluşturur
  static Widget createTestAppWithLocalization(Widget child) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: MaterialApp(
        theme: _createDefaultTheme(),
        home: Scaffold(body: child),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('tr')],
        locale: const Locale('en'),
      ),
    );
  }

  /// AppColors extension'ını içeren MaterialApp wrapper'ı
  static Widget createTestApp({required Widget child, ThemeData? theme}) {
    return MaterialApp(
      theme: theme ?? _createDefaultTheme(),
      home: Scaffold(body: child),
    );
  }

  /// AppColors extension'ını içeren varsayılan tema
  static ThemeData _createDefaultTheme() {
    return createTestTheme();
  }

  /// Dark tema ile AppColors extension'ı
  static ThemeData createDarkTheme() {
    final appColors = _createDarkAppColors();
    return ThemeData.dark().copyWith(
      extensions: <ThemeExtension<dynamic>>[appColors],
    );
  }

  /// Custom tema ile AppColors extension'ı
  static ThemeData createCustomTheme({
    required Color seedColor,
    AppColors? appColors,
  }) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      extensions: <ThemeExtension<dynamic>>[
        appColors ?? _createDefaultAppColors(),
      ],
    );
  }

  /// Varsayılan AppColors instance'ı (light tema)
  static AppColors _createDefaultAppColors() {
    return AppColors.light;
  }

  /// Dark tema için AppColors instance'ı
  static AppColors _createDarkAppColors() {
    return AppColors.dark;
  }

  /// Provider ile test app oluşturur
  static Widget createTestAppWithProvider<T extends ChangeNotifier>({
    required Widget child,
    required T provider,
    ThemeData? theme,
  }) {
    return ChangeNotifierProvider<T>.value(
      value: provider,
      child: MaterialApp(
        theme: theme ?? _createDefaultTheme(),
        home: Scaffold(body: child),
      ),
    );
  }

  /// Firebase ile test app oluşturur
  static Widget createTestAppWithFirebase({
    required Widget child,
    ThemeData? theme,
  }) {
    return MaterialApp(
      theme: theme ?? _createDefaultTheme(),
      home: Scaffold(body: child),
    );
  }

  /// MultiProvider ile test app oluşturur
  static Widget createTestAppWithMultiProvider({
    required Widget child,
    required List<ChangeNotifierProvider> providers,
    ThemeData? theme,
  }) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        theme: theme ?? _createDefaultTheme(),
        home: Scaffold(body: child),
      ),
    );
  }

  // ==================== TEST INTERACTION HELPERS ====================

  /// Belirli bir widget'ın bulunmasını bekle
  static Future<void> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      await tester.pump();
      if (finder.evaluate().isNotEmpty) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    throw Exception('Widget not found within timeout');
  }

  /// Animasyon tamamlanmasını bekle
  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.pumpAndSettle(timeout);
  }

  /// Text field'a değer gir
  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Button'a bas ve animasyon bekle
  static Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Scroll action'ı
  static Future<void> scrollUntilVisible(
    WidgetTester tester,
    Finder itemFinder,
    Finder scrollableFinder, {
    double delta = 100.0,
  }) async {
    await tester.scrollUntilVisible(
      itemFinder,
      delta,
      scrollable: scrollableFinder,
    );
  }

  /// Test timeout wrapper'ı
  static Future<T> withTimeout<T>(
    Future<T> future, {
    Duration timeout = const Duration(seconds: 30),
  }) {
    return future.timeout(timeout);
  }

  // ==================== MOCK FACTORIES ====================

  /// Test için UserModel oluşturur
  static UserModel createTestUserModel({
    String? uid,
    String? name,
    String? surname,
    String? email,
    String? username,
  }) {
    return UserModel(
      uid: uid ?? 'test-uid',
      name: name ?? 'Test User',
      surname: surname ?? 'Test Surname',
      email: email ?? 'test@example.com',
      username: username ?? 'testuser',
    );
  }

  // ==================== ADD PRODUCT TEST HELPERS ====================

  /// AddProduct testleri için MaterialApp wrapper'ı
  static Widget createAddProductTestApp({
    required Widget child,
    required ChangeNotifier viewModel,
  }) {
    return MaterialApp(
      theme: createTestTheme(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('tr', 'TR')],
      locale: const Locale('tr', 'TR'),
      home: ChangeNotifierProvider(create: (_) => viewModel, child: child),
    );
  }

  /// AddProduct form alanlarını doldurur
  static Future<void> fillAddProductForm(
    WidgetTester tester, {
    required Map<String, String> testData,
  }) async {
    final textFields = find.byType(TextFormField);

    if (textFields.evaluate().isNotEmpty) {
      final fieldOrder = [
        'barcode',
        'name',
        'brands',
        'categories',
        'quantity',
        'ingredients',
        'energy',
        'fat',
        'carbs',
        'protein',
        'sodium',
        'fiber',
        'sugar',
        'allergens',
        'description',
        'tags',
      ];

      for (
        int i = 0;
        i < fieldOrder.length && i < textFields.evaluate().length;
        i++
      ) {
        final fieldName = fieldOrder[i];
        if (testData.containsKey(fieldName) &&
            testData[fieldName]!.isNotEmpty) {
          await tester.enterText(textFields.at(i), testData[fieldName]!);
          await tester.pumpAndSettle();
        }
      }
    }
  }

  /// AddProduct form submit butonuna tıklar
  static Future<void> submitAddProductForm(WidgetTester tester) async {
    final addButton = find.text('add_product.actions.add_product'.tr());
    if (addButton.evaluate().isNotEmpty) {
      await tester.tap(addButton, warnIfMissed: false);
      await tester.pumpAndSettle();
    }
  }

  /// AddProduct form alanlarının doğru değerleri içerdiğini kontrol eder
  static void verifyFormFields({required Map<String, String> expectedData}) {
    final fieldOrder = [
      'barcode',
      'name',
      'brands',
      'categories',
      'quantity',
      'ingredients',
      'energy',
      'fat',
      'carbs',
      'protein',
      'sodium',
      'fiber',
      'sugar',
      'allergens',
      'description',
      'tags',
    ];

    for (int i = 0; i < fieldOrder.length; i++) {
      final fieldName = fieldOrder[i];
      if (expectedData.containsKey(fieldName) &&
          expectedData[fieldName]!.isNotEmpty) {
        expect(find.text(expectedData[fieldName]!), findsOneWidget);
      }
    }
  }

  /// AddProduct form alanlarının boş olduğunu kontrol eder
  static void verifyFormFieldsEmpty(WidgetTester tester) {
    final textFields = find.byType(TextFormField);
    for (int i = 0; i < textFields.evaluate().length; i++) {
      final field = textFields.at(i);
      final fieldWidget = tester.widget<TextFormField>(field);
      expect(fieldWidget.controller?.text, isEmpty);
    }
  }

  /// AddProduct ekranının temel bileşenlerini kontrol eder
  static void verifyAddProductScreenComponents() {
    expect(find.byType(AddProductScreen), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  }

  /// AddProduct resim bölümünün bileşenlerini kontrol eder
  static void verifyImageSectionComponents() {
    expect(find.byType(ImageSection), findsOneWidget);
    expect(find.byType(ElevatedButton), findsAtLeastNWidgets(2));
    expect(find.byIcon(Icons.photo_library), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
  }

  /// AddProduct barkod bölümünün bileşenlerini kontrol eder
  static void verifyBarcodeSectionComponents() {
    expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
    expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
    expect(find.byType(IconButton), findsAtLeastNWidgets(1));
  }

  /// AddProduct form validasyon hatalarını kontrol eder
  static void verifyValidationErrors({required List<String> expectedErrors}) {
    for (final error in expectedErrors) {
      expect(find.text(error), findsOneWidget);
    }
  }

  /// AddProduct başarı mesajını kontrol eder
  static void verifySuccessMessage() {
    expect(
      find.text('add_product.validation.product_added_success'.tr()),
      findsOneWidget,
    );
  }

  /// AddProduct hata mesajını kontrol eder
  static void verifyErrorMessage(String expectedError) {
    expect(find.text(expectedError), findsOneWidget);
  }

  /// Firebase'i test ortamında başlat (daha basit versiyon)
  static Future<void> initializeFirebaseForTests() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Firebase Core mock setup - daha kapsamlı
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/firebase_core'),
          (MethodCall methodCall) async {
            switch (methodCall.method) {
              case 'Firebase#initializeCore':
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
              case 'Firebase#initializeApp':
                return {
                  'name': methodCall.arguments['appName'] ?? '[DEFAULT]',
                  'options':
                      methodCall.arguments['options'] ??
                      {
                        'apiKey': 'test-api-key',
                        'appId': 'test-app-id',
                        'messagingSenderId': 'test-sender-id',
                        'projectId': 'test-project-id',
                      },
                  'pluginConstants': <String, dynamic>{},
                };
              case 'Firebase#app':
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
              default:
                return null;
            }
          },
        );

    // Firebase'i gerçekten başlat
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'test-api-key',
          appId: 'test-app-id',
          messagingSenderId: 'test-sender-id',
          projectId: 'test-project-id',
        ),
      );
    } catch (e) {
      // Test ortamında hata olması normal, devam et
    }

    // Firebase Firestore mock setup
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/cloud_firestore'),
          (MethodCall methodCall) async {
            switch (methodCall.method) {
              case 'Firestore#enableNetwork':
              case 'Firestore#disableNetwork':
              case 'DocumentReference#set':
              case 'DocumentReference#update':
              case 'DocumentReference#delete':
                return null;
              case 'DocumentReference#get':
                return {
                  'data': <String, dynamic>{
                    'uid': 'test-uid',
                    'name': 'Test',
                    'surname': 'User',
                    'email': 'test@example.com',
                  },
                  'metadata': <String, dynamic>{
                    'hasPendingWrites': false,
                    'isFromCache': false,
                  },
                };
              case 'Query#get':
                return {
                  'documents': [],
                  'metadata': {'hasPendingWrites': false, 'isFromCache': false},
                };
              default:
                return null;
            }
          },
        );

    // Firebase Auth mock setup
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/firebase_auth'),
          (MethodCall methodCall) async {
            switch (methodCall.method) {
              case 'Auth#registerIdTokenListener':
              case 'Auth#registerAuthStateListener':
              case 'User#reload':
              case 'User#delete':
              case 'Auth#signOut':
                return null;
              case 'User#getIdToken':
                return 'mock-token';
              case 'Auth#signInWithEmailAndPassword':
                return {
                  'user': {
                    'uid': 'test-uid',
                    'email': 'test@example.com',
                    'displayName': 'Test User',
                  },
                  'additionalUserInfo': <String, dynamic>{},
                };
              case 'Auth#currentUser':
                return null;
              default:
                return null;
            }
          },
        );
  }

  /// Test için AppShellView widget'ı - mock screen'lerle
  static Widget createTestAppShellView({
    required Map<String, dynamic> mockViewModels,
  }) {
    return Consumer<AppShellViewModel>(
      builder: (context, vm, child) {
        final List<Widget> mockPages = [
          TestHelpers.createMockHomeScreen(),
          TestHelpers.createMockStoreScreen(),
          TestHelpers.createMockCartScreen(),
          TestHelpers.createMockProfileScreen(),
        ];

        return Scaffold(
          body: IndexedStack(index: vm.selectedIndex, children: mockPages),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: vm.selectedIndex,
            onTap: vm.onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store_outlined),
                activeIcon: Icon(Icons.store_rounded),
                label: 'Store',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                activeIcon: Icon(Icons.shopping_cart_rounded),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
