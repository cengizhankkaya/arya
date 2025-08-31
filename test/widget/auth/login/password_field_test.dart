import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// --------- ViewModel Interface ---------
abstract class ILoginViewModel {
  String? validatePassword(String? value);
  TextEditingController get passwordController;
  bool get obscurePassword;
  void togglePasswordVisibility();
}

/// --------- Mock ViewModel ---------
class MockLoginViewModel implements ILoginViewModel {
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
class ExceptionMockLoginViewModel implements ILoginViewModel {
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
class TestPasswordField extends StatefulWidget {
  final ILoginViewModel viewModel;

  const TestPasswordField({super.key, required this.viewModel});

  @override
  State<TestPasswordField> createState() => _TestPasswordFieldState();
}

class _TestPasswordFieldState extends State<TestPasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
            setState(() {}); // UI'ı yeniden render et
          },
        ),
        border: const OutlineInputBorder(),
      ),
      validator: widget.viewModel.validatePassword,
      autofillHints: const [AutofillHints.password],
    );
  }
}

void main() {
  group('Password Field Widget Tests', () {
    late Widget testWidget;
    late ILoginViewModel mockViewModel;
    final formKey = GlobalKey<FormState>();

    Widget createTestWidget(ILoginViewModel viewModel) {
      return MaterialApp(
        home: Scaffold(
          body: Provider<ILoginViewModel>.value(
            value: viewModel,
            child: Form(
              key: formKey,
              child: TestPasswordField(viewModel: viewModel),
            ),
          ),
        ),
      );
    }

    setUp(() {
      mockViewModel = MockLoginViewModel();
      testWidget = createTestWidget(mockViewModel);
    });

    tearDown(() {
      mockViewModel.passwordController.dispose();
    });

    group('Basic Rendering Tests', () {
      testWidgets('Password field render ediliyor', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Şifre'), findsOneWidget);
        expect(find.text('Şifrenizi girin'), findsOneWidget);
      });

      testWidgets('Password field icon gösteriyor', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });
    });

    group('User Input Tests', () {
      testWidgets('Kullanıcı şifre girişi yapabiliyor', (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.enterText(find.byType(TextFormField), '123456');
        await tester.pump();
        expect(find.text('123456'), findsOneWidget);
      });

      testWidgets('Password controller state güncelleniyor', (tester) async {
        await tester.pumpWidget(testWidget);

        expect(mockViewModel.passwordController.text, isEmpty);

        await tester.enterText(find.byType(TextFormField), '123456');
        await tester.pump();

        expect(mockViewModel.passwordController.text, equals('123456'));
      });
    });

    group('Form Validation Tests', () {
      testWidgets('Boş şifre validation testi', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(formKey.currentState?.validate() ?? false, isFalse);
      });

      testWidgets('Password validation testi - boş', (tester) async {
        await tester.pumpWidget(testWidget);
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('');
        expect(result, equals('Şifre gerekli'));
      });

      testWidgets('Password validation testi - kısa şifre', (tester) async {
        await tester.pumpWidget(testWidget);
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('123');
        expect(result, equals('Şifre en az 6 karakter olmalı'));
      });

      testWidgets('Password validation testi - geçerli şifre', (tester) async {
        await tester.pumpWidget(testWidget);
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('123456');
        expect(result, isNull);
      });

      testWidgets('Form submission validation testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Boş form validation
        expect(formKey.currentState?.validate() ?? false, isFalse);

        // Geçerli şifre ile validation
        await tester.enterText(find.byType(TextFormField), '123456');
        await tester.pump();
        expect(formKey.currentState?.validate() ?? false, isTrue);
      });
    });

    group('Password Visibility Tests', () {
      testWidgets('Password visibility toggle çalışıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Başlangıçta visibility icon'u görünür olmalı
        expect(find.byIcon(Icons.visibility), findsOneWidget);

        // Toggle butonuna tıkla
        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pump();

        // Şimdi visibility_off icon'u görünür olmalı
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);

        // Tekrar toggle yap
        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pump();

        // Tekrar visibility icon'u görünür olmalı
        expect(find.byIcon(Icons.visibility), findsOneWidget);
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
    });

    group('Edge Case Tests', () {
      testWidgets('Çok uzun şifre edge case testi', (tester) async {
        await tester.pumpWidget(testWidget);
        final longPassword = 'a' * 100;
        await tester.enterText(find.byType(TextFormField), longPassword);
        await tester.pumpAndSettle();
        expect(find.text(longPassword), findsOneWidget);
      });

      testWidgets('Çok uzun şifre validation testi', (tester) async {
        await tester.pumpWidget(testWidget);
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final longPassword = 'a' * 129;
        final result = textField.validator?.call(longPassword);
        expect(result, equals('Şifre çok uzun'));
      });

      testWidgets('Boşluk içeren şifre testi', (tester) async {
        await tester.pumpWidget(testWidget);
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('123 456');
        expect(result, equals('Şifre boşluk içeremez'));
      });

      testWidgets('Null şifre validation testi', (tester) async {
        await tester.pumpWidget(testWidget);
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call(null);
        expect(result, equals('Şifre gerekli'));
      });

      testWidgets('Özel karakterler içeren şifre testi', (tester) async {
        await tester.pumpWidget(testWidget);
        final specialPassword = '!@#\$%^&*()_+';
        await tester.enterText(find.byType(TextFormField), specialPassword);
        await tester.pump();
        expect(find.text(specialPassword), findsOneWidget);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('Exception durumunda widget davranışı', (tester) async {
        final exceptionViewModel = ExceptionMockLoginViewModel();
        final exceptionWidget = createTestWidget(exceptionViewModel);

        await tester.pumpWidget(exceptionWidget);

        // Widget'ın crash olmadan render olduğunu doğrula
        expect(find.byType(TestPasswordField), findsOneWidget);

        // Null değer ile exception testi
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        expect(() => textField.validator?.call(null), throwsException);
      });
    });

    group('Performance Tests', () {
      testWidgets('Text input performance testi', (tester) async {
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
      }, skip: true);

      testWidgets('Toggle performance testi', (tester) async {
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
      }, skip: true);
    });

    group('Accessibility Tests', () {
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
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Şifrenizi girin'), findsOneWidget);
      });
    });

    group('ViewModel Integration Tests', () {
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
    });

    group('Security Tests', () {
      testWidgets('Şifre güvenlik testi - minimum uzunluk', (tester) async {
        await tester.pumpWidget(testWidget);

        // 5 karakter - çok kısa
        final shortPassword = '12345';
        await tester.enterText(find.byType(TextFormField), shortPassword);
        await tester.pump();

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call(shortPassword);
        expect(result, equals('Şifre en az 6 karakter olmalı'));
      });

      testWidgets('Şifre güvenlik testi - geçerli uzunluk', (tester) async {
        await tester.pumpWidget(testWidget);

        // 6 karakter - minimum geçerli
        final validPassword = '123456';
        await tester.enterText(find.byType(TextFormField), validPassword);
        await tester.pump();

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call(validPassword);
        expect(result, isNull);
      });
    });
  });
}
