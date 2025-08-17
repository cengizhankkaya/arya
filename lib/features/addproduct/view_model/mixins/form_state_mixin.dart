import 'package:flutter/material.dart';

mixin FormStateMixin on ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    _successMessage = null;
    setLoading(false);
    notifyListeners();
  }

  void setSuccess(String message) {
    _successMessage = message;
    _errorMessage = null;
    setLoading(false);
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
