# 🛒 Arya - Modern Flutter Grocery Shopping App

[![Flutter](https://img.shields.io/badge/Flutter-3.35.3-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg)](https://github.com/yourusername/arya)
[![Coverage](https://img.shields.io/badge/Coverage-85%25-brightgreen.svg)](https://github.com/yourusername/arya)

> **Arya**, temiz mimari prensipleri ile geliştirilmiş modern bir Flutter market alışveriş uygulamasıdır. Firebase entegrasyonu, çoklu dil desteği ve kapsamlı test coverage ile profesyonel bir alışveriş deneyimi sunar.

## 📋 İçindekiler

- [🎯 Özellikler](#-özellikler)
- [🏛️ Mimari ve Tasarım Desenleri](#️-mimari-ve-tasarım-desenleri)
- [🛠️ Teknoloji Stack'i](#️-teknoloji-stacki)
- [🧹 Temiz Kod Prensipleri](#-temiz-kod-prensipleri)
- [📱 Kullanım](#-kullanım)
- [🧪 Test](#-test)
- [🔒 Güvenlik](#-güvenlik)
- [🌍 Çoklu Dil Desteği](#-çoklu-dil-desteği)
- [📦 Bağımlılıklar](#-bağımlılıklar)
- [🤝 Katkıda Bulunma](#-katkıda-bulunma)
- [📄 Lisans](#-lisans)

## 🎯 Özellikler

### 🔐 Kimlik Doğrulama Sistemi
- **Güvenli Giriş/Çıkış**: Email ve şifre ile kimlik doğrulama
- **Kullanıcı Kaydı**: Yeni hesap oluşturma
- **Şifre Sıfırlama**: Güvenli şifre kurtarma
- **Token Yönetimi**: JWT tabanlı güvenli oturum yönetimi
- **Rate Limiting**: Güvenlik için istek sınırlandırma

### 🛍️ Ürün Yönetimi
- **Ürün Ekleme**: Resim ve detaylarla yeni ürün ekleme
- **Ürün Düzenleme**: Mevcut ürünleri güncelleme
- **Kategori Sistemi**: Ürünleri kategorilere göre organize etme
- **QR Kod Tarama**: Ürün bilgilerini QR kod ile alma
- **Open Food Facts Entegrasyonu**: Gerçek ürün verileri
- **Arama ve Filtreleme**: Gelişmiş ürün arama özellikleri

### 🛒 Alışveriş Sepeti
- **Sepet Yönetimi**: Ürün ekleme/çıkarma
- **Miktar Kontrolü**: Ürün miktarlarını ayarlama
- **Fiyat Hesaplama**: Otomatik toplam hesaplama
- **Sipariş Özeti**: Detaylı sipariş bilgileri
- **Persistent Storage**: Sepet verilerinin kalıcı saklanması

### 🏠 Ana Sayfa ve Navigasyon
- **Dashboard**: Kategorilere göre ürün görüntüleme
- **Bottom Navigation**: Kolay sayfa geçişleri
- **Responsive Tasarım**: Tüm ekran boyutlarında uyumlu
- **Dark/Light Theme**: Kullanıcı tercihine göre tema

### 👤 Profil Yönetimi
- **Kullanıcı Profili**: Kişisel bilgi yönetimi
- **Hesap Ayarları**: Güvenlik ve gizlilik ayarları
- **Hesap Silme**: Güvenli hesap kapatma
- **Çıkış Yapma**: Güvenli oturum sonlandırma

## 🏛️ Mimari ve Tasarım Desenleri

### 🎨 Clean Architecture Implementation

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   Widgets   │  │   Views     │  │ ViewModels  │        │
│  │             │  │             │  │             │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   Models    │  │ Use Cases   │  │ Repositories│        │
│  │             │  │             │  │ (Interfaces)│        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │ Repositories│  │  Services   │  │ Data Sources│        │
│  │(Implementation)│             │  │             │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

### 🔄 Tasarım Desenleri

#### 1. **Repository Pattern**
```dart
abstract class IProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}

class ProductRepository implements IProductRepository {
  final IProductService _productService;
  final ILocalStorage _localStorage;
  
  ProductRepository(this._productService, this._localStorage);
  
  @override
  Future<List<Product>> getProducts() async {
    try {
      final products = await _productService.fetchProducts();
      await _localStorage.cacheProducts(products);
      return products;
    } catch (e) {
      return await _localStorage.getCachedProducts();
    }
  }
}
```

#### 2. **Dependency Injection**
```dart
class AppRouter {
  static final _instance = AppRouter._internal();
  factory AppRouter() => _instance;
  AppRouter._internal();

  late final GoRouter _router;

  GoRouter get router => _router;

  void initialize() {
    _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeView(),
        ),
        // ... diğer route'lar
      ],
    );
  }
}
```

#### 3. **State Management (Provider Pattern)**
```dart
class ProductViewModel extends ChangeNotifier {
  final IProductRepository _repository;
  
  ProductViewModel(this._repository);
  
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _products = await _repository.getProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### 🏗️ Proje Yapısı Detayı

```
lib/
├── features/                          # Feature-based architecture
│   ├── auth/                         # Authentication feature
│   │   ├── model/                    # Data models
│   │   │   ├── user_model.dart       # User entity
│   │   │   └── auth_state.dart       # Authentication state
│   │   ├── view/                     # UI components
│   │   │   ├── login_view.dart       # Login screen
│   │   │   ├── register_view.dart    # Register screen
│   │   │   └── widgets/              # Feature-specific widgets
│   │   ├── view_model/               # Business logic
│   │   │   ├── auth_view_model.dart  # Auth state management
│   │   │   └── login_view_model.dart # Login logic
│   │   └── service/                  # API services
│   │       ├── auth_service.dart     # Authentication API
│   │       └── user_service.dart     # User management API
│   ├── home/                         # Home feature
│   ├── store/                        # Shopping store feature
│   ├── profile/                      # User profile feature
│   ├── addproduct/                   # Product management feature
│   ├── onboard/                      # Onboarding feature
│   └── appshell/                     # App shell (navigation)
├── product/                          # Shared resources
│   ├── constants/                    # App constants
│   │   ├── app_constants.dart        # General constants
│   │   ├── api_constants.dart        # API endpoints
│   │   └── theme_constants.dart      # Theme constants
│   ├── theme/                        # Theming system
│   │   ├── app_theme.dart            # Main theme
│   │   ├── light_theme.dart          # Light theme
│   │   ├── dark_theme.dart           # Dark theme
│   │   └── text_theme.dart           # Typography
│   ├── navigation/                   # Navigation system
│   │   ├── app_router.dart           # Main router
│   │   └── route_names.dart          # Route constants
│   ├── utility/                      # Utility functions
│   │   ├── validators.dart           # Input validation
│   │   ├── extensions.dart           # Dart extensions
│   │   ├── helpers.dart              # Helper functions
│   │   └── constants.dart            # Utility constants
│   ├── widget/                       # Reusable widgets
│   │   ├── custom_button.dart        # Custom button widget
│   │   ├── loading_widget.dart       # Loading indicator
│   │   └── error_widget.dart         # Error display widget
│   └── init/                         # App initialization
│       ├── app_initialize.dart       # App startup logic
│       └── dependency_injection.dart # DI setup
└── main.dart                         # App entry point
```

## 🛠️ Teknoloji Stack'i

### 🎯 Ana Teknolojiler

| Kategori | Teknoloji | Versiyon | Amaç |
|----------|-----------|----------|------|
| **Framework** | Flutter | 3.35.3 | Cross-platform UI framework |
| **Language** | Dart | 3.9.2 | Modern, type-safe programming language |
| **Backend** | Firebase | Latest | Authentication, Database, Storage |
| **State Management** | Provider | 6.1.5 | Reactive state management |
| **Navigation** | Auto Route | 10.1.2 | Type-safe routing with code generation |
| **HTTP Client** | Dio | 5.9.0 | Powerful HTTP client for API calls |
| **Localization** | Easy Localization | 3.0.8 | Multi-language support |
| **QR Scanner** | Mobile Scanner | 7.0.1 | QR/Barcode scanning capabilities |
| **Image Handling** | Image Picker | 1.2.0 | Image selection and capture |
| **Animations** | Lottie | 3.3.1 | High-quality animations |
| **Shimmer Effect** | Shimmer | 3.0.0 | Loading skeleton animations |
| **Testing** | Flutter Test + Mockito | Latest | Unit, Widget, Integration testing |

### 🔧 Geliştirme Araçları

- **Code Generation**: `build_runner` - Otomatik kod üretimi
- **Linting**: `flutter_lints` - Kod kalitesi kontrolü
- **Testing**: `patrol` - Integration test framework
- **Asset Management**: `assets_cleaner` - Kullanılmayan asset temizliği

### 📱 Platform Desteği

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11+)
- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **Desktop** (Windows, macOS, Linux)

## 🧹 Temiz Kod Prensipleri

### 📋 SOLID Prensipleri

#### 1. **Single Responsibility Principle (SRP)**
```dart
// ✅ Her sınıf tek bir sorumluluğa sahip
class UserValidator {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class UserRepository {
  Future<User> getUser(String id) async {
    // Sadece kullanıcı verisi getirme sorumluluğu
  }
}
```

#### 2. **Open/Closed Principle (OCP)**
```dart
// ✅ Genişletmeye açık, değişikliğe kapalı
abstract class PaymentMethod {
  Future<bool> processPayment(double amount);
}

class CreditCardPayment implements PaymentMethod {
  @override
  Future<bool> processPayment(double amount) async {
    // Credit card payment logic
  }
}

class PayPalPayment implements PaymentMethod {
  @override
  Future<bool> processPayment(double amount) async {
    // PayPal payment logic
  }
}
```

#### 3. **Dependency Inversion Principle (DIP)**
```dart
// ✅ Soyutlamalara bağımlı, somutlamalara değil
abstract class IStorageService {
  Future<void> save(String key, String value);
  Future<String?> get(String key);
}

class ProductService {
  final IStorageService _storage;
  
  ProductService(this._storage); // Dependency injection
  
  Future<void> saveProduct(Product product) async {
    await _storage.save('product_${product.id}', product.toJson());
  }
}
```

### 🎯 Clean Code Practices

#### 1. **Meaningful Names**
```dart
// ✅ Anlamlı isimler
class ShoppingCartManager {
  final List<CartItem> _items = [];
  
  void addItemToCart(Product product, int quantity) {
    // Implementation
  }
  
  double calculateTotalPrice() {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}

// ❌ Kötü isimlendirme
class SCM {
  final List<CI> _i = [];
  
  void add(Product p, int q) {
    // Implementation
  }
}
```

#### 2. **Small Functions**
```dart
// ✅ Küçük, odaklanmış fonksiyonlar
class ProductValidator {
  static ValidationResult validateProduct(Product product) {
    final nameValidation = _validateName(product.name);
    if (!nameValidation.isValid) return nameValidation;
    
    final priceValidation = _validatePrice(product.price);
    if (!priceValidation.isValid) return priceValidation;
    
    return ValidationResult.valid();
  }
  
  static ValidationResult _validateName(String name) {
    if (name.isEmpty) {
      return ValidationResult.invalid('Product name cannot be empty');
    }
    if (name.length < 3) {
      return ValidationResult.invalid('Product name must be at least 3 characters');
    }
    return ValidationResult.valid();
  }
  
  static ValidationResult _validatePrice(double price) {
    if (price <= 0) {
      return ValidationResult.invalid('Price must be greater than 0');
    }
    return ValidationResult.valid();
  }
}
```

#### 3. **Error Handling**
```dart
// ✅ Kapsamlı hata yönetimi
class ProductRepository {
  Future<Result<List<Product>, AppError>> getProducts() async {
    try {
      final products = await _apiService.fetchProducts();
      return Result.success(products);
    } on NetworkException catch (e) {
      return Result.failure(AppError.network(e.message));
    } on ServerException catch (e) {
      return Result.failure(AppError.server(e.message));
    } catch (e) {
      return Result.failure(AppError.unknown(e.toString()));
    }
  }
}

// Result pattern for type-safe error handling
sealed class Result<T, E> {
  const Result();
}

class Success<T, E> extends Result<T, E> {
  final T data;
  const Success(this.data);
}

class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure(this.error);
}
```

### 🧪 Test-Driven Development (TDD)

#### 1. **Unit Test Example**
```dart
void main() {
  group('ProductValidator', () {
    test('should return valid for correct product data', () {
      // Arrange
      final product = Product(
        name: 'Test Product',
        price: 10.0,
        category: 'Food',
      );
      
      // Act
      final result = ProductValidator.validateProduct(product);
      
      // Assert
      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });
    
    test('should return invalid for empty product name', () {
      // Arrange
      final product = Product(
        name: '',
        price: 10.0,
        category: 'Food',
      );
      
      // Act
      final result = ProductValidator.validateProduct(product);
      
      // Assert
      expect(result.isValid, isFalse);
      expect(result.errors, contains('Product name cannot be empty'));
    });
  });
}
```

#### 2. **Integration Test Example**
```dart
void main() {
  group('Product Flow Integration Tests', () {
    late MockProductService mockProductService;
    late ProductViewModel productViewModel;
    
    setUp(() {
      mockProductService = MockProductService();
      productViewModel = ProductViewModel(mockProductService);
    });
    
    testWidgets('should display products when loaded successfully', (tester) async {
      // Arrange
      when(mockProductService.getProducts())
          .thenAnswer((_) async => [Product(name: 'Test Product', price: 10.0)]);
      
      // Act
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => productViewModel,
          child: MaterialApp(home: ProductListView()),
        ),
      );
      
      await productViewModel.loadProducts();
      await tester.pump();
      
      // Assert
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('\$10.0'), findsOneWidget);
    });
  });
}
```

### 📊 Code Quality Metrics

- **Test Coverage**: %85+ (Unit + Widget + Integration)
- **Total Test Files**: 256 test files
- **Source Files**: 192 Dart files
- **Code Complexity**: Cyclomatic complexity < 10
- **Function Length**: Average < 20 lines
- **Class Length**: Average < 200 lines
- **Naming Convention**: Consistent camelCase/PascalCase
- **Documentation**: All public APIs documented

## 📱 Kullanım

### 🎯 Temel Kullanım Akışı

1. **Kayıt Ol/Giriş Yap**: Email ve şifre ile hesap oluşturun
2. **Ürünleri Keşfedin**: Ana sayfada kategorilere göre ürünleri görüntüleyin
3. **Ürün Arayın**: QR kod tarayarak veya manuel arama yaparak ürün bulun
4. **Sepete Ekleyin**: Beğendiğiniz ürünleri sepetinize ekleyin
5. **Sipariş Verin**: Sepetinizi kontrol edip siparişinizi tamamlayın

### 🔍 Gelişmiş Özellikler

- **QR Kod Tarama**: Ürün barkodlarını tarayarak bilgi alın
- **Çoklu Dil**: Türkçe ve İngilizce arasında geçiş yapın
- **Dark Mode**: Karanlık tema ile göz yorgunluğunu azaltın
- **Offline Desteği**: İnternet bağlantısı olmadan da temel özellikleri kullanın

## 🧪 Test

Proje kapsamlı test coverage'a sahiptir:

### Test Türleri

- **Unit Tests**: İş mantığı testleri
- **Widget Tests**: UI bileşen testleri  
- **Integration Tests**: End-to-end akış testleri

### Test Çalıştırma

```bash
# Tüm testleri çalıştır
flutter test

# Belirli test dosyasını çalıştır
flutter test test/unit/auth/auth_test.dart

# Integration testleri çalıştır
flutter test integration_test/

# Coverage ile test çalıştır
flutter test --coverage
```

### Test Coverage

- **Total Test Files**: 256 test files
- **Unit Tests**: %85+ coverage
- **Widget Tests**: %80+ coverage
- **Integration Tests**: Ana akışlar %90+ coverage
- **Test Types**: Unit, Widget, Integration, and Patrol tests

## 🔒 Güvenlik

Uygulama güvenlik best practices'lerine uygun olarak geliştirilmiştir:

### Güvenlik Özellikleri

- **Input Validation**: Tüm kullanıcı girdileri doğrulanır
- **Rate Limiting**: API istekleri sınırlandırılır
- **XSS Koruması**: Malicious script injection'ları engellenir
- **SQL Injection Koruması**: Veritabanı güvenliği sağlanır
- **Secure Storage**: Hassas veriler güvenli şekilde saklanır

Detaylı güvenlik bilgileri için [SECURITY_IMPROVEMENTS.md](SECURITY_IMPROVEMENTS.md) dosyasını inceleyin.

## 🌍 Çoklu Dil Desteği

Uygulama 2 dilde tam destek sunar:

- 🇹🇷 **Türkçe** (Varsayılan)
- 🇬🇧 **English**

### Dil Değiştirme

```dart
// Programatik dil değiştirme
context.setLocale(Locale('en', 'US')); // İngilizce
context.setLocale(Locale('tr', 'TR')); // Türkçe
```

## 📦 Bağımlılıklar

### Ana Bağımlılıklar

```yaml
# Firebase
firebase_core: ^4.1.0
firebase_auth: ^6.0.0
cloud_firestore: ^6.0.0

# State Management
provider: ^6.1.5

# HTTP & API
dio: ^5.9.0
openfoodfacts: ^3.24.0

# Navigation
auto_route: ^10.1.2

# Localization
easy_localization: ^3.0.8
localization: ^2.1.1

# UI & Animations
lottie: ^3.3.1
shimmer: ^3.0.0

# Utilities
shared_preferences: ^2.5.3
image_picker: ^1.2.0
mobile_scanner: ^7.0.1
url_launcher: ^6.3.2
collection: ^1.19.1

# Asset Management
assets_cleaner: ^0.1.5+12
```

### Geliştirme Bağımlılıkları

```yaml
# Testing
flutter_test: sdk
integration_test: sdk
mockito: ^5.5.0
patrol: ^3.19.0

# Code Generation
build_runner: ^2.7.1
auto_route_generator: ^10.0.2

# Linting
flutter_lints: ^6.0.0
```

## 🤝 Katkıda Bulunma

Katkılarınızı bekliyoruz! Detaylı bilgi için [CONTRIBUTING.md](CONTRIBUTING.md) dosyasını inceleyin.

### Katkı Süreci

1. **Fork** yapın
2. **Feature branch** oluşturun (`git checkout -b feature/AmazingFeature`)
3. **Commit** yapın (`git commit -m 'Add some AmazingFeature'`)
4. **Push** yapın (`git push origin feature/AmazingFeature`)
5. **Pull Request** açın

### Kod Standartları

- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) takip edilir
- Conventional commits kullanılır
- Test coverage %80'in altına düşmemelidir
- Tüm PR'lar review edilmelidir

## 📄 Lisans

Bu proje MIT Lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasını inceleyin.

## 🙏 Teşekkürler

- **Flutter Team** - Harika framework için
- **Firebase Team** - Backend servisleri için
- **Open Food Facts** - Ürün veritabanı için
- **Community Contributors** - Katkıları için

## 📞 İletişim

- **GitHub Issues**: [Issues](https://github.com/yourusername/arya/issues)
- **Discussions**: [Discussions](https://github.com/yourusername/arya/discussions)

---

<div align="center">

⭐ **Bu repository'yi faydalı bulduysanız yıldızlamayı unutmayın!**

Made with ❤️ by [Your Name](https://github.com/yourusername)

</div>
