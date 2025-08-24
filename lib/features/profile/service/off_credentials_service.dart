import 'package:arya/product/utility/storage/app_prefs.dart';
import '../model/off_credentials_model.dart';

abstract class IOffCredentialsService {
  Future<OffCredentialsModel?> getCredentials();
  Future<bool> saveCredentials(OffCredentialsModel credentials);
  Future<bool> clearCredentials();
}

class OffCredentialsService implements IOffCredentialsService {
  @override
  Future<OffCredentialsModel?> getCredentials() async {
    try {
      final username = await AppPrefs.getOffUsername();
      final password = await AppPrefs.getOffPassword();

      if (username != null && password != null) {
        return OffCredentialsModel(username: username, password: password);
      }
      return null;
    } catch (e) {
      throw Exception('Credentials yüklenirken hata: $e');
    }
  }

  @override
  Future<bool> saveCredentials(OffCredentialsModel credentials) async {
    try {
      await AppPrefs.setOffCredentials(
        username: credentials.username,
        password: credentials.password,
      );
      return true;
    } catch (e) {
      throw Exception('Credentials kaydedilirken hata: $e');
    }
  }

  @override
  Future<bool> clearCredentials() async {
    try {
      await AppPrefs.clearOffCredentials();
      return true;
    } catch (e) {
      throw Exception('Credentials temizlenirken hata: $e');
    }
  }
}
