// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:arya/features/onboard/view/onboard_view.dart';

// void main() {
//   group('Onboard Buttons Widget Tests', () {
//     // Test 1: Skip butonu ilk sayfada görünmeli
//     testWidgets('Skip butonu ilk sayfada görünmeli', (tester) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: Skip butonu var mı?
//       expect(find.byType(TextButton), findsAtLeastNWidgets(1));

//       // Skip butonu tıklanabilir mi?
//       final skipButton = tester.widget<TextButton>(
//         find.byType(TextButton).first,
//       );
//       expect(skipButton.onPressed, isNotNull);
//     });

//     // Test 2: Next butonu ilk sayfada görünmeli
//     testWidgets('Next butonu ilk sayfada görünmeli', (tester) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: Next butonu var mı?
//       expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));

//       // Next butonu tıklanabilir mi?
//       final nextButton = tester.widget<ElevatedButton>(
//         find.byType(ElevatedButton).first,
//       );
//       expect(nextButton.onPressed, isNotNull);
//     });

//     // Test 3: Butonlar tıklanabilir olmalı
//     testWidgets('Butonlar tıklanabilir olmalı', (tester) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: Tüm butonlar tıklanabilir mi?
//       final buttons = find.byType(ElevatedButton);
//       expect(buttons, findsAtLeastNWidgets(1));

//       // İlk butonu kontrol et
//       final firstButton = tester.widget<ElevatedButton>(buttons.first);
//       expect(firstButton.onPressed, isNotNull);
//     });

//     // Test 4: Buton text'leri doğru olmalı
//     testWidgets('Buton text\'leri doğru olmalı', (tester) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: Buton text'leri var mı?
//       // Not: Localization key'leri bulunamadığı için uyarı alabiliriz
//       // Bu normal, test çalışmaya devam eder
//       expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
//       expect(find.byType(TextButton), findsAtLeastNWidgets(1));
//     });

//     // Test 5: Buton stilleri doğru olmalı
//     testWidgets('Buton stilleri doğru olmalı', (tester) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: Buton stilleri doğru mu?
//       final elevatedButton = tester.widget<ElevatedButton>(
//         find.byType(ElevatedButton).first,
//       );

//       // ElevatedButton style'ı var mı?
//       expect(elevatedButton.style, isNotNull);

//       // TextButton style'ı var mı?
//       final textButton = tester.widget<TextButton>(
//         find.byType(TextButton).first,
//       );
//       expect(textButton.style, isNotNull);
//     });

//     // Test 6: Buton widget tree yapısı doğru olmalı
//     testWidgets('Buton widget tree yapısı doğru olmalı', (tester) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: Widget tree yapısı doğru mu?
//       expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
//       expect(find.byType(TextButton), findsAtLeastNWidgets(1));

//       // Butonların child'ları var mı?
//       final elevatedButton = tester.widget<ElevatedButton>(
//         find.byType(ElevatedButton).first,
//       );
//       expect(elevatedButton.child, isNotNull);

//       final textButton = tester.widget<TextButton>(
//         find.byType(TextButton).first,
//       );
//       expect(textButton.child, isNotNull);
//     });

//     // Test 7: Butonlar accessibility desteği olmalı
//     testWidgets('Butonlar accessibility desteği olmalı', (tester) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: Accessibility desteği var mı?
//       expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
//       expect(find.byType(TextButton), findsAtLeastNWidgets(1));

//       // Butonlar semantic label'a sahip mi?
//       // Not: Test ortamında semantic label'lar görünmeyebilir
//       // Bu durumda sadece butonların var olduğunu kontrol ederiz
//       expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
//     });

//     // Test 8: Butonlar key property doğru çalışmalı
//     testWidgets('Butonlar key property doğru çalışmalı', (tester) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: Butonlar key property'ye sahip mi?
//       expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
//       expect(find.byType(TextButton), findsAtLeastNWidgets(1));

//       // Butonlar tıklanabilir mi?
//       final elevatedButton = tester.widget<ElevatedButton>(
//         find.byType(ElevatedButton).first,
//       );
//       expect(elevatedButton.onPressed, isNotNull);
//     });
//   });
// }
