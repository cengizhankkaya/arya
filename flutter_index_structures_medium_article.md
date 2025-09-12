# Flutter Projelerinde Index Yapıları: Temiz Import'lar ve Modüler Mimari

## Temel Kullanım

```dart
// lib/features/auth/index.dart
export 'model/user_model.dart';
export 'model/auth_state.dart';
export 'view/login_view.dart';
export 'view/register_view.dart';
export 'view_model/auth_view_model.dart';
export 'service/auth_service.dart';
```

**❌ Index Olmadan:**
```dart
import 'package:my_app/features/auth/model/user_model.dart';
import 'package:my_app/features/auth/model/auth_state.dart';
import 'package:my_app/features/auth/view/login_view.dart';
import 'package:my_app/features/auth/view/register_view.dart';
import 'package:my_app/features/auth/view_model/auth_view_model.dart';
import 'package:my_app/features/auth/service/auth_service.dart';
```

**✅ Index ile:**
```dart
import 'package:my_app/features/auth/index.dart';
```

## Hiyerarşik Index Yapısı

```dart
// lib/features/auth/index.dart
export 'model/index.dart';
export 'view/index.dart';
export 'view_model/index.dart';
export 'service/index.dart';
export 'widget/index.dart';
```

```dart
// lib/features/auth/model/index.dart
export 'user_model.dart';
export 'auth_state.dart';
export 'login_request.dart';
export 'register_request.dart';
```

```dart
// lib/features/auth/view/index.dart
export 'login_view.dart';
export 'register_view.dart';
export 'forgot_password_view.dart';
```

```dart
// lib/features/auth/view_model/index.dart
export 'auth_view_model.dart';
export 'login_view_model.dart';
export 'register_view_model.dart';
```

## Store Feature Örneği

```dart
// lib/features/store/index.dart
export 'model/index.dart';
export 'view/index.dart';
export 'view_model/index.dart';
export 'services/index.dart';
export 'widget/index.dart';
```

```dart
// lib/features/store/model/index.dart
export 'product_model.dart';
export 'cart_item_model.dart';
export 'category_model.dart';
export 'order_model.dart';
```

```dart
// lib/features/store/services/index.dart
export 'product_service.dart';
export 'cart_service.dart';
export 'order_service.dart';
export 'payment_service.dart';
```

## Shared Resources

```dart
// lib/product/index.dart
export 'constants/index.dart';
export 'theme/index.dart';
export 'utility/index.dart';
export 'widget/index.dart';
export 'navigation/index.dart';
```

```dart
// lib/product/constants/index.dart
export 'app_constants.dart';
export 'api_constants.dart';
export 'theme_constants.dart';
export 'string_constants.dart';
```

```dart
// lib/product/theme/index.dart
export 'app_theme.dart';
export 'light_theme.dart';
export 'dark_theme.dart';
export 'text_theme.dart';
export 'color_scheme.dart';
```

## Proje Yapısı

```
lib/
├── features/
│   ├── auth/
│   │   ├── index.dart
│   │   ├── model/
│   │   │   ├── index.dart
│   │   │   ├── user_model.dart
│   │   │   └── auth_state.dart
│   │   ├── view/
│   │   │   ├── index.dart
│   │   │   ├── login_view.dart
│   │   │   └── register_view.dart
│   │   └── view_model/
│   │       ├── index.dart
│   │       ├── auth_view_model.dart
│   │       └── login_view_model.dart
│   └── store/
│       ├── index.dart
│       └── ...
├── product/
│   ├── index.dart
│   ├── constants/
│   │   ├── index.dart
│   │   └── ...
│   └── theme/
│       ├── index.dart
│       └── ...
└── main.dart
```

## API Kontrolü

```dart
// lib/features/auth/index.dart
// ✅ Sadece public API'yi export et
export 'model/user_model.dart';
export 'view/login_view.dart';
export 'view_model/auth_view_model.dart';

// ❌ Internal implementation'ları export etme
// export 'service/auth_service_impl.dart';
// export 'repository/auth_repository_impl.dart';
```

## Dokümantasyon

```dart
// lib/features/auth/index.dart
/// Authentication feature exports
/// 
/// Usage:
/// ```dart
/// import 'package:my_app/features/auth/index.dart';
/// 
/// final authViewModel = AuthViewModel();
/// await authViewModel.login(email, password);
/// ```

