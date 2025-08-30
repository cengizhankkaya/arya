// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:arya/features/onboard/view/onboard_view.dart';

// // Mock OnBoardCard widget'ı
// class MockOnBoardCard extends StatelessWidget {
//   const MockOnBoardCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       height: 100,
//       color: Colors.blue,
//       child: const Center(child: Text('Mock Card')),
//     );
//   }
// }

// void main() {
//   group('Onboard Screen Widget Tests', () {
//     // Test 1: Onboard ekranı temel widget'ları göstermeli
//     testWidgets('Onboard ekranı temel widget\'ları göstermeli', (tester) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: Temel widget'lar var mı?
//       expect(find.byType(OnBoardView), findsOneWidget);
//       expect(find.byType(Scaffold), findsOneWidget);
//       expect(find.byType(PageView), findsOneWidget);
//       expect(find.byType(AppBar), findsOneWidget);
//     });

//     // Test 2: Onboard ekranı doğru layout yapısına sahip olmalı
//     testWidgets('Onboard ekranı doğru layout yapısına sahip olmalı', (
//       tester,
//     ) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: Layout yapısı doğru mu?
//       expect(find.byType(Column), findsAtLeastNWidgets(1));
//       expect(find.byType(Row), findsAtLeastNWidgets(1));
//       expect(find.byType(Padding), findsAtLeastNWidgets(1));
//     });

//     // Test 3: Onboard ekranı AppBar göstermeli
//     testWidgets('Onboard ekranı AppBar göstermeli', (tester) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: AppBar var mı?
//       expect(find.byType(AppBar), findsOneWidget);

//       // AppBar'da skip butonu var mı? (ilk sayfada)
//       expect(find.byType(TextButton), findsAtLeastNWidgets(1));
//     });

//     // Test 4: Onboard ekranı PageView göstermeli
//     testWidgets('Onboard ekranı PageView göstermeli', (tester) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: PageView var mı?
//       expect(find.byType(PageView), findsOneWidget);
//     });

//     // Test 5: Onboard ekranı bottom row göstermeli
//     testWidgets('Onboard ekranı bottom row göstermeli', (tester) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: Bottom row bileşenleri var mı?
//       expect(find.byType(Row), findsAtLeastNWidgets(1));
//       expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
//     });

//     // Test 6: Onboard ekranı next/start butonu göstermeli
//     testWidgets('Onboard ekranı next/start butonu göstermeli', (tester) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: Next/Start butonu var mı?
//       expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));

//       // Buton tıklanabilir mi?
//       final button = tester.widget<ElevatedButton>(
//         find.byType(ElevatedButton).first,
//       );
//       expect(button.onPressed, isNotNull);
//     });

//     // Test 7: Onboard ekranı widget tree yapısı doğru olmalı
//     testWidgets('Onboard ekranı widget tree yapısı doğru olmalı', (
//       tester,
//     ) async {
//       // ARRANGE: Onboard ekranını aç
//       await tester.pumpWidget(MaterialApp(home: OnBoardView()));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: Widget tree yapısı doğru mu?
//       expect(find.byType(OnBoardView), findsOneWidget);
//       expect(find.byType(Scaffold), findsOneWidget);
//       expect(find.byType(PageView), findsOneWidget);
//       expect(find.byType(AppBar), findsOneWidget);
//       expect(find.byType(Column), findsAtLeastNWidgets(1));
//       expect(find.byType(Row), findsAtLeastNWidgets(1));
//     });

//     // Test 8: Onboard ekranı key property doğru çalışmalı
//     testWidgets('Onboard ekranı key property doğru çalışmalı', (tester) async {
//       // ARRANGE: Farklı key'ler ile Onboard ekranını oluştur
//       final key1 = const Key('key1');
//       final key2 = const Key('key2');

//       await tester.pumpWidget(MaterialApp(home: OnBoardView(key: key1)));

//       // ACT: Widget'ın yüklenmesini bekle
//       await tester.pump();

//       // ASSERT: Key doğru mu?
//       expect(find.byKey(key1), findsOneWidget);
//       expect(find.byKey(key2), findsNothing);
//     });
//   });
// }
