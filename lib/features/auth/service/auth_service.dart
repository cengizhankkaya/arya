import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Mevcut kullanıcıyı alma
  User? get currentUser => _auth.currentUser;

  /// Kullanıcı durumu değişikliklerini dinleme
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Giriş yapma işlemi
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return AuthResult.success(userCredential);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e.code));
    } catch (e) {
      return AuthResult.error('Beklenmeyen bir hata oluştu: $e');
    }
  }

  /// Kayıt olma işlemi
  Future<AuthResult> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return AuthResult.success(userCredential);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e.code));
    } catch (e) {
      return AuthResult.error('Beklenmeyen bir hata oluştu: $e');
    }
  }

  /// Çıkış yapma işlemi
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Firebase hata kodlarını Türkçe mesajlara çevirme
  String _getErrorMessage(String code) {
    switch (code) {
      case AuthConstants.userNotFound:
        return 'Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı';
      case AuthConstants.wrongPassword:
        return 'Yanlış şifre';
      case AuthConstants.invalidEmail:
        return 'Geçersiz e-posta adresi';
      case AuthConstants.userDisabled:
        return 'Bu hesap devre dışı bırakılmış';
      case AuthConstants.tooManyRequests:
        return 'Çok fazla başarısız giriş denemesi. Lütfen daha sonra tekrar deneyin';
      case AuthConstants.networkRequestFailed:
        return 'İnternet bağlantınızı kontrol edin';
      case AuthConstants.invalidCredential:
        return 'Geçersiz kimlik bilgileri';
      case AuthConstants.emailAlreadyInUse:
        return 'Bu e-posta adresi zaten kullanımda';
      case AuthConstants.weakPassword:
        return 'Şifre çok zayıf. Daha güçlü bir şifre seçin';
      case AuthConstants.operationNotAllowed:
        return 'Bu işlem şu anda etkin değil';
      default:
        return 'Bir hata oluştu';
    }
  }
}

/// Authentication sonuç sınıfı
class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final UserCredential? userCredential;

  AuthResult._({
    required this.isSuccess,
    this.errorMessage,
    this.userCredential,
  });

  /// Başarılı sonuç
  factory AuthResult.success(UserCredential? userCredential) {
    return AuthResult._(isSuccess: true, userCredential: userCredential);
  }

  /// Hatalı sonuç
  factory AuthResult.error(String errorMessage) {
    return AuthResult._(isSuccess: false, errorMessage: errorMessage);
  }
}
