import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/auth/register/view/register_password_field.dart';

/// --------- Mock ViewModel Interface ---------
abstract class IRegisterPasswordViewModel {
  String? validatePassword(String? value);
  TextEditingController get passwordController;
  bool get obscurePassword;
  void togglePasswordVisibility();
}

/// --------- Mock ViewModel ---------
class MockRegisterPasswordViewModel implements IRegisterPasswordViewModel {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Şifre gerekli';
    if (value.length < 6) return 'Şifre en az 6 karakter olmalı';
    if (value.length > 128) return 'Şifre çok uzun';
    if (value.contains(' ')) return 'Şifre boşluk içeremez';
    return null;
  }

  @override
  TextEditingController get passwordController => _passwordController;

  @override
  bool get obscurePassword => _obscurePassword;

  @override
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
  }
}

/// --------- Exception Mock ViewModel ---------
class ExceptionMockRegisterPasswordViewModel
    implements IRegisterPasswordViewModel {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  String? validatePassword(String? value) {
    if (value == null) throw Exception('Null değer hatası');
    if (value.isEmpty) return 'Şifre gerekli';
    if (value.length < 6) return 'Şifre en az 6 karakter olmalı';
    return null;
  }

  @override
  TextEditingController get passwordController => _passwordController;

  @override
  bool get obscurePassword => _obscurePassword;

  @override
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
  }
}

/// --------- Test Widget ---------
class TestRegisterPasswordField extends StatefulWidget {
  final IRegisterPasswordViewModel viewModel;
  final String label;
  final String? Function(String?)? validator;

  const TestRegisterPasswordField({
    super.key,
    required this.viewModel,
    required this.label,
    this.validator,
  });

  @override
  State<TestRegisterPasswordField> createState() =>
      _TestRegisterPasswordFieldState();
}

class _TestRegisterPasswordFieldState extends State<TestRegisterPasswordField> {
  @override
  Widget build(BuildContext context) {
    return RegisterPasswordField(
      controller: widget.viewModel.passwordController,
      label: widget.label,
      obscureText: widget.viewModel.obscurePassword,
      onToggle: () {
        widget.viewModel.togglePasswordVisibility();
        setState(() {}); // UI'ı yeniden render et
      },
      validator: widget.validator ?? widget.viewModel.validatePassword,
    );
  }
}

