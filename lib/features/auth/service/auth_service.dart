import 'package:arya/product/index.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service class responsible for handling all Firebase Authentication operations.
/// This service provides a clean abstraction layer over Firebase Auth SDK,
/// offering simplified authentication methods with proper error handling
/// and localized error messages.
///
/// The service implements the following authentication flows:
/// - User sign-in with email/password
/// - User registration with email/password
/// - User sign-out
/// - Authentication state monitoring
///
/// Error handling is centralized and provides user-friendly Turkish messages
/// for common authentication scenarios.
///
/// Usage:
/// ```dart
/// final authService = FirebaseAuthService();
/// final result = await authService.signIn(email: 'user@example.com', password: 'password');
/// if (result.isSuccess) {
///   // Handle successful authentication
/// } else {
///   // Handle authentication error
///   print(result.errorMessage);
/// }
/// ```
class FirebaseAuthService {
  /// Firebase Auth instance for performing authentication operations
  final FirebaseAuth _auth;

  /// Creates a new FirebaseAuthService instance.
  ///
  /// Parameters:
  /// - auth: FirebaseAuth instance to use for authentication operations
  ///         If not provided, defaults to FirebaseAuth.instance
  FirebaseAuthService({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  /// Returns the currently signed-in user, or null if no user is signed in.
  /// This getter provides immediate access to the current user's authentication state
  /// without requiring async operations.
  User? get currentUser => _auth.currentUser;

  /// Stream that emits authentication state changes.
  /// This stream is useful for:
  /// - Automatically updating UI when user signs in/out
  /// - Implementing authentication guards
  /// - Monitoring authentication state in real-time
  ///
  /// The stream emits:
  /// - User object when user is authenticated
  /// - null when user is not authenticated
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Authenticates a user with email and password credentials.
  /// This method handles the sign-in process and provides comprehensive error handling
  /// for various authentication failure scenarios.
  ///
  /// Parameters:
  /// - email: User's email address (automatically trimmed)
  /// - password: User's password
  ///
  /// Returns:
  /// - AuthResult.success with UserCredential on successful authentication
  /// - AuthResult.error with localized error message on failure
  ///
  /// Throws:
  /// - FirebaseAuthException for Firebase-specific errors
  /// - Generic exceptions for unexpected errors
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

  /// Creates a new user account with email and password credentials.
  /// This method handles the user registration process and provides comprehensive
  /// error handling for various registration failure scenarios.
  ///
  /// Parameters:
  /// - email: User's email address (automatically trimmed)
  /// - password: User's password (must meet Firebase security requirements)
  ///
  /// Returns:
  /// - AuthResult.success with UserCredential on successful registration
  /// - AuthResult.error with localized error message on failure
  ///
  /// Throws:
  /// - FirebaseAuthException for Firebase-specific errors
  /// - Generic exceptions for unexpected errors
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

  /// Signs out the currently authenticated user.
  /// This method clears the user's authentication session and returns them
  /// to an unauthenticated state.
  ///
  /// After calling this method:
  /// - currentUser will return null
  /// - authStateChanges stream will emit null
  /// - User will need to re-authenticate to access protected resources
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Sends a password reset email to the specified email address.
  /// This method triggers Firebase's password reset flow, which sends
  /// an email with a link to reset the user's password.
  ///
  /// Parameters:
  /// - email: Email address to send the password reset email to
  ///
  /// Returns:
  /// - AuthResult.success if email was sent successfully
  /// - AuthResult.error with localized error message on failure
  ///
  /// Note: This method will always return success even if the email
  /// doesn't exist in the system (for security reasons)
  Future<AuthResult> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return AuthResult.success(null);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getPasswordResetErrorMessage(e.code));
    } catch (e) {
      return AuthResult.error('Beklenmeyen bir hata oluştu: $e');
    }
  }

  /// Maps Firebase authentication error codes to user-friendly Turkish messages.
  /// This method centralizes error message localization and provides consistent
  /// error messaging across the application.
  ///
  /// Parameters:
  /// - code: Firebase authentication error code
  ///
  /// Returns:
  /// - Localized Turkish error message for the given error code
  /// - Generic error message for unknown error codes
  ///
  /// Supported error codes:
  /// - userNotFound: User account doesn't exist
  /// - wrongPassword: Incorrect password
  /// - invalidEmail: Malformed email address
  /// - userDisabled: Account has been disabled
  /// - tooManyRequests: Rate limiting exceeded
  /// - networkRequestFailed: Network connectivity issues
  /// - invalidCredential: Invalid authentication credentials
  /// - emailAlreadyInUse: Email already registered
  /// - weakPassword: Password doesn't meet security requirements
  /// - operationNotAllowed: Authentication method disabled
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

  /// Maps Firebase password reset error codes to user-friendly Turkish messages.
  /// This method provides localized error messages specifically for password reset operations.
  ///
  /// Parameters:
  /// - code: Firebase authentication error code
  ///
  /// Returns:
  /// - Localized Turkish error message for the given error code
  /// - Generic error message for unknown error codes
  ///
  /// Supported error codes:
  /// - invalidEmail: Malformed email address
  /// - userNotFound: User account doesn't exist
  /// - tooManyRequests: Rate limiting exceeded
  /// - networkRequestFailed: Network connectivity issues
  String _getPasswordResetErrorMessage(String code) {
    switch (code) {
      case AuthConstants.invalidEmail:
        return 'Geçersiz e-posta adresi';
      case AuthConstants.userNotFound:
        return 'Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı';
      case AuthConstants.tooManyRequests:
        return 'Çok fazla istek gönderildi. Lütfen daha sonra tekrar deneyin';
      case AuthConstants.networkRequestFailed:
        return 'İnternet bağlantınızı kontrol edin';
      default:
        return 'Şifre sıfırlama e-postası gönderilemedi';
    }
  }
}

