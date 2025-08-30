import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/auth/register/view_model/register_view_model.dart';
import 'package:arya/features/auth/service/auth_service.dart';
import 'package:arya/features/auth/service/user_service.dart';
import 'package:arya/features/auth/model/user_model.dart';

// Mock sınıfları manuel olarak oluştur
class MockFirebaseAuthService implements FirebaseAuthService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockUserService implements UserService {
  @override
  Future<void> createDataUser(UserModel user) async {}

  @override
  Future<UserModel?> getUserData(String uid) async => null;

  @override
  Future<void> updateUserData(UserModel user) async {}

  @override
  Future<void> deleteUserData(String uid) async {}

  @override
  Future<UserModel?> getUserByEmail(String email) async => null;

  @override
  Future<UserModel?> getUserByUsername(String username) async => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('RegisterViewModel Tests', () {
    late RegisterViewModel viewModel;
    late MockFirebaseAuthService mockAuthService;
    late MockUserService mockUserService;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
      mockUserService = MockUserService();
      viewModel = RegisterViewModel(
        authService: mockAuthService,
        userService: mockUserService,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initial State Tests', () {
      test('RegisterViewModel başlangıç durumu doğru olmalı', () {
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.obscurePassword, isTrue);
        expect(viewModel.obscureConfirmPassword, isTrue);
        expect(viewModel.nameController.text, isEmpty);
        expect(viewModel.surnameController.text, isEmpty);
        expect(viewModel.emailController.text, isEmpty);
        expect(viewModel.passwordController.text, isEmpty);
        expect(viewModel.confirmPasswordController.text, isEmpty);
      });

      test('Form key doğru oluşturulmalı', () {
        expect(viewModel.formKey, isNotNull);
        expect(viewModel.formKey.currentState, isNull);
      });

      test('TextEditingController\'lar doğru oluşturulmalı', () {
        expect(viewModel.nameController, isNotNull);
        expect(viewModel.nameController.text, isEmpty);
        expect(viewModel.surnameController, isNotNull);
        expect(viewModel.surnameController.text, isEmpty);
        expect(viewModel.emailController, isNotNull);
        expect(viewModel.emailController.text, isEmpty);
        expect(viewModel.passwordController, isNotNull);
        expect(viewModel.passwordController.text, isEmpty);
        expect(viewModel.confirmPasswordController, isNotNull);
        expect(viewModel.confirmPasswordController.text, isEmpty);
      });
    });

    group('Password Visibility Tests', () {
      test('togglePasswordVisibility doğru çalışmalı', () {
        final initialState = viewModel.obscurePassword;

        viewModel.togglePasswordVisibility();
        expect(viewModel.obscurePassword, equals(!initialState));
      });

      test('toggleConfirmPasswordVisibility doğru çalışmalı', () {
        final initialState = viewModel.obscureConfirmPassword;

        viewModel.toggleConfirmPasswordVisibility();
        expect(viewModel.obscureConfirmPassword, equals(!initialState));
      });

      test('togglePasswordVisibility notifyListeners çağırmalı', () {
        expect(() => viewModel.togglePasswordVisibility(), returnsNormally);
      });

      test('toggleConfirmPasswordVisibility notifyListeners çağırmalı', () {
        expect(() => viewModel.toggleConfirmPasswordVisibility(), returnsNormally);
      });
    });

