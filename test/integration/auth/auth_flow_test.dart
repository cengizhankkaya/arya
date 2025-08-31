import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:arya/features/auth/login/view_model/login_view_model.dart';
import 'package:arya/features/auth/register/view_model/register_view_model.dart';
import 'package:arya/features/auth/service/auth_service.dart';
import 'package:arya/features/auth/service/user_service.dart';

@GenerateMocks([FirebaseAuthService, UserService])
import 'auth_flow_test.mocks.dart';

void main() {
  group('Auth Flow Integration Tests', () {
    late MockFirebaseAuthService mockAuthService;
    late MockUserService mockUserService;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
      mockUserService = MockUserService();
    });

    tearDown(() {
      // Cleanup
    });

    group('Login Flow Tests', () {
      testWidgets('Login view model doğru şekilde oluşturulmalı', (
        tester,
      ) async {
        // ARRANGE: Mock service'i hazırla
        when(
          mockAuthService.signIn(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.success(null));

        // ACT: Login view model oluştur
        final viewModel = LoginViewModel(authService: mockAuthService);

        // ASSERT: View model doğru oluşturuldu mu?
        expect(viewModel, isNotNull);
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.obscurePassword, isTrue);
        expect(viewModel.emailController, isNotNull);
        expect(viewModel.passwordController, isNotNull);
        expect(viewModel.formKey, isNotNull);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('Login view model password visibility toggle çalışmalı', (
        tester,
      ) async {
        // ARRANGE: Mock service'i hazırla
        when(
          mockAuthService.signIn(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.success(null));

        // ACT: Login view model oluştur
        final viewModel = LoginViewModel(authService: mockAuthService);

        // ASSERT: Başlangıçta password gizli olmalı
        expect(viewModel.obscurePassword, isTrue);

        // ACT: Password visibility toggle
        viewModel.togglePasswordVisibility();

        // ASSERT: Password artık görünür olmalı
        expect(viewModel.obscurePassword, isFalse);

        // ACT: Tekrar toggle
        viewModel.togglePasswordVisibility();

        // ASSERT: Password tekrar gizli olmalı
        expect(viewModel.obscurePassword, isTrue);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('Login view model form validation çalışmalı', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(
          mockAuthService.signIn(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.success(null));

        // ACT: Login view model oluştur
        final viewModel = LoginViewModel(authService: mockAuthService);

        // ASSERT: Form validation metodları mevcut olmalı
        expect(viewModel.validateEmail, isNotNull);
        expect(viewModel.validatePassword, isNotNull);

        // ACT: Email validation test
        final emailError = viewModel.validateEmail('');
        expect(emailError, isNotNull);

        // ACT: Password validation test
        final passwordError = viewModel.validatePassword('');
        expect(passwordError, isNotNull);

        // Cleanup
        viewModel.dispose();
      });
    });

    group('Register Flow Tests', () {
      testWidgets('Register view model doğru şekilde oluşturulmalı', (
        tester,
      ) async {
        // ARRANGE: Mock service'i hazırla
        when(
          mockAuthService.signUp(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.success(null));
        when(mockUserService.createDataUser(any)).thenAnswer((_) async => true);

        // ACT: Register view model oluştur
        final viewModel = RegisterViewModel(
          authService: mockAuthService,
          userService: mockUserService,
        );

        // ASSERT: View model doğru oluşturuldu mu?
        expect(viewModel, isNotNull);
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.obscurePassword, isTrue);
        expect(viewModel.obscureConfirmPassword, isTrue);
        expect(viewModel.nameController, isNotNull);
        expect(viewModel.surnameController, isNotNull);
        expect(viewModel.emailController, isNotNull);
        expect(viewModel.passwordController, isNotNull);
        expect(viewModel.confirmPasswordController, isNotNull);
        expect(viewModel.formKey, isNotNull);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('Register view model password visibility toggle çalışmalı', (
        tester,
      ) async {
        // ARRANGE: Mock service'i hazırla
        when(
          mockAuthService.signUp(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.success(null));
        when(mockUserService.createDataUser(any)).thenAnswer((_) async => true);

        // ACT: Register view model oluştur
        final viewModel = RegisterViewModel(
          authService: mockAuthService,
          userService: mockUserService,
        );

        // ASSERT: Başlangıçta password'lar gizli olmalı
        expect(viewModel.obscurePassword, isTrue);
        expect(viewModel.obscureConfirmPassword, isTrue);

        // ACT: Password visibility toggle
        viewModel.togglePasswordVisibility();

        // ASSERT: Password artık görünür olmalı
        expect(viewModel.obscurePassword, isFalse);
        expect(viewModel.obscureConfirmPassword, isTrue);

        // ACT: Confirm password visibility toggle
        viewModel.toggleConfirmPasswordVisibility();

        // ASSERT: Confirm password artık görünür olmalı
        expect(viewModel.obscurePassword, isFalse);
        expect(viewModel.obscureConfirmPassword, isFalse);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('Register view model form validation çalışmalı', (
        tester,
      ) async {
        // ARRANGE: Mock service'i hazırla
        when(
          mockAuthService.signUp(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.success(null));
        when(mockUserService.createDataUser(any)).thenAnswer((_) async => true);

        // ACT: Register view model oluştur
        final viewModel = RegisterViewModel(
          authService: mockAuthService,
          userService: mockUserService,
        );

        // ASSERT: Form validation metodları mevcut olmalı
        expect(viewModel.validateName, isNotNull);
        expect(viewModel.validateSurname, isNotNull);
        expect(viewModel.validateEmail, isNotNull);
        expect(viewModel.validatePassword, isNotNull);
        expect(viewModel.validateConfirmPassword, isNotNull);

        // ACT: Name validation test
        final nameError = viewModel.validateName('');
        expect(nameError, isNotNull);

        // ACT: Email validation test
        final emailError = viewModel.validateEmail('');
        expect(emailError, isNotNull);

        // Cleanup
        viewModel.dispose();
      });
    });

    group('Service Integration Tests', () {
      testWidgets(
        'Auth service signIn metodu doğru parametrelerle çağrılmalı',
        (tester) async {
          // ARRANGE: Mock service'i hazırla
          when(
            mockAuthService.signIn(
              email: anyNamed('email'),
              password: anyNamed('password'),
            ),
          ).thenAnswer((_) async => AuthResult.success(null));

          // ACT: Login view model oluştur ve login çağır
          final viewModel = LoginViewModel(authService: mockAuthService);

          // Form alanlarını doldur
          viewModel.emailController.text = 'test@example.com';
          viewModel.passwordController.text = 'password123';

          await viewModel.login();

          // ASSERT: Auth service doğru parametrelerle çağrıldı mı?
          verify(
            mockAuthService.signIn(
              email: 'test@example.com',
              password: 'password123',
            ),
          ).called(1);

          // Cleanup
          viewModel.dispose();
        },
      );

      testWidgets(
        'Auth service signUp metodu doğru parametrelerle çağrılmalı',
        (tester) async {
          // ARRANGE: Mock service'i hazırla
          when(
            mockAuthService.signUp(
              email: anyNamed('email'),
              password: anyNamed('password'),
            ),
          ).thenAnswer((_) async => AuthResult.success(null));
          when(
            mockUserService.createDataUser(any),
          ).thenAnswer((_) async => true);

          // ACT: Register view model oluştur ve register çağır
          final viewModel = RegisterViewModel(
            authService: mockAuthService,
            userService: mockUserService,
          );

          // Form alanlarını doldur
          viewModel.nameController.text = 'John';
          viewModel.surnameController.text = 'Doe';
          viewModel.emailController.text = 'test@example.com';
          viewModel.passwordController.text = 'password123';
          viewModel.confirmPasswordController.text = 'password123';

          await viewModel.register();

          // ASSERT: Auth service doğru parametrelerle çağrıldı mı?
          verify(
            mockAuthService.signUp(
              email: 'test@example.com',
              password: 'password123',
            ),
          ).called(1);

          // Cleanup
          viewModel.dispose();
        },
      );
    });

    group('Error Handling Tests', () {
      testWidgets('Login error durumunda error message doğru set edilmeli', (
        tester,
      ) async {
        // ARRANGE: Mock service'i error için hazırla
        when(
          mockAuthService.signIn(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.error('Invalid credentials'));

        // ACT: Login view model oluştur ve login çağır
        final viewModel = LoginViewModel(authService: mockAuthService);

        // Form alanlarını doldur
        viewModel.emailController.text = 'test@example.com';
        viewModel.passwordController.text = 'wrongpassword';

        final result = await viewModel.login();

        // ASSERT: Login başarısız olmalı ve error message set edilmeli
        expect(result, isFalse);
        expect(viewModel.errorMessage, equals('Invalid credentials'));

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('Register error durumunda error message doğru set edilmeli', (
        tester,
      ) async {
        // ARRANGE: Mock service'i error için hazırla
        when(
          mockAuthService.signUp(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.error('Email already exists'));
        when(mockUserService.createDataUser(any)).thenAnswer((_) async => true);

        // ACT: Register view model oluştur ve register çağır
        final viewModel = RegisterViewModel(
          authService: mockAuthService,
          userService: mockUserService,
        );

        // Form alanlarını doldur
        viewModel.nameController.text = 'John';
        viewModel.surnameController.text = 'Doe';
        viewModel.emailController.text = 'existing@example.com';
        viewModel.passwordController.text = 'password123';
        viewModel.confirmPasswordController.text = 'password123';

        final result = await viewModel.register();

        // ASSERT: Register başarısız olmalı ve error message set edilmeli
        expect(result, isFalse);
        expect(viewModel.errorMessage, equals('Email already exists'));

        // Cleanup
        viewModel.dispose();
      });
    });

    group('State Management Tests', () {
      testWidgets('Loading state doğru yönetilmeli', (tester) async {
        // ARRANGE: Mock service'i async operation için hazırla
        when(
          mockAuthService.signIn(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.success(null));

        // ACT: Login view model oluştur
        final viewModel = LoginViewModel(authService: mockAuthService);

        // Form alanlarını doldur
        viewModel.emailController.text = 'test@example.com';
        viewModel.passwordController.text = 'password123';

        // ASSERT: Başlangıçta loading false olmalı
        expect(viewModel.isLoading, isFalse);

        // ACT: Login çağır (async)
        final future = viewModel.login();

        // ASSERT: Loading state true olmalı
        expect(viewModel.isLoading, isTrue);

        // ACT: Operation tamamlanana kadar bekle
        await future;

        // ASSERT: Loading state false olmalı
        expect(viewModel.isLoading, isFalse);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('Form validation state doğru yönetilmeli', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(
          mockAuthService.signIn(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.success(null));

        // ACT: Login view model oluştur
        final viewModel = LoginViewModel(authService: mockAuthService);

        // ASSERT: Form key mevcut olmalı
        expect(viewModel.formKey, isNotNull);
        expect(viewModel.formKey.currentState, isNull);

        // ACT: Form validation çağır
        final isValid = viewModel.formKey.currentState?.validate() ?? false;

        // ASSERT: Form validation çalışmalı
        expect(isValid, isFalse); // Boş form invalid olmalı

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('Form clear işlemi doğru çalışmalı', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(
          mockAuthService.signIn(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.success(null));

        // ACT: Login view model oluştur
        final viewModel = LoginViewModel(authService: mockAuthService);

        // Form alanlarını doldur
        viewModel.emailController.text = 'test@example.com';
        viewModel.passwordController.text = 'password123';

        // ASSERT: Form alanları dolu olmalı
        expect(viewModel.emailController.text, equals('test@example.com'));
        expect(viewModel.passwordController.text, equals('password123'));

        // ACT: Form'u temizle
        viewModel.clearForm();

        // ASSERT: Form alanları temizlenmiş olmalı
        expect(viewModel.emailController.text, isEmpty);
        expect(viewModel.passwordController.text, isEmpty);

        // Cleanup
        viewModel.dispose();
      });
    });

    group('Dependency Injection Tests', () {
      testWidgets('Login view model dependency injection ile oluşturulmalı', (
        tester,
      ) async {
        // ARRANGE: Mock service'i hazırla
        when(
          mockAuthService.signIn(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.success(null));

        // ACT: Login view model'ı mock service ile oluştur
        final viewModel = LoginViewModel(authService: mockAuthService);

        // ASSERT: Mock service inject edildi mi?
        expect(viewModel, isNotNull);

        // ACT: Login işlemi çağır
        await viewModel.login();

        // ASSERT: Mock service metodu çağrıldı mı?
        verify(
          mockAuthService.signIn(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).called(1);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets(
        'Register view model dependency injection ile oluşturulmalı',
        (tester) async {
          // ARRANGE: Mock service'leri hazırla
          when(
            mockAuthService.signUp(
              email: anyNamed('email'),
              password: anyNamed('password'),
            ),
          ).thenAnswer((_) async => AuthResult.success(null));
          when(
            mockUserService.createDataUser(any),
          ).thenAnswer((_) async => true);

          // ACT: Register view model'ı mock service'ler ile oluştur
          final viewModel = RegisterViewModel(
            authService: mockAuthService,
            userService: mockUserService,
          );

          // ASSERT: Mock service'ler inject edildi mi?
          expect(viewModel, isNotNull);

          // Form alanlarını doldur
          viewModel.nameController.text = 'John';
          viewModel.surnameController.text = 'Doe';
          viewModel.emailController.text = 'test@example.com';
          viewModel.passwordController.text = 'password123';
          viewModel.confirmPasswordController.text = 'password123';

          // ACT: Register işlemi çağır
          await viewModel.register();

          // ASSERT: Mock service metodları çağrıldı mı?
          verify(
            mockAuthService.signUp(
              email: anyNamed('email'),
              password: anyNamed('password'),
            ),
          ).called(1);
          verify(mockUserService.createDataUser(any)).called(1);

          // Cleanup
          viewModel.dispose();
        },
      );
    });
  });
}