export 'model/index.dart';
export 'view/index.dart';
export 'view_model/index.dart';
export 'service/index.dart';
```

## Naming Conventions

```dart
// ✅ Tutarlı isimlendirme
export 'user_model.dart';
export 'user_service.dart';
export 'user_view_model.dart';

// ❌ Tutarlı olmayan isimlendirme
export 'UserModel.dart';
export 'userService.dart';
export 'user_viewmodel.dart';
```

## Conditional Exports

```dart
// lib/features/camera/index.dart
export 'camera_service.dart';

// Platform-specific implementations
export 'camera_service_android.dart' if (dart.library.io) 'camera_service_android.dart';
export 'camera_service_ios.dart' if (dart.library.io) 'camera_service_ios.dart';
export 'camera_service_web.dart' if (dart.library.html) 'camera_service_web.dart';
```

## Feature Flags

```dart
// lib/features/analytics/index.dart
export 'analytics_service.dart';

// Feature flag ile conditional export
export 'analytics_service_advanced.dart' if (bool.fromEnvironment('ENABLE_ADVANCED_ANALYTICS'));
```

## Environment-based Exports

```dart
// lib/features/api/index.dart
export 'api_service.dart';

// Environment-based exports
export 'api_service_production.dart' if (bool.fromEnvironment('PRODUCTION'));
export 'api_service_development.dart' if (bool.fromEnvironment('DEVELOPMENT'));
export 'api_service_test.dart' if (bool.fromEnvironment('TEST'));
```

## Barrel Exports

```dart
// lib/features/store/index.dart
// Barrel export - tüm alt modülleri tek noktadan export et
export 'model/index.dart';
export 'view/index.dart';
export 'view_model/index.dart';
export 'services/index.dart';
export 'widget/index.dart';

// Convenience exports - sık kullanılan sınıfları direkt export et
export 'model/product_model.dart';
export 'view_model/cart_view_model.dart';
export 'services/product_service.dart';
```

## Tree Shaking

```dart
// ❌ Tüm sınıfları export etmek tree shaking'i engelleyebilir
export 'model/user_model.dart';
export 'model/admin_model.dart';
export 'model/guest_model.dart';

// ✅ Sadece gerekli sınıfları export et
export 'model/user_model.dart';
// export 'model/admin_model.dart'; // Sadece admin özelliklerinde kullanılıyorsa
// export 'model/guest_model.dart'; // Sadece guest özelliklerinde kullanılıyorsa
```

## Bundle Size

```dart
// lib/features/auth/index.dart
// ✅ Sadece gerekli sınıfları export et
export 'model/user_model.dart';
export 'view/login_view.dart';
export 'view_model/auth_view_model.dart';

// ❌ Gereksiz sınıfları export etme
// export 'model/user_model_legacy.dart';
// export 'view/login_view_old.dart';
```

## Lazy Loading

```dart
// lib/features/index.dart
// ✅ Lazy loading ile büyük modülleri yükle
export 'auth/index.dart';
export 'store/index.dart';

// Büyük modüller için lazy loading
// export 'analytics/index.dart' deferred as analytics;
// export 'reporting/index.dart' deferred as reporting;
```

## Arya Projesi Örneği

```dart
// lib/features/index.dart
export 'auth/index.dart';
export 'appshell/index.dart';
export 'profile/index.dart';
export 'store/index.dart';
export 'home/index.dart';
export 'onboard/index.dart';
export 'addproduct/index.dart';
```

```dart
// lib/features/auth/index.dart
export 'login/index.dart';
export 'register/index.dart';
export 'model/index.dart';
export 'service/index.dart';
export 'widget/index.dart';
```

```dart
// lib/features/auth/login/index.dart
export 'view/index.dart';
export 'view_model/index.dart';
```

```dart
// lib/features/auth/login/view/index.dart
export 'login_view.dart';
export 'email_field.dart';
export 'password_field.dart';
export 'login_title.dart';
export 'sign_up_row.dart';
```

**Kullanım:**
```dart
// ✅ Temiz import
import 'package:arya/features/auth/index.dart';

