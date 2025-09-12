import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// --------- ViewModel Interface ---------
abstract class IRegisterViewModel {
  String? validateEmail(String? value);
  String? validatePassword(String? value);
  String? validateConfirmPassword(String? value);
  String? validateName(String? value);
  TextEditingController get emailController;
  TextEditingController get passwordController;
  TextEditingController get confirmPasswordController;
  TextEditingController get nameController;
  bool get obscurePassword;
  bool get obscureConfirmPassword;
  void togglePasswordVisibility();
  void toggleConfirmPasswordVisibility();
  bool get isFormValid;
  Future<void> register();
}

/// --------- Mock ViewModel ---------
class MockRegisterViewModel implements IRegisterViewModel {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email gerekli';
    if (!value.contains('@')) return 'Geçerli email girin';
    if (value.length > 254) return 'Email çok uzun';
    return null;
  }

  @override
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Şifre gerekli';
    if (value.length < 6) return 'Şifre en az 6 karakter olmalı';
    if (value.length > 128) return 'Şifre çok uzun';
    return null;
  }

  @override
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Şifre tekrarı gerekli';
    if (value != _passwordController.text) return 'Şifreler eşleşmiyor';
    return null;
  }

  @override
  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Ad gerekli';
    if (value.length < 2) return 'Ad en az 2 karakter olmalı';
    if (value.length > 50) return 'Ad çok uzun';
    return null;
  }

  @override
  TextEditingController get emailController => _emailController;

  @override
  TextEditingController get passwordController => _passwordController;

  @override
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;

  @override
  TextEditingController get nameController => _nameController;

  @override
  bool get obscurePassword => _obscurePassword;

  @override
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  @override
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
  }

  @override
  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
  }

  @override
  bool get isFormValid {
    return validateEmail(_emailController.text) == null &&
        validatePassword(_passwordController.text) == null &&
        validateConfirmPassword(_confirmPasswordController.text) == null &&
        validateName(_nameController.text) == null;
  }

  @override
  Future<void> register() async {
    if (!isFormValid) throw Exception('Form geçersiz');
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

/// --------- Test Widget ---------
class TestRegisterForm extends StatefulWidget {
  final IRegisterViewModel viewModel;

  const TestRegisterForm({super.key, required this.viewModel});

  @override
  State<TestRegisterForm> createState() => _TestRegisterFormState();
}

class _TestRegisterFormState extends State<TestRegisterForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: GlobalKey<FormState>(),
      child: Column(
        children: [
          // Name Field
          TextFormField(
            controller: widget.viewModel.nameController,
            decoration: const InputDecoration(
              labelText: 'Ad Soyad',
              hintText: 'Adınızı ve soyadınızı girin',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            validator: widget.viewModel.validateName,
          ),
          const SizedBox(height: 16),

          // Email Field
          TextFormField(
            controller: widget.viewModel.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'ornek@email.com',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            validator: widget.viewModel.validateEmail,
          ),
          const SizedBox(height: 16),

          // Password Field
          TextFormField(
            controller: widget.viewModel.passwordController,
            obscureText: widget.viewModel.obscurePassword,
            decoration: InputDecoration(
              labelText: 'Şifre',
              hintText: 'Şifrenizi girin',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  widget.viewModel.obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  widget.viewModel.togglePasswordVisibility();
                  setState(() {});
                },
              ),
              border: const OutlineInputBorder(),
            ),
            validator: widget.viewModel.validatePassword,
          ),
          const SizedBox(height: 16),

          // Confirm Password Field
          TextFormField(
            controller: widget.viewModel.confirmPasswordController,
            obscureText: widget.viewModel.obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Şifre Tekrarı',
              hintText: 'Şifrenizi tekrar girin',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  widget.viewModel.obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  widget.viewModel.toggleConfirmPasswordVisibility();
                  setState(() {});
                },
              ),
              border: const OutlineInputBorder(),
            ),
            validator: widget.viewModel.validateConfirmPassword,
          ),
          const SizedBox(height: 16),

          // Register Button
          ElevatedButton(
            onPressed: widget.viewModel.isFormValid
                ? () async {
                    try {
                      await widget.viewModel.register();
                      // Success handling
                    } catch (e) {
                      // Error handling
                    }
                  }
                : null,
            child: const Text('Kayıt Ol'),
          ),
        ],
      ),
    );
  }
}