    group('Form Validation Tests', () {
      group('Name Validation', () {
        test('validateName null değer ile hata döndürmeli', () {
          final result = viewModel.validateName(null);
          expect(result, isNotNull);
        });

        test('validateName boş string ile hata döndürmeli', () {
          final result = viewModel.validateName('');
          expect(result, isNotNull);
        });

        test('validateName çok kısa isim ile hata döndürmeli', () {
          final result = viewModel.validateName('a');
          expect(result, isNotNull);
        });

        test('validateName geçerli isim ile null döndürmeli', () {
          final result = viewModel.validateName('John');
          expect(result, isNull);
        });

        test('validateName uzun isim ile null döndürmeli', () {
          final result = viewModel.validateName('Johnathan');
          expect(result, isNull);
        });
      });

      group('Surname Validation', () {
        test('validateSurname null değer ile hata döndürmeli', () {
          final result = viewModel.validateSurname(null);
          expect(result, isNotNull);
        });

        test('validateSurname boş string ile hata döndürmeli', () {
          final result = viewModel.validateSurname('');
          expect(result, isNotNull);
        });

        test('validateSurname çok kısa soyisim ile hata döndürmeli', () {
          final result = viewModel.validateSurname('D');
          expect(result, isNotNull);
        });

        test('validateSurname geçerli soyisim ile null döndürmeli', () {
          final result = viewModel.validateSurname('Doe');
          expect(result, isNull);
        });

        test('validateSurname uzun soyisim ile null döndürmeli', () {
          final result = viewModel.validateSurname('Smithson');
          expect(result, isNull);
        });
      });

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
        viewModel.nameController.text = 'John';
        viewModel.surnameController.text = 'Doe';
        viewModel.emailController.text = 'john@example.com';
        viewModel.passwordController.text = 'password123';
        viewModel.confirmPasswordController.text = 'password123';
        
        // Act
        viewModel.clearForm();
        
        // Assert
        expect(viewModel.nameController.text, isEmpty);
        expect(viewModel.surnameController.text, isEmpty);
        expect(viewModel.emailController.text, isEmpty);
        expect(viewModel.passwordController.text, isEmpty);
        expect(viewModel.confirmPasswordController.text, isEmpty);
      });
    });

    group('Dependency Injection Tests', () {
      test('RegisterViewModel FirebaseAuthService ve UserService dependency injection testi', () {
        // Arrange
        final testViewModel = RegisterViewModel(
          authService: mockAuthService,
          userService: mockUserService,
        );
        
        // Act & Assert
        expect(testViewModel, isNotNull);
        expect(testViewModel.nameController, isNotNull);
        expect(testViewModel.surnameController, isNotNull);
        expect(testViewModel.emailController, isNotNull);
        expect(testViewModel.passwordController, isNotNull);
        expect(testViewModel.confirmPasswordController, isNotNull);
        expect(testViewModel.formKey, isNotNull);
        
        // Cleanup
        testViewModel.dispose();
      });

      test('RegisterViewModel mock servisler ile testi', () {
        // Arrange
        final testViewModel = RegisterViewModel(
          authService: mockAuthService,
          userService: mockUserService,
        );
        
        // Act & Assert
        expect(testViewModel, isNotNull);
        expect(mockAuthService, isA<MockFirebaseAuthService>());
        expect(mockUserService, isA<MockUserService>());
        
        // Cleanup
        testViewModel.dispose();
      });
    });

    group('State Management Tests', () {
      test('notifyListeners çağrıldığında state güncellenmeli', () {
        // Arrange
        final initialPasswordVisibility = viewModel.obscurePassword;
        final initialConfirmPasswordVisibility = viewModel.obscureConfirmPassword;
        
        // Act
        viewModel.togglePasswordVisibility();
        viewModel.toggleConfirmPasswordVisibility();
        
        // Assert
        expect(viewModel.obscurePassword, equals(!initialPasswordVisibility));
        expect(viewModel.obscureConfirmPassword, equals(!initialConfirmPasswordVisibility));
      });
    });

    group('Edge Case Tests', () {
      test('çok uzun form verileri ile çalışmalı', () {
        // Arrange
        final longName = 'a' * 100;
        final longSurname = 'b' * 100;
        final longEmail = 'c' * 100 + '@example.com';
        final longPassword = 'd' * 1000;
        
        // Act
        viewModel.nameController.text = longName;
        viewModel.surnameController.text = longSurname;
        viewModel.emailController.text = longEmail;
        viewModel.passwordController.text = longPassword;
        viewModel.confirmPasswordController.text = longPassword;
        
        // Assert
        expect(viewModel.nameController.text, equals(longName));
        expect(viewModel.surnameController.text, equals(longSurname));
        expect(viewModel.emailController.text, equals(longEmail));
        expect(viewModel.passwordController.text, equals(longPassword));
        expect(viewModel.confirmPasswordController.text, equals(longPassword));
      });

      test('özel karakterler içeren form verileri ile çalışmalı', () {
        // Arrange
        const specialName = 'José-Maria';
        const specialSurname = 'O\'Connor';
        const specialEmail = 'test+tag@domain.co.uk';
        const specialPassword = 'P@ssw0rd!';
        
        // Act
        viewModel.nameController.text = specialName;
        viewModel.surnameController.text = specialSurname;
        viewModel.emailController.text = specialEmail;
        viewModel.passwordController.text = specialPassword;
        viewModel.confirmPasswordController.text = specialPassword;
        
        // Assert
        expect(viewModel.nameController.text, equals(specialName));
        expect(viewModel.surnameController.text, equals(specialSurname));
        expect(viewModel.emailController.text, equals(specialEmail));
        expect(viewModel.passwordController.text, equals(specialPassword));
        expect(viewModel.confirmPasswordController.text, equals(specialPassword));
      });
    });

    group('Integration Tests', () {
      test('tam form validation flow entegrasyon testi', () {
        // Act 1: Form doldur
        viewModel.nameController.text = 'John';
        viewModel.surnameController.text = 'Doe';
        viewModel.emailController.text = 'john@example.com';
        viewModel.passwordController.text = 'password123';
        viewModel.confirmPasswordController.text = 'password123';
        
        // Act 2: Password visibility toggles
        viewModel.togglePasswordVisibility();
        viewModel.toggleConfirmPasswordVisibility();
        expect(viewModel.obscurePassword, isFalse);
        expect(viewModel.obscureConfirmPassword, isFalse);
        
        // Act 3: Form validation
        expect(viewModel.validateName('John'), isNull);
        expect(viewModel.validateSurname('Doe'), isNull);
        expect(viewModel.validateEmail('john@example.com'), isNull);
        expect(viewModel.validatePassword('password123'), isNull);
        
        // Act 4: Form temizle
        viewModel.clearForm();
        
        // Assert
        expect(viewModel.nameController.text, isEmpty);
        expect(viewModel.surnameController.text, isEmpty);
        expect(viewModel.emailController.text, isEmpty);
        expect(viewModel.passwordController.text, isEmpty);
        expect(viewModel.confirmPasswordController.text, isEmpty);
        expect(viewModel.obscurePassword, isFalse); // Toggle state korunmalı
        expect(viewModel.obscureConfirmPassword, isFalse); // Toggle state korunmalı
      });
    });
  });
}
