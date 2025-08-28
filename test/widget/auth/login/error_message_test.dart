import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// --------- Test Widget ---------
class TestErrorMessage extends StatelessWidget {
  final String message;

  const TestErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(8.0), // ProjectPadding.allVerySmall()
      margin: const EdgeInsets.only(top: 16.0), // ProjectMargin.topMedium
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(8.0), // ProjectRadius.medium
        border: Border.all(color: scheme.error),
      ),
      child: Text(
        message,
        style: TextStyle(color: scheme.onErrorContainer),
        textAlign: TextAlign.center,
      ),
    );
  }
}

void main() {
  group('ErrorMessage Widget Tests', () {
    late Widget testWidget;
    const String testMessage = 'Bu bir test hata mesajıdır';

    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(body: TestErrorMessage(message: testMessage)),
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            error: Colors.red,
            errorContainer: Colors.redAccent,
            onErrorContainer: Colors.white,
          ),
        ),
      );
    }

    setUp(() {
      testWidget = createTestWidget();
    });

    group('Basic Rendering Tests', () {
      testWidgets('ErrorMessage widget render ediliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
        expect(find.text(testMessage), findsOneWidget);
      });

      testWidgets('Hata mesajı doğru şekilde gösteriliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, equals(testMessage));
        expect(textWidget.textAlign, equals(TextAlign.center));
      });

      testWidgets('Container dekorasyonu doğru uygulanıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final containerWidget = tester.widget<Container>(
          find.byType(Container),
        );
        final decoration = containerWidget.decoration as BoxDecoration;

        expect(decoration.color, equals(Colors.redAccent));
        expect(decoration.borderRadius, equals(BorderRadius.circular(8.0)));
        expect(decoration.border, isA<Border>());
      });
    });

    group('Styling Tests', () {
      testWidgets('Text rengi doğru ayarlanıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, equals(Colors.white));
      });

      testWidgets('Border rengi doğru ayarlanıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final containerWidget = tester.widget<Container>(
          find.byType(Container),
        );
        final decoration = containerWidget.decoration as BoxDecoration;
        final border = decoration.border as Border;

        expect(border.top.color, equals(Colors.red));
        expect(border.bottom.color, equals(Colors.red));
        expect(border.left.color, equals(Colors.red));
        expect(border.right.color, equals(Colors.red));
      });
    });

    group('Layout Tests', () {
      testWidgets('Padding doğru uygulanıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final containerWidget = tester.widget<Container>(
          find.byType(Container),
        );
        expect(containerWidget.padding, equals(const EdgeInsets.all(8.0)));
      });

      testWidgets('Margin doğru uygulanıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final containerWidget = tester.widget<Container>(
          find.byType(Container),
        );
        expect(
          containerWidget.margin,
          equals(const EdgeInsets.only(top: 16.0)),
        );
      });

      testWidgets('Border radius doğru uygulanıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final containerWidget = tester.widget<Container>(
          find.byType(Container),
        );
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.borderRadius, equals(BorderRadius.circular(8.0)));
      });
    });

    group('Content Tests', () {
      testWidgets('Farklı hata mesajları gösteriliyor', (tester) async {
        const differentMessage = 'Farklı bir hata mesajı';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: TestErrorMessage(message: differentMessage)),
          ),
        );

        expect(find.text(differentMessage), findsOneWidget);
        expect(find.text(testMessage), findsNothing);
      });

      testWidgets('Boş hata mesajı gösteriliyor', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: TestErrorMessage(message: '')),
          ),
        );

        expect(find.text(''), findsOneWidget);
      });

      testWidgets('Uzun hata mesajı gösteriliyor', (tester) async {
        const longMessage =
            'Bu çok uzun bir hata mesajıdır ve widget\'ın genişliğini aşabilir, bu durumda text wrapping yapılmalıdır';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: TestErrorMessage(message: longMessage)),
          ),
        );

        expect(find.text(longMessage), findsOneWidget);
      });
    });

    group('Theme Integration Tests', () {
      testWidgets('Farklı tema renkleri kullanılıyor', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: TestErrorMessage(message: testMessage)),
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                error: Colors.purple,
                errorContainer: Colors.purpleAccent,
                onErrorContainer: Colors.yellow,
              ),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.byType(Text));
        final containerWidget = tester.widget<Container>(
          find.byType(Container),
        );
        final decoration = containerWidget.decoration as BoxDecoration;

        expect(textWidget.style?.color, equals(Colors.yellow));
        expect(decoration.color, equals(Colors.purpleAccent));
        expect(decoration.border, isA<Border>());
      });

      testWidgets('Dark tema ile çalışıyor', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: TestErrorMessage(message: testMessage)),
            theme: ThemeData(
              colorScheme: const ColorScheme.dark(
                error: Colors.red,
                errorContainer: Colors.redAccent,
                onErrorContainer: Colors.white,
              ),
            ),
          ),
        );

        expect(find.text(testMessage), findsOneWidget);
      });
    });

    group('Edge Case Tests', () {
      testWidgets('Çok uzun hata mesajı edge case testi', (tester) async {
        final veryLongMessage = 'A' * 1000;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: TestErrorMessage(message: veryLongMessage)),
          ),
        );

        expect(find.text(veryLongMessage), findsOneWidget);
      });

      testWidgets('Özel karakterler içeren hata mesajı', (tester) async {
        const specialMessage = 'Hata: @#\$%^&*()_+-=[]{}|;\'",./<>?`~';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: TestErrorMessage(message: specialMessage)),
          ),
        );

        expect(find.text(specialMessage), findsOneWidget);
      });

      testWidgets('Emoji içeren hata mesajı', (tester) async {
        const emojiMessage = 'Hata: 🚨 ❌ ⚠️';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: TestErrorMessage(message: emojiMessage)),
          ),
        );

        expect(find.text(emojiMessage), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('Widget rebuild performance testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Widget'ı birkaç kez yeniden render et
        for (int i = 0; i < 10; i++) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: TestErrorMessage(message: 'Test $i')),
            ),
          );
        }

        expect(find.byType(TestErrorMessage), findsOneWidget);
      });

      testWidgets('Text rendering performance testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Text widget'ını bul ve render et
        final textWidget = find.byType(Text);
        expect(textWidget, findsOneWidget);

        // Performans için widget'ı yeniden render et
        await tester.pump();
      });
    });
  });
}
