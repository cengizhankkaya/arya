import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:auto_route/auto_route.dart';
import '../model/off_credentials_model.dart';
import '../repository/off_credentials_repository.dart';
import 'base_view_model.dart';

class OffCredentialsViewModel extends BaseViewModel {
  final IOffCredentialsRepository _repository;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  OffCredentialsModel? _credentials;
  OffCredentialsModel? get credentials => _credentials;

  OffCredentialsViewModel({IOffCredentialsRepository? repository})
    : _repository = repository ?? OffCredentialsRepository();

  GlobalKey<FormState> get formKey => _formKey;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> load() async {
    try {
      setLoading(true);
      _credentials = await _repository.getCredentials();

      if (_credentials != null) {
        usernameController.text = _credentials!.username;
        passwordController.text = _credentials!.password;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Credentials yüklenirken hata: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<bool> save() async {
    if (!_formKey.currentState!.validate()) return false;

    return await withLoading(() async {
      try {
        final newCredentials = OffCredentialsModel(
          username: usernameController.text.trim(),
          password: passwordController.text.trim(),
        );

        final success = await _repository.saveCredentials(newCredentials);
        if (success) {
          _credentials = newCredentials;
          notifyListeners();
        }
        return success;
      } catch (e) {
        debugPrint('Credentials kaydedilirken hata: $e');
        return false;
      }
    });
  }

  Future<void> clear() async {
    try {
      setLoading(true);
      await _repository.clearCredentials();
      _credentials = null;
      usernameController.clear();
      passwordController.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Credentials temizlenirken hata: $e');
    } finally {
      setLoading(false);
    }
  }

  // UI işlemleri için metodlar
  Future<void> handleSave(BuildContext context) async {
    final success = await save();

    if (success) {
      showSuccess(context, 'off.saved'.tr());
      context.router.pop();
    } else {
      showError(context, 'off.save_failed'.tr());
    }
  }

  Future<void> handleClear(BuildContext context) async {
    await clear();
    showSuccess(context, 'off.cleared'.tr());
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'off.required_username'.tr();
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'off.required_password'.tr();
    }
    return null;
  }

  // State getters
  bool get hasCredentials => _credentials != null;
  bool get isFormValid =>
      usernameController.text.trim().isNotEmpty &&
      passwordController.text.trim().isNotEmpty;
}
