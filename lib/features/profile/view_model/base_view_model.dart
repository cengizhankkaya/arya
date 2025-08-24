import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // Ortak hata yönetimi
  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Ortak başarı mesajı
  void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Loading state ile işlem yapma
  Future<T> withLoading<T>(Future<T> Function() operation) async {
    setLoading(true);
    try {
      return await operation();
    } finally {
      setLoading(false);
    }
  }
}
