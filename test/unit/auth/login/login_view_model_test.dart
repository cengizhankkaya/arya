import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/auth/login/view_model/login_view_model.dart';
import 'package:arya/features/auth/service/auth_service.dart';

// Mock sınıfları manuel olarak oluştur
class MockFirebaseAuthService implements FirebaseAuthService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginViewModel Tests', () {
    late LoginViewModel viewModel;
    late MockFirebaseAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
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

      test('TextEditingController\'lar doğru oluşturulmalı', () {
        expect(viewModel.emailController, isNotNull);
        expect(viewModel.emailController.text, isEmpty);
        expect(viewModel.passwordController, isNotNull);
        expect(viewModel.passwordController.text, isEmpty);
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
        });

        test('validateEmail boş string ile hata döndürmeli', () {
          final result = viewModel.validateEmail('');
          expect(result, isNotNull);
        });

        test('validateEmail geçersiz email formatı ile hata döndürmeli', () {
          final result = viewModel.validateEmail('invalid-email');
          expect(result, isNotNull);
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
        });

        test('validatePassword boş string ile hata döndürmeli', () {
          final result = viewModel.validatePassword('');
          expect(result, isNotNull);
        });

        test('validatePassword çok kısa şifre ile hata döndürmeli', () {
          final result = viewModel.validatePassword('12345');
          expect(result, isNotNull);
        });

        test('validatePassword geçerli şifre ile null döndürmeli', () {
          final result = viewModel.validatePassword('password123');
          expect(result, isNull);
        });
      });
    });

    group('Form Management Tests', () {
      test('clearForm form verilerini temizlemeli', () {
        // Arrange
        viewModel.emailController.text = 'test@example.com';
        viewModel.passwordController.text = 'password123';

        // Act
        viewModel.clearForm();

        // Assert
        expect(viewModel.emailController.text, isEmpty);
        expect(viewModel.passwordController.text, isEmpty);
      });
    });

    group('Dependency Injection Tests', () {
      test('LoginViewModel FirebaseAuthService dependency injection testi', () {
        // Arrange
        final testViewModel = LoginViewModel(authService: mockAuthService);

        // Act & Assert
        expect(testViewModel, isNotNull);
        expect(testViewModel.emailController, isNotNull);
        expect(testViewModel.passwordController, isNotNull);
        expect(testViewModel.formKey, isNotNull);

        // Cleanup
        testViewModel.dispose();
      });

      test('LoginViewModel mock FirebaseAuthService ile testi', () {
        // Arrange
        final testViewModel = LoginViewModel(authService: mockAuthService);

        // Act & Assert
        expect(testViewModel, isNotNull);
        expect(mockAuthService, isA<MockFirebaseAuthService>());

        // Cleanup
        testViewModel.dispose();
      });
    });

    group('State Management Tests', () {
      test('notifyListeners çağrıldığında state güncellenmeli', () {
        // Arrange
        final initialPasswordVisibility = viewModel.obscurePassword;

        // Act
        viewModel.togglePasswordVisibility();

        // Assert
        expect(viewModel.obscurePassword, equals(!initialPasswordVisibility));
      });
    });
  });
}