void main() {
  group('RegisterPasswordField Widget Tests', () {
    late Widget testWidget;
    late IRegisterPasswordViewModel mockViewModel;
    final formKey = GlobalKey<FormState>();

    Widget createTestWidget(
      IRegisterPasswordViewModel viewModel, {
      String label = 'Şifre',
      String? Function(String?)? validator,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: TestRegisterPasswordField(
              viewModel: viewModel,
              label: label,
              validator: validator,
            ),
          ),
        ),
      );
    }

    setUp(() {
      mockViewModel = MockRegisterPasswordViewModel();
      testWidget = createTestWidget(mockViewModel);
    });

    tearDown(() {
      mockViewModel.passwordController.dispose();
    });

    group('Temel Render Testleri', () {
      testWidgets('RegisterPasswordField doğru şekilde render ediliyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        expect(find.byType(RegisterPasswordField), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Şifre'), findsOneWidget);
      });

      testWidgets('Label text doğru şekilde gösteriliyor', (tester) async {
        const customLabel = 'Özel Şifre Etiketi';
        final customWidget = createTestWidget(
          mockViewModel,
          label: customLabel,
        );

        await tester.pumpWidget(customWidget);
        expect(find.text(customLabel), findsOneWidget);
      });

      testWidgets('Prefix icon (lock) doğru şekilde gösteriliyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);
        expect(find.byIcon(Icons.lock), findsOneWidget);
      });

      testWidgets(
        'Suffix icon (visibility) başlangıçta doğru şekilde gösteriliyor',
        (tester) async {
          await tester.pumpWidget(testWidget);
          expect(find.byIcon(Icons.visibility), findsOneWidget);
          expect(find.byIcon(Icons.visibility_off), findsNothing);
        },
      );
    });

    group('Kullanıcı Giriş Testleri', () {
      testWidgets('Kullanıcı şifre girişi yapabiliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        const testPassword = '123456';
        await tester.enterText(find.byType(TextFormField), testPassword);
        await tester.pump();

        expect(find.text(testPassword), findsOneWidget);
      });

      testWidgets('Password controller state güncelleniyor', (tester) async {
        await tester.pumpWidget(testWidget);

        expect(mockViewModel.passwordController.text, isEmpty);

        const testPassword = 'testPassword123';
        await tester.enterText(find.byType(TextFormField), testPassword);
        await tester.pump();

        expect(mockViewModel.passwordController.text, equals(testPassword));
      });

      testWidgets('Farklı karakter türleri ile giriş yapılabiliyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        const specialPassword = '!@#\$%^&*()_+{}|:"<>?[]\\;\',./';
        await tester.enterText(find.byType(TextFormField), specialPassword);
        await tester.pump();

        expect(find.text(specialPassword), findsOneWidget);
      });

      testWidgets('Sayısal şifre girişi yapılabiliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        const numericPassword = '1234567890';
        await tester.enterText(find.byType(TextFormField), numericPassword);
        await tester.pump();

        expect(find.text(numericPassword), findsOneWidget);
      });
    });

    group('Form Validasyon Testleri', () {
      testWidgets('Boş şifre validasyon testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('');
        expect(result, equals('Şifre gerekli'));
      });

      testWidgets('Null şifre validasyon testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call(null);
        expect(result, equals('Şifre gerekli'));
      });

      testWidgets('Kısa şifre validasyon testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('123');
        expect(result, equals('Şifre en az 6 karakter olmalı'));
      });

      testWidgets('Geçerli şifre validasyon testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('123456');
        expect(result, isNull);
      });

      testWidgets('Çok uzun şifre validasyon testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final longPassword = 'a' * 129;
        final result = textField.validator?.call(longPassword);
        expect(result, equals('Şifre çok uzun'));
      });

      testWidgets('Boşluk içeren şifre validasyon testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('123 456');
        expect(result, equals('Şifre boşluk içeremez'));
      });

      testWidgets('Form submission validasyon testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Boş form validasyon
        expect(formKey.currentState?.validate() ?? false, isFalse);

        // Geçerli şifre ile validasyon
        await tester.enterText(find.byType(TextFormField), '123456');
        await tester.pump();
        expect(formKey.currentState?.validate() ?? false, isTrue);
      });
    });

    group('Şifre Görünürlük Testleri', () {
      testWidgets('Password visibility toggle çalışıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Başlangıçta visibility icon'u görünür olmalı
        expect(find.byIcon(Icons.visibility), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off), findsNothing);

        // Toggle butonuna tıkla
        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pump();

        // Şimdi visibility_off icon'u görünür olmalı
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsNothing);

        // Tekrar toggle yap
        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pump();

        // Tekrar visibility icon'u görünür olmalı
        expect(find.byIcon(Icons.visibility), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off), findsNothing);
      });

      testWidgets('Password visibility state değişiklikleri', (tester) async {
        await tester.pumpWidget(testWidget);

        // Başlangıç durumu
        expect(mockViewModel.obscurePassword, isTrue);

        // Toggle işlemi
        mockViewModel.togglePasswordVisibility();
        expect(mockViewModel.obscurePassword, isFalse);

        // Tekrar toggle
        mockViewModel.togglePasswordVisibility();
        expect(mockViewModel.obscurePassword, isTrue);
      });

      testWidgets('Toggle butonu tıklanabilir', (tester) async {
        await tester.pumpWidget(testWidget);

        final toggleButton = find.byType(IconButton);
        expect(toggleButton, findsOneWidget);

        // Buton tıklanabilir olmalı
        expect(tester.widget<IconButton>(toggleButton).onPressed, isNotNull);
      });
    });

    group('Edge Case Testleri', () {
      testWidgets('Çok uzun şifre edge case testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final longPassword = 'a' * 100;
        await tester.enterText(find.byType(TextFormField), longPassword);
        await tester.pumpAndSettle();

        expect(find.text(longPassword), findsOneWidget);
      });

      testWidgets('Minimum geçerli şifre uzunluğu testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        // 5 karakter - çok kısa
        final shortPassword = '12345';
        expect(
          textField.validator?.call(shortPassword),
          equals('Şifre en az 6 karakter olmalı'),
        );

        // 6 karakter - minimum geçerli
        final validPassword = '123456';
        expect(textField.validator?.call(validPassword), isNull);
      });

      testWidgets('Maksimum şifre uzunluğu testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        // 128 karakter - maksimum geçerli
        final maxValidPassword = 'a' * 128;
        expect(textField.validator?.call(maxValidPassword), isNull);

        // 129 karakter - çok uzun
        final tooLongPassword = 'a' * 129;
        expect(
          textField.validator?.call(tooLongPassword),
          equals('Şifre çok uzun'),
        );
      });

      testWidgets('Özel karakterler içeren şifre testi', (tester) async {
        await tester.pumpWidget(testWidget);

        const specialPassword = '!@#\$%^&*()_+{}|:"<>?[]\\;\',./';
        await tester.enterText(find.byType(TextFormField), specialPassword);
        await tester.pump();

        expect(find.text(specialPassword), findsOneWidget);
      });

      testWidgets('Unicode karakterler içeren şifre testi', (tester) async {
        await tester.pumpWidget(testWidget);

        const unicodePassword = 'şifre123çğıöüŞİĞÇÖÜ';
        await tester.enterText(find.byType(TextFormField), unicodePassword);
        await tester.pump();

        expect(find.text(unicodePassword), findsOneWidget);
      });
    });

    group('Hata Yönetimi Testleri', () {
      testWidgets('Exception durumunda widget davranışı', (tester) async {
        final exceptionViewModel = ExceptionMockRegisterPasswordViewModel();
        final exceptionWidget = createTestWidget(exceptionViewModel);

        await tester.pumpWidget(exceptionWidget);

        // Widget'ın crash olmadan render olduğunu doğrula
        expect(find.byType(TestRegisterPasswordField), findsOneWidget);

        // Null değer ile exception testi
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        expect(() => textField.validator?.call(null), throwsException);
      });

      testWidgets('Custom validator kullanımı', (tester) async {
        String? customValidator(String? value) {
          if (value == null || value.isEmpty) return 'Özel hata mesajı';
          if (value.length < 8) return 'En az 8 karakter olmalı';
          return null;
        }

        final customWidget = createTestWidget(
          mockViewModel,
          validator: customValidator,
        );

        await tester.pumpWidget(customWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        // Custom validator çalışıyor mu?
        expect(customValidator(''), equals('Özel hata mesajı'));
        expect(customValidator('123'), equals('En az 8 karakter olmalı'));
        expect(customValidator('12345678'), isNull);
      });
    });

    group('Performans Testleri', () {
      testWidgets('Widget rebuild performans testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final stopwatch = Stopwatch()..start();

        // Çoklu rebuild
        for (int i = 0; i < 50; i++) {
          mockViewModel.passwordController.text = 'password$i';
          await tester.pump();
        }

        stopwatch.stop();
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(500),
        ); // 500ms'den az olmalı
      });

      testWidgets('Text input performans testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final stopwatch = Stopwatch()..start();

        // Hızlı text input
        for (int i = 0; i < 100; i++) {
          await tester.enterText(find.byType(TextFormField), 'password$i');
          await tester.pump();
        }

        stopwatch.stop();
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(1500),
        ); // 1.5 saniyeden az olmalı
      });

      testWidgets('Toggle performans testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final stopwatch = Stopwatch()..start();

        // Hızlı toggle
        for (int i = 0; i < 50; i++) {
          await tester.tap(find.byIcon(Icons.visibility));
          await tester.pump();
          await tester.tap(find.byIcon(Icons.visibility_off));
          await tester.pump();
        }

        stopwatch.stop();
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(1500),
        ); // 1.5 saniyeden az olmalı
      });
    });

    group('Erişilebilirlik Testleri', () {
      testWidgets('Accessibility özellikleri test ediliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = find.byType(TextFormField);
        final semantics = tester.getSemantics(textField);

        // Semantics'in var olduğunu doğrula
        expect(semantics, isNotNull);
        expect(semantics.label, isNotEmpty);
      });

      testWidgets('Widget özellikleri doğru ayarlanmış', (tester) async {
        await tester.pumpWidget(testWidget);

        // Widget'ın doğru render edildiğini doğrula
        expect(find.byType(RegisterPasswordField), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Şifre'), findsOneWidget);
      });

      testWidgets('Icon button accessibility testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final iconButton = find.byType(IconButton);
        expect(iconButton, findsOneWidget);

        final button = tester.widget<IconButton>(iconButton);
        expect(button.onPressed, isNotNull);
      });
    });

    group('ViewModel Entegrasyon Testleri', () {
      testWidgets('ViewModel state değişiklikleri test ediliyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        // Başlangıç durumu
        expect(mockViewModel.obscurePassword, isTrue);

        // Toggle işlemi
        mockViewModel.togglePasswordVisibility();
        expect(mockViewModel.obscurePassword, isFalse);

        // Tekrar toggle
        mockViewModel.togglePasswordVisibility();
        expect(mockViewModel.obscurePassword, isTrue);
      });

      testWidgets('ViewModel controller disposal testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Controller'ın dispose edilmediğini doğrula
        expect(mockViewModel.passwordController.hasListeners, isTrue);

        // tearDown'da dispose edilecek
      });

      testWidgets('Controller text değişiklikleri test ediliyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        const testText = 'testPassword';
        mockViewModel.passwordController.text = testText;
        await tester.pump();

        expect(find.text(testText), findsOneWidget);
      });
    });

    group('Güvenlik Testleri', () {
      testWidgets('Şifre güvenlik testi - minimum uzunluk', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        // 5 karakter - çok kısa
        final shortPassword = '12345';
        expect(
          textField.validator?.call(shortPassword),
          equals('Şifre en az 6 karakter olmalı'),
        );

        // 6 karakter - minimum geçerli
        final validPassword = '123456';
        expect(textField.validator?.call(validPassword), isNull);
      });

      testWidgets('Şifre güvenlik testi - boşluk kontrolü', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        // Boşluk içeren şifre
        final passwordWithSpace = '123 456';
        expect(
          textField.validator?.call(passwordWithSpace),
          equals('Şifre boşluk içeremez'),
        );

        // Boşluk içermeyen şifre
        final validPassword = '123456';
        expect(textField.validator?.call(validPassword), isNull);
      });

      testWidgets('Şifre güvenlik testi - maksimum uzunluk', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        // 128 karakter - maksimum geçerli
        final maxValidPassword = 'a' * 128;
        expect(textField.validator?.call(maxValidPassword), isNull);

        // 129 karakter - çok uzun
        final tooLongPassword = 'a' * 129;
        expect(
          textField.validator?.call(tooLongPassword),
          equals('Şifre çok uzun'),
        );
      });
    });

    group('UI/UX Testleri', () {
      testWidgets('Widget doğru şekilde render ediliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Widget'ın doğru render edildiğini doğrula
        expect(find.byType(RegisterPasswordField), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.byIcon(Icons.lock), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });

      testWidgets('Label text doğru gösteriliyor', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(find.text('Şifre'), findsOneWidget);
      });

      testWidgets('Icon button tıklanabilir', (tester) async {
        await tester.pumpWidget(testWidget);

        final iconButton = find.byType(IconButton);
        expect(iconButton, findsOneWidget);

        // Buton tıklanabilir olmalı
        expect(tester.widget<IconButton>(iconButton).onPressed, isNotNull);
      });
    });
  });
}
