# Repository Pattern ile Veri Katmanı Soyutlaması: Flutter'da Temiz Mimari

*Modern Flutter uygulamalarında veri katmanını nasıl organize edeceğinizi ve Repository Pattern ile nasıl temiz bir mimari oluşturacağınızı öğrenin.*

---

## 🎯 Giriş

Flutter uygulamalarında veri yönetimi, uygulamanın en kritik bileşenlerinden biridir. API çağrıları, yerel veritabanı işlemleri, cache yönetimi ve veri senkronizasyonu gibi karmaşık işlemleri organize etmek için güçlü bir mimariye ihtiyaç duyarız. Bu yazıda, **Repository Pattern** kullanarak nasıl temiz ve sürdürülebilir bir veri katmanı oluşturacağımızı gerçek proje örnekleriyle inceleyeceğiz.

## 🏗️ Repository Pattern Nedir?

Repository Pattern, veri erişim mantığını iş mantığından ayıran bir tasarım desenidir. Bu pattern sayesinde:

- **Veri kaynaklarını soyutlar** (API, veritabanı, cache)
- **Test edilebilirlik** sağlar
- **Bağımlılıkları tersine çevirir** (Dependency Inversion)
- **Tek sorumluluk prensibi** uygular

### Temel Yapı

```dart
// Interface (Soyutlama)
abstract class IProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}

// Implementation (Somutlama)
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

## 🚀 Gerçek Proje Örnekleri

### 1. Ürün Yönetimi Repository'si

Arya projesinde, Open Food Facts API ile entegre çalışan bir ürün repository'si implementasyonu:

```dart
abstract class IProductRepository {
  Future<off.Status> saveProduct(
    AddProductModel product,
    String username,
    String password, {
    File? imageFile,
  });
}

class ProductRepository implements IProductRepository {
  static const String _baseUrl = 'https://world.openfoodfacts.org';
  static const String _endpoint = '/cgi/product_jqm.pl';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    headers: {
      'User-Agent': 'Arya-Flutter-App/1.0',
      'Accept': 'application/json, text/html, */*',
    },
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  @override
  Future<off.Status> saveProduct(
    AddProductModel product,
    String username,
    String password, {
    File? imageFile,
  }) async {
    final formData = FormData.fromMap({
      'user_id': username,
      'password': password,
      'action': 'process',
      'json': '1',
      'type': 'product',
    });

    try {
      final response = await _dio.post(
        _endpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Origin': _baseUrl,
            'Referer': '$_baseUrl/',
          },
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      // Redirect handling
      if (response.statusCode != null &&
          response.statusCode! >= 300 &&
          response.statusCode! < 400) {
        final status = await _handleRedirect(response);
        
        if (status.status == 1 && imageFile != null) {
          await _uploadProductImage(
            barcode: product.barcode,
            username: username,
            password: password,
            imageFile: imageFile,
          );
        }
        return status;
      }
      
      return parseResponse(response.data);
    } on DioException catch (e) {
      return off.Status(
        status: -1,
        statusVerbose: 'Network error: ${e.message}',
      );
    } catch (e) {
      return off.Status(status: -1, statusVerbose: 'Unexpected error: $e');
    }
  }
}
```

**Bu implementasyonun avantajları:**
- **Tek sorumluluk**: Sadece ürün kaydetme işlemi
- **Hata yönetimi**: Kapsamlı exception handling
- **Dependency Injection**: Dio instance'ı test edilebilir
- **Soyutlama**: Interface ile bağımlılık tersine çevirme

### 2. Kimlik Bilgileri Repository'si

Güvenlik odaklı bir repository implementasyonu:

```dart
abstract class IOffCredentialsRepository {
  Future<OffCredentialsModel?> getCredentials();
  Future<bool> saveCredentials(OffCredentialsModel credentials);
  Future<bool> clearCredentials();
}