// Tüm auth özelliklerine erişim
final authViewModel = AuthViewModel();
final loginView = LoginView();
final userModel = UserModel();
```

## Import Hatalarını Debug Etme

```dart
// lib/features/auth/index.dart
export 'model/user_model.dart';
export 'view/login_view.dart';
export 'view_model/auth_view_model.dart';

// Hata durumunda debug için
// export 'model/user_model.dart' show UserModel;
// export 'view/login_view.dart' show LoginView;
// export 'view_model/auth_view_model.dart' show AuthViewModel;
```

## Circular Dependency Kontrolü

```dart
// lib/features/auth/index.dart
// ✅ Circular dependency'yi önle
export 'model/user_model.dart';
export 'view/login_view.dart';
export 'view_model/auth_view_model.dart';

// ❌ Circular dependency yaratabilir
// export 'service/auth_service.dart'; // Eğer auth_service, auth_view_model'i import ediyorsa
```

## Import Validation

```dart
// lib/features/auth/index.dart
// Tüm export'ların geçerli olduğundan emin ol
export 'model/user_model.dart';
export 'view/login_view.dart';
export 'view_model/auth_view_model.dart';

// Test için
// export 'model/user_model.dart' show UserModel;
// export 'view/login_view.dart' show LoginView;
// export 'view_model/auth_view_model.dart' show AuthViewModel;
```

## Index Dosyalarını Test Etme

```dart
// test/features/auth/index_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/features/auth/index.dart';

void main() {
  group('Auth Index Exports', () {
    test('should export all required classes', () {
      // Test that all required classes are exported
      expect(() => UserModel(), returnsNormally);
      expect(() => LoginView(), returnsNormally);
      expect(() => AuthViewModel(), returnsNormally);
    });
  });
}
```

## Import Test'leri

```dart
// test/features/auth/import_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth Imports', () {
    test('should import auth module without errors', () {
      // Test that importing the auth module doesn't cause errors
      expect(() {
        import 'package:my_app/features/auth/index.dart';
      }, returnsNormally);
    });
  });
}
```

## Mevcut Projeyi Index Yapısına Geçirme

**Adım 1: Mevcut import'ları analiz et**
```bash
# Projedeki tüm import'ları bul
grep -r "import 'package:" lib/ | head -20
```

**Adım 2: Index dosyalarını oluştur**
```dart
// lib/features/auth/index.dart
export 'model/user_model.dart';
export 'view/login_view.dart';
export 'view_model/auth_view_model.dart';
```

**Adım 3: Import'ları güncelle**
```dart
// Önce
import 'package:my_app/features/auth/model/user_model.dart';
import 'package:my_app/features/auth/view/login_view.dart';

// Sonra
import 'package:my_app/features/auth/index.dart';
```

## Migration Progress Tracking

```dart
// lib/features/auth/index.dart
// Migration progress tracking
export 'model/user_model.dart'; // ✅ Migrated
export 'view/login_view.dart'; // ✅ Migrated
// export 'view/register_view.dart'; // 🔄 In progress
// export 'view_model/auth_view_model.dart'; // ⏳ Pending
```

## Sonuç

Index yapıları, Flutter projelerinde:

- ✅ **Temiz import yapıları** oluşturur
- ✅ **Modüler mimari** sağlar
- ✅ **Refactoring** kolaylaştırır
- ✅ **API kontrolü** verir
- ✅ **Kod organizasyonu** geliştirir

### Anahtar Noktalar

1. **Hiyerarşik yapı** kullanın
2. **Sadece gerekli sınıfları** export edin
3. **Tutarlı isimlendirme** yapın
4. **Dokümantasyon** ekleyin
5. **Performans etkilerini** göz önünde bulundurun

### Sonraki Adımlar

1. Mevcut projenizde index yapılarını uygulayın
2. Import'ları temizleyin
3. Modüler mimariyi geliştirin
4. Test coverage'ı artırın
5. Dokümantasyonu güncelleyin

---

**💡 İpucu:** Index yapılarını kullanmaya başladığınızda, kodunuzun daha temiz ve organize olduğunu hemen fark edeceksiniz!

**#Flutter #Dart #CleanArchitecture #IndexStructures #ModularArchitecture**
