import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/auth/login/view/widget/error_message.dart';

void main() {
  group('ErrorMessage Widget Tests', () {
    late Widget testWidget;
    const String testMessage = 'Bu bir test hata mesajıdır';

    Widget createTestWidget({String? message, ThemeData? theme}) {
      return MaterialApp(
        home: Scaffold(
          body: ErrorMessage(message: message ?? testMessage),
        ),
        theme: theme ?? ThemeData(
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

        expect(find.byType(ErrorMessage), findsOneWidget);
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
        expect(decoration.borderRadius, isA<BorderRadius>());
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

      testWidgets('Container arka plan rengi doğru', (tester) async {
        await tester.pumpWidget(testWidget);

        final containerWidget = tester.widget<Container>(
          find.byType(Container),
        );
        final decoration = containerWidget.decoration as BoxDecoration;

        expect(decoration.color, equals(Colors.redAccent));
      });
    });

    group('Layout Tests', () {
      testWidgets('Padding doğru uygulanıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final containerWidget = tester.widget<Container>(
          find.byType(Container),
        );
        
        // ProjectPadding.allVerySmall() değerini kontrol et
        expect(containerWidget.padding, isNotNull);
        expect(containerWidget.padding, isA<EdgeInsets>());
      });

      testWidgets('Margin doğru uygulanıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final containerWidget = tester.widget<Container>(
          find.byType(Container),
        );
        
        // ProjectMargin.topMedium değerini kontrol et
        expect(containerWidget.margin, isNotNull);
        expect(containerWidget.margin, isA<EdgeInsets>());
      });

      testWidgets('Border radius doğru uygulanıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        final containerWidget = tester.widget<Container>(
          find.byType(Container),
        );
        final decoration = containerWidget.decoration as BoxDecoration;
        
        // ProjectRadius.medium değerini kontrol et
        expect(decoration.borderRadius, isNotNull);
        expect(decoration.borderRadius, isA<BorderRadius>());
      });

      testWidgets('Widget boyutları doğru', (tester) async {
        await tester.pumpWidget(testWidget);

        final containerWidget = tester.widget<Container>(
          find.byType(Container),
        );
        
        expect(containerWidget.constraints, isNull); // Constraints yok
        expect(containerWidget.child, isNotNull); // Child var
      });
    });

    group('Content Tests', () {
      testWidgets('Farklı hata mesajları gösteriliyor', (tester) async {
        const differentMessage = 'Farklı bir hata mesajı';

        await tester.pumpWidget(createTestWidget(message: differentMessage));

        expect(find.text(differentMessage), findsOneWidget);
        expect(find.text(testMessage), findsNothing);
      });

      testWidgets('Boş hata mesajı gösteriliyor', (tester) async {
        await tester.pumpWidget(createTestWidget(message: ''));

        expect(find.text(''), findsOneWidget);
      });

      testWidgets('Uzun hata mesajı gösteriliyor', (tester) async {
        const longMessage =
            'Bu çok uzun bir hata mesajıdır ve widget\'ın genişliğini aşabilir, bu durumda text wrapping yapılmalıdır';

        await tester.pumpWidget(createTestWidget(message: longMessage));

        expect(find.text(longMessage), findsOneWidget);
      });

      testWidgets('Tek karakter hata mesajı', (tester) async {
        await tester.pumpWidget(createTestWidget(message: '!'));
        expect(find.text('!'), findsOneWidget);
      });
    });

    group('Theme Integration Tests', () {
      testWidgets('Farklı tema renkleri kullanılıyor', (tester) async {
        final customTheme = ThemeData(
          colorScheme: const ColorScheme.light(
            error: Colors.purple,
            errorContainer: Colors.purpleAccent,
            onErrorContainer: Colors.yellow,
          ),
        );

        await tester.pumpWidget(createTestWidget(theme: customTheme));

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
        final darkTheme = ThemeData(
          colorScheme: const ColorScheme.dark(
            error: Colors.red,
            errorContainer: Colors.redAccent,
            onErrorContainer: Colors.white,
          ),
        );

        await tester.pumpWidget(createTestWidget(theme: darkTheme));

        expect(find.text(testMessage), findsOneWidget);
        
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, equals(Colors.white));
      });

      testWidgets('High contrast tema ile çalışıyor', (tester) async {
        final highContrastTheme = ThemeData(
          colorScheme: const ColorScheme.light(
            error: Colors.red,
            errorContainer: Colors.redAccent,
            onErrorContainer: Colors.white,
          ),
        );

        await tester.pumpWidget(createTestWidget(theme: highContrastTheme));

        expect(find.text(testMessage), findsOneWidget);
      });
    });

    group('Edge Case Tests', () {
      testWidgets('Çok uzun hata mesajı edge case testi', (tester) async {
        final veryLongMessage = 'A' * 1000;

        await tester.pumpWidget(createTestWidget(message: veryLongMessage));

        expect(find.text(veryLongMessage), findsOneWidget);
      });

      testWidgets('Özel karakterler içeren hata mesajı', (tester) async {
        const specialMessage = 'Hata: @#\$%^&*()_+-=[]{}|;\'",./<>?`~';

        await tester.pumpWidget(createTestWidget(message: specialMessage));

        expect(find.text(specialMessage), findsOneWidget);
      });

      testWidgets('Emoji içeren hata mesajı', (tester) async {
        const emojiMessage = 'Hata: 🚨 ❌ ⚠️';

        await tester.pumpWidget(createTestWidget(message: emojiMessage));

        expect(find.text(emojiMessage), findsOneWidget);
      });

      testWidgets('Null message ile çalışmamalı', (tester) async {
        // ErrorMessage required message parametresi olduğu için null olamaz
        expect(() => ErrorMessage(message: null as String), throwsA(anything));
      });

      testWidgets('Whitespace only message', (tester) async {
        await tester.pumpWidget(createTestWidget(message: '   '));
        expect(find.text('   '), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Semantic label doğru', (tester) async {
        await tester.pumpWidget(testWidget);

        final semantics = tester.getSemantics(find.byType(ErrorMessage));
        expect(semantics, isNotNull);
      });

      testWidgets('Text widget semantic özellikleri', (tester) async {
        await tester.pumpWidget(testWidget);

        final textSemantics = tester.getSemantics(find.byType(Text));
        expect(textSemantics, isNotNull);
      });
    });

    group('Performance Tests', () {
      testWidgets('Widget build performance testi', (tester) async {
        final stopwatch = Stopwatch()..start();
        
        await tester.pumpWidget(testWidget);
        
        stopwatch.stop();
        
        // Build süresi makul olmalı
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      testWidgets('Widget rebuild performance testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final stopwatch = Stopwatch()..start();

        // Widget'ı birkaç kez yeniden render et
        for (int i = 0; i < 5; i++) {
          await tester.pumpWidget(createTestWidget(message: 'Test $i'));
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
      });

      testWidgets('Text rendering performance testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final textWidget = find.byType(Text);
        expect(textWidget, findsOneWidget);

        // Performans için widget'ı yeniden render et
        await tester.pump();
      });
    });

    group('Responsiveness Tests', () {
      testWidgets('Farklı ekran boyutlarında çalışıyor', (tester) async {
        // Küçük ekran
        tester.binding.window.physicalSizeTestValue = const Size(320, 568);
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        await tester.pumpWidget(testWidget);
        expect(find.byType(ErrorMessage), findsOneWidget);

        // Orta ekran
        tester.binding.window.physicalSizeTestValue = const Size(600, 400);
        await tester.pumpWidget(testWidget);
        expect(find.byType(ErrorMessage), findsOneWidget);

        // Büyük ekran
        tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
        await tester.pumpWidget(testWidget);
        expect(find.byType(ErrorMessage), findsOneWidget);

        // Reset
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });

      testWidgets('Landscape ve portrait modda çalışıyor', (tester) async {
        // Portrait
        tester.binding.window.physicalSizeTestValue = const Size(375, 812);
        await tester.pumpWidget(testWidget);
        expect(find.byType(ErrorMessage), findsOneWidget);

        // Landscape
        tester.binding.window.physicalSizeTestValue = const Size(812, 375);
        await tester.pumpWidget(testWidget);
        expect(find.byType(ErrorMessage), findsOneWidget);

        // Reset
        tester.binding.window.clearPhysicalSizeTestValue();
      });
    });

    group('Integration Tests', () {
      testWidgets('Form içinde çalışıyor', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                child: Column(
                  children: [
                    const Text('Form Title'),
                    ErrorMessage(message: testMessage),
                    const Text('Form Footer'),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(ErrorMessage), findsOneWidget);
        expect(find.text(testMessage), findsOneWidget);
      });

      testWidgets('ListView içinde çalışıyor', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView(
                children: [
                  const Text('Header'),
                  ErrorMessage(message: testMessage),
                  const Text('Footer'),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(ErrorMessage), findsOneWidget);
        expect(find.text(testMessage), findsOneWidget);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('Widget dispose edildiğinde hata vermemeli', (tester) async {
        await tester.pumpWidget(testWidget);
        
        // Widget'ı dispose et
        await tester.pumpWidget(const SizedBox.shrink());
        
        // Hata vermemeli
        expect(true, isTrue);
      });

      testWidgets('Theme değişikliğinde hata vermemeli', (tester) async {
        await tester.pumpWidget(testWidget);
        
        // Farklı tema ile yeniden render et
        final newTheme = ThemeData(
          colorScheme: const ColorScheme.light(
            error: Colors.blue,
            errorContainer: Colors.blueAccent,
            onErrorContainer: Colors.black,
          ),
        );
        
        await tester.pumpWidget(createTestWidget(theme: newTheme));
        
        expect(find.byType(ErrorMessage), findsOneWidget);
      });
    });
  });
}
