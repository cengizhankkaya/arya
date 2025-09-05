import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arya/features/index.dart';

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

  /// Firebase mock setup'ı
  static void setupFirebaseMocks() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Firebase Core mock setup
    setupFirebaseCoreMocks();
    setupFirebaseAuthMocks();
    setupFirebaseFirestoreMocks();
  }

  /// Firebase'i test ortamında başlat
  static Future<void> initializeFirebaseForTesting() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupComprehensiveFirebaseMocks();

    // Firebase Core mock setup - daha kapsamlı
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
    final appColors = _createDefaultAppColors();
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      extensions: <ThemeExtension<dynamic>>[appColors],
    );
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
}
