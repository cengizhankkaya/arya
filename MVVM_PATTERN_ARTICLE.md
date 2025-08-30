# Flutter'da MVVM Pattern: Modern Uygulama Mimarisi Rehberi

## Giriş

Flutter uygulamalarında mimari tasarım, projenin büyümesiyle birlikte en kritik konulardan biri haline gelir. **Model-View-ViewModel (MVVM)** pattern'i, Flutter'da en popüler ve etkili mimari yaklaşımlardan biridir. Bu yazıda, MVVM pattern'inin ne olduğunu, neden tercih edildiğini ve Flutter'da nasıl implement edileceğini detaylı olarak inceleyeceğiz.

## MVVM Pattern Nedir?

MVVM (Model-View-ViewModel), Microsoft tarafından geliştirilen ve Flutter'da yaygın olarak kullanılan bir mimari pattern'dir. Bu pattern, uygulama kodunu üç ana katmana ayırır:

### 1. **Model (Veri Katmanı)**
- Uygulama verilerini ve business logic'i temsil eder
- API calls, database operations, data validation
- Pure Dart classes ve business rules

### 2. **View (Görünüm Katmanı)**
- Kullanıcı arayüzünü temsil eder
- StatelessWidget veya StatefulWidget'lar
- Sadece UI logic içerir, business logic içermez

### 3. **ViewModel (İş Mantığı Katmanı)**
- View ile Model arasında köprü görevi görür
- Business logic'i yönetir
- State management ve UI updates'i sağlar

## Neden MVVM Pattern?

### 1. **Separation of Concerns**
- UI logic ile business logic ayrılır
- Her katman kendi sorumluluğuna odaklanır
- Kod daha maintainable hale gelir

### 2. **Testability**
- ViewModel'lar unit test'lerle kolayca test edilebilir
- UI'dan bağımsız business logic test edilebilir
- Mock objects kullanımı kolaylaşır

### 3. **Reusability**
- ViewModel'lar farklı View'larda kullanılabilir
- Business logic tekrar yazılmaz
- Code duplication azalır

### 4. **Maintainability**
- Kod değişiklikleri izole edilir
- Bug fixing daha kolay
- Feature ekleme/çıkarma basitleşir

## Flutter'da MVVM Implementasyonu: Arya Projesi Örneği

Gerçek bir Flutter projesinden örnek alarak MVVM pattern'inin nasıl implement edildiğini görelim.

### Temel ViewModel Yapısı

```dart
// lib/features/auth/login/view_model/login_view_model.dart
class LoginViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService;

  LoginViewModel({FirebaseAuthService? authService})
    : _authService = authService ?? FirebaseAuthService();

  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _isDisposed = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;

  // Business logic methods
  Future<bool> login() async {
    // Implementation
  }
}
```

### ChangeNotifier Entegrasyonu

Flutter'da MVVM implementasyonu için `ChangeNotifier` kullanılır:

```dart
class LoginViewModel extends ChangeNotifier {
  // State değişikliklerinde UI'ı güncelle
  void _setLoading(bool loading) {
    _isLoading = loading;
    _notifySafely();
  }

  void _notifySafely() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }
}
```

## Advanced MVVM Patterns

### 1. **Base ViewModel Pattern**

Projenizde gördüğümüz gibi, ortak functionality'ler için base class kullanılır:

```dart
// lib/features/profile/view_model/base_view_model.dart
abstract class BaseViewModel extends ChangeNotifier {
  bool _loading = false;
  
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // Loading wrapper for async operations
  Future<T> withLoading<T>(Future<T> Function() operation) async {
    setLoading(true);
    try {
      return await operation();
    } finally {
      setLoading(false);
    }
  }

  // Standardized error handling
  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }
}
```

### 2. **Mixin Pattern**

Form state management için mixin'ler kullanılır:

```dart
// lib/features/addproduct/view_model/mixins/form_state_mixin.dart
mixin FormStateMixin on ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    _successMessage = null;
    setLoading(false);
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
```

### 3. **Multiple Mixin Kullanımı**

```dart
class AddProductViewModel extends ChangeNotifier
    with FormStateMixin, FormControllersMixin {
  
  final IProductRepository _productRepository;
  final IImageService _imageService;

  AddProductViewModel({
    IProductRepository? productRepository,
    IImageService? imageService,
  }) : _productRepository = productRepository ?? ProductRepository(),
       _imageService = imageService ?? ImageService();

  // Business logic implementation
  Future<void> addProduct() async {
    if (!validateForm()) return;
    
    setLoading(true);
    try {
      // Implementation
    } catch (e) {
      setError(e.toString());
    }
  }
}
```

## View-ViewModel Bağlantısı

### Provider Pattern ile State Management

```dart
// lib/features/auth/login/view/login_view.dart
@RoutePage()
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const _LoginViewBody(),
    );
  }
}

class _LoginViewBody extends StatelessWidget {
  const _LoginViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(child: const LoginForm()),
    );
  }
}
```

### ViewModel'a Erişim

```dart
class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              // Form fields
              if (viewModel.isLoading)
                CircularProgressIndicator(),
              if (viewModel.errorMessage != null)
                Text(viewModel.errorMessage!),
            ],
          ),
        );
      },
    );
  }
}
```

## State Management Best Practices

### 1. **Loading State Management**

```dart
class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  
  bool get isLoading => _isLoading;

  Future<bool> login() async {
    _setLoading(true);
    try {
      final result = await _authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      return result.isSuccess;
    } finally {
      _setLoading(false);
    }
  }
}
```

