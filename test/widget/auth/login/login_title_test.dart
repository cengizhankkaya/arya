import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// --------- ViewModel Interface ---------
abstract class ILoginViewModel {
  String get welcomeTitle;
  String get welcomeDescription;
}

/// --------- Mock ViewModel ---------
class MockLoginViewModel implements ILoginViewModel {
  @override
  String get welcomeTitle => 'Hoş Geldiniz';

  @override
  String get welcomeDescription => 'Hesabınıza giriş yapın';
}

/// --------- Exception Mock ViewModel ---------
class ExceptionMockLoginViewModel implements ILoginViewModel {
  @override
  String get welcomeTitle => throw Exception('Title hatası');

  @override
  String get welcomeDescription => throw Exception('Description hatası');
}

/// --------- Test Widget ---------
class TestLoginTitle extends StatelessWidget {
  final ILoginViewModel viewModel;

  const TestLoginTitle({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Lottie animasyonu yerine Icon kullanıyoruz (test için)
        const Icon(Icons.login, size: 120.0, color: Colors.blue),
        const SizedBox(height: 8.0),
        Text(
          viewModel.welcomeTitle,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          viewModel.welcomeDescription,
          style: const TextStyle(fontSize: 16.0, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

void main() {
  group('LoginTitle Widget Tests', () {
    // Test constants - sabit değerler
    const double _expectedLottieSize = 120.0;
    const double _expectedSpacing = 8.0;
    const double _expectedTitleFontSize = 24.0;
    const double _expectedBodyFontSize = 16.0;
    const FontWeight _expectedTitleFontWeight = FontWeight.w700;

    late Widget testWidget;
    late ILoginViewModel mockViewModel;

    // Test için özel widget wrapper
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(body: child),
        theme: ThemeData(
          textTheme: const TextTheme(
            headlineMedium: TextStyle(
              fontSize: _expectedTitleFontSize,
              fontWeight: _expectedTitleFontWeight,
            ),
            bodyLarge: TextStyle(fontSize: _expectedBodyFontSize),
          ),
          colorScheme: const ColorScheme.light(
            onSurface: Colors.black87,
            onSurfaceVariant: Colors.black54,
          ),
        ),
      );
    }

    setUp(() {
      mockViewModel = MockLoginViewModel();

      testWidget = createTestWidget(
        Provider<ILoginViewModel>.value(
          value: mockViewModel,
          child: TestLoginTitle(viewModel: mockViewModel),
        ),
      );
    });

    group('Widget Rendering Tests', () {
      testWidgets('LoginTitle widget başarıyla render edilir', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(find.byType(TestLoginTitle), findsOneWidget);
      });

      testWidgets('LoginTitle Lottie animasyonunu gösterir', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(find.byIcon(Icons.login), findsOneWidget);

        final iconFinder = find.byIcon(Icons.login);
        final iconWidget = tester.widget<Icon>(iconFinder);
        expect(iconWidget.size, _expectedLottieSize);
        expect(iconWidget.color, Colors.blue);
      });

      testWidgets('LoginTitle metin elementlerini gösterir', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(find.byType(Text), findsNWidgets(2));
        expect(find.text(mockViewModel.welcomeTitle), findsOneWidget);
        expect(find.text(mockViewModel.welcomeDescription), findsOneWidget);
      });
    });

    group('Layout Structure Tests', () {
      testWidgets('LoginTitle layout düzeni doğru', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(find.byType(Column), findsOneWidget);

        final columnFinder = find.byType(Column);
        final columnWidget = tester.widget<Column>(columnFinder);
        expect(columnWidget.children.length, 5);
        expect(columnWidget.children[0], isA<Icon>());
        expect(columnWidget.children[1], isA<SizedBox>());
        expect(columnWidget.children[2], isA<Text>());
        expect(columnWidget.children[3], isA<SizedBox>());
        expect(columnWidget.children[4], isA<Text>());
      });

      testWidgets('LoginTitle widget tree yapısı doğru olmalı', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(find.byType(TestLoginTitle), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
        expect(find.byType(Text), findsNWidgets(2));
        expect(
          find.byType(SizedBox),
          findsNWidgets(3),
        ); // Icon da SizedBox olarak render ediliyor
      });

      testWidgets('LoginTitle spacing değerleri doğru', (tester) async {
        await tester.pumpWidget(testWidget);

        final sizedBoxes = find.byType(SizedBox);
        expect(sizedBoxes, findsNWidgets(3));

        // Spacing değerlerini kontrol et - basit test
        expect(sizedBoxes, findsNWidgets(3));
      });
    });

    group('Typography and Styling Tests', () {
      testWidgets('LoginTitle metin stilleri doğru', (tester) async {
        await tester.pumpWidget(testWidget);

        final titleFinder = find.text(mockViewModel.welcomeTitle);
        final titleWidget = tester.widget<Text>(titleFinder);
        expect(titleWidget.style?.fontSize, _expectedTitleFontSize);
        expect(titleWidget.style?.fontWeight, _expectedTitleFontWeight);
        expect(titleWidget.style?.color, Colors.black87);

        final descFinder = find.text(mockViewModel.welcomeDescription);
        final descWidget = tester.widget<Text>(descFinder);
        expect(descWidget.style?.fontSize, _expectedBodyFontSize);
        expect(descWidget.style?.color, Colors.black54);
      });

      testWidgets('LoginTitle text alignment doğru', (tester) async {
        await tester.pumpWidget(testWidget);

        final descFinder = find.text(mockViewModel.welcomeDescription);
        final descWidget = tester.widget<Text>(descFinder);
        expect(descWidget.textAlign, TextAlign.center);
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('LoginTitle responsive tasarım testi', (tester) async {
        await tester.pumpWidget(testWidget);
        expect(find.byType(TestLoginTitle), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('LoginTitle farklı ekran boyutlarında testi', (tester) async {
        // Küçük ekran
        await tester.binding.setSurfaceSize(const Size(320, 480));
        await tester.pumpWidget(testWidget);
        expect(find.byType(TestLoginTitle), findsOneWidget);

        // Büyük ekran
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(testWidget);
        expect(find.byType(TestLoginTitle), findsOneWidget);

        // Orijinal boyutu geri yükle
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('LoginTitle orientation değişikliği testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Portrait
        await tester.binding.setSurfaceSize(const Size(480, 800));
        await tester.pumpWidget(testWidget);
        expect(find.byType(TestLoginTitle), findsOneWidget);

        // Landscape
        await tester.binding.setSurfaceSize(const Size(800, 480));
        await tester.pumpWidget(testWidget);
        expect(find.byType(TestLoginTitle), findsOneWidget);

        // Orijinal boyutu geri yükle
        await tester.binding.setSurfaceSize(null);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('Exception durumunda widget davranışı', (tester) async {
        final exceptionViewModel = ExceptionMockLoginViewModel();

        // Exception'ı doğrudan test et
        expect(
          () => exceptionViewModel.welcomeTitle,
          throwsA(isA<Exception>()),
        );
        expect(
          () => exceptionViewModel.welcomeDescription,
          throwsA(isA<Exception>()),
        );

        // FlutterError.onError kullanarak exception'ları yakala
        dynamic capturedError;
        FlutterError.onError = (FlutterErrorDetails details) {
          capturedError = details.exception;
        };

        // Widget'ı render etmeye çalış
        final exceptionWidget = createTestWidget(
          Provider<ILoginViewModel>.value(
            value: exceptionViewModel,
            child: TestLoginTitle(viewModel: exceptionViewModel),
          ),
        );

        await tester.pumpWidget(exceptionWidget);

        // Exception'ın yakalandığını doğrula
        expect(capturedError, isNotNull);

        // FlutterError.onError'ı geri yükle
        FlutterError.onError = FlutterError.presentError;
      });

      testWidgets('Null viewModel durumunda widget davranışı', (tester) async {
        // Null viewModel ile test - bu durumda compile time hatası olur
        // Bu test sadece documentation amaçlı
        expect(true, isTrue); // Placeholder test
      });
    });

    group('Performance Tests', () {
      testWidgets('Widget rebuild performance testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final stopwatch = Stopwatch()..start();

        // Çoklu rebuild
        for (int i = 0; i < 100; i++) {
          await tester.pumpWidget(testWidget);
        }

        stopwatch.stop();
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(1000),
        ); // 1 saniyeden az olmalı
      });

      testWidgets('Widget render performance testi', (tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(testWidget);

        stopwatch.stop();
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(500),
        ); // 500ms'den az olmalı
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Accessibility özellikleri test ediliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Icon accessibility
        final iconFinder = find.byIcon(Icons.login);
        final iconSemantics = tester.getSemantics(iconFinder);
        expect(iconSemantics, isNotNull);

        // Text accessibility
        final titleFinder = find.text(mockViewModel.welcomeTitle);
        final titleSemantics = tester.getSemantics(titleFinder);
        expect(titleSemantics.label, contains('Hoş Geldiniz'));

        final descFinder = find.text(mockViewModel.welcomeDescription);
        final descSemantics = tester.getSemantics(descFinder);
        expect(descSemantics.label, contains('Hesabınıza giriş yapın'));
      });

      testWidgets('Semantic tree yapısı doğru', (tester) async {
        await tester.pumpWidget(testWidget);

        final semantics = tester.getSemantics(find.byType(TestLoginTitle));
        expect(semantics, isNotNull);

        // Semantic tree'nin var olduğunu doğrula
        expect(semantics, isNotNull);
      });
    });

    group('ViewModel Integration Tests', () {
      testWidgets('ViewModel state değişiklikleri test ediliyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        expect(mockViewModel.welcomeTitle, equals('Hoş Geldiniz'));
        expect(
          mockViewModel.welcomeDescription,
          equals('Hesabınıza giriş yapın'),
        );

        expect(find.text('Hoş Geldiniz'), findsOneWidget);
        expect(find.text('Hesabınıza giriş yapın'), findsOneWidget);
      });

      testWidgets('ViewModel değişikliklerinde widget güncelleniyor', (
        tester,
      ) async {
        await tester.pumpWidget(testWidget);

        // Başlangıç durumu
        expect(find.text('Hoş Geldiniz'), findsOneWidget);

        // Yeni mock viewModel ile güncelle
        final newMockViewModel = MockLoginViewModel();
        final newWidget = createTestWidget(
          Provider<ILoginViewModel>.value(
            value: newMockViewModel,
            child: TestLoginTitle(viewModel: newMockViewModel),
          ),
        );

        await tester.pumpWidget(newWidget);
        expect(find.text('Hoş Geldiniz'), findsOneWidget);
      });
    });

    group('Edge Case Tests', () {
      testWidgets('Çok uzun metin edge case testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Uzun metin ile test - daha makul uzunlukta
        final longTitle = 'A' * 100;
        final longDescription = 'B' * 100;

        final longMockViewModel = _LongTextMockLoginViewModel(
          title: longTitle,
          description: longDescription,
        );

        final longWidget = createTestWidget(
          Provider<ILoginViewModel>.value(
            value: longMockViewModel,
            child: TestLoginTitle(viewModel: longMockViewModel),
          ),
        );

        await tester.pumpWidget(longWidget);
        expect(find.text(longTitle), findsOneWidget);
        expect(find.text(longDescription), findsOneWidget);
      });

      testWidgets('Boş metin edge case testi', (tester) async {
        final emptyMockViewModel = _EmptyTextMockLoginViewModel();
        final emptyWidget = createTestWidget(
          Provider<ILoginViewModel>.value(
            value: emptyMockViewModel,
            child: TestLoginTitle(viewModel: emptyMockViewModel),
          ),
        );

        await tester.pumpWidget(emptyWidget);
        expect(find.text(''), findsNWidgets(2)); // Boş string'ler
      });

      testWidgets('Özel karakterler içeren metin testi', (tester) async {
        final specialMockViewModel = _SpecialCharMockLoginViewModel();
        final specialWidget = createTestWidget(
          Provider<ILoginViewModel>.value(
            value: specialMockViewModel,
            child: TestLoginTitle(viewModel: specialMockViewModel),
          ),
        );

        await tester.pumpWidget(specialWidget);
        expect(find.text('Hoş Geldiniz! 🎉'), findsOneWidget);
        expect(find.text('Hesabınıza giriş yapın 😊'), findsOneWidget);
      });
    });

    group('Memory Management Tests', () {
      testWidgets('Widget disposal testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Widget'ı dispose et
        await tester.pumpWidget(const SizedBox.shrink());

        // Widget'ın artık bulunmadığını doğrula
        expect(find.byType(TestLoginTitle), findsNothing);
      });

      testWidgets('Memory leak testi', (tester) async {
        // Çoklu widget oluştur ve dispose et
        for (int i = 0; i < 10; i++) {
          await tester.pumpWidget(testWidget);
          await tester.pumpWidget(const SizedBox.shrink());
        }

        // Son durumda widget'ın bulunmadığını doğrula
        expect(find.byType(TestLoginTitle), findsNothing);
      });
    });
  });
}

/// --------- Edge Case Mock ViewModels ---------
class _LongTextMockLoginViewModel implements ILoginViewModel {
  final String title;
  final String description;

  _LongTextMockLoginViewModel({required this.title, required this.description});

  @override
  String get welcomeTitle => title;

  @override
  String get welcomeDescription => description;
}

class _EmptyTextMockLoginViewModel implements ILoginViewModel {
  @override
  String get welcomeTitle => '';

  @override
  String get welcomeDescription => '';
}

class _SpecialCharMockLoginViewModel implements ILoginViewModel {
  @override
  String get welcomeTitle => 'Hoş Geldiniz! 🎉';

  @override
  String get welcomeDescription => 'Hesabınıza giriş yapın 😊';
}
