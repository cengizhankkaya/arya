import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:arya/features/addproduct/view/widgets/common/section_title.dart';
import 'package:arya/product/index.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('SectionTitle Widget Tests', () {
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

    /// Test için SectionTitle wrapper'ı oluştur
    Widget createTestSectionTitle({
      required String title,
      double? fontSize,
      FontWeight? fontWeight,
    }) {
      return MaterialApp(
        theme: ThemeData(extensions: [AppColors.light]),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('tr', 'TR')],
        locale: const Locale('tr', 'TR'),
        home: Scaffold(
          body: SectionTitle(
            title: title,
            fontSize: fontSize ?? 18.0,
            fontWeight: fontWeight ?? FontWeight.bold,
          ),
        ),
      );
    }

    group('Widget Structure Tests', () {
      testWidgets('SectionTitle temel widget yapısını göstermeli', (
        tester,
      ) async {
        await tester.pumpWidget(createTestSectionTitle(title: 'Test Başlık'));
        await tester.pumpAndSettle();

        // Ana widget'ın varlığını kontrol et
        expect(find.byType(SectionTitle), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('SectionTitle doğru metni göstermeli', (tester) async {
        const testTitle = 'Test Başlık';
        await tester.pumpWidget(createTestSectionTitle(title: testTitle));
        await tester.pumpAndSettle();

        // Metnin doğru şekilde gösterildiğini kontrol et
        expect(find.text(testTitle), findsOneWidget);
      });

      testWidgets('SectionTitle varsayılan font boyutunu kullanmalı', (
        tester,
      ) async {
        const testTitle = 'Test Başlık';
        await tester.pumpWidget(createTestSectionTitle(title: testTitle));
        await tester.pumpAndSettle();

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.fontSize, 18.0);
      });

      testWidgets('SectionTitle varsayılan font ağırlığını kullanmalı', (
        tester,
      ) async {
        const testTitle = 'Test Başlık';
        await tester.pumpWidget(createTestSectionTitle(title: testTitle));
        await tester.pumpAndSettle();

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.fontWeight, FontWeight.bold);
      });
    });

    group('Custom Properties Tests', () {
      testWidgets('SectionTitle özel font boyutunu kullanmalı', (tester) async {
        const testTitle = 'Test Başlık';
        const customFontSize = 24.0;
        await tester.pumpWidget(
          createTestSectionTitle(title: testTitle, fontSize: customFontSize),
        );
        await tester.pumpAndSettle();

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.fontSize, customFontSize);
      });

      testWidgets('SectionTitle özel font ağırlığını kullanmalı', (
        tester,
      ) async {
        const testTitle = 'Test Başlık';
        const customFontWeight = FontWeight.w300;
        await tester.pumpWidget(
          createTestSectionTitle(
            title: testTitle,
            fontWeight: customFontWeight,
          ),
        );
        await tester.pumpAndSettle();

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.fontWeight, customFontWeight);
      });

      testWidgets('SectionTitle tüm özel özellikleri birlikte kullanmalı', (
        tester,
      ) async {
        const testTitle = 'Özel Başlık';
        const customFontSize = 20.0;
        const customFontWeight = FontWeight.w600;
        await tester.pumpWidget(
          createTestSectionTitle(
            title: testTitle,
            fontSize: customFontSize,
            fontWeight: customFontWeight,
          ),
        );
        await tester.pumpAndSettle();

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(find.text(testTitle), findsOneWidget);
        expect(textWidget.style?.fontSize, customFontSize);
        expect(textWidget.style?.fontWeight, customFontWeight);
      });
    });

    group('Theme Integration Tests', () {
      testWidgets('SectionTitle tema renklerini doğru kullanmalı', (
        tester,
      ) async {
        const testTitle = 'Test Başlık';
        await tester.pumpWidget(createTestSectionTitle(title: testTitle));
        await tester.pumpAndSettle();

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, isNotNull);
      });

      testWidgets('SectionTitle farklı temalarda çalışmalı', (tester) async {
        const testTitle = 'Test Başlık';

        // Light tema
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
            home: Scaffold(body: SectionTitle(title: testTitle)),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(testTitle), findsOneWidget);
        expect(find.byType(SectionTitle), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('SectionTitle boş string ile çalışmalı', (tester) async {
        const emptyTitle = '';
        await tester.pumpWidget(createTestSectionTitle(title: emptyTitle));
        await tester.pumpAndSettle();

        expect(find.text(emptyTitle), findsOneWidget);
        expect(find.byType(SectionTitle), findsOneWidget);
      });

      testWidgets('SectionTitle uzun metin ile çalışmalı', (tester) async {
        const longTitle =
            'Bu çok uzun bir başlık metni olup widget\'ın uzun metinlerle nasıl davrandığını test eder';
        await tester.pumpWidget(createTestSectionTitle(title: longTitle));
        await tester.pumpAndSettle();

        expect(find.text(longTitle), findsOneWidget);
        expect(find.byType(SectionTitle), findsOneWidget);
      });

      testWidgets('SectionTitle özel karakterler ile çalışmalı', (
        tester,
      ) async {
        const specialTitle =
            'Başlık: Özel Karakterler! @#\$%^&*()_+{}|:"<>?[]\\;\',./';
        await tester.pumpWidget(createTestSectionTitle(title: specialTitle));
        await tester.pumpAndSettle();

        expect(find.text(specialTitle), findsOneWidget);
        expect(find.byType(SectionTitle), findsOneWidget);
      });
    });
  });
}