class OffCredentialsRepository implements IOffCredentialsRepository {
  final IOffCredentialsService _service;

  OffCredentialsRepository({IOffCredentialsService? service})
    : _service = service ?? OffCredentialsService();

  @override
  Future<OffCredentialsModel?> getCredentials() async {
    try {
      final credentials = await _service.getCredentials();

      // Repository seviyesinde ek güvenlik kontrolü
      if (credentials != null && !_validateRepositoryLevel(credentials)) {
        await _service.clearCredentials();
        return null;
      }

      return credentials;
    } catch (e) {
      _logRepositoryError('getCredentials', e);
      rethrow;
    }
  }

  @override
  Future<bool> saveCredentials(OffCredentialsModel credentials) async {
    try {
      // Repository seviyesinde ek validasyon
      if (!_validateRepositoryLevel(credentials)) {
        throw Exception('Invalid credentials format at repository level');
      }

      // Güvenlik kontrolü
      if (!_isRepositoryLevelSecure(credentials)) {
        throw Exception('Credentials security requirements not met');
      }

      return await _service.saveCredentials(credentials);
    } catch (e) {
      _logRepositoryError('saveCredentials', e);
      rethrow;
    }
  }

  // Repository seviyesinde güvenlik metodları
  bool _validateRepositoryLevel(OffCredentialsModel credentials) {
    if (credentials.username.isEmpty || credentials.password.isEmpty) {
      return false;
    }

    if (credentials.username.length < 3 ||
        credentials.username.length > 50 ||
        credentials.password.length < 8 ||
        credentials.password.length > 128) {
      return false;
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(credentials.username)) {
      return false;
    }

    return true;
  }

  bool _isRepositoryLevelSecure(OffCredentialsModel credentials) {
    // Username ve password aynı olamaz
    if (credentials.username.toLowerCase() ==
        credentials.password.toLowerCase()) {
      return false;
    }

    // Username password içinde geçemez
    if (credentials.password.toLowerCase().contains(
      credentials.username.toLowerCase(),
    )) {
      return false;
    }

    return _isStrongPassword(credentials.password);
  }

  bool _isStrongPassword(String password) {
    if (password.length < 8) return false;
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;
    if (!RegExp(r'[0-9]').hasMatch(password)) return false;
    if (!RegExp(r'[!@#$%^&*()_+\-=\[\]{}:;<>,.?]').hasMatch(password))
      return false;

    return true;
  }
}
```

**Bu implementasyonun güçlü yanları:**
- **Çoklu katman güvenlik**: Service ve Repository seviyesinde validasyon
- **Güvenli hata yönetimi**: Sensitive bilgileri loglamaz
- **Güçlü şifre politikası**: Kapsamlı şifre güvenlik kontrolü
- **Corrupted data handling**: Bozuk verileri otomatik temizler

### 3. Alışveriş Sepeti Repository'si

Real-time veri senkronizasyonu ile sepet yönetimi:

```dart
class CartService {
  final FirebaseFirestore _firestore;

  CartService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Real-time sepet stream'i
  Stream<List<CartItemModel>> streamCart(String uid) {
    return _userCartCollection(uid)
        .snapshots()
        .map((snapshot) {
          final items = snapshot.docs
              .map((doc) {
                final data = doc.data();
                return CartItemModel.fromMap(data);
              })
              .toList(growable: false);

          return items;
        })
        .handleError((error) {
          // Graceful degradation
          return <CartItemModel>[];
        });
  }

  /// Transaction ile güvenli sepet ekleme
  Future<void> addToCart(String uid, CartItemModel item) async {
    final docRef = _userCartCollection(uid).doc(item.id);
    await _firestore.runTransaction((transaction) async {
      final existing = await transaction.get(docRef);
      if (existing.exists) {
        final currentQty = (existing.data()!['quantity'] as num?)?.toInt() ?? 0;
        transaction.update(docRef, {'quantity': currentQty + 1});
      } else {
        transaction.set(docRef, item.toMap());
      }
    });
  }

