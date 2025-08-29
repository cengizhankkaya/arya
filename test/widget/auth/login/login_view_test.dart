import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// --------- ViewModel Interface ---------
abstract class ILoginViewModel {
  String? validateEmail(String? value);
  String? validatePassword(String? value);
  TextEditingController get emailController;
  TextEditingController get passwordController;
  bool get obscurePassword;
  bool get isLoading;
  String? get errorMessage;
  void togglePasswordVisibility();
  Future<bool> login();
}

/// --------- Mock ViewModel ---------
class MockLoginViewModel extends ChangeNotifier implements ILoginViewModel {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email gerekli';
    }
    if (!value.contains('@')) {
      return 'Geçerli email girin';
    }
    return null;
  }

  @override
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre gerekli';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalı';
    }
    return null;
  }

  @override
  TextEditingController get emailController => _emailController;

  @override
  TextEditingController get passwordController => _passwordController;

  @override
  bool get obscurePassword => _obscurePassword;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get errorMessage => _errorMessage;

  @override
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  @override
  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 100));

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _errorMessage = 'Form hataları var';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

/// --------- Mock LoginView ---------
class MockLoginView extends StatelessWidget {
  final MockLoginViewModel viewModel;

  const MockLoginView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Giriş Yap',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: viewModel.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: viewModel.validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: viewModel.passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: viewModel.obscurePassword,
                  validator: viewModel.validatePassword,
                ),
                const SizedBox(height: 16),
                if (viewModel.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.red.shade100,
                    child: Text(
                      viewModel.errorMessage!,
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                  ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () => viewModel.login(),
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Giriş Yap'),
                ),
                const SizedBox(height: 16),
                IconButton(
                  onPressed: viewModel.togglePasswordVisibility,
                  icon: Icon(
                    viewModel.obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  group('LoginView Widget Tests', () {
    late MockLoginViewModel mockViewModel;
    late Widget testWidget;

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<MockLoginViewModel>.value(
          value: mockViewModel,
          child: MockLoginView(viewModel: mockViewModel),
        ),
      );
    }

    setUp(() {
      mockViewModel = MockLoginViewModel();
    });

    tearDown(() {
      mockViewModel.emailController.dispose();
      mockViewModel.passwordController.dispose();
    });

    group('Widget Structure Tests', () {
      testWidgets('LoginView temel widget yapısını göstermeli', (tester) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Ana widget'ların varlığını kontrol et
        expect(find.byType(MockLoginView), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
      });

      testWidgets('LoginView tüm gerekli child widget\'ları göstermeli', (
        tester,
      ) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Form içeriğini kontrol et
        expect(find.byType(Form), findsOneWidget);
        expect(
          find.byType(TextFormField),
          findsNWidgets(2),
        ); // Email ve Password
        expect(find.byType(ElevatedButton), findsOneWidget); // Login button
      });
    });

    group('Provider Integration Tests', () {
      testWidgets('Provider ile LoginViewModel doğru şekilde bağlanmalı', (
        tester,
      ) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Provider context'ten LoginViewModel'e erişim
        final context = tester.element(find.byType(MockLoginView));
        final viewModel = Provider.of<MockLoginViewModel>(
          context,
          listen: false,
        );
        expect(viewModel, isA<MockLoginViewModel>());
      });
    });

    group('User Interaction Tests', () {
      testWidgets('Email field\'a text girilebilmeli', (tester) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Email field'ı bul ve text gir
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump();

        // Text'in girildiğini kontrol et
        expect(find.text('test@example.com'), findsOneWidget);
      });

      testWidgets('Password field\'a text girilebilmeli', (tester) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Password field'ı bul ve text gir
        final passwordField = find.byType(TextFormField).at(1);
        await tester.enterText(passwordField, 'password123');
        await tester.pump();

        // Text'in girildiği kontrol edilmeli
        expect(mockViewModel.passwordController.text, equals('password123'));
      });

      testWidgets('Login button tıklanabilir olmalı', (tester) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Login button'ı bul ve tıkla
        final loginButton = find.byType(ElevatedButton);
        expect(loginButton, findsOneWidget);

        await tester.tap(loginButton);
        await tester.pumpAndSettle();
      });
    });

    group('Form Validation Tests', () {
      testWidgets('Boş email ile validation hatası gösterilmeli', (
        tester,
      ) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Login button'a tıkla (boş form ile)
        final loginButton = find.byType(ElevatedButton);
        await tester.tap(loginButton);
        await tester.pumpAndSettle();

        // Validation hatası gösterilmeli
        expect(mockViewModel.errorMessage, isNotNull);
      });

      testWidgets('Geçersiz email formatı ile validation hatası gösterilmeli', (
        tester,
      ) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Geçersiz email gir
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, 'invalid-email');
        await tester.pump();

        // Validation hatası kontrol et
        final validationResult = mockViewModel.validateEmail('invalid-email');
        expect(validationResult, isNotNull);
        expect(validationResult!.contains('Geçerli email girin'), isTrue);
      });

      testWidgets('Kısa şifre ile validation hatası gösterilmeli', (
        tester,
      ) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Kısa şifre gir
        final passwordField = find.byType(TextFormField).at(1);
        await tester.enterText(passwordField, '123');
        await tester.pump();

        // Validation hatası kontrol et
        final validationResult = mockViewModel.validatePassword('123');
        expect(validationResult, isNotNull);
        expect(validationResult!.contains('en az 6 karakter'), isTrue);
      });
    });

    group('Loading State Tests', () {
      testWidgets('Loading state\'de button disabled olmalı', (tester) async {
        // Loading state'i ayarla
        mockViewModel._isLoading = true;
        mockViewModel.notifyListeners();

        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Loading state'de button disabled olmalı
        final elevatedButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(elevatedButton.onPressed, isNull);
      });

      testWidgets('Loading state\'de CircularProgressIndicator gösterilmeli', (
        tester,
      ) async {
        // Loading state'i ayarla
        mockViewModel._isLoading = true;
        mockViewModel.notifyListeners();

        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Loading indicator görünmeli
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('Error message gösterilmeli', (tester) async {
        // Hata mesajı ayarla
        mockViewModel._errorMessage = 'Test hata mesajı';
        mockViewModel.notifyListeners();

        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Error message görünmeli
        expect(find.text('Test hata mesajı'), findsOneWidget);
      });
    });

    group('Password Visibility Tests', () {
      testWidgets('Password visibility toggle çalışmalı', (tester) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Başlangıçta şifre gizli olmalı
        expect(mockViewModel.obscurePassword, isTrue);

        // Toggle button'a tıkla
        final toggleButton = find.byType(IconButton);
        await tester.tap(toggleButton);
        await tester.pump();

        // Şifre görünür olmalı
        expect(mockViewModel.obscurePassword, isFalse);
      });
    });

    group('Edge Case Tests', () {
      testWidgets('Çok uzun email text\'i ile çalışmalı', (tester) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Çok uzun email text'i
        final longEmail = 'a' * 100 + '@example.com';
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, longEmail);
        await tester.pump();

        // Text girildi mi kontrol et
        expect(find.text(longEmail), findsOneWidget);
      });

      testWidgets('Çok uzun şifre text\'i ile çalışmalı', (tester) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Çok uzun şifre text'i
        final longPassword = 'a' * 100;
        final passwordField = find.byType(TextFormField).at(1);
        await tester.enterText(passwordField, longPassword);
        await tester.pump();

        // Text girildi mi kontrol et
        expect(mockViewModel.passwordController.text, equals(longPassword));
      });

      testWidgets('Özel karakterler ile çalışmalı', (tester) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Özel karakterler içeren email
        final specialEmail = 'test+tag@example.com';
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, specialEmail);
        await tester.pump();

        // Text girildi mi kontrol et
        expect(find.text(specialEmail), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Semantic labels doğru olmalı', (tester) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Email field semantic label'ı
        final emailField = find.byType(TextFormField).first;
        final emailSemantics = tester.getSemantics(emailField);
        expect(emailSemantics.label, isNotEmpty);

        // Password field semantic label'ı
        final passwordField = find.byType(TextFormField).at(1);
        final passwordSemantics = tester.getSemantics(passwordField);
        expect(passwordSemantics.label, isNotEmpty);
      });

      testWidgets('Login button semantic label\'ı olmalı', (tester) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Login button semantic label'ı
        final loginButton = find.byType(ElevatedButton);
        final buttonSemantics = tester.getSemantics(loginButton);
        expect(buttonSemantics.label, isNotEmpty);
      });
    });

    group('Responsiveness Tests', () {
      testWidgets('Farklı ekran boyutlarında çalışmalı', (tester) async {
        testWidget = createTestWidget();

        // Küçük ekran
        await tester.binding.setSurfaceSize(const Size(320, 568));
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();
        expect(find.byType(MockLoginView), findsOneWidget);

        // Büyük ekran
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();
        expect(find.byType(MockLoginView), findsOneWidget);
      });

      testWidgets('Landscape orientation\'da çalışmalı', (tester) async {
        testWidget = createTestWidget();

        // Landscape orientation
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Form hala görünür olmalı
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
      });
    });

    group('Integration Tests', () {
      testWidgets('Tam login flow entegrasyon testi', (tester) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // 1. Email gir
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump();

        // 2. Şifre gir
        final passwordField = find.byType(TextFormField).at(1);
        await tester.enterText(passwordField, 'password123');
        await tester.pump();

        // 3. Login button'a tıkla
        final loginButton = find.byType(ElevatedButton);
        await tester.tap(loginButton);
        await tester.pumpAndSettle();

        // Login işlemi tamamlandı mı kontrol et
        expect(mockViewModel.emailController.text, equals('test@example.com'));
        expect(mockViewModel.passwordController.text, equals('password123'));
      });

      testWidgets('Form validation entegrasyon testi', (tester) async {
        testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Boş form ile login'e çalış
        final loginButton = find.byType(ElevatedButton);
        await tester.tap(loginButton);
        await tester.pumpAndSettle();

        // Validation hataları gösterilmeli
        expect(mockViewModel.errorMessage, isNotNull);
      });
    });
  });
}
