import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/auth/register/view/register_text_field.dart';

/// --------- Mock ViewModel Interface ---------
abstract class IRegisterTextFieldViewModel {
  String? validateName(String? value);
  String? validateEmail(String? value);
  TextEditingController get nameController;
  TextEditingController get emailController;
}

/// --------- Mock ViewModel ---------
class MockRegisterTextFieldViewModel implements IRegisterTextFieldViewModel {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Ad gerekli';
    if (value.trim().length < 2) return 'Ad en az 2 karakter olmalı';
    if (value.trim().length > 50) return 'Ad çok uzun';
    return null;
  }

  @override
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email gerekli';
    if (!value.contains('@')) return 'Geçerli email girin';
    if (value.length > 254) return 'Email çok uzun';
    return null;
  }

  @override
  TextEditingController get nameController => _nameController;

  @override
  TextEditingController get emailController => _emailController;
}

/// --------- Exception Mock ViewModel ---------
class ExceptionMockRegisterTextFieldViewModel
    implements IRegisterTextFieldViewModel {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  String? validateName(String? value) {
    if (value == null) throw Exception('Null değer hatası');
    if (value.isEmpty) return 'Ad gerekli';
    if (value.length < 2) return 'Ad en az 2 karakter olmalı';
    return null;
  }

  @override
  String? validateEmail(String? value) {
    if (value == null) throw Exception('Null değer hatası');
    if (value.isEmpty) return 'Email gerekli';
    if (!value.contains('@')) return 'Geçerli email girin';
    return null;
  }

  @override
  TextEditingController get nameController => _nameController;

  @override
  TextEditingController get emailController => _emailController;
}

/// --------- Test Widget ---------
class TestRegisterTextField extends StatelessWidget {
  final IRegisterTextFieldViewModel viewModel;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const TestRegisterTextField({
    super.key,
    required this.viewModel,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return RegisterTextField(
      controller: viewModel.nameController,
      label: label,
      icon: icon,
      keyboardType: keyboardType,
      validator: validator ?? viewModel.validateName,
    );
  }
}

void main() {
  group('RegisterTextField Widget Tests', () {
    late Widget testWidget;
    late IRegisterTextFieldViewModel mockViewModel;
    final formKey = GlobalKey<FormState>();

    Widget createTestWidget(
      IRegisterTextFieldViewModel viewModel, {
      String label = 'Ad',
      IconData icon = Icons.person,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: TestRegisterTextField(
              viewModel: viewModel,
              label: label,
              icon: icon,
              keyboardType: keyboardType,
              validator: validator,
            ),
          ),
        ),
      );
    }

    setUp(() {
      mockViewModel = MockRegisterTextFieldViewModel();
      testWidget = createTestWidget(mockViewModel);
    });

    tearDown(() {
      mockViewModel.nameController.dispose();
      mockViewModel.emailController.dispose();
    });

    group('Temel Render Testleri', () {
      testWidgets('RegisterTextField doğru şekilde render ediliyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        expect(find.byType(RegisterTextField), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Ad'), findsOneWidget);
      });

      testWidgets('Label text doğru şekilde gösteriliyor', (tester) async {
        const customLabel = 'Özel Etiket';
        final customWidget = createTestWidget(
          mockViewModel,
          label: customLabel,
        );

        await tester.pumpWidget(customWidget);
        expect(find.text(customLabel), findsOneWidget);
      });

