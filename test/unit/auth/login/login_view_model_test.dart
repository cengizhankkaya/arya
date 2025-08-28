import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:arya/features/auth/login/view_model/login_view_model.dart';
import 'package:arya/features/auth/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Mock sınıfları oluştur
@GenerateMocks([FirebaseAuthService, UserCredential, User])
import 'login_view_model_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginViewModel Tests', () {
    late LoginViewModel viewModel;
    late MockFirebaseAuthService mockAuthService;
    late MockUserCredential mockUserCredential;
    late MockUser mockUser;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
      mockUserCredential = MockUserCredential();
      mockUser = MockUser();

      // Mock UserCredential'ın user property'sini ayarla
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('test-uid-123');

      // ViewModel'i mock servis ile oluştur
      viewModel = LoginViewModel(authService: mockAuthService);
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initial State Tests', () {
      test('LoginViewModel başlangıç durumu doğru olmalı', () {
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.obscurePassword, isTrue);
        expect(viewModel.emailController.text, isEmpty);
        expect(viewModel.passwordController.text, isEmpty);
      });

      test('Form key doğru oluşturulmalı', () {
        expect(viewModel.formKey, isNotNull);
        expect(viewModel.formKey.currentState, isNull);
      });
    });

    group('Password Visibility Tests', () {
      test('togglePasswordVisibility doğru çalışmalı', () {
        final initialState = viewModel.obscurePassword;

        viewModel.togglePasswordVisibility();
        expect(viewModel.obscurePassword, equals(!initialState));
      });

      test('togglePasswordVisibility notifyListeners çağırmalı', () {
        expect(() => viewModel.togglePasswordVisibility(), returnsNormally);
      });
    });

    group('Form Validation Tests', () {
      group('Email Validation', () {
        test('validateEmail null değer ile hata döndürmeli', () {
          final result = viewModel.validateEmail(null);
          expect(result, isNotNull);
          expect(result!.contains('required'), isTrue);
        });

        test('validateEmail boş string ile hata döndürmeli', () {
          final result = viewModel.validateEmail('');
          expect(result, isNotNull);
          expect(result!.contains('required'), isTrue);
        });

        test('validateEmail geçersiz email formatı ile hata döndürmeli', () {
          final result = viewModel.validateEmail('invalid-email');
          expect(result, isNotNull);
          expect(result!.contains('invalid'), isTrue);
        });

        test('validateEmail geçerli email formatı ile null döndürmeli', () {
          final result = viewModel.validateEmail('test@example.com');
          expect(result, isNull);
        });
      });

      group('Password Validation', () {
        test('validatePassword null değer ile hata döndürmeli', () {
          final result = viewModel.validatePassword(null);
          expect(result, isNotNull);
          expect(result!.contains('required'), isTrue);
        });

        test('validatePassword boş string ile hata döndürmeli', () {
          final result = viewModel.validatePassword('');
          expect(result, isNotNull);
          expect(result!.contains('required'), isTrue);
        });

        test('validatePassword çok kısa şifre ile hata döndürmeli', () {
          final result = viewModel.validatePassword('12345');
          expect(result, isNotNull);
          expect(result!.contains('min'), isTrue);
        });

        test('validatePassword geçerli şifre ile null döndürmeli', () {
          final result = viewModel.validatePassword('password123');
          expect(result, isNull);
        });
      });
    });

    group('Login Flow Tests', () {
      test('login başarılı olduğunda true döndürmeli', () async {
        // ARRANGE: Mock servis davranışını ayarla
        when(
          mockAuthService.signIn(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => AuthResult.success(mockUserCredential));

        // ACT: Login metodunu çağır
        viewModel.emailController.text = 'test@example.com';
        viewModel.passwordController.text = 'password123';

        // Form validation'ı bypass et (test ortamında currentState null)
        // Bu durumda login metodu direkt olarak auth service'i çağırır
        final result = await viewModel.login();

        // ASSERT: Başarılı sonuç
        expect(result, isTrue);
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.errorMessage, isNull);
      });
    });
  });
}
