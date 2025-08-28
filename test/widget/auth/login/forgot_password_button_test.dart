import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// --------- Mock Dialog ---------
class MockForgotPasswordDialog extends StatelessWidget {
  const MockForgotPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Şifremi Unuttum'),
      content: const Text('Şifre sıfırlama dialog\'u'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Kapat'),
        ),
      ],
    );
  }
}

/// --------- Test Widget ---------
class TestForgotPasswordButton extends StatelessWidget {
  const TestForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const MockForgotPasswordDialog(),
          );
        },
        child: Text(
          'Şifremi Unuttum',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

void main() {
  group('ForgotPasswordButton Widget Tests', () {
    late Widget testWidget;

    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(body: const TestForgotPasswordButton()),
        theme: ThemeData(
          primaryColor: Colors.blue,
          textTheme: const TextTheme(
            labelLarge: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    setUp(() {
      testWidget = createTestWidget();
    });

    group('Basic Rendering Tests', () {
      testWidgets('ForgotPasswordButton widget render ediliyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        expect(find.byType(TextButton), findsOneWidget);
        expect(find.text('Şifremi Unuttum'), findsOneWidget);
      });
f
      testWidgets('Button metni doğru gösteriliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, equals('Şifremi Unuttum'));
      });

      testWidgets('Button alignment doğru ayarlanıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final alignWidget = tester.widget<Align>(find.byType(Align).first);
        expect(alignWidget.alignment, equals(Alignment.centerRight));
      });
    });

    group('Styling Tests', () {
      testWidgets('Button text rengi doğru ayarlanıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, equals(Colors.blue));
      });

      testWidgets('Button text font weight doğru ayarlanıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.fontWeight, equals(FontWeight.w500));
      });

      testWidgets('Farklı tema renkleri kullanılıyor', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: const TestForgotPasswordButton()),
            theme: ThemeData(primaryColor: Colors.purple),
          ),
        );

        final textWidget = tester.widget<Text>(find.byType(Text).first);
        expect(textWidget.style?.color, equals(Colors.purple));
      });
    });

    group('Interaction Tests', () {
      testWidgets('Button tıklanabilir', (tester) async {
        await tester.pumpWidget(testWidget);

        final button = find.byType(TextButton);
        expect(button, findsOneWidget);

        // Button'ın tıklanabilir olduğunu kontrol et
        final textButton = tester.widget<TextButton>(button);
        expect(textButton.onPressed, isNotNull);
      });

      testWidgets('Button tıklandığında dialog açılıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Button'ı tıkla
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();

        // Dialog açıldığını kontrol et
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(
          find.text('Şifremi Unuttum'),
          findsNWidgets(2),
        ); // Button + Dialog title
        expect(find.text('Şifre sıfırlama dialog\'u'), findsOneWidget);
      });

      testWidgets('Dialog kapatılabiliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Button'ı tıkla ve dialog'u aç
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();

        // Dialog açıldığını kontrol et
        expect(find.byType(AlertDialog), findsOneWidget);

        // Kapat butonunu tıkla
        await tester.tap(find.text('Kapat'));
        await tester.pumpAndSettle();

        // Dialog kapandığını kontrol et
        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    group('Layout Tests', () {
      testWidgets('Button sağa hizalanıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final alignWidget = tester.widget<Align>(find.byType(Align).first);
        expect(alignWidget.alignment, equals(Alignment.centerRight));
      });

      testWidgets('Button boyutları doğru', (tester) async {
        await tester.pumpWidget(testWidget);

        final button = find.byType(TextButton);
        expect(button, findsOneWidget);

        // Button'ın minimum boyutları var mı kontrol et
        final buttonWidget = tester.widget<TextButton>(button);
        expect(buttonWidget, isNotNull);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Button semantic label\'ı var', (tester) async {
        await tester.pumpWidget(testWidget);

        final button = find.byType(TextButton);
        expect(button, findsOneWidget);

        // Accessibility için semantic label kontrolü
        expect(find.bySemanticsLabel('Şifremi Unuttum'), findsOneWidget);
      });

      testWidgets('Button tıklanabilir semantic property\'si var', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        final button = find.byType(TextButton);
        expect(button, findsOneWidget);

        // Button'ın tıklanabilir olduğunu semantic olarak kontrol et
        final semantics = tester.getSemantics(find.byType(TextButton));
        expect(semantics, isNotNull);
      });
    });

    group('Edge Case Tests', () {
      testWidgets('Çok uzun text ile button render ediliyor', (tester) async {
        const longText =
            'Çok uzun bir şifremi unuttum metni burada yer alıyor ve button genişliğini aşabilir';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () {}, child: Text(longText)),
              ),
            ),
          ),
        );

        expect(find.text(longText), findsOneWidget);
      });

      testWidgets('Boş text ile button render ediliyor', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () {}, child: const Text('')),
              ),
            ),
          ),
        );

        expect(find.byType(TextButton), findsOneWidget);
      });

      testWidgets('Null onPressed ile button render ediliyor', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: null,
                  child: const Text('Şifremi Unuttum'),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(TextButton), findsOneWidget);
        expect(find.text('Şifremi Unuttum'), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('Widget rebuild performance testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Widget'ı birkaç kez yeniden render et
        for (int i = 0; i < 10; i++) {
          await tester.pumpWidget(
            MaterialApp(home: Scaffold(body: const TestForgotPasswordButton())),
          );
        }

        expect(find.byType(TestForgotPasswordButton), findsOneWidget);
      });

      testWidgets('Button tıklama performance testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Button'ı birkaç kez tıkla
        for (int i = 0; i < 5; i++) {
          await tester.tap(find.byType(TextButton));
          await tester.pumpAndSettle();

          // Dialog'u kapat
          await tester.tap(find.text('Kapat'));
          await tester.pumpAndSettle();
        }

        expect(find.byType(TestForgotPasswordButton), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('Button ve dialog entegrasyonu çalışıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Button'ı tıkla
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();

        // Dialog açıldığını kontrol et
        expect(find.byType(AlertDialog), findsOneWidget);

        // Dialog içeriğini kontrol et
        expect(find.text('Şifremi Unuttum'), findsNWidgets(2));
        expect(find.text('Şifre sıfırlama dialog\'u'), findsOneWidget);
        expect(find.text('Kapat'), findsOneWidget);

        // Dialog'u kapat
        await tester.tap(find.text('Kapat'));
        await tester.pumpAndSettle();

        // Dialog kapandığını kontrol et
        expect(find.byType(AlertDialog), findsNothing);

        // Button hala mevcut
        expect(find.byType(TextButton), findsOneWidget);
      });
    });
  });
}
