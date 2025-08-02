class AuthConstants {
  // Route isimleri
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String splashRoute = '/splash';

  // Form validation mesajları
  static const String emailRequired = 'E-posta adresi gereklidir';
  static const String emailInvalid = 'Geçerli bir e-posta adresi giriniz';
  static const String passwordRequired = 'Şifre gereklidir';
  static const String passwordMinLength = 'Şifre en az 6 karakter olmalıdır';
  static const String passwordMaxLength =
      'Şifre en fazla 20 karakter olmalıdır';
  static const String nameRequired = 'Ad gereklidir';
  static const String nameMinLength = 'Ad en az 2 karakter olmalıdır';
  static const String confirmPasswordRequired = 'Şifre tekrarı gereklidir';
  static const String passwordsNotMatch = 'Şifreler eşleşmiyor';

  // Firebase Auth hata kodları
  static const String userNotFound = 'user-not-found';
  static const String wrongPassword = 'wrong-password';
  static const String invalidEmail = 'invalid-email';
  static const String userDisabled = 'user-disabled';
  static const String tooManyRequests = 'too-many-requests';
  static const String networkRequestFailed = 'network-request-failed';
  static const String invalidCredential = 'invalid-credential';
  static const String emailAlreadyInUse = 'email-already-in-use';
  static const String weakPassword = 'weak-password';
  static const String operationNotAllowed = 'operation-not-allowed';

  // UI metinleri
  static const String loginTitle = 'Giriş Yap';
  static const String registerTitle = 'Kayıt Ol';
  static const String emailHint = 'E-posta adresiniz';
  static const String passwordHint = 'Şifreniz';
  static const String nameHint = 'Adınız';
  static const String confirmPasswordHint = 'Şifrenizi tekrar giriniz';
  static const String loginButtonText = 'Giriş Yap';
  static const String registerButtonText = 'Kayıt Ol';
  static const String forgotPasswordText = 'Şifremi Unuttum';
  static const String noAccountText = 'Hesabınız yok mu?';
  static const String haveAccountText = 'Zaten hesabınız var mı?';
  static const String signUpText = 'Kayıt Ol';
  static const String signInText = 'Giriş Yap';

  // Loading mesajları
  static const String loggingIn = 'Giriş yapılıyor...';
  static const String registering = 'Kayıt olunuyor...';
  static const String signingOut = 'Çıkış yapılıyor...';

  // Başarı mesajları
  static const String loginSuccess = 'Başarıyla giriş yapıldı';
  static const String registerSuccess = 'Başarıyla kayıt olundu';
  static const String logoutSuccess = 'Başarıyla çıkış yapıldı';

  // Regex patterns
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{6,}$',
  );

  // Validation kuralları
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
}
