# Dio Migration Manuel Test Rehberi

## 🎯 Test Edilen Özellikler

### ✅ Başarıyla Tamamlanan Testler
- **parseResponse metodu**: JSON parsing doğru çalışıyor
- **Dio konfigürasyonu**: Base URL ve timeout ayarları aktif
- **Hata yönetimi**: Geçersiz credentials ile graceful error handling
- **Network timeout**: Timeout ayarları çalışıyor

## 🧪 Manuel Test Yöntemleri

### 1. **Uygulama İçinde Test**

#### AddProduct Sayfasında Test:
```dart
// lib/features/addproduct/view_model/add_product_viewmodel.dart içinde
// saveProduct metodunu çağırdığınızda:

final result = await _productRepository.saveProduct(
  product,
  username,
  password,
  imageFile: selectedImage,
);

// Console'da şu logları göreceksiniz:
// - Dio request/response logları
// - Timeout ayarları
// - Error handling mesajları
```

#### Test Adımları:
1. **Uygulamayı başlatın**: `flutter run`
2. **AddProduct sayfasına gidin**
3. **Form doldurun**:
   - Barcode: `1234567890123`
   - Name: `Test Product`
   - Brands: `Test Brand`
   - Categories: `Test Category`
   - Quantity: `100g`
   - Ingredients: `Test ingredients`
   - Diğer alanları doldurun
4. **Save butonuna basın**
5. **Console loglarını kontrol edin**

### 2. **Network Inspector ile Test**

#### Chrome DevTools:
```bash
# Chrome'da network tab'ını açın
# Uygulamayı web'de çalıştırın
flutter run -d chrome

# Network tab'ında şunları göreceksiniz:
# - Request URL: https://world.openfoodfacts.org/cgi/product_jqm.pl
# - Request Method: POST
# - Request Headers: User-Agent, Content-Type, etc.
# - Request Body: FormData
# - Response Status: 200/302/400/403/etc.
```

### 3. **Debug Console Testleri**

#### Dio Logging Ekleme:
```dart
// lib/features/addproduct/service/product_repository.dart içinde
// Dio instance'ına logging ekleyin:

final Dio _dio = Dio(
  BaseOptions(
    baseUrl: _baseUrl,
    headers: {
      'User-Agent': 'Arya-Flutter-App/1.0 (https://github.com/your-repo)',
      'Accept': 'application/json, text/html, */*',
      'Accept-Language': 'en-US,en;q=0.9',
    },
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ),
)..interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    requestHeader: true,
    responseHeader: true,
  ));
```

### 4. **Gerçek API Testleri**

#### Valid Credentials ile Test:
```dart
// Geçerli OpenFoodFacts credentials ile test
final result = await repository.saveProduct(
  testProduct,
  'your_real_username',  // Gerçek kullanıcı adı
  'your_real_password',  // Gerçek şifre
);

// Beklenen sonuçlar:
// - status: 1 (başarılı)
// - statusVerbose: "Product saved successfully"
```

#### Invalid Credentials ile Test:
```dart
// Geçersiz credentials ile test
final result = await repository.saveProduct(
  testProduct,
  'invalid_user',
  'invalid_pass',
);

// Beklenen sonuçlar:
// - status: -1 (hata)
// - statusVerbose: "HTTP error: 403 - Forbidden" veya benzeri
```

### 5. **Performance Testleri**

#### Timeout Testi:
```dart
// Network bağlantısını kesin ve test edin
// Beklenen: Timeout hatası (30 saniye sonra)

final result = await repository.saveProduct(
  testProduct,
  'test_user',
  'test_pass',
);

// Beklenen: DioException with timeout message
```

#### Memory Testi:
```dart
// Çok sayıda istek gönderin
for (int i = 0; i < 10; i++) {
  final result = await repository.saveProduct(
    testProduct.copyWith(barcode: '${testProduct.barcode}$i'),
    'test_user',
    'test_pass',
  );
}

// Memory leak olmamalı
// Dio instance'ı düzgün dispose edilmeli
```

## 🔍 Beklenen Sonuçlar

### ✅ Başarılı Senaryolar:
- **200 Response**: `{"status":1,"status_verbose":"Product saved successfully"}`
- **Redirect (3xx)**: Otomatik redirect handling
- **Timeout**: 30 saniye sonra timeout hatası
- **Network Error**: Graceful error handling

### ❌ Hata Senaryoları:
- **403 Forbidden**: Geçersiz credentials
- **400 Bad Request**: Geçersiz form data
- **500 Server Error**: API server hatası
- **Network Timeout**: Bağlantı timeout'u

## 📊 Test Sonuçları

### Unit Tests: ✅ 7/7 PASSED
- parseResponse metodları
- Dio konfigürasyonu
- Hata yönetimi
- Integration testleri

### Manuel Tests: 🔄 YAPILACAK
- Uygulama içi test
- Network inspector
- Gerçek API testleri
- Performance testleri

## 🚀 Sonraki Adımlar

1. **Uygulamayı test edin**: AddProduct sayfasında gerçek test
2. **Network loglarını kontrol edin**: Dio request/response logları
3. **Error handling'i test edin**: Geçersiz credentials ile
4. **Performance'i ölçün**: Timeout ve memory kullanımı

## 💡 İpuçları

- **Debug mode'da çalıştırın**: Daha detaylı loglar için
- **Network inspector kullanın**: Request/response detayları için
- **Console loglarını takip edin**: Dio interceptor logları
- **Gerçek credentials kullanın**: Production-like test için
