import 'package:arya/features/index.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _isDisposed = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;

  // Password visibility toggle
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    _notifySafely();
  }

  // Form validation
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AuthConstants.emailRequired;
    }
    if (!AuthConstants.emailRegex.hasMatch(value.trim())) {
      return AuthConstants.emailInvalid;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AuthConstants.passwordRequired;
    }
    if (value.length < AuthConstants.minPasswordLength) {
      return AuthConstants.passwordMinLength;
    }
    return null;
  }

  // Login işlemi
  Future<bool> login() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (_isDisposed) return false;

      if (result.isSuccess) {
        _clearError();
        _setLoading(false);
        return true;
      } else {
        _setError(result.errorMessage ?? 'Giriş işlemi başarısız');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Beklenmeyen bir hata oluştu: $e');
      _setLoading(false);
      return false;
    }
  }

  // State management methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    _notifySafely();
  }

  void _setError(String message) {
    _errorMessage = message;
    _notifySafely();
  }

  void _clearError() {
    _errorMessage = null;
    _notifySafely();
  }

  void _notifySafely() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  // Clear form
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    _clearError();
  }

  // Dispose
  @override
  void dispose() {
    _isDisposed = true;
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
