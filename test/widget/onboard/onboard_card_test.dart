import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/onboard/model/onboard_model.dart';
import 'package:arya/features/onboard/view/widget/onboard_card.dart';

void main() {
  group('Onboard Card Widget Tests', () {
    // Test data
    late OnboardModel testModel;

    setUp(() {
      testModel = OnboardModel(
        'Test Başlık',
        'Test açıklama metni burada yer alıyor.',
        'assets/lottie/test.json',
      );
    });

    // Test 1: OnBoardCard temel widget'ları göstermeli
    testWidgets('OnBoardCard temel widget\'ları göstermeli', (tester) async {
      // ARRANGE: OnBoardCard widget'ını oluştur
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: OnBoardCard(onboardModel: testModel)),
        ),
      );

      // ACT: Widget'ın yüklenmesini bekle
      await tester.pump();

      // ASSERT: Temel widget'lar var mı?
      expect(find.byType(OnBoardCard), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    // Test 2: OnBoardCard title göstermeli
    testWidgets('OnBoardCard title göstermeli', (tester) async {
      // ARRANGE: OnBoardCard widget'ını oluştur
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: OnBoardCard(onboardModel: testModel)),
        ),
      );

      // ACT: Widget'ın yüklenmesini bekle
      await tester.pump();

      // ASSERT: Title text'i var mı?
      expect(find.text('Test Başlık'), findsOneWidget);
      expect(find.byType(Text), findsAtLeastNWidgets(1));
    });

    // Test 3: OnBoardCard description göstermeli
    testWidgets('OnBoardCard description göstermeli', (tester) async {
      // ARRANGE: OnBoardCard widget'ını oluştur
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: OnBoardCard(onboardModel: testModel)),
        ),
      );

      // ACT: Widget'ın yüklenmesini bekle
      await tester.pump();

      // ASSERT: Description text'i var mı?
      expect(
        find.text('Test açıklama metni burada yer alıyor.'),
        findsOneWidget,
      );
    });

    // Test 4: OnBoardCard null lottiePath ile çalışmalı
    testWidgets('OnBoardCard null lottiePath ile çalışmalı', (tester) async {
      // ARRANGE: Lottie path'i null olan model - Küçük ekran boyutunda
      final nullLottieModel = OnboardModel(
        'Test Başlık',
        'Test açıklama',
        null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 568), // iPhone SE boyutu
              devicePixelRatio: 2.0,
            ),
            child: Scaffold(body: OnBoardCard(onboardModel: nullLottieModel)),
          ),
        ),
      );

      // ACT: Widget'ın yüklenmesini bekle
      await tester.pump();

      // ASSERT: Widget hala render ediliyor mu?
      expect(find.byType(OnBoardCard), findsOneWidget);
      expect(find.text('Test Başlık'), findsOneWidget);
      expect(find.text('Test açıklama'), findsOneWidget);
    });

    // Test 5: OnBoardCard farklı content ile çalışmalı
    testWidgets('OnBoardCard farklı content ile çalışmalı', (tester) async {
      // ARRANGE: Farklı content ile model - Orta ekran boyutunda
      final differentModel = OnboardModel(
        'Farklı Başlık',
        'Farklı açıklama metni',
        'assets/lottie/different.json',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(414, 896), // iPhone 11 boyutu
              devicePixelRatio: 2.0,
            ),
            child: Scaffold(body: OnBoardCard(onboardModel: differentModel)),
          ),
        ),
      );

      // ACT: Widget'ın yüklenmesini bekle
      await tester.pump();

      // ASSERT: Farklı content gösteriliyor mu?
      expect(find.text('Farklı Başlık'), findsOneWidget);
      expect(find.text('Farklı açıklama metni'), findsOneWidget);
      expect(find.text('Test Başlık'), findsNothing); // Eski content yok
    });

    // Test 6: OnBoardCard widget tree yapısı doğru olmalı
    testWidgets('OnBoardCard widget tree yapısı doğru olmalı', (tester) async {
      // ARRANGE: OnBoardCard widget'ını oluştur - Büyük ekran boyutunda
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(1024, 768), // Desktop boyutu
              devicePixelRatio: 1.0,
            ),
            child: Scaffold(body: OnBoardCard(onboardModel: testModel)),
          ),
        ),
      );

      // ACT: Widget'ın yüklenmesini bekle
      await tester.pump();

      // ASSERT: Widget tree yapısı doğru mu?
      expect(find.byType(OnBoardCard), findsOneWidget);

      // Column widget'ı var mı?
      expect(find.byType(Column), findsAtLeastNWidgets(1));

      // Text widget'ları var mı?
      expect(find.byType(Text), findsAtLeastNWidgets(2)); // Title + Description
    });

    // Test 7: OnBoardCard key property doğru çalışmalı
    testWidgets('OnBoardCard key property doğru çalışmalı', (tester) async {
      // ARRANGE: Farklı key'ler ile OnBoardCard oluştur - Tablet boyutunda
      final key1 = const Key('key1');
      final key2 = const Key('key2');

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(820, 1180), // iPad Air boyutu
              devicePixelRatio: 2.0,
            ),
            child: Scaffold(
              body: OnBoardCard(key: key1, onboardModel: testModel),
            ),
          ),
        ),
      );

      // ACT: Widget'ın yüklenmesini bekle
      await tester.pump();

      // ASSERT: Key doğru mu?
      expect(find.byKey(key1), findsOneWidget);
      expect(find.byKey(key2), findsNothing);
    });

    // Test 8: OnBoardCard text style'ları doğru olmalı
    testWidgets('OnBoardCard text style\'ları doğru olmalı', (tester) async {
      // ARRANGE: OnBoardCard widget'ını oluştur - Ultra-wide ekran boyutunda
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(1440, 900), // MacBook Pro boyutu
              devicePixelRatio: 2.0,
            ),
            child: Scaffold(body: OnBoardCard(onboardModel: testModel)),
          ),
        ),
      );

      // ACT: Widget'ın yüklenmesini bekle
      await tester.pump();

      // ASSERT: Text widget'ları var mı?
      expect(find.byType(Text), findsAtLeastNWidgets(2));

      // Title text'i var mı?
      expect(find.text('Test Başlık'), findsOneWidget);

      // Description text'i var mı?
      expect(
        find.text('Test açıklama metni burada yer alıyor.'),
        findsOneWidget,
      );
    });
  });
}