void main() {
  group('Register Form Widget Tests', () {
    late Widget testWidget;
    late IRegisterViewModel mockViewModel;
    final formKey = GlobalKey<FormState>();

    Widget createTestWidget(IRegisterViewModel viewModel) {
      return MaterialApp(
        home: Scaffold(
          body: Provider<IRegisterViewModel>.value(
            value: viewModel,
            child: TestRegisterForm(viewModel: viewModel),
          ),
        ),
      );
    }

    setUp(() {
      mockViewModel = MockRegisterViewModel();
      testWidget = createTestWidget(mockViewModel);
    });

    tearDown(() {
      mockViewModel.emailController.dispose();
      mockViewModel.passwordController.dispose();
      mockViewModel.confirmPasswordController.dispose();
      mockViewModel.nameController.dispose();
    });

    group('Basic Rendering Tests', () {
      testWidgets('Register form render ediliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        expect(find.byType(TextFormField), findsNWidgets(4));
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('Ad Soyad'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Şifre'), findsOneWidget);
        expect(find.text('Şifre Tekrarı'), findsOneWidget);
        expect(find.text('Kayıt Ol'), findsOneWidget);
      });

      testWidgets('Form field iconları gösteriyor', (tester) async {
        await tester.pumpWidget(testWidget);

        expect(find.byIcon(Icons.person_outline), findsOneWidget);
        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsNWidgets(2));
        expect(find.byIcon(Icons.visibility), findsNWidgets(2));
      });
    });

    group('User Input Tests', () {
      testWidgets('Kullanıcı tüm alanlara giriş yapabiliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Name input
        await tester.enterText(
          find.byType(TextFormField).at(0),
          'Ahmet Yılmaz',
        );
        await tester.pump();
        expect(find.text('Ahmet Yılmaz'), findsOneWidget);

        // Email input
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'ahmet@email.com',
        );
        await tester.pump();
        expect(find.text('ahmet@email.com'), findsOneWidget);

        // Password input
        await tester.enterText(find.byType(TextFormField).at(2), '123456');
        await tester.pump();
        expect(mockViewModel.passwordController.text, equals('123456'));

        // Confirm password input
        await tester.enterText(find.byType(TextFormField).at(3), '123456');
        await tester.pump();
        expect(mockViewModel.confirmPasswordController.text, equals('123456'));
      });

      testWidgets('Controller state güncelleniyor', (tester) async {
        await tester.pumpWidget(testWidget);

        expect(mockViewModel.nameController.text, isEmpty);
        expect(mockViewModel.emailController.text, isEmpty);
        expect(mockViewModel.passwordController.text, isEmpty);
        expect(mockViewModel.confirmPasswordController.text, isEmpty);

        await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
        await tester.pump();

        expect(mockViewModel.nameController.text, equals('Test User'));
      });
    });

    group('Form Validation Tests', () {
      testWidgets('Boş form validation testi', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(mockViewModel.isFormValid, isFalse);
      });

      testWidgets('Geçerli form validation testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Geçerli veriler gir
        await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'test@email.com',
        );
        await tester.enterText(find.byType(TextFormField).at(2), '123456');
        await tester.enterText(find.byType(TextFormField).at(3), '123456');
        await tester.pump();

        expect(mockViewModel.isFormValid, isTrue);
      });

      testWidgets('Name validation testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final nameField = tester.widget<TextFormField>(
          find.byType(TextFormField).at(0),
        );

        // Boş name
        expect(nameField.validator?.call(''), equals('Ad gerekli'));

        // Çok kısa name
        expect(
          nameField.validator?.call('A'),
          equals('Ad en az 2 karakter olmalı'),
        );

        // Geçerli name
        expect(nameField.validator?.call('Ahmet'), isNull);
      });

      testWidgets('Email validation testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final emailField = tester.widget<TextFormField>(
          find.byType(TextFormField).at(1),
        );

        // Boş email
        expect(emailField.validator?.call(''), equals('Email gerekli'));

        // Geçersiz email
        expect(
          emailField.validator?.call('gecersizemail'),
          equals('Geçerli email girin'),
        );

        // Geçerli email
        expect(emailField.validator?.call('test@email.com'), isNull);
      });

      testWidgets('Password validation testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final passwordField = tester.widget<TextFormField>(
          find.byType(TextFormField).at(2),
        );

        // Boş şifre
        expect(passwordField.validator?.call(''), equals('Şifre gerekli'));

        // Kısa şifre
        expect(
          passwordField.validator?.call('123'),
          equals('Şifre en az 6 karakter olmalı'),
        );

        // Geçerli şifre
        expect(passwordField.validator?.call('123456'), isNull);
      });

      testWidgets('Confirm password validation testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Önce password gir
        await tester.enterText(find.byType(TextFormField).at(2), '123456');
        await tester.pump();

        final confirmPasswordField = tester.widget<TextFormField>(
          find.byType(TextFormField).at(3),
        );

        // Boş confirm password
        expect(
          confirmPasswordField.validator?.call(''),
          equals('Şifre tekrarı gerekli'),
        );

        // Eşleşmeyen şifre
        expect(
          confirmPasswordField.validator?.call('654321'),
          equals('Şifreler eşleşmiyor'),
        );

        // Eşleşen şifre
        expect(confirmPasswordField.validator?.call('123456'), isNull);
      });
    });

    group('Password Visibility Tests', () {
      testWidgets('Password visibility toggle çalışıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Password field visibility
        expect(find.byIcon(Icons.visibility), findsNWidgets(2));

        // İlk visibility toggle (password field)
        final passwordField = find.byType(TextFormField).at(2);
        final passwordVisibilityIcon = find.descendant(
          of: passwordField,
          matching: find.byIcon(Icons.visibility),
        );
        await tester.tap(passwordVisibilityIcon);
        await tester.pump();
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);

        // İkinci visibility toggle (confirm password field)
        final confirmPasswordField = find.byType(TextFormField).at(3);
        final confirmPasswordVisibilityIcon = find.descendant(
          of: confirmPasswordField,
          matching: find.byIcon(Icons.visibility),
        );
        await tester.tap(confirmPasswordVisibilityIcon);
        await tester.pump();
        expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));
      });

      testWidgets('Confirm password visibility toggle çalışıyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        // Confirm password field visibility
        await tester.tap(find.byIcon(Icons.visibility).at(1));
        await tester.pump();
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      });
    });

    group('Form State Tests', () {
      testWidgets('Form valid state değişiklikleri', (tester) async {
        await tester.pumpWidget(testWidget);

        // Başlangıçta form geçersiz
        expect(mockViewModel.isFormValid, isFalse);

        // Geçerli veriler gir
        await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'test@email.com',
        );
        await tester.enterText(find.byType(TextFormField).at(2), '123456');
        await tester.enterText(find.byType(TextFormField).at(3), '123456');
        await tester.pump();

        // Form artık geçerli
        expect(mockViewModel.isFormValid, isTrue);
      });

      testWidgets('Register button state değişiklikleri', (tester) async {
        await tester.pumpWidget(testWidget);

        // Başlangıçta button disabled
        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(button.onPressed, isNull);

        // Geçerli veriler gir
        await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'test@email.com',
        );
        await tester.enterText(find.byType(TextFormField).at(2), '123456');
        await tester.enterText(find.byType(TextFormField).at(3), '123456');
        await tester.pump();

        // Widget'ı yeniden build et
        await tester.pumpWidget(createTestWidget(mockViewModel));
        await tester.pump();

        // Button artık enabled
        final updatedButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(updatedButton.onPressed, isNotNull);
      });
    });

    group('Edge Case Tests', () {
      testWidgets('Çok uzun input edge case testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Çok uzun name
        final longName = 'A' * 100;
        await tester.enterText(find.byType(TextFormField).at(0), longName);
        await tester.pump();
        expect(find.text(longName), findsOneWidget);

        // Çok uzun email
        final longEmail = 'a' * 100 + '@test.com';
        await tester.enterText(find.byType(TextFormField).at(1), longEmail);
        await tester.pump();
        expect(find.text(longEmail), findsOneWidget);
      });

      testWidgets('Özel karakterler içeren input testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Özel karakterler içeren name
        final specialName = 'Ahmet-Yılmaz_123!@#';
        await tester.enterText(find.byType(TextFormField).at(0), specialName);
        await tester.pump();
        expect(find.text(specialName), findsOneWidget);

        // Özel karakterler içeren password
        final specialPassword = '!@#\$%^&*()_+';
        await tester.enterText(
          find.byType(TextFormField).at(2),
          specialPassword,
        );
        await tester.pump();
        expect(find.text(specialPassword), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('Form rebuild performance testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final stopwatch = Stopwatch()..start();

        // Çoklu rebuild
        for (int i = 0; i < 50; i++) {
          mockViewModel.nameController.text = 'User$i';
          await tester.pump();
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      });

      testWidgets('Text input performance testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final stopwatch = Stopwatch()..start();

        // Hızlı text input
        for (int i = 0; i < 100; i++) {
          await tester.enterText(find.byType(TextFormField).at(0), 'User$i');
          await tester.pump();
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      });
    });

    group('Integration Tests', () {
      testWidgets('Register işlemi testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Geçerli veriler gir
        await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'test@email.com',
        );
        await tester.enterText(find.byType(TextFormField).at(2), '123456');
        await tester.enterText(find.byType(TextFormField).at(3), '123456');
        await tester.pump();

        // Register butonuna tıkla
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Register işlemi başarılı olmalı
        expect(mockViewModel.isFormValid, isTrue);
      });

      testWidgets('Form reset testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Veriler gir
        await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'test@email.com',
        );
        await tester.pump();

        // Form'u reset et - controller'ları temizle
        mockViewModel.nameController.clear();
        mockViewModel.emailController.clear();
        mockViewModel.passwordController.clear();
        mockViewModel.confirmPasswordController.clear();
        await tester.pump();

        // Tüm alanlar boş olmalı
        expect(mockViewModel.nameController.text, isEmpty);
        expect(mockViewModel.emailController.text, isEmpty);
        expect(mockViewModel.passwordController.text, isEmpty);
        expect(mockViewModel.confirmPasswordController.text, isEmpty);
      });
    });
  });
}
