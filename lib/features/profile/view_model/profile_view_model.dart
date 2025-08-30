import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:arya/features/index.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserService _userService;

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isEditing = false;
  bool _isDisposed = false;

  final nameController = TextEditingController();
  final surnameController = TextEditingController();

  // Constructor with dependency injection
  ProfileViewModel({UserService? userService})
    : _userService = userService ?? UserService();

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEditing => _isEditing;
  bool get hasUser => _user != null;
  bool get isUserComplete => _user?.isComplete ?? false;

  Future<void> fetchUser() async {
    if (_isDisposed) return;
    _setLoading(true);
    _clearError();

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        _setError("Kullanıcı oturumu bulunamadı.");
        return;
      }

      _user = await _userService.getUserData(uid);
      if (_user == null) {
        _setError("Kullanıcı verisi bulunamadı.");
      } else {
        _initializeControllers();
      }
    } catch (e) {
      _setError("Kullanıcı verisi yüklenirken hata oluştu: ${e.toString()}");
    } finally {
      _setLoading(false);
    }
  }

  void _initializeControllers() {
    if (_isDisposed) return;
    nameController.text = _user?.name ?? '';
    surnameController.text = _user?.surname ?? '';
  }

  Future<void> updateUserFromControllers() async {
    if (_isDisposed) return;
    await updateUser(
      name: nameController.text.trim(),
      surname: surnameController.text.trim(),
    );
  }

  Future<void> updateUser({String? name, String? surname}) async {
    if (_isDisposed) return;
    if (_user == null) {
      _setError("Güncellenecek kullanıcı verisi bulunamadı.");
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final updatedUser = _user!.copyWith(name: name, surname: surname);

      await _userService.updateUserData(updatedUser);
      _user = updatedUser;
      _isEditing = false;
      _initializeControllers();
      _notifySafely();
    } catch (e) {
      _setError("Kullanıcı verisi güncellenirken hata oluştu: ${e.toString()}");
    } finally {
      _setLoading(false);
    }
  }

  void toggleEditMode() {
    if (_isDisposed) return;
    _isEditing = !_isEditing;
    if (!_isEditing) {
      _clearError();
    }
    _notifySafely();
  }

  Future<void> signOut() async {
    if (_isDisposed) return;
    _setLoading(true);
    try {
      await FirebaseAuth.instance.signOut();
      _user = null;
      _isEditing = false;
      _clearError();
    } catch (e) {
      _setError("Çıkış yapılırken hata oluştu: ${e.toString()}");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteAccount() async {
    if (_isDisposed) return;
    if (_user?.uid == null) {
      _setError("Silinecek kullanıcı verisi bulunamadı.");
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      await _userService.deleteUserData(_user!.uid!);
      await FirebaseAuth.instance.currentUser?.delete();

      _user = null;
      _isEditing = false;
    } catch (e) {
      _setError("Hesap silinirken hata oluştu: ${e.toString()}");
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    if (_isDisposed) return;
    _clearError();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _notifySafely();
  }

  void _setError(String error) {
    _errorMessage = error;
    _notifySafely();
  }

  void _clearError() {
    _errorMessage = null;
    _notifySafely();
  }

  @override
  void dispose() {
    _isDisposed = true;
    nameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  void _notifySafely() {
    if (_isDisposed) return;
    notifyListeners();
  }
}