  /// Miktar güncelleme
  Future<void> setQuantity(String uid, String productId, int quantity) async {
    final docRef = _userCartCollection(uid).doc(productId);
    if (quantity <= 0) {
      await docRef.delete();
      return;
    }
    await docRef.set({'quantity': quantity}, SetOptions(merge: true));
  }

  CollectionReference<Map<String, dynamic>> _userCartCollection(String uid) {
    return _firestore.collection('carts').doc(uid).collection('items');
  }
}
```

**Bu implementasyonun özellikleri:**
- **Real-time updates**: Firestore stream'leri ile canlı güncellemeler
- **Atomic transactions**: Veri tutarlılığı garantisi
- **Graceful degradation**: Hata durumunda boş liste döner
- **Performance optimization**: Merge operations ile verimli güncellemeler

## 🎨 Clean Architecture ile Entegrasyon

Repository Pattern, Clean Architecture'ın temel taşlarından biridir:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   Widgets   │  │   Views     │  │ ViewModels  │        │
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

### ViewModel ile Kullanım

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

## 🧪 Test Edilebilirlik

Repository Pattern'in en büyük avantajlarından biri test edilebilirliktir:

```dart
// Mock repository for testing
class MockProductRepository implements IProductRepository {
  final List<Product> _products = [];
  bool _shouldThrowError = false;

  @override
  Future<List<Product>> getProducts() async {
    if (_shouldThrowError) {
      throw Exception('Network error');
    }
    return _products;
  }

  @override
  Future<Product> addProduct(Product product) async {
    _products.add(product);
    return product;
  }

  // Test helper methods
  void setShouldThrowError(bool value) {
    _shouldThrowError = value;
  }

  void addTestProduct(Product product) {
    _products.add(product);
  }
}

// Test implementation
void main() {
  group('ProductViewModel Tests', () {
    late MockProductRepository mockRepository;
    late ProductViewModel viewModel;

    setUp(() {
      mockRepository = MockProductRepository();
      viewModel = ProductViewModel(mockRepository);
    });

    test('should load products successfully', () async {
      // Arrange
      final testProduct = Product(name: 'Test Product', price: 10.0);
      mockRepository.addTestProduct(testProduct);

      // Act
      await viewModel.loadProducts();

      // Assert
      expect(viewModel.products, contains(testProduct));
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.error, isNull);
    });

    test('should handle error when loading products fails', () async {
      // Arrange
      mockRepository.setShouldThrowError(true);

      // Act
      await viewModel.loadProducts();

      // Assert
      expect(viewModel.products, isEmpty);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.error, isNotNull);
    });
  });
}
```

## 🔧 Best Practices

### 1. Interface Segregation

```dart
// ❌ Kötü: Tek büyük interface
abstract class IUserRepository {
  Future<User> getUser(String id);
  Future<List<User>> getAllUsers();
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String id);
  Future<void> sendEmail(String email);
  Future<void> uploadAvatar(File file);
}

// ✅ İyi: Ayrılmış interface'ler
abstract class IUserRepository {
  Future<User> getUser(String id);
  Future<List<User>> getAllUsers();
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String id);
}

abstract class IUserEmailService {
  Future<void> sendEmail(String email);
}

abstract class IUserFileService {
  Future<void> uploadAvatar(File file);
}
```

### 2. Error Handling

```dart
// Result pattern ile type-safe error handling
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

class ProductRepository implements IProductRepository {
  @override
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
```

### 3. Caching Strategy

```dart
class ProductRepository implements IProductRepository {
  final IProductService _productService;
  final ILocalStorage _localStorage;
  final Duration _cacheExpiry = const Duration(minutes: 5);

