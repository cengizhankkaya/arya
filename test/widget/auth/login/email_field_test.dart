import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// --------- ViewModel Interface ---------
abstract class ILoginViewModel {
  String? validateEmail(String? value);
  TextEditingController get emailController;
}

/// --------- Mock ViewModel ---------
class MockLoginViewModel implements ILoginViewModel {
  final TextEditingController _emailController = TextEditingController();

  @override
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email gerekli';
    if (!value.contains('@')) return 'Geçerli email girin';
    if (value.length > 254) return 'Email çok uzun';
    if (value.contains('..')) return 'Geçersiz email formatı';
    return null;
  }

  @override
  TextEditingController get emailController => _emailController;
}

/// --------- Exception Mock ViewModel ---------
class ExceptionMockLoginViewModel implements ILoginViewModel {
  final TextEditingController _emailController = TextEditingController();

  @override
  String? validateEmail(String? value) {
    if (value == null) throw Exception('Null değer hatası');
    if (value.isEmpty) return 'Email gerekli';
    if (!value.contains('@')) return 'Geçerli email girin';
    return null;
  }

  @override
  TextEditingController get emailController => _emailController;
}

/// --------- Test Widget ---------
class TestEmailField extends StatelessWidget {
  final ILoginViewModel viewModel;

  const TestEmailField({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: viewModel.emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'ornek@email.com',
        prefixIcon: Icon(Icons.email_outlined),
        border: OutlineInputBorder(),
      ),
      validator: viewModel.validateEmail,
      autofillHints: const [AutofillHints.email],
    );
  }
}

void main() {
  group('Email Field Widget Tests', () {
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
              child: TestEmailField(viewModel: viewModel),
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
      mockViewModel.emailController.dispose();
    });

    group('Basic Rendering Tests', () {
      testWidgets('Email field render ediliyor', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('ornek@email.com'), findsOneWidget);
      });

      testWidgets('Email field icon gösteriyor', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      });
    });

    group('User Input Tests', () {
      testWidgets('Kullanıcı email girişi yapabiliyor', (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.enterText(find.byType(TextFormField), 'test@email.com');
        await tester.pump();
        expect(find.text('test@email.com'), findsOneWidget);
      });

      testWidgets('Email controller state güncelleniyor', (tester) async {
        await tester.pumpWidget(testWidget);

        expect(mockViewModel.emailController.text, isEmpty);

        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        await tester.pump();

        expect(mockViewModel.emailController.text, equals('test@example.com'));
      });
    });

    group('Form Validation Tests', () {
      testWidgets('Boş email validation testi', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(formKey.currentState?.validate() ?? false, isFalse);
      });

      testWidgets('Geçersiz email validation testi', (tester) async {
        await tester.pumpWidget(testWidget);
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('gecersizemail');
        expect(result, equals('Geçerli email girin'));
      });

      testWidgets('Geçerli email validation testi', (tester) async {
        await tester.pumpWidget(testWidget);
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('test@email.com');
        expect(result, isNull);
      });

      testWidgets('Form submission validation testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Boş form validation
        expect(formKey.currentState?.validate() ?? false, isFalse);

        // Geçerli email ile validation
        await tester.enterText(find.byType(TextFormField), 'test@email.com');
        await tester.pump();
        expect(formKey.currentState?.validate() ?? false, isTrue);
      });
    });

    group('Edge Case Tests', () {
      testWidgets('Çok uzun email edge case testi', (tester) async {
        await tester.pumpWidget(testWidget);
        final longEmail = 'a' * 100 + '@test.com';
        await tester.enterText(find.byType(TextFormField), longEmail);
        await tester.pumpAndSettle();
        expect(find.text(longEmail), findsOneWidget);
      });

      testWidgets('Çok uzun email validation testi', (tester) async {
        await tester.pumpWidget(testWidget);
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final longEmail = 'a' * 255 + '@test.com';
        final result = textField.validator?.call(longEmail);
        expect(result, equals('Email çok uzun'));
      });

      testWidgets('Çift nokta içeren email testi', (tester) async {
        await tester.pumpWidget(testWidget);
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('test..@email.com');
        expect(result, equals('Geçersiz email formatı'));
      });

      testWidgets('Null email validation testi', (tester) async {
        await tester.pumpWidget(testWidget);
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call(null);
        expect(result, equals('Email gerekli'));
      });
    });

    group('Error Handling Tests', () {
      testWidgets('Exception durumunda widget davranışı', (tester) async {
        final exceptionViewModel = ExceptionMockLoginViewModel();
        final exceptionWidget = createTestWidget(exceptionViewModel);

        await tester.pumpWidget(exceptionWidget);

        // Widget'ın crash olmadan render olduğunu doğrula
        expect(find.byType(TestEmailField), findsOneWidget);

        // Null değer ile exception testi
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        expect(() => textField.validator?.call(null), throwsException);
      });
    });

    group('Performance Tests', () {
      testWidgets('Widget rebuild performance testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final stopwatch = Stopwatch()..start();

        // Çoklu rebuild
        for (int i = 0; i < 50; i++) {
          mockViewModel.emailController.text = 'test$i@email.com';
          await tester.pump();
        }

        stopwatch.stop();
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(500),
        ); // 500ms'den az olmalı
      });

      testWidgets('Text input performance testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final stopwatch = Stopwatch()..start();

        // Hızlı text input
        for (int i = 0; i < 100; i++) {
          await tester.enterText(
            find.byType(TextFormField),
            'test$i@email.com',
          );
          await tester.pump();
        }

        stopwatch.stop();
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(1000),
        ); // 1 saniyeden az olmalı
      });
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
        expect(find.text('ornek@email.com'), findsOneWidget);
      });
    });

    group('ViewModel Integration Tests', () {
      testWidgets('ViewModel state değişiklikleri test ediliyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        // Controller'ın başlangıç durumu
        expect(mockViewModel.emailController.text, isEmpty);

        // Text girişi
        mockViewModel.emailController.text = 'test@example.com';
        expect(mockViewModel.emailController.text, equals('test@example.com'));

        // Validation testi
        final result = mockViewModel.validateEmail('test@example.com');
        expect(result, isNull);
      });

      testWidgets('ViewModel controller disposal testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Controller'ın dispose edilmediğini doğrula
        expect(mockViewModel.emailController.hasListeners, isTrue);

        // tearDown'da dispose edilecek
      });
    });

    group('Keyboard and Input Tests', () {
      testWidgets('Email input field doğru çalışıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Email input field'ın doğru çalıştığını doğrula
        await tester.enterText(find.byType(TextFormField), 'test@email.com');
        await tester.pump();

        expect(find.text('test@email.com'), findsOneWidget);
      });

      testWidgets('Text selection testi', (tester) async {
        await tester.pumpWidget(testWidget);

        await tester.enterText(find.byType(TextFormField), 'test@email.com');
        await tester.pump();

        // Text'i seç
        await tester.tap(find.byType(TextFormField));
        await tester.pump();

        // Selection'ın çalıştığını doğrula - text length kontrol et
        expect(mockViewModel.emailController.text.length, equals(14));
      });
    });
  });
}