/// Result wrapper class for authentication operations.
/// This class provides a consistent way to handle both successful and failed
/// authentication attempts, encapsulating the result data and error information.
///
/// The class follows the Result pattern commonly used in functional programming
/// to handle operations that can succeed or fail, providing type safety and
/// clear error handling patterns.
///
/// Usage:
/// ```dart
/// final result = await authService.signIn(email: 'user@example.com', password: 'password');
/// if (result.isSuccess) {
///   final user = result.userCredential?.user;
///   // Handle successful authentication
/// } else {
///   final error = result.errorMessage;
///   // Handle authentication error
/// }
/// ```
class AuthResult {
  /// Indicates whether the authentication operation was successful
  final bool isSuccess;

  /// Error message describing the authentication failure (null if successful)
  final String? errorMessage;

  /// Firebase UserCredential containing user authentication data (null if failed)
  final UserCredential? userCredential;

  /// Private constructor to enforce factory pattern usage
  AuthResult._({
    required this.isSuccess,
    this.errorMessage,
    this.userCredential,
  });

  /// Factory constructor for successful authentication results.
  /// Creates an AuthResult instance indicating successful authentication
  /// with the provided UserCredential data.
  ///
  /// Parameters:
  /// - userCredential: Firebase UserCredential from successful authentication
  ///
  /// Returns:
  /// - AuthResult instance with isSuccess = true
  factory AuthResult.success(UserCredential? userCredential) {
    return AuthResult._(isSuccess: true, userCredential: userCredential);
  }

  /// Factory constructor for failed authentication results.
  /// Creates an AuthResult instance indicating authentication failure
  /// with the provided error message.
  ///
  /// Parameters:
  /// - errorMessage: Description of the authentication failure
  ///
  /// Returns:
  /// - AuthResult instance with isSuccess = false
  factory AuthResult.error(String errorMessage) {
    return AuthResult._(isSuccess: false, errorMessage: errorMessage);
  }
}
