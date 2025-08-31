import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService;
  final UserService _userService;

  RegisterViewModel({
    FirebaseAuthService? authService,
    UserService? userService,
  }) : _authService = authService ?? FirebaseAuthService(),
       _userService = userService ?? UserService();

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
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

  // Password visibility toggles
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  // Form validation methods
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'auth.validators.name_required'.tr();
    }
    if (value.trim().length < AuthConstants.minNameLength) {
      return 'auth.validators.name_min_length'.tr(
        args: [AuthConstants.minNameLength.toString()],
      );
    }
    if (value.trim().length > AuthConstants.maxNameLength) {
      return 'auth.validators.name_max_length'.tr(
        args: [AuthConstants.maxNameLength.toString()],
      );
    }
    return null;
  }

  String? validateSurname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'auth.validators.surname_required'.tr();
    }
    if (value.trim().length < AuthConstants.minNameLength) {
      return 'auth.validators.surname_min_length'.tr(
        args: [AuthConstants.minNameLength.toString()],
      );
    }
    if (value.trim().length > AuthConstants.maxNameLength) {
      return 'auth.validators.surname_max_length'.tr(
        args: [AuthConstants.maxNameLength.toString()],
      );
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'auth.validators.email_required'.tr();
    }
    if (!AuthConstants.emailRegex.hasMatch(value.trim())) {
      return 'auth.validators.email_invalid'.tr();
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'auth.validators.password_required'.tr();
    }
    if (value.length < AuthConstants.minPasswordLength) {
      return 'auth.validators.password_min_length'.tr(
        args: [AuthConstants.minPasswordLength.toString()],
      );
    }
    if (value.length > AuthConstants.maxPasswordLength) {
      return 'auth.validators.password_max_length'.tr(
        args: [AuthConstants.maxPasswordLength.toString()],
      );
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'auth.validators.confirm_password_required'.tr();
    }
    if (value != passwordController.text) {
      return 'auth.validators.passwords_not_match'.tr();
    }
    return null;
  }

  // Register işlemi - MVVM mimarisine uygun
  Future<bool> register() async {
    // Form validation'ı güvenli şekilde kontrol et
    final formState = formKey.currentState;
    if (formState != null && !formState.validate()) {
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      // 1. Firebase Auth ile kullanıcı oluştur
      final authResult = await _authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!authResult.isSuccess) {
        _setError(authResult.errorMessage ?? 'Kayıt işlemi başarısız');
        _setLoading(false);
        return false;
      }

      // 2. Kullanıcı bilgilerini UserModel'e dönüştür
      final user = UserModel(
        uid: authResult.userCredential?.user?.uid ?? '',
        name: nameController.text.trim(),
        surname: surnameController.text.trim(),
        email: emailController.text.trim(),
      );

      // 3. Firestore'a kullanıcı verilerini kaydet
      await _userService.createDataUser(user);

      _clearError();
      _setLoading(false);
      return true;
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
    nameController.clear();
    surnameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _clearError();
  }

  // Dispose
  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
