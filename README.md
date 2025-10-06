# 🛒 Arya - Modern Flutter Grocery Shopping App

[![Flutter](https://img.shields.io/badge/Flutter-3.35.3-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg)](https://github.com/yourusername/arya)
[![Coverage](https://img.shields.io/badge/Coverage-85%25-brightgreen.svg)](https://github.com/yourusername/arya)

[![Get it on Google Play](https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png)](https://play.google.com/store/apps/details?id=com.cngz.arya)

Uygulamayı Google Play'den indirin: https://play.google.com/store/apps/details?id=com.cngz.arya

> **Arya** is a modern Flutter grocery shopping app developed with clean architecture principles. It provides a professional shopping experience with Firebase integration, multi-language support, and comprehensive test coverage.

## 📋 Table of Contents

- [🎯 Features](#-features)
- [🏛️ Architecture and Design Patterns](#️-architecture-and-design-patterns)
- [🛠️ Technology Stack](#️-technology-stack)
- [🧹 Clean Code Principles](#-clean-code-principles)
- [📱 Usage](#-usage)
- [🧪 Testing](#-testing)
- [🔒 Security](#-security)
- [🌍 Multi-language Support](#-multi-language-support)
- [📦 Dependencies](#-dependencies)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## 🎯 Features

### 🔐 Authentication System
- **Secure Login/Logout**: Email and password authentication
- **User Registration**: New account creation
- **Password Reset**: Secure password recovery
- **Token Management**: JWT-based secure session management
- **Rate Limiting**: Request throttling for security

### 🛍️ Product Management
- **Product Addition**: Adding new products with images and details
- **Product Editing**: Updating existing products
- **Category System**: Organizing products by categories
- **QR Code Scanning**: Getting product information via QR code
- **Open Food Facts Integration**: Real product data
- **Search and Filtering**: Advanced product search features

### 🛒 Shopping Cart
- **Cart Management**: Adding/removing products
- **Quantity Control**: Adjusting product quantities
- **Price Calculation**: Automatic total calculation
- **Order Summary**: Detailed order information
- **Persistent Storage**: Persistent cart data storage

### 🏠 Home Page and Navigation
- **Dashboard**: Product display by categories
- **Bottom Navigation**: Easy page transitions
- **Responsive Design**: Compatible with all screen sizes
- **Dark/Light Theme**: Theme based on user preference

### 👤 Profile Management
- **User Profile**: Personal information management
- **Account Settings**: Security and privacy settings
- **Account Deletion**: Secure account closure
- **Logout**: Secure session termination

## 🏛️ Architecture and Design Patterns

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

### 🔄 Design Patterns

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
        // ... other routes
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

### 🏗️ Project Structure Details

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

## 🛠️ Technology Stack

### 🎯 Core Technologies

| Category | Technology | Version | Purpose |
|----------|------------|---------|---------|
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

### 🔧 Development Tools

- **Code Generation**: `build_runner` - Automatic code generation
- **Linting**: `flutter_lints` - Code quality control
- **Testing**: `patrol` - Integration test framework
- **Asset Management**: `assets_cleaner` - Unused asset cleanup

### 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11+)
- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **Desktop** (Windows, macOS, Linux)

## 🧹 Clean Code Principles

### 📋 SOLID Principles

#### 1. **Single Responsibility Principle (SRP)**
```dart
// ✅ Each class has a single responsibility
class UserValidator {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class UserRepository {
  Future<User> getUser(String id) async {
    // Only responsible for fetching user data
  }
}
```

#### 2. **Open/Closed Principle (OCP)**
```dart
// ✅ Open for extension, closed for modification
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
// ✅ Depends on abstractions, not concretions
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
// ✅ Meaningful names
class ShoppingCartManager {
  final List<CartItem> _items = [];
  
  void addItemToCart(Product product, int quantity) {
    // Implementation
  }
  
  double calculateTotalPrice() {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}

// ❌ Bad naming
class SCM {
  final List<CI> _i = [];
  
  void add(Product p, int q) {
    // Implementation
  }
}
```

#### 2. **Small Functions**
```dart
// ✅ Small, focused functions
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
// ✅ Comprehensive error handling
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

- **Test Coverage**: 85%+ (Unit + Widget + Integration)
- **Total Test Files**: 256 test files
- **Source Files**: 192 Dart files
- **Code Complexity**: Cyclomatic complexity < 10
- **Function Length**: Average < 20 lines
- **Class Length**: Average < 200 lines
- **Naming Convention**: Consistent camelCase/PascalCase
- **Documentation**: All public APIs documented

## 📱 Usage

### 🎯 Basic Usage Flow

1. **Sign Up/Login**: Create an account with email and password
2. **Discover Products**: View products by categories on the home page
3. **Search Products**: Find products by scanning QR codes or manual search
4. **Add to Cart**: Add your favorite products to your cart
5. **Place Order**: Review your cart and complete your order

### 🔍 Advanced Features

- **QR Code Scanning**: Get product information by scanning barcodes
- **Multi-language**: Switch between Turkish and English
- **Dark Mode**: Reduce eye strain with dark theme
- **Offline Support**: Use basic features without internet connection

## 🧪 Testing

The project has comprehensive test coverage:

### Test Types

- **Unit Tests**: Business logic tests
- **Widget Tests**: UI component tests  
- **Integration Tests**: End-to-end flow tests

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/auth/auth_test.dart

# Run integration tests
flutter test integration_test/

# Run tests with coverage
flutter test --coverage
```

### Test Coverage

- **Total Test Files**: 256 test files
- **Unit Tests**: 85%+ coverage
- **Widget Tests**: 80%+ coverage
- **Integration Tests**: Main flows 90%+ coverage
- **Test Types**: Unit, Widget, Integration, and Patrol tests

## 🔒 Security

The application is developed in accordance with security best practices:

### Security Features

- **Input Validation**: All user inputs are validated
- **Rate Limiting**: API requests are throttled
- **XSS Protection**: Malicious script injections are prevented
- **SQL Injection Protection**: Database security is ensured
- **Secure Storage**: Sensitive data is stored securely

For detailed security information, see the [SECURITY_IMPROVEMENTS.md](SECURITY_IMPROVEMENTS.md) file.

## 🌍 Multi-language Support

The application provides full support in 2 languages:

- 🇹🇷 **Turkish** (Default)
- 🇬🇧 **English**

### Language Switching

```dart
// Programmatic language switching
context.setLocale(Locale('en', 'US')); // English
context.setLocale(Locale('tr', 'TR')); // Turkish
```

## 📦 Dependencies

### Core Dependencies

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

### Development Dependencies

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

## 🤝 Contributing

We welcome your contributions! For detailed information, see the [CONTRIBUTING.md](CONTRIBUTING.md) file.

### Contribution Process

1. **Fork** the repository
2. **Create a feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open a Pull Request**

### Code Standards

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use conventional commits
- Test coverage should not fall below 80%
- All PRs must be reviewed

## 📄 License

This project is licensed under the MIT License. For details, see the [LICENSE](LICENSE) file.

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **Firebase Team** - For backend services
- **Open Food Facts** - For product database
- **Community Contributors** - For their contributions



---

<div align="center">

⭐ **If you found this repository useful, don't forget to star it!**



</div>
