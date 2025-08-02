import 'package:arya/auth/service/auth_service.dart';
import 'package:flutter/material.dart';
import '../auth_constants.dart';

class RegisterViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  // Password visibility toggle
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  // Form validation
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AuthConstants.nameRequired;
    }
    if (value.trim().length < AuthConstants.minNameLength) {
      return AuthConstants.nameMinLength;
    }
    if (value.trim().length > AuthConstants.maxNameLength) {
      return 'Ad en fazla ${AuthConstants.maxNameLength} karakter olmalıdır';
    }
    return null;
  }

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
    if (value.length > AuthConstants.maxPasswordLength) {
      return AuthConstants.passwordMaxLength;
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AuthConstants.confirmPasswordRequired;
    }
    if (value != passwordController.text) {
      return AuthConstants.passwordsNotMatch;
    }
    return null;
  }

  // Register işlemi
  Future<bool> register() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (result.isSuccess) {
        _clearError();
        _setLoading(false);
        return true;
      } else {
        _setError(result.errorMessage ?? 'Kayıt işlemi başarısız');
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
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear form
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _clearError();
  }

  // Dispose
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Password reset işlemi
}
