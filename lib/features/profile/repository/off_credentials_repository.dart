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
    return await _service.getCredentials();
  }

  @override
  Future<bool> saveCredentials(OffCredentialsModel credentials) async {
    return await _service.saveCredentials(credentials);
  }

  @override
  Future<bool> clearCredentials() async {
    return await _service.clearCredentials();
  }
}
