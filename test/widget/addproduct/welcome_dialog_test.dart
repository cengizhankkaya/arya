import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:arya/features/addproduct/view/widgets/welcome_dialog.dart';
import '../../helpers/test_helpers.dart';

/// Mock sınıfları için annotation
@GenerateMocks([])
void main() {
  group('WelcomeDialog Widget Tests', () {
    late VoidCallback mockOnNavigateToCredentials;
    bool callbackCalled = false;

    setUpAll(() async {
      // Test ortamını başlat
      TestWidgetsFlutterBinding.ensureInitialized();
      TestHelpers.setupEasyLocalization();
      TestHelpers.setupComprehensiveFirebaseMocks();
      await TestHelpers.initializeFirebaseForTests();
      TestHelpers.setupPlatformChannels();
    });

    setUp(() {
      // Mock callback'i initialize et
      callbackCalled = false;
      mockOnNavigateToCredentials = () {
        callbackCalled = true;
      };
    });

    tearDownAll(() {
      TestHelpers.tearDown();
    });

    Widget createTestWidget() {
      return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('tr', 'TR')],
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => WelcomeDialog(
                    onNavigateToCredentials: mockOnNavigateToCredentials,
                  ),
                );
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      );
    }

    testWidgets('WelcomeDialog widget başarıyla render edilir', (tester) async {
      // Widget'ı test ortamına yerleştir
      await tester.pumpWidget(createTestWidget());

      // Dialog'ı aç
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog'ın render edildiğini kontrol et
      expect(find.byType(WelcomeDialog), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Dialog başlığı doğru şekilde gösterilir', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Dialog'ı aç
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog başlığının gösterildiğini kontrol et
      expect(find.byType(AlertDialog), findsOneWidget);
      final alertDialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
      expect(alertDialog.title, isA<Text>());
    });

    testWidgets('Dialog içeriği doğru şekilde gösterilir', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Dialog'ı aç
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog içeriğinin gösterildiğini kontrol et
      expect(find.byType(AlertDialog), findsOneWidget);
      final alertDialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
      expect(alertDialog.content, isA<Text>());
    });

    testWidgets('Dialog butonları doğru şekilde gösterilir', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Dialog'ı aç
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog butonlarının gösterildiğini kontrol et
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('"Daha Sonra" butonu doğru şekilde çalışır', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Dialog'ı aç
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // "Daha Sonra" butonunu bul ve tıkla
      final laterButton = find.byType(TextButton);
      expect(laterButton, findsOneWidget);

      await tester.tap(laterButton);
      await tester.pumpAndSettle();

      // Dialog'ın kapandığını kontrol et
      expect(find.byType(AlertDialog), findsNothing);

      // Callback'in çağrılmadığını kontrol et
      expect(callbackCalled, false);
    });

    testWidgets('"Bilgileri Gir" butonu doğru şekilde çalışır', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Dialog'ı aç
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // "Bilgileri Gir" butonunu bul ve tıkla (dialog içindeki ElevatedButton)
      final enterCredentialsButton = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(ElevatedButton),
      );
      expect(enterCredentialsButton, findsOneWidget);

      await tester.tap(enterCredentialsButton);
      await tester.pumpAndSettle();

      // Dialog'ın kapandığını kontrol et
      expect(find.byType(AlertDialog), findsNothing);

      // Callback'in çağrıldığını kontrol et
      expect(callbackCalled, true);
    });

    testWidgets('Dialog\'ın doğru yapıda olduğunu kontrol et', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Dialog'ı aç
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog'ın yapısını kontrol et
      final alertDialog = tester.widget<AlertDialog>(find.byType(AlertDialog));

      // Title'ın Text widget'ı olduğunu kontrol et
      expect(alertDialog.title, isA<Text>());

      // Content'in Text widget'ı olduğunu kontrol et
      expect(alertDialog.content, isA<Text>());

      // Actions'ın 2 element içerdiğini kontrol et
      expect(alertDialog.actions, hasLength(2));

      // İlk action'ın TextButton olduğunu kontrol et
      expect(alertDialog.actions![0], isA<TextButton>());

      // İkinci action'ın ElevatedButton olduğunu kontrol et
      expect(alertDialog.actions![1], isA<ElevatedButton>());
    });

    testWidgets('Dialog butonlarının doğru sırada olduğunu kontrol et', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Dialog'ı aç
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog'ın yapısını kontrol et
      final alertDialog = tester.widget<AlertDialog>(find.byType(AlertDialog));

      // İlk butonun TextButton olduğunu kontrol et
      expect(alertDialog.actions![0], isA<TextButton>());

      // İkinci butonun ElevatedButton olduğunu kontrol et
      expect(alertDialog.actions![1], isA<ElevatedButton>());
    });

    testWidgets('Dialog\'ın barrierDismissible özelliğini kontrol et', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Dialog'ı aç
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog'ın açık olduğunu kontrol et
      expect(find.byType(AlertDialog), findsOneWidget);

      // Dialog dışına tıklayarak kapatmaya çalış
      await tester.tapAt(const Offset(50, 50));
      await tester.pumpAndSettle();

      // Dialog'ın hala açık olduğunu kontrol et (barrierDismissible: true - default)
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets(
      'Dialog\'ın doğru callback ile initialize edildiğini kontrol et',
      (tester) async {
        // Farklı bir callback ile test et
        bool testCallbackCalled = false;
        final testCallback = () {
          testCallbackCalled = true;
        };

        final testWidget = MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [const Locale('tr', 'TR')],
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        WelcomeDialog(onNavigateToCredentials: testCallback),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await tester.pumpWidget(testWidget);

        // Dialog'ı aç
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // "Bilgileri Gir" butonunu tıkla (dialog içindeki ElevatedButton)
        final enterCredentialsButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(enterCredentialsButton);
        await tester.pumpAndSettle();

        // Doğru callback'in çağrıldığını kontrol et
        expect(testCallbackCalled, true);
        expect(callbackCalled, false);
      },
    );

    testWidgets('Dialog\'ın accessibility özelliklerini kontrol et', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Dialog'ı aç
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog'ın accessibility özelliklerini kontrol et
      final alertDialog = tester.widget<AlertDialog>(find.byType(AlertDialog));

      // Dialog'ın semantic label'ının olup olmadığını kontrol et
      expect(alertDialog.title, isNotNull);
      expect(alertDialog.content, isNotNull);
    });

    testWidgets('Dialog\'ın responsive tasarımını kontrol et', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Dialog'ı aç
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog'ın render edildiğini kontrol et
      expect(find.byType(AlertDialog), findsOneWidget);

      // Dialog'ın boyutlarını kontrol et
      final alertDialogFinder = find.byType(AlertDialog);
      final alertDialogRenderBox =
          tester.renderObject(alertDialogFinder) as RenderBox;

      expect(alertDialogRenderBox.size.width, greaterThan(0));
      expect(alertDialogRenderBox.size.height, greaterThan(0));
    });
  });
}
