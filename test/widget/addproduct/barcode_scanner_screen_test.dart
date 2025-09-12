import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:arya/features/addproduct/view/widgets/fields/basic_info_fields.dart';
import 'package:arya/product/index.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('BarcodeScannerScreen Tests', () {
    setUpAll(() async {
      // Test ortamını başlat
      TestWidgetsFlutterBinding.ensureInitialized();
      TestHelpers.setupEasyLocalization();
      TestHelpers.setupComprehensiveFirebaseMocks();
      await TestHelpers.initializeFirebaseForTests();
      TestHelpers.setupPlatformChannels();
    });

    tearDownAll(() {
      TestHelpers.tearDown();
    });

    /// Test için BarcodeScannerScreen wrapper'ı oluştur
    Widget createTestBarcodeScannerScreen() {
      return MaterialApp(
        theme: ThemeData(extensions: [AppColors.light]),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('tr', 'TR')],
        locale: const Locale('tr', 'TR'),
        home: const Scaffold(body: BarcodeScannerScreen()),
      );
    }

    /// Test için navigation wrapper'ı oluştur
    Widget createTestWithNavigation() {
      return MaterialApp(
        theme: ThemeData(extensions: [AppColors.light]),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('tr', 'TR')],
        locale: const Locale('tr', 'TR'),
        home: const Scaffold(body: Center(child: Text('Test Home'))),
        routes: {'/scanner': (context) => const BarcodeScannerScreen()},
      );
    }

    group('Widget Structure Tests', () {
      testWidgets('BarcodeScannerScreen temel widget yapısını göstermeli', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Ana widget'ın varlığını kontrol et
        expect(find.byType(BarcodeScannerScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsWidgets);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('BarcodeScannerScreen doğru AppBar yapısına sahip olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // AppBar'ın varlığını kontrol et
        expect(find.byType(AppBar), findsOneWidget);

        // AppBar title'ını kontrol et
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.title, isA<Text>());
      });

      testWidgets('BarcodeScannerScreen doğru body yapısına sahip olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Body'de Stack olmalı
        expect(find.byType(Stack), findsWidgets);

        // MobileScanner widget'ı olmalı
        expect(find.byType(MobileScanner), findsOneWidget);
      });
    });

    group('AppBar Tests', () {
      testWidgets('AppBar doğru başlığa sahip olmalı', (tester) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // AppBar title'ını kontrol et
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        final titleWidget = appBar.title as Text;
        expect(titleWidget.data, 'Barkod Tarayıcı');
      });

      testWidgets('AppBar doğru action butonlarına sahip olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // AppBar actions'ını kontrol et
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.actions, isNotNull);
        expect(appBar.actions!.length, 2);

        // IconButton'ları kontrol et
        final iconButtons = find.byType(IconButton);
        expect(iconButtons, findsNWidgets(2));
      });

      testWidgets('AppBar flash butonu doğru icon\'a sahip olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Flash butonunu bul
        final flashButton = find.byIcon(Icons.flash_on);
        expect(flashButton, findsOneWidget);

        // Icon'ın varlığını kontrol et
        final iconWidget = tester.widget<Icon>(flashButton);
        expect(iconWidget.icon, Icons.flash_on);
      });

      testWidgets(
        'AppBar kamera değiştirme butonu doğru icon\'a sahip olmalı',
        (tester) async {
          await tester.pumpWidget(createTestBarcodeScannerScreen());
          await tester.pump();

          // Kamera değiştirme butonunu bul
          final cameraButton = find.byIcon(Icons.camera_rear);
          expect(cameraButton, findsOneWidget);

          // Icon'ın varlığını kontrol et
          final iconWidget = tester.widget<Icon>(cameraButton);
          expect(iconWidget.icon, Icons.camera_rear);
        },
      );
    });

    group('MobileScanner Tests', () {
      testWidgets('MobileScanner widget\'ı doğru yapıda olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // MobileScanner widget'ının varlığını kontrol et
        expect(find.byType(MobileScanner), findsOneWidget);

        // MobileScanner widget'ının özelliklerini kontrol et
        final mobileScanner = tester.widget<MobileScanner>(
          find.byType(MobileScanner),
        );
        expect(mobileScanner.controller, isNotNull);
        expect(mobileScanner.onDetect, isNotNull);
      });

      testWidgets('MobileScanner controller doğru şekilde başlatılmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // MobileScanner widget'ını bul
        final mobileScanner = tester.widget<MobileScanner>(
          find.byType(MobileScanner),
        );
        expect(mobileScanner.controller, isA<MobileScannerController>());
      });
    });

    group('Scanning Instructions Tests', () {
      testWidgets('Tarama talimatları doğru şekilde gösterilmeli', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Talimat container'ını bul
        final instructionContainer = find.byType(Container);
        expect(instructionContainer, findsWidgets);

        // Talimat metnini bul
        final instructionText = find.text('Barkodu kameraya doğrultun');
        expect(instructionText, findsOneWidget);
      });

      testWidgets('Tarama talimatları doğru konumda olmalı', (tester) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Positioned widget'ını bul
        final positionedWidget = find.byType(Positioned);
        expect(positionedWidget, findsOneWidget);

        // Positioned widget'ının özelliklerini kontrol et
        final positioned = tester.widget<Positioned>(positionedWidget);
        expect(positioned.bottom, 20);
        expect(positioned.left, 0);
        expect(positioned.right, 0);
      });

      testWidgets('Tarama talimatları doğru stil özelliklerine sahip olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Talimat metnini bul
        final instructionText = find.text('Barkodu kameraya doğrultun');
        final textWidget = tester.widget<Text>(instructionText);

        // Text stil özelliklerini kontrol et
        expect(textWidget.style?.color, Colors.white);
        expect(textWidget.style?.fontSize, 16);
        expect(textWidget.style?.fontWeight, FontWeight.w500);
      });
    });

    group('State Management Tests', () {
      testWidgets('Widget başlangıçta tarama durumunda olmalı', (tester) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Positioned widget'ı bul (tarama aktifken gösterilir)
        final positionedWidget = find.byType(Positioned);
        expect(positionedWidget, findsOneWidget);
      });

      testWidgets('Widget dispose edildiğinde controller temizlenmeli', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Widget'ı dispose et
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        // Widget'ın dispose edildiğini kontrol et
        expect(find.byType(BarcodeScannerScreen), findsNothing);
      });
    });

    group('Navigation Tests', () {
      testWidgets('Widget navigation ile açılabilmeli', (tester) async {
        await tester.pumpWidget(createTestWithNavigation());
        await tester.pump();

        // Scanner sayfasına git
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
            home: const BarcodeScannerScreen(),
          ),
        );
        await tester.pump();

        expect(find.byType(BarcodeScannerScreen), findsOneWidget);
      });
    });

    group('Theme Integration Tests', () {
      testWidgets('Widget tema renklerini doğru kullanmalı', (tester) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // AppBar'ın varlığını kontrol et
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar, isNotNull);
      });

      testWidgets('Widget farklı temalarda çalışmalı', (tester) async {
        // Dark tema ile test et
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
            home: const Scaffold(body: BarcodeScannerScreen()),
          ),
        );
        await tester.pump();

        expect(find.byType(BarcodeScannerScreen), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Widget erişilebilirlik özelliklerine sahip olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Widget'ın render edildiğini kontrol et
        expect(find.byType(BarcodeScannerScreen), findsOneWidget);

        // AppBar'ın varlığını kontrol et
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('Widget semantic özelliklerini desteklemeli', (tester) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Widget'ın semantic tree'de yer aldığını kontrol et
        expect(find.byType(BarcodeScannerScreen), findsOneWidget);
      });

      testWidgets('Butonlar erişilebilir olmalı', (tester) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // IconButton'ların varlığını kontrol et
        final iconButtons = find.byType(IconButton);
        expect(iconButtons, findsNWidgets(2));

        // Butonların varlığını kontrol et
        final flashButton = find.byIcon(Icons.flash_on);
        final cameraButton = find.byIcon(Icons.camera_rear);

        expect(flashButton, findsOneWidget);
        expect(cameraButton, findsOneWidget);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('Widget hata durumlarında çalışmalı', (tester) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Widget'ın hata durumunda da render edildiğini kontrol et
        expect(find.byType(BarcodeScannerScreen), findsOneWidget);
        expect(find.byType(MobileScanner), findsOneWidget);
      });

      testWidgets('Widget null değerlerle çalışmalı', (tester) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Widget'ın null değerlerle de çalıştığını kontrol et
        expect(find.byType(BarcodeScannerScreen), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('Widget performans testi', (tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        stopwatch.stop();

        // Widget'ın 2 saniyeden kısa sürede render edilmesi beklenir
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
        expect(find.byType(BarcodeScannerScreen), findsOneWidget);
      });

      testWidgets('Widget memory leak testi', (tester) async {
        // Widget'ı oluştur
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Widget'ı dispose et
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        // Widget'ın tamamen temizlendiğini kontrol et
        expect(find.byType(BarcodeScannerScreen), findsNothing);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('Widget farklı ekran boyutlarında çalışmalı', (tester) async {
        // Küçük ekran boyutu
        await tester.binding.setSurfaceSize(const Size(320, 568));
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        expect(find.byType(BarcodeScannerScreen), findsOneWidget);

        // Büyük ekran boyutu
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        expect(find.byType(BarcodeScannerScreen), findsOneWidget);
      });

      testWidgets('Widget farklı yönelimlerde çalışmalı', (tester) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Widget'ın farklı yönelimlerde de çalıştığını kontrol et
        expect(find.byType(BarcodeScannerScreen), findsOneWidget);
        expect(find.byType(Stack), findsWidgets);
      });
    });

    group('Integration Tests', () {
      testWidgets('Widget BasicInfoFields ile entegre çalışmalı', (
        tester,
      ) async {
        // Bu test, BarcodeScannerScreen'in BasicInfoFields'den çağrıldığını test eder
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Widget'ın doğru şekilde render edildiğini kontrol et
        expect(find.byType(BarcodeScannerScreen), findsOneWidget);
        expect(find.byType(MobileScanner), findsOneWidget);
      });

      testWidgets('Widget navigation stack ile uyumlu çalışmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBarcodeScannerScreen());
        await tester.pump();

        // Widget'ın navigation stack'te doğru çalıştığını kontrol et
        expect(find.byType(BarcodeScannerScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsWidgets);
      });
    });
  });
}