### 2. **Error Handling**

```dart
class LoginViewModel extends ChangeNotifier {
  String? _errorMessage;
  
  String? get errorMessage => _errorMessage;

  void _setError(String message) {
    _errorMessage = message;
    _notifySafely();
  }

  void _clearError() {
    _errorMessage = null;
    _notifySafely();
  }
}
```

### 3. **Disposal Safety**

```dart
class LoginViewModel extends ChangeNotifier {
  bool _isDisposed = false;

  void _notifySafely() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
```

## Dependency Injection

### Constructor Injection

```dart
class LoginViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService;
  final NavigationService _navigationService;

  LoginViewModel({
    FirebaseAuthService? authService,
    NavigationService? navigationService,
  }) : _authService = authService ?? FirebaseAuthService(),
       _navigationService = navigationService ?? NavigationService();
}
```

### Service Locator Pattern

```dart
class LoginViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = GetIt.instance<FirebaseAuthService>();
  final NavigationService _navigationService = GetIt.instance<NavigationService>();
}
```

## Form Validation

### ViewModel'da Validation

```dart
class LoginViewModel extends ChangeNotifier {
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'auth.validators.email_required'.tr();
    }
    if (!AuthConstants.emailRegex.hasMatch(value.trim())) {
      return 'auth.validators.email_invalid'.tr();
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'auth.validators.password_required'.tr();
    }
    if (value.length < AuthConstants.minPasswordLength) {
      return 'auth.validators.password_min_length'.tr(
        args: [AuthConstants.minPasswordLength.toString()],
      );
    }
    return null;
  }
}
```

## Testing MVVM Implementation

### Unit Testing ViewModels

```dart
// test/unit/auth/login/login_view_model_test.dart
void main() {
  group('LoginViewModel Tests', () {
    late LoginViewModel viewModel;
    late MockFirebaseAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
      viewModel = LoginViewModel(authService: mockAuthService);
    });

    test('should validate email correctly', () {
      final result = viewModel.validateEmail('invalid-email');
      expect(result, isNotNull);
    });

    test('should handle login success', () async {
      when(mockAuthService.signIn(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => AuthResult.success());

      final result = await viewModel.login();
      expect(result, isTrue);
    });
  });
}
```

### Mock Objects

```dart
class MockFirebaseAuthService extends Mock implements FirebaseAuthService {
  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    return AuthResult.success();
  }
}
```

## Performance Optimization

### 1. **Selective Rebuilds**

```dart
class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<LoginViewModel, bool>(
      selector: (context, viewModel) => viewModel.isLoading,
      builder: (context, isLoading, child) {
        return Form(
          child: Column(
            children: [
              // Form fields
              if (isLoading) CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }
}
```

### 2. **Lazy Loading**

```dart
class LoginViewModel extends ChangeNotifier {
  bool _isInitialized = false;
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Perform initialization
    _isInitialized = true;
  }
}
```

## Common MVVM Anti-Patterns

### 1. **View'da Business Logic**

❌ **Yanlış:**
```dart
class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Business logic in view
    if (email.isEmpty) {
      showError('Email required');
    }
  }
}
```

✅ **Doğru:**
```dart
class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              TextFormField(
                validator: viewModel.validateEmail,
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### 2. **ViewModel'da UI Logic**

❌ **Yanlış:**
```dart
class LoginViewModel extends ChangeNotifier {
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }
}
```

✅ **Doğru:**
```dart
class LoginViewModel extends ChangeNotifier {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
```

## Migration Guide

### Mevcut Projeyi MVVM'e Geçirme

#### 1. **Analiz Aşaması**
- Mevcut kod yapısını analiz edin
- Business logic'i UI'dan ayırın
- State management ihtiyaçlarını belirleyin

#### 2. **ViewModel Oluşturma**
- Her View için ViewModel oluşturun
- Business logic'i ViewModel'a taşıyın
- State variables'ları tanımlayın

#### 3. **View Güncelleme**
- View'ları StatelessWidget yapın
- Provider pattern entegrasyonu
- ViewModel'dan state'leri consume edin

#### 4. **Testing**
- ViewModel unit test'leri yazın
- Mock objects oluşturun
- Integration test'leri güncelleyin

## Sonuç

MVVM pattern, Flutter uygulamalarında modern ve maintainable kod yazmanın en etkili yollarından biridir. Bu pattern sayesinde:

- **Kod organizasyonu** daha net ve anlaşılır
- **Test edilebilirlik** önemli ölçüde artar
- **Code reusability** sağlanır
- **Maintenance** maliyeti düşer
- **Team collaboration** daha verimli hale gelir

Arya projesinde gördüğümüz gibi, MVVM pattern gerçek projelerde başarıyla uygulanabilir ve uzun vadede büyük faydalar sağlar. Projenizi bu pattern'e geçirmek için kademeli bir yaklaşım benimseyin ve her adımda test coverage'ınızı koruyun.

## Kaynaklar

- [Flutter Architecture Patterns](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple)
- [Provider Package Documentation](https://pub.dev/packages/provider)
- [MVVM Pattern in Flutter](https://medium.com/flutter-community/flutter-architecture-blueprints-79effcfff166)
- [Clean Architecture in Flutter](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

*Bu yazı, gerçek bir Flutter projesi olan Arya'nın MVVM implementasyonu analiz edilerek hazırlanmıştır. MVVM pattern'inin pratik uygulamasını görmek için proje kodlarını inceleyebilirsiniz.*