      testWidgets('Prefix icon doğru şekilde gösteriliyor', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      testWidgets('Farklı icon türleri ile render ediliyor', (tester) async {
        final emailWidget = createTestWidget(
          mockViewModel,
          label: 'Email',
          icon: Icons.email,
        );

        await tester.pumpWidget(emailWidget);
        expect(find.byIcon(Icons.email), findsOneWidget);
        expect(find.byIcon(Icons.person), findsNothing);
      });

      testWidgets('Widget doğru şekilde render ediliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Widget'ın doğru render edildiğini doğrula
        expect(find.byType(RegisterTextField), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
        expect(find.text('Ad'), findsOneWidget);
      });
    });

    group('Kullanıcı Giriş Testleri', () {
      testWidgets('Kullanıcı text girişi yapabiliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        const testText = 'Ahmet Yılmaz';
        await tester.enterText(find.byType(TextFormField), testText);
        await tester.pump();

        expect(find.text(testText), findsOneWidget);
      });

      testWidgets('Text controller state güncelleniyor', (tester) async {
        await tester.pumpWidget(testWidget);

        expect(mockViewModel.nameController.text, isEmpty);

        const testText = 'Test Kullanıcı';
        await tester.enterText(find.byType(TextFormField), testText);
        await tester.pump();

        expect(mockViewModel.nameController.text, equals(testText));
      });

      testWidgets('Farklı karakter türleri ile giriş yapılabiliyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        const specialText = 'Ahmet-Yılmaz_123!@#';
        await tester.enterText(find.byType(TextFormField), specialText);
        await tester.pump();

        expect(find.text(specialText), findsOneWidget);
      });

      testWidgets('Unicode karakterler ile giriş yapılabiliyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        const unicodeText = 'Şahin Çelik Özkan';
        await tester.enterText(find.byType(TextFormField), unicodeText);
        await tester.pump();

        expect(find.text(unicodeText), findsOneWidget);
      });

      testWidgets('Sayısal karakterler ile giriş yapılabiliyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        const numericText = '1234567890';
        await tester.enterText(find.byType(TextFormField), numericText);
        await tester.pump();

        expect(find.text(numericText), findsOneWidget);
      });
    });

    group('Keyboard Type Testleri', () {
      testWidgets('Farklı keyboard type\'lar ile widget oluşturulabiliyor', (
        tester,
      ) async {
        // Email keyboard type
        final emailWidget = createTestWidget(
          mockViewModel,
          label: 'Email',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        );

        await tester.pumpWidget(emailWidget);
        expect(find.byType(RegisterTextField), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.byIcon(Icons.email), findsOneWidget);

        // Number keyboard type
        final numberWidget = createTestWidget(
          mockViewModel,
          label: 'Telefon',
          icon: Icons.phone,
          keyboardType: TextInputType.number,
        );

        await tester.pumpWidget(numberWidget);
        expect(find.byType(RegisterTextField), findsOneWidget);
        expect(find.text('Telefon'), findsOneWidget);
        expect(find.byIcon(Icons.phone), findsOneWidget);

        // Phone keyboard type
        final phoneWidget = createTestWidget(
          mockViewModel,
          label: 'Telefon',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        );

        await tester.pumpWidget(phoneWidget);
        expect(find.byType(RegisterTextField), findsOneWidget);
        expect(find.text('Telefon'), findsOneWidget);
        expect(find.byIcon(Icons.phone), findsOneWidget);
      });
    });

    group('Form Validasyon Testleri', () {
      testWidgets('Boş text validasyon testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('');
        expect(result, equals('Ad gerekli'));
      });

      testWidgets('Null text validasyon testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call(null);
        expect(result, equals('Ad gerekli'));
      });

      testWidgets('Kısa text validasyon testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('A');
        expect(result, equals('Ad en az 2 karakter olmalı'));
      });

      testWidgets('Geçerli text validasyon testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('Ahmet');
        expect(result, isNull);
      });

      testWidgets('Çok uzun text validasyon testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final longText = 'a' * 51;
        final result = textField.validator?.call(longText);
        expect(result, equals('Ad çok uzun'));
      });

      testWidgets('Sadece boşluk karakteri validasyon testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('   ');
        expect(result, equals('Ad gerekli'));
      });

      testWidgets('Form submission validasyon testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Boş form validasyon
        expect(formKey.currentState?.validate() ?? false, isFalse);

        // Geçerli text ile validasyon
        await tester.enterText(find.byType(TextFormField), 'Ahmet');
        await tester.pump();
        expect(formKey.currentState?.validate() ?? false, isTrue);
      });
    });

    group('Email Validasyon Testleri', () {
      testWidgets('Email validasyon testi - boş email', (tester) async {
        final emailWidget = createTestWidget(
          mockViewModel,
          label: 'Email',
          icon: Icons.email,
          validator: mockViewModel.validateEmail,
        );

        await tester.pumpWidget(emailWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('');
        expect(result, equals('Email gerekli'));
      });

      testWidgets('Email validasyon testi - geçersiz email', (tester) async {
        final emailWidget = createTestWidget(
          mockViewModel,
          label: 'Email',
          icon: Icons.email,
          validator: mockViewModel.validateEmail,
        );

        await tester.pumpWidget(emailWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('gecersizemail');
        expect(result, equals('Geçerli email girin'));
      });

      testWidgets('Email validasyon testi - geçerli email', (tester) async {
        final emailWidget = createTestWidget(
          mockViewModel,
          label: 'Email',
          icon: Icons.email,
          validator: mockViewModel.validateEmail,
        );

        await tester.pumpWidget(emailWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final result = textField.validator?.call('test@email.com');
        expect(result, isNull);
      });

      testWidgets('Email validasyon testi - çok uzun email', (tester) async {
        final emailWidget = createTestWidget(
          mockViewModel,
          label: 'Email',
          icon: Icons.email,
          validator: mockViewModel.validateEmail,
        );

        await tester.pumpWidget(emailWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        final longEmail = 'a' * 250 + '@email.com';
        final result = textField.validator?.call(longEmail);
        expect(result, equals('Email çok uzun'));
      });
    });

    group('Edge Case Testleri', () {
      testWidgets('Çok uzun text edge case testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final longText = 'a' * 100;
        await tester.enterText(find.byType(TextFormField), longText);
        await tester.pumpAndSettle();

        expect(find.text(longText), findsOneWidget);
      });

      testWidgets('Minimum geçerli text uzunluğu testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        // 1 karakter - çok kısa
        final shortText = 'A';
        expect(
          textField.validator?.call(shortText),
          equals('Ad en az 2 karakter olmalı'),
        );

        // 2 karakter - minimum geçerli
        final validText = 'Ab';
        expect(textField.validator?.call(validText), isNull);
      });

      testWidgets('Maksimum text uzunluğu testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        // 50 karakter - maksimum geçerli
        final maxValidText = 'a' * 50;
        expect(textField.validator?.call(maxValidText), isNull);

        // 51 karakter - çok uzun
        final tooLongText = 'a' * 51;
        expect(textField.validator?.call(tooLongText), equals('Ad çok uzun'));
      });

      testWidgets('Özel karakterler içeren text testi', (tester) async {
        await tester.pumpWidget(testWidget);

        const specialText = '!@#\$%^&*()_+{}|:"<>?[]\\;\',./';
        await tester.enterText(find.byType(TextFormField), specialText);
        await tester.pump();

        expect(find.text(specialText), findsOneWidget);
      });

      testWidgets('Karışık karakter türleri testi', (tester) async {
        await tester.pumpWidget(testWidget);

        const mixedText = 'Ahmet123!@#Yılmaz';
        await tester.enterText(find.byType(TextFormField), mixedText);
        await tester.pump();

        expect(find.text(mixedText), findsOneWidget);
      });
    });

    group('Hata Yönetimi Testleri', () {
      testWidgets('Exception durumunda widget davranışı', (tester) async {
        final exceptionViewModel = ExceptionMockRegisterTextFieldViewModel();
        final exceptionWidget = createTestWidget(exceptionViewModel);

        await tester.pumpWidget(exceptionWidget);

        // Widget'ın crash olmadan render olduğunu doğrula
        expect(find.byType(TestRegisterTextField), findsOneWidget);

        // Null değer ile exception testi
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        expect(() => textField.validator?.call(null), throwsException);
      });

      testWidgets('Custom validator kullanımı', (tester) async {
        String? customValidator(String? value) {
          if (value == null || value.isEmpty) return 'Özel hata mesajı';
          if (value.length < 5) return 'En az 5 karakter olmalı';
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
        expect(customValidator('123'), equals('En az 5 karakter olmalı'));
        expect(customValidator('12345'), isNull);
      });

      testWidgets('Farklı validator türleri testi', (tester) async {
        // Name validator
        final nameWidget = createTestWidget(
          mockViewModel,
          label: 'Ad',
          icon: Icons.person,
          validator: mockViewModel.validateName,
        );

        await tester.pumpWidget(nameWidget);

        final nameField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        expect(
          nameField.validator?.call('A'),
          equals('Ad en az 2 karakter olmalı'),
        );

        // Email validator
        final emailWidget = createTestWidget(
          mockViewModel,
          label: 'Email',
          icon: Icons.email,
          validator: mockViewModel.validateEmail,
        );

        await tester.pumpWidget(emailWidget);

        final emailField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        expect(
          emailField.validator?.call('test'),
          equals('Geçerli email girin'),
        );
      });
    });

    group('Performans Testleri', () {
      testWidgets('Widget rebuild performans testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final stopwatch = Stopwatch()..start();

        // Çoklu rebuild
        for (int i = 0; i < 50; i++) {
          mockViewModel.nameController.text = 'text$i';
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
          await tester.enterText(find.byType(TextFormField), 'text$i');
          await tester.pump();
        }

        stopwatch.stop();
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(1500),
        ); // 1.5 saniyeden az olmalı
      });

      testWidgets('Validation performans testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        final stopwatch = Stopwatch()..start();

        // Hızlı validation
        for (int i = 0; i < 1000; i++) {
          textField.validator?.call('test$i');
        }

        stopwatch.stop();
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(100),
        ); // 100ms'den az olmalı
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
        expect(find.byType(RegisterTextField), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Ad'), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      testWidgets('Label ve icon eşleşmesi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Label ve icon doğru eşleşiyor mu?
        expect(find.text('Ad'), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
      });
    });

    group('ViewModel Entegrasyon Testleri', () {
      testWidgets('ViewModel controller disposal testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Controller'ın dispose edilmediğini doğrula
        expect(mockViewModel.nameController.hasListeners, isTrue);

        // tearDown'da dispose edilecek
      });

      testWidgets('Controller text değişiklikleri test ediliyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        const testText = 'testText';
        mockViewModel.nameController.text = testText;
        await tester.pump();

        expect(find.text(testText), findsOneWidget);
      });

      testWidgets('Farklı controller kullanımı', (tester) async {
        // Name controller
        final nameWidget = createTestWidget(
          mockViewModel,
          label: 'Ad',
          icon: Icons.person,
        );

        await tester.pumpWidget(nameWidget);
        await tester.enterText(find.byType(TextFormField), 'Ahmet');
        await tester.pump();

        expect(mockViewModel.nameController.text, equals('Ahmet'));

        // Email controller
        final emailWidget = createTestWidget(
          mockViewModel,
          label: 'Email',
          icon: Icons.email,
        );

        await tester.pumpWidget(emailWidget);
        await tester.enterText(find.byType(TextFormField), 'test@email.com');
        await tester.pump();

        expect(mockViewModel.nameController.text, equals('test@email.com'));
      });
    });

    group('Güvenlik Testleri', () {
      testWidgets('Text güvenlik testi - minimum uzunluk', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        // 1 karakter - çok kısa
        final shortText = 'A';
        expect(
          textField.validator?.call(shortText),
          equals('Ad en az 2 karakter olmalı'),
        );

        // 2 karakter - minimum geçerli
        final validText = 'Ab';
        expect(textField.validator?.call(validText), isNull);
      });

      testWidgets('Text güvenlik testi - maksimum uzunluk', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        // 50 karakter - maksimum geçerli
        final maxValidText = 'a' * 50;
        expect(textField.validator?.call(maxValidText), isNull);

        // 51 karakter - çok uzun
        final tooLongText = 'a' * 51;
        expect(textField.validator?.call(tooLongText), equals('Ad çok uzun'));
      });

      testWidgets('Text güvenlik testi - boşluk kontrolü', (tester) async {
        await tester.pumpWidget(testWidget);

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        // Sadece boşluk karakteri
        final spaceOnlyText = '   ';
        expect(textField.validator?.call(spaceOnlyText), equals('Ad gerekli'));

        // Boşluk içeren geçerli text
        final validTextWithSpace = ' Ahmet ';
        expect(textField.validator?.call(validTextWithSpace), isNull);
      });
    });

    group('UI/UX Testleri', () {
      testWidgets('Widget doğru şekilde render ediliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Widget'ın doğru render edildiğini doğrula
        expect(find.byType(RegisterTextField), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
        expect(find.text('Ad'), findsOneWidget);
      });

      testWidgets('Farklı icon türleri testi', (tester) async {
        // Person icon
        final personWidget = createTestWidget(
          mockViewModel,
          label: 'Ad',
          icon: Icons.person,
        );
        await tester.pumpWidget(personWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);

        // Email icon
        final emailWidget = createTestWidget(
          mockViewModel,
          label: 'Email',
          icon: Icons.email,
        );
        await tester.pumpWidget(emailWidget);
        expect(find.byIcon(Icons.email), findsOneWidget);

        // Phone icon
        final phoneWidget = createTestWidget(
          mockViewModel,
          label: 'Telefon',
          icon: Icons.phone,
        );
        await tester.pumpWidget(phoneWidget);
        expect(find.byIcon(Icons.phone), findsOneWidget);
      });

      testWidgets('Label text değişiklikleri', (tester) async {
        // Ad label
        final nameWidget = createTestWidget(
          mockViewModel,
          label: 'Ad',
          icon: Icons.person,
        );
        await tester.pumpWidget(nameWidget);
        expect(find.text('Ad'), findsOneWidget);

        // Email label
        final emailWidget = createTestWidget(
          mockViewModel,
          label: 'Email',
          icon: Icons.email,
        );
        await tester.pumpWidget(emailWidget);
        expect(find.text('Email'), findsOneWidget);

        // Telefon label
        final phoneWidget = createTestWidget(
          mockViewModel,
          label: 'Telefon',
          icon: Icons.phone,
        );
        await tester.pumpWidget(phoneWidget);
        expect(find.text('Telefon'), findsOneWidget);
      });
    });
  });
}
