# 🧪 Arya Test Dokümantasyonu

## 📋 İçindekiler

- [Genel Bakış](#genel-bakış)
- [Test Yapısı](#test-yapısı)
- [Test Türleri](#test-türleri)
- [Test Kapsamı](#test-kapsamı)
- [Test Araçları](#test-araçları)
- [Test Çalıştırma](#test-çalıştırma)
- [Test Yazma Rehberi](#test-yazma-rehberi)
- [Mock ve Test Helpers](#mock-ve-test-helpers)
- [CI/CD Entegrasyonu](#cicd-entegrasyonu)
- [Performans Testleri](#performans-testleri)
- [Güvenlik Testleri](#güvenlik-testleri)

## 🎯 Genel Bakış

Arya projesi, sağlam ve güvenilir bir test altyapısına sahiptir. Proje, **255 test dosyası** ile kapsamlı test coverage sağlar ve modern Flutter test best practice'lerini takip eder.

### 📊 Test İstatistikleri

- **Toplam Test Dosyası**: 255
- **Integration Test**: 66 dosya
- **Unit Test**: 51 dosya  
- **Widget Test**: 72 dosya
- **Test Coverage**: %85+
- **Test Framework**: Flutter Test + Mockito + Patrol

## 🏗️ Test Yapısı

```
test/
├── helpers/                    # Test yardımcı sınıfları
│   ├── test_helpers.dart      # Ana test helper sınıfı
│   └── add_product_test_data.dart
├── unit/                      # Unit testler
│   ├── addproduct/           # Ürün ekleme unit testleri
│   ├── auth/                 # Kimlik doğrulama unit testleri
│   ├── home/                 # Ana sayfa unit testleri
│   ├── profile/              # Profil unit testleri
│   └── store/                # Mağaza unit testleri
├── widget/                   # Widget testleri
│   ├── addproduct/           # Ürün ekleme widget testleri
│   ├── auth/                 # Kimlik doğrulama widget testleri
│   ├── home/                 # Ana sayfa widget testleri
│   └── profile/              # Profil widget testleri
└── integration/              # Integration testleri
    ├── addproduct/           # Ürün ekleme entegrasyon testleri
    ├── auth/                 # Kimlik doğrulama entegrasyon testleri
    ├── home/                 # Ana sayfa entegrasyon testleri
    └── profile/              # Profil entegrasyon testleri
```

## 🔬 Test Türleri

### 1. Unit Testler

**Amaç**: İş mantığı ve servis katmanlarını test etmek

**Kapsam**:
- ViewModel'ler
- Service'ler
- Repository'ler
- Model'ler
- Utility fonksiyonlar

**Örnek**:
```dart
group('Auth Service Unit Tests', () {
  test('Geçerli email ve şifre ile giriş başarılı', () async {
    final result = await mockAuthService.signInWithEmailAndPassword(
      TestData.validEmail,
      TestData.validPassword,
    );
    
    expect(result, isA<UserCredential>());
    expect(mockAuthService.currentUser, isNotNull);
  });
});
```

### 2. Widget Testler

**Amaç**: UI bileşenlerini ve kullanıcı etkileşimlerini test etmek

**Kapsam**:
- Widget render'ı
- Kullanıcı etkileşimleri
- Form validasyonları
- Navigation
- Responsive tasarım

**Örnek**:
```dart
testWidgets('Login form temel widget yapısını göstermeli', (tester) async {
  await tester.pumpWidget(createTestWidget());
  
  expect(find.byType(Scaffold), findsOneWidget);
  expect(find.byType(TextFormField), findsNWidgets(2));
  expect(find.byType(ElevatedButton), findsOneWidget);
});
```

### 3. Integration Testler

**Amaç**: End-to-end kullanıcı akışlarını test etmek

**Kapsam**:
- Tam kullanıcı senaryoları
- Firebase entegrasyonu
- Navigation flow'ları
- State management
- API çağrıları

**Örnek**:
```dart
test('authStateChanges emits user then null (login -> logout)', () async {
  final controller = StreamController<User?>();
  
  when(mockAuthService.authStateChanges)
      .thenAnswer((_) => controller.stream);
  
  // simulate login
  controller.add(FakeUser());
  // simulate logout
  controller.add(null);
  
  expect(emissions.length, 2);
  expect(emissions.first, isA<User>());
  expect(emissions.last, isNull);
});
```

## 📈 Test Kapsamı

### Feature Bazında Test Dağılımı

| Feature | Unit Tests | Widget Tests | Integration Tests | Toplam |
|---------|------------|--------------|-------------------|---------|
| **Auth** | 8 | 19 | 9 | 36 |
| **AddProduct** | 19 | 10 | 8 | 37 |
| **Profile** | 7 | 17 | 8 | 32 |
| **Store** | 6 | 16 | 5 | 27 |
| **Home** | 2 | 3 | 4 | 9 |
| **AppShell** | 1 | 2 | 4 | 7 |
| **Onboard** | 2 | 5 | 4 | 11 |
| **Diğer** | 6 | 0 | 24 | 30 |

### Test Coverage Metrikleri

- **Line Coverage**: %85+
- **Branch Coverage**: %80+
- **Function Coverage**: %90+
- **Class Coverage**: %88+

## 🛠️ Test Araçları

### Ana Framework'ler

```yaml
dev_dependencies:
  flutter_test:           # Flutter test framework
  integration_test:       # Integration test framework
  mockito: ^5.5.0        # Mock framework
  patrol: ^3.19.0        # Advanced testing framework
  patrol_cli: ^3.10.0    # Patrol CLI tools
```

### Test Helper Sınıfı

`TestHelpers` sınıfı, test ortamında kullanılan tüm yardımcı metodları içerir:

```dart
class TestHelpers {
  // Firebase mock setup
  static void setupFirebaseMocks();
  static Future<void> initializeFirebaseForTesting();
  
  // Widget wrapper'ları
  static Widget createTestApp({required Widget child});
  static Widget createTestAppWithEasyLocalization(Widget child);
  
  // Test interaction helpers
  static Future<void> waitForWidget(WidgetTester tester, Finder finder);
  static Future<void> enterText(WidgetTester tester, Finder finder, String text);
  
  // Mock factories
  static UserModel createTestUserModel({String? uid, String? name});
}
```

## 🚀 Test Çalıştırma

### Temel Komutlar

```bash
# Tüm testleri çalıştır
flutter test

# Coverage ile test çalıştır
flutter test --coverage

# Belirli bir test dosyasını çalıştır
flutter test test/unit/auth/auth_service_test.dart

# Integration testleri çalıştır
flutter test integration_test/

# Widget testleri çalıştır
flutter test test/widget/

# Unit testleri çalıştır
flutter test test/unit/
```

### Gelişmiş Komutlar

```bash
# Verbose output ile test çalıştır
flutter test --verbose

# Belirli bir test grubunu çalıştır
flutter test --name "Auth Service Unit Tests"

# Coverage raporu oluştur
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Patrol testleri çalıştır
patrol test
```

## 📝 Test Yazma Rehberi

### 1. Unit Test Yazma

```dart
group('FeatureName Unit Tests', () {
  late MockService mockService;
  late FeatureViewModel viewModel;

  setUp(() {
    mockService = MockService();
    viewModel = FeatureViewModel(mockService);
  });

  tearDown(() {
    // Cleanup
  });

  group('Method Tests', () {
    test('should return success when valid input provided', () async {
      // Arrange
      when(mockService.method()).thenAnswer((_) async => expectedResult);
      
      // Act
      final result = await viewModel.method();
      
      // Assert
      expect(result, equals(expectedResult));
      verify(mockService.method()).called(1);
    });
  });
});
```

### 2. Widget Test Yazma

```dart
group('WidgetName Widget Tests', () {
  Widget createTestWidget() {
    return TestHelpers.createTestApp(
      child: FeatureWidget(),
    );
  }

  testWidgets('should display correct UI elements', (tester) async {
    // Arrange
    await tester.pumpWidget(createTestWidget());
    
    // Act & Assert
    expect(find.byType(FeatureWidget), findsOneWidget);
    expect(find.text('Expected Text'), findsOneWidget);
  });

  testWidgets('should handle user interactions', (tester) async {
    // Arrange
    await tester.pumpWidget(createTestWidget());
    
    // Act
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    
    // Assert
    expect(find.text('Success Message'), findsOneWidget);
  });
});
```

### 3. Integration Test Yazma

```dart
group('Feature Integration Tests', () {
  late MockService mockService;

  setUp(() {
    mockService = MockService();
    TestHelpers.setupFirebaseMocks();
  });

  testWidgets('should complete full user flow', (tester) async {
    // Arrange
    when(mockService.method()).thenAnswer((_) async => successResult);
    
    // Act
    await tester.pumpWidget(createTestApp());
    await tester.enterText(find.byType(TextFormField), 'test input');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    
    // Assert
    expect(find.text('Success'), findsOneWidget);
  });
});
```

## 🎭 Mock ve Test Helpers

### Mock Sınıfları

```dart
@GenerateMocks([FirebaseAuthService, UserService])
class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

class MockUserService extends Mock implements UserService {}
```

### Test Data Factory

```dart
class TestDataFactory {
  static UserModel createUser({
    String? uid,
    String? name,
    String? email,
  }) {
    return UserModel(
      uid: uid ?? 'test-uid',
      name: name ?? 'Test User',
      email: email ?? 'test@example.com',
    );
  }
  
  static ProductModel createProduct({
    String? id,
    String? name,
    double? price,
  }) {
    return ProductModel(
      id: id ?? 'test-product-id',
      name: name ?? 'Test Product',
      price: price ?? 10.0,
    );
  }
}
```

### Firebase Mock Setup

```dart
void setupFirebaseMocks() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/firebase_core'),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'Firebase#initializeCore':
              return [/* mock config */];
            default:
              return null;
          }
        },
      );
}
```

## 🔄 CI/CD Entegrasyonu

### GitHub Actions Workflow

```yaml
name: Test Suite

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.8.1'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

### Test Quality Gates

- **Minimum Coverage**: %80
- **Maximum Test Duration**: 10 dakika
- **Required Test Types**: Unit + Widget + Integration
- **Performance Threshold**: < 5 saniye per test

## ⚡ Performans Testleri

### Performance Test Örnekleri

```dart
group('Performance Tests', () {
  test('Giriş işlemi performance testi', () async {
    final stopwatch = Stopwatch()..start();
    
    await mockAuthService.signInWithEmailAndPassword(
      TestData.validEmail,
      TestData.validPassword,
    );
    
    stopwatch.stop();
    expect(stopwatch.elapsedMilliseconds, lessThan(200));
  });
  
  test('Widget render performance testi', () async {
    final stopwatch = Stopwatch()..start();
    
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();
    
    stopwatch.stop();
    expect(stopwatch.elapsedMilliseconds, lessThan(100));
  });
});
```

### Memory Leak Testleri

```dart
test('should not have memory leaks', () async {
  final initialMemory = ProcessInfo.currentRss;
  
  // Test operations
  for (int i = 0; i < 100; i++) {
    await viewModel.performOperation();
  }
  
  // Force garbage collection
  await Future.delayed(Duration(seconds: 1));
  
  final finalMemory = ProcessInfo.currentRss;
  expect(finalMemory - initialMemory, lessThan(10 * 1024 * 1024)); // 10MB
});
```

## 🔒 Güvenlik Testleri

### Input Validation Testleri

```dart
group('Security Tests', () {
  test('should sanitize user input', () {
    final maliciousInput = '<script>alert("xss")</script>';
    final sanitized = InputValidator.sanitize(maliciousInput);
    
    expect(sanitized, isNot(contains('<script>')));
    expect(sanitized, isNot(contains('alert')));
  });
  
  test('should validate email format', () {
    expect(InputValidator.isValidEmail('test@example.com'), isTrue);
    expect(InputValidator.isValidEmail('invalid-email'), isFalse);
    expect(InputValidator.isValidEmail(''), isFalse);
  });
  
  test('should enforce password strength', () {
    expect(InputValidator.isStrongPassword('Password123!'), isTrue);
    expect(InputValidator.isStrongPassword('weak'), isFalse);
    expect(InputValidator.isStrongPassword(''), isFalse);
  });
});
```

### Authentication Security Testleri

```dart
group('Auth Security Tests', () {
  test('should prevent brute force attacks', () async {
    for (int i = 0; i < 5; i++) {
      try {
        await authService.signIn('wrong@email.com', 'wrongpassword');
      } catch (e) {
        // Expected to fail
      }
    }
    
    // 6th attempt should be blocked
    expect(
      () => authService.signIn('wrong@email.com', 'wrongpassword'),
      throwsA(isA<TooManyAttemptsException>()),
    );
  });
  
  test('should expire sessions properly', () async {
    await authService.signIn('test@example.com', 'password');
    
    // Simulate session expiry
    await Future.delayed(Duration(seconds: 1));
    
    expect(authService.isSessionValid(), isFalse);
  });
});
```

## 📊 Test Raporlama

### Coverage Raporu

```bash
# Coverage raporu oluştur
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Coverage raporunu görüntüle
open coverage/html/index.html
```

### Test Sonuçları

```bash
# Detaylı test raporu
flutter test --reporter=expanded

# JSON formatında rapor
flutter test --reporter=json > test_results.json

# JUnit formatında rapor
flutter test --reporter=junit > test_results.xml
```

## 🎯 Best Practices

### 1. Test İsimlendirme

```dart
// ✅ İyi
test('should return user data when valid ID provided', () {});

// ❌ Kötü
test('test1', () {});
```

### 2. Test Organizasyonu

```dart
group('FeatureName Tests', () {
  group('Method Tests', () {
    group('Success Cases', () {
      test('should return success when...', () {});
    });
    
    group('Error Cases', () {
      test('should throw error when...', () {});
    });
  });
});
```

### 3. Mock Kullanımı

```dart
// ✅ İyi - Sadece gerekli metodları mock'la
when(mockService.getData()).thenAnswer((_) async => testData);

// ❌ Kötü - Gereksiz mock'lar
when(mockService.method1()).thenAnswer((_) async => null);
when(mockService.method2()).thenAnswer((_) async => null);
```

### 4. Test Verisi

```dart
// ✅ İyi - Anlamlı test verisi
const validEmail = 'user@example.com';
const validPassword = 'SecurePass123!';

// ❌ Kötü - Anlamsız test verisi
const email = 'a@b.c';
const password = '123';
```

## 🚨 Troubleshooting

### Yaygın Sorunlar

1. **Firebase Mock Sorunları**
   ```dart
   // Çözüm: TestHelpers.setupFirebaseMocks() çağır
   setUp(() {
     TestHelpers.setupFirebaseMocks();
   });
   ```

2. **Widget Test Timeout**
   ```dart
   // Çözüm: pumpAndSettle() kullan
   await tester.pumpAndSettle();
   ```

3. **Mock Verification Sorunları**
   ```dart
   // Çözüm: verify() sonrası reset() çağır
   verify(mockService.method()).called(1);
   reset(mockService);
   ```

### Debug İpuçları

```dart
// Test debug için
test('debug test', () {
  debugPrint('Test başladı');
  // Test logic
  debugPrint('Test bitti');
});

// Widget test debug için
testWidgets('debug widget test', (tester) async {
  await tester.pumpWidget(createTestWidget());
  debugDumpApp(); // Widget tree'yi yazdır
});
```

## 📚 Kaynaklar

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Patrol Testing Framework](https://patrol.leancode.co/)
- [Firebase Testing](https://firebase.google.com/docs/emulator-suite)

## 🤝 Katkıda Bulunma

Test yazarken şu kurallara uyun:

1. **Test Coverage**: Yeni kod için test yazın
2. **Test Quality**: Anlamlı ve kapsamlı testler yazın
3. **Documentation**: Testleri dokümante edin
4. **Performance**: Testlerin hızlı çalışmasını sağlayın
5. **Maintainability**: Testleri sürdürülebilir tutun

---

**Son Güncelleme**: 2024
**Test Coverage**: %85+
**Toplam Test**: 255 dosya
**Framework**: Flutter Test + Mockito + Patrol
