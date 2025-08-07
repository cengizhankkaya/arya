import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:arya/features/index.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isEditing = false;

  // TextEditingController'lar
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final usernameController = TextEditingController();

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEditing => _isEditing;
  bool get hasUser => _user != null;
  bool get isUserComplete => _user?.isComplete ?? false;

  /// Kullanıcı verisini Firestore'dan çek
  Future<void> fetchUser() async {
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

  /// Controller'lara veriyi yükle
  void _initializeControllers() {
    nameController.text = _user?.name ?? '';
    surnameController.text = _user?.surname ?? '';
    usernameController.text = _user?.username ?? '';
  }

  /// Kullanıcı verilerini controller'lardan güncelle
  Future<void> updateUserFromControllers() async {
    await updateUser(
      name: nameController.text.trim(),
      surname: surnameController.text.trim(),
      username: usernameController.text.trim(),
    );
  }

  /// Kullanıcı verilerini parametrelerle güncelle
  Future<void> updateUser({
    String? name,
    String? surname,
    String? username,
  }) async {
    if (_user == null) {
      _setError("Güncellenecek kullanıcı verisi bulunamadı.");
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final updatedUser = _user!.copyWith(
        name: name,
        surname: surname,
        username: username,
      );

      await _userService.updateUserData(updatedUser);
      _user = updatedUser;
      _isEditing = false;
      _initializeControllers(); // güncellenmiş verileri tekrar yükle
      notifyListeners();
    } catch (e) {
      _setError("Kullanıcı verisi güncellenirken hata oluştu: ${e.toString()}");
    } finally {
      _setLoading(false);
    }
  }

  void toggleEditMode() {
    _isEditing = !_isEditing;
    if (!_isEditing) {
      _clearError();
    }
    notifyListeners();
  }

  Future<void> signOut() async {
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
    _clearError();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    usernameController.dispose();
    super.dispose();
  }
}
