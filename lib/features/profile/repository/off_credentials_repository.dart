import '../model/off_credentials_model.dart';
import '../service/off_credentials_service.dart';

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
      // Repository seviyesinde ek güvenlik kontrolü
      final credentials = await _service.getCredentials();

      // Null safety ve format kontrolü
      if (credentials != null && !_validateRepositoryLevel(credentials)) {
        // Corrupted data tespit edildi, temizle
        await _service.clearCredentials();
        return null;
      }

      return credentials;
    } catch (e) {
      // Repository seviyesinde güvenli hata işleme
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
        throw Exception(
          'Credentials security requirements not met at repository level',
        );
      }

      return await _service.saveCredentials(credentials);
    } catch (e) {
      // Repository seviyesinde güvenli hata işleme
      _logRepositoryError('saveCredentials', e);
      rethrow;
    }
  }

  @override
  Future<bool> clearCredentials() async {
    try {
      return await _service.clearCredentials();
    } catch (e) {
      // Repository seviyesinde güvenli hata işleme
      _logRepositoryError('clearCredentials', e);
      rethrow;
    }
  }

  // Repository seviyesinde ek güvenlik metodları
  bool _validateRepositoryLevel(OffCredentialsModel credentials) {
    // Null kontrolü
    if (credentials.username.isEmpty || credentials.password.isEmpty) {
      return false;
    }

    // Uzunluk kontrolü
    if (credentials.username.length < 3 ||
        credentials.username.length > 50 ||
        credentials.password.length < 8 ||
        credentials.password.length > 128) {
      return false;
    }

    // Format kontrolü
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

    // En az bir özel karakter (basit karakter seti)
    if (!RegExp(r'[!@#$%^&*()_+\-=\[\]{}:;<>,.?]').hasMatch(password))
      return false;

    return true;
  }

  // Repository seviyesinde güvenli hata loglama
  void _logRepositoryError(String operation, dynamic error) {
    // Production'da sensitive bilgileri loglama
    if (const bool.fromEnvironment('dart.vm.product')) {
      print('Repository güvenlik hatası: $operation işlemi başarısız');
    } else {
      // Development'ta detaylı hata
      print('Repository hata detayı [$operation]: $error');
    }
  }
}
