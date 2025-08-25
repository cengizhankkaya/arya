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

  static const int _maxSaveAttempts = 5;
  static const Duration _saveCooldown = Duration(minutes: 1);
  int _saveAttempts = 0;
  DateTime? _lastSaveAttempt;

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
      debugPrint('Credentials yüklenirken hata oluştu');
      _handleSecureError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<bool> save() async {
    if (!_formKey.currentState!.validate()) return false;

    if (!_checkRateLimit()) {
      return false;
    }

    return await withLoading(() async {
      try {
        final sanitizedUsername = _sanitizeInput(usernameController.text);
        final sanitizedPassword = _sanitizeInput(passwordController.text);

        if (!_validateSecurityRequirements(
          sanitizedUsername,
          sanitizedPassword,
        )) {
          return false;
        }

        final newCredentials = OffCredentialsModel(
          username: sanitizedUsername,
          password: sanitizedPassword,
        );

        final success = await _repository.saveCredentials(newCredentials);
        if (success) {
          _credentials = newCredentials;
          _updateRateLimit();
          notifyListeners();
        }
        return success;
      } catch (e) {
        debugPrint('Credentials kaydedilirken hata oluştu');
        _handleSecureError(e);
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
      debugPrint('Credentials temizlenirken hata oluştu');
      _handleSecureError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> handleSave(BuildContext context) async {
    final success = await save();

    if (success) {
      showSuccess(context, 'off.saved'.tr());
      context.router.pop();
    } else {
      if (!_checkRateLimit()) {
        showError(context, 'off.rate_limit_exceeded'.tr());
      } else {
        showError(context, 'off.save_failed'.tr());
      }
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

    final sanitizedValue = _sanitizeInput(value);
    if (sanitizedValue.length < 3) {
      return 'off.username_too_short'.tr();
    }

    if (sanitizedValue.length > 50) {
      return 'off.username_too_long'.tr();
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(sanitizedValue)) {
      return 'off.username_invalid_chars'.tr();
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'off.required_password'.tr();
    }

    final sanitizedValue = _sanitizeInput(value);
    if (sanitizedValue.length < 8) {
      return 'off.password_too_short'.tr();
    }

    if (sanitizedValue.length > 128) {
      return 'off.password_too_long'.tr();
    }

    if (!_isStrongPassword(sanitizedValue)) {
      return 'off.password_weak'.tr();
    }

    return null;
  }

  String _sanitizeInput(String input) {
    if (input.isEmpty) return input;

    String sanitized = input
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '')
        .replaceAll(RegExp(r'data:', caseSensitive: false), '')
        .replaceAll(RegExp(r'vbscript:', caseSensitive: false), '')
        .trim();

    sanitized = sanitized.replaceAll("'", "''");
    sanitized = sanitized.replaceAll('"', '""');

    return sanitized;
  }

  bool _validateSecurityRequirements(String username, String password) {
    if (username.toLowerCase() == password.toLowerCase()) {
      return false;
    }

    if (password.toLowerCase().contains(username.toLowerCase())) {
      return false;
    }

    return true;
  }

  bool _isStrongPassword(String password) {
    if (password.length < 8) return false;

    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;

    if (!RegExp(r'[a-z]').hasMatch(password)) return false;

    if (!RegExp(r'[0-9]').hasMatch(password)) return false;

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) return false;

    return true;
  }

  bool _checkRateLimit() {
    final now = DateTime.now();

    if (_lastSaveAttempt != null &&
        now.difference(_lastSaveAttempt!) > _saveCooldown) {
      _saveAttempts = 0;
      _lastSaveAttempt = null;
    }

    if (_saveAttempts >= _maxSaveAttempts) {
      return false;
    }

    return true;
  }

  void _updateRateLimit() {
    _saveAttempts++;
    _lastSaveAttempt = DateTime.now();
  }

  void _handleSecureError(dynamic error) {
    if (const bool.fromEnvironment('dart.vm.product')) {
      debugPrint('Güvenlik hatası: İşlem başarısız');
    } else {
      debugPrint('Hata detayı: $error');
    }
  }

  bool get hasCredentials => _credentials != null;
  bool get isFormValid =>
      usernameController.text.trim().isNotEmpty &&
      passwordController.text.trim().isNotEmpty;

  bool get isRateLimited => !_checkRateLimit();
  int get remainingAttempts => _maxSaveAttempts - _saveAttempts;
}