  @override
  Future<List<Product>> getProducts() async {
    try {
      // Cache kontrolü
      final cachedProducts = await _localStorage.getCachedProducts();
      if (cachedProducts != null && !_isCacheExpired()) {
        return cachedProducts;
      }

      // API'den veri çek
      final products = await _productService.fetchProducts();
      
      // Cache'e kaydet
      await _localStorage.cacheProducts(products);
      await _localStorage.setCacheTimestamp(DateTime.now());
      
      return products;
    } catch (e) {
      // Fallback to cache
      final cachedProducts = await _localStorage.getCachedProducts();
      if (cachedProducts != null) {
        return cachedProducts;
      }
      rethrow;
    }
  }

  bool _isCacheExpired() {
    final timestamp = _localStorage.getCacheTimestamp();
    if (timestamp == null) return true;
    return DateTime.now().difference(timestamp) > _cacheExpiry;
  }
}
```

## 🚀 Performance Optimizasyonları

### 1. Batch Operations

```dart
class CartRepository implements ICartRepository {
  Future<void> addMultipleItems(String uid, List<CartItem> items) async {
    final batch = _firestore.batch();
    
    for (final item in items) {
      final docRef = _userCartCollection(uid).doc(item.id);
      batch.set(docRef, item.toMap());
    }
    
    await batch.commit();
  }
}
```

### 2. Pagination

```dart
class ProductRepository implements IProductRepository {
  Future<PaginatedResult<Product>> getProducts({
    int page = 1,
    int limit = 20,
  }) async {
    final offset = (page - 1) * limit;
    
    final response = await _apiService.getProducts(
      offset: offset,
      limit: limit,
    );
    
    return PaginatedResult(
      data: response.products,
      currentPage: page,
      totalPages: (response.total / limit).ceil(),
      hasNextPage: page < (response.total / limit).ceil(),
    );
  }
}
```

## 📊 Monitoring ve Logging

```dart
class ProductRepository implements IProductRepository {
  final IProductService _productService;
  final IAnalyticsService _analytics;

  @override
  Future<List<Product>> getProducts() async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final products = await _productService.fetchProducts();
      
      _analytics.trackEvent('products_loaded', {
        'count': products.length,
        'duration_ms': stopwatch.elapsedMilliseconds,
      });
      
      return products;
    } catch (e) {
      _analytics.trackEvent('products_load_failed', {
        'error': e.toString(),
        'duration_ms': stopwatch.elapsedMilliseconds,
      });
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }
}
```

## 🎯 Sonuç

Repository Pattern, Flutter uygulamalarında veri katmanını organize etmek için güçlü bir araçtır. Bu pattern sayesinde:

- **Temiz mimari** oluşturabilirsiniz
- **Test edilebilir** kod yazabilirsiniz
- **Bağımlılıkları** yönetebilirsiniz
- **Performansı** optimize edebilirsiniz
- **Güvenliği** artırabilirsiniz

Gerçek proje örneklerinde gördüğümüz gibi, Repository Pattern sadece bir tasarım deseni değil, aynı zamanda uygulamanızın kalitesini ve sürdürülebilirliğini artıran bir yaklaşımdır.

### Key Takeaways

1. **Interface'leri kullanın** - Soyutlamalar oluşturun
2. **Tek sorumluluk** - Her repository tek bir domain'e odaklansın
3. **Error handling** - Kapsamlı hata yönetimi uygulayın
4. **Test edin** - Mock'lar ile test edilebilirlik sağlayın
5. **Performance** - Caching ve batch operations kullanın
6. **Security** - Güvenlik kontrollerini repository seviyesinde yapın

Bu yaklaşımla, ölçeklenebilir ve maintainable Flutter uygulamaları geliştirebilirsiniz. Happy coding! 🚀

---

*Bu yazı, [Arya Flutter Projesi](https://github.com/yourusername/arya) örnekleriyle hazırlanmıştır. Proje, Clean Architecture prensipleri ve Repository Pattern kullanılarak geliştirilmiştir.*

