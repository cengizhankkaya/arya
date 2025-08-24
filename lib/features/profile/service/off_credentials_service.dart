import 'package:arya/product/utility/storage/app_prefs.dart';
import '../model/off_credentials_model.dart';

abstract class IOffCredentialsService {
  Future<OffCredentialsModel?> getCredentials();
  Future<bool> saveCredentials(OffCredentialsModel credentials);
  Future<bool> clearCredentials();
}

class OffCredentialsService implements IOffCredentialsService {
  // Rate limiting için
  static const int _maxRequestsPerMinute = 30;
  static final Map<String, List<DateTime>> _requestHistory = {};

  @override
  Future<OffCredentialsModel?> getCredentials() async {
    try {
      // Rate limiting kontrolü
      if (!_checkRateLimit('get_credentials')) {
        throw Exception('Rate limit exceeded');
      }

      final username = await AppPrefs.getOffUsername();
      final password = await AppPrefs.getOffPassword();

      if (username != null && password != null) {
        // Güvenlik validasyonu
        if (!_validateStoredCredentials(username, password)) {
          await _clearCorruptedCredentials();
          return null;
        }

        return OffCredentialsModel(username: username, password: password);
      }
      return null;
    } catch (e) {
      // Güvenli hata mesajı
      _logSecureError('getCredentials', e);
      throw Exception('Credentials yüklenirken hata oluştu');
    }
  }

  @override
  Future<bool> saveCredentials(OffCredentialsModel credentials) async {
    try {
      // Rate limiting kontrolü
      if (!_checkRateLimit('save_credentials')) {
        throw Exception('Rate limit exceeded');
      }

      // Input validation
      if (!_validateCredentials(credentials)) {
        throw Exception('Invalid credentials format');
      }

      // Güvenlik kontrolü
      if (!_isSecureCredentials(credentials)) {
        throw Exception('Credentials security requirements not met');
      }

      await AppPrefs.setOffCredentials(
        username: credentials.username,
        password: credentials.password,
      );
      return true;
    } catch (e) {
      // Güvenli hata mesajı
      _logSecureError('saveCredentials', e);
      throw Exception('Credentials kaydedilirken hata oluştu');
    }
  }

  @override
  Future<bool> clearCredentials() async {
    try {
      // Rate limiting kontrolü
      if (!_checkRateLimit('clear_credentials')) {
        throw Exception('Rate limit exceeded');
      }

      await AppPrefs.clearOffCredentials();
      return true;
    } catch (e) {
      // Güvenli hata mesajı
      _logSecureError('clearCredentials', e);
      throw Exception('Credentials temizlenirken hata oluştu');
    }
  }

  // Güvenlik metodları
  bool _validateCredentials(OffCredentialsModel credentials) {
    if (credentials.username.isEmpty || credentials.password.isEmpty) {
      return false;
    }

    // Username uzunluk kontrolü
    if (credentials.username.length < 3 || credentials.username.length > 50) {
      return false;
    }

    // Password uzunluk kontrolü
    if (credentials.password.length < 8 || credentials.password.length > 128) {
      return false;
    }

    // Username format kontrolü
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(credentials.username)) {
      return false;
    }

    return true;
  }

  bool _isSecureCredentials(OffCredentialsModel credentials) {
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

    // Güçlü şifre kontrolü
    if (!_isStrongPassword(credentials.password)) {
      return false;
    }

    return true;
  }

  bool _isStrongPassword(String password) {
    // En az 8 karakter
    if (password.length < 8) return false;

    // En az bir büyük harf
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;

    // En az bir küçük harf
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;

    // En az bir rakam
    if (!RegExp(r'[0-9]').hasMatch(password)) return false;

    // En az bir özel karakter
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) return false;

    return true;
  }

  bool _validateStoredCredentials(String username, String password) {
    // Boş değer kontrolü
    if (username.isEmpty || password.isEmpty) {
      return false;
    }

    // Uzunluk kontrolü
    if (username.length < 3 ||
        username.length > 50 ||
        password.length < 8 ||
        password.length > 128) {
      return false;
    }

    return true;
  }

  Future<void> _clearCorruptedCredentials() async {
    try {
      await AppPrefs.clearOffCredentials();
    } catch (e) {
      // Silent fail - zaten corrupted
    }
  }

  // Rate limiting metodları
  bool _checkRateLimit(String operation) {
    final now = DateTime.now();
    final key = operation;

    if (!_requestHistory.containsKey(key)) {
      _requestHistory[key] = [];
    }

    final requests = _requestHistory[key]!;

    // 1 dakikadan eski istekleri temizle
    requests.removeWhere(
      (time) => now.difference(time) > const Duration(minutes: 1),
    );

    // Limit kontrolü
    if (requests.length >= _maxRequestsPerMinute) {
      return false;
    }

    // Yeni isteği ekle
    requests.add(now);
    return true;
  }

  // Güvenli hata loglama
  void _logSecureError(String operation, dynamic error) {
    // Production'da sensitive bilgileri loglama
    if (const bool.fromEnvironment('dart.vm.product')) {
      print('Güvenlik hatası: $operation işlemi başarısız');
    } else {
      // Development'ta detaylı hata
      print('Hata detayı [$operation]: $error');
    }
  }
}
