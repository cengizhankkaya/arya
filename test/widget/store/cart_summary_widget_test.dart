import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:arya/features/store/view/widget/cart_summary_widget.dart';
import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
import 'package:arya/product/theme/app_colors.dart';

import 'cart_summary_widget_test.mocks.dart';

@GenerateMocks([CartViewModel])
void main() {
  group('CartSummaryWidget', () {
    late MockCartViewModel mockCartViewModel;
    late ColorScheme colorScheme;
    late AppColors appColors;

    setUp(() {
      mockCartViewModel = MockCartViewModel();
      colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      appColors = AppColors.light;

      // Mock değerleri ayarla
      when(mockCartViewModel.totalKcal).thenReturn(0.0);
      when(mockCartViewModel.totalProtein).thenReturn(0.0);
      when(mockCartViewModel.totalFat).thenReturn(0.0);
      when(mockCartViewModel.totalCarbs).thenReturn(0.0);
      when(mockCartViewModel.totalVitamins).thenReturn(0.0);
    });

    Widget createTestWidget({required CartViewModel cart}) {
      return MaterialApp(
        theme: ThemeData(colorScheme: colorScheme, extensions: [appColors]),
        home: ChangeNotifierProvider<CartViewModel>.value(
          value: cart,
          child: const Scaffold(body: CartSummaryWidget()),
        ),
      );
    }

    testWidgets('boş sepet durumunda tüm metrikler sıfır gösterilmeli', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(cart: mockCartViewModel));

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('0 kcal'), findsOneWidget);
      expect(find.text('0.0 g'), findsNWidgets(3)); // protein, fat, carbs
      expect(find.text('0.0 mg'), findsOneWidget); // vitamins
    });

    testWidgets('tek ürünlü sepet için doğru metrikler gösterilmeli', (
      WidgetTester tester,
    ) async {
      // Arrange - Mock değerleri ayarla
      when(mockCartViewModel.totalKcal).thenReturn(500.0);
      when(mockCartViewModel.totalProtein).thenReturn(31.0);
      when(mockCartViewModel.totalFat).thenReturn(16.4);
      when(mockCartViewModel.totalCarbs).thenReturn(60.0);
      when(mockCartViewModel.totalVitamins).thenReturn(30.0);

      await tester.pumpWidget(createTestWidget(cart: mockCartViewModel));

      // Act
      await tester.pumpAndSettle();

      // Assert - 2 adet ürün için hesaplanan değerler
      expect(find.text('500 kcal'), findsOneWidget); // 250 * 2
      expect(find.text('31.0 g'), findsOneWidget); // 15.5 * 2
      expect(find.text('16.4 g'), findsOneWidget); // 8.2 * 2
      expect(find.text('60.0 g'), findsOneWidget); // 30.0 * 2
      expect(find.text('30.0 mg'), findsOneWidget); // (10.0 + 5.0) * 2
    });

    testWidgets('çoklu ürünlü sepet için toplam metrikler doğru hesaplanmalı', (
      WidgetTester tester,
    ) async {
      // Arrange - Mock değerleri ayarla
      when(mockCartViewModel.totalKcal).thenReturn(650.0);
      when(mockCartViewModel.totalProtein).thenReturn(34.0);
      when(mockCartViewModel.totalFat).thenReturn(14.0);
      when(mockCartViewModel.totalCarbs).thenReturn(85.0);
      when(mockCartViewModel.totalVitamins).thenReturn(26.0);

      await tester.pumpWidget(createTestWidget(cart: mockCartViewModel));

      // Act
      await tester.pumpAndSettle();

      // Assert - Toplam değerler
      expect(find.text('650 kcal'), findsOneWidget); // (200 * 1) + (150 * 3)
      expect(find.text('34.0 g'), findsOneWidget); // (10.0 * 1) + (8.0 * 3)
      expect(find.text('14.0 g'), findsOneWidget); // (5.0 * 1) + (3.0 * 3)
      expect(find.text('85.0 g'), findsOneWidget); // (25.0 * 1) + (20.0 * 3)
      expect(find.text('26.0 mg'), findsOneWidget); // (8.0 * 1) + (6.0 * 3)
    });

    testWidgets('metrik ikonları doğru gösterilmeli', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(cart: mockCartViewModel));

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget); // kcal
      expect(find.byIcon(Icons.fitness_center), findsOneWidget); // protein
      expect(find.byIcon(Icons.opacity), findsOneWidget); // fat
      expect(find.byIcon(Icons.grain), findsOneWidget); // carbs
      expect(find.byIcon(Icons.eco), findsOneWidget); // vitamins
    });

    testWidgets('metrik etiketleri doğru gösterilmeli', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(cart: mockCartViewModel));

      // Act
      await tester.pumpAndSettle();

      // Assert - Etiketlerin varlığını kontrol et
      expect(find.text('store.totals.total_kcal'), findsOneWidget);
      expect(find.text('store.totals.total_protein'), findsOneWidget);
      expect(find.text('store.totals.total_fat'), findsOneWidget);
      expect(find.text('store.totals.total_carbs'), findsOneWidget);
      expect(find.text('store.totals.total_vitamins'), findsOneWidget);
    });

    testWidgets('widget yapısı doğru olmalı', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(cart: mockCartViewModel));

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(Row), findsAtLeastNWidgets(3)); // En az 3 satır metrik
    });

    testWidgets('ondalık sayılar doğru formatlanmalı', (
      WidgetTester tester,
    ) async {
      // Arrange - Mock değerleri ayarla
      when(mockCartViewModel.totalKcal).thenReturn(1234.567);
      when(mockCartViewModel.totalProtein).thenReturn(12.345);
      when(mockCartViewModel.totalFat).thenReturn(8.999);
      when(mockCartViewModel.totalCarbs).thenReturn(45.123);
      when(mockCartViewModel.totalVitamins).thenReturn(1.234);

      await tester.pumpWidget(createTestWidget(cart: mockCartViewModel));

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('1,235 kcal'),
        findsOneWidget,
      ); // round() ile yuvarlanmış
      expect(find.text('12.3 g'), findsOneWidget); // #,##0.0 formatı
      expect(find.text('9.0 g'), findsOneWidget); // #,##0.0 formatı
      expect(find.text('45.1 g'), findsOneWidget); // #,##0.0 formatı
      expect(find.text('1.2 mg'), findsOneWidget); // #,##0.0 formatı
    });

    testWidgets('sepet değiştiğinde metrikler güncellenmeli', (
      WidgetTester tester,
    ) async {
      // Arrange - İlk durum - boş sepet
      await tester.pumpWidget(createTestWidget(cart: mockCartViewModel));
      await tester.pumpAndSettle();

      expect(find.text('0 kcal'), findsOneWidget);

      // Act - Yeni mock oluştur ve değerleri ayarla
      final newMockCartViewModel = MockCartViewModel();
      when(newMockCartViewModel.totalKcal).thenReturn(300.0);
      when(newMockCartViewModel.totalProtein).thenReturn(20.0);
      when(newMockCartViewModel.totalFat).thenReturn(10.0);
      when(newMockCartViewModel.totalCarbs).thenReturn(40.0);
      when(newMockCartViewModel.totalVitamins).thenReturn(15.0);

      await tester.pumpWidget(createTestWidget(cart: newMockCartViewModel));
      await tester.pumpAndSettle();

      // Assert - Güncellenmiş değerler
      expect(find.text('300 kcal'), findsOneWidget);
      expect(find.text('20.0 g'), findsOneWidget);
      expect(find.text('10.0 g'), findsOneWidget);
      expect(find.text('40.0 g'), findsOneWidget);
      expect(find.text('15.0 mg'), findsOneWidget);
    });

    testWidgets('eksik nutriment değerleri için sıfır gösterilmeli', (
      WidgetTester tester,
    ) async {
      // Arrange - Mock değerleri ayarla (sadece kcal var)
      when(mockCartViewModel.totalKcal).thenReturn(200.0);
      when(mockCartViewModel.totalProtein).thenReturn(0.0);
      when(mockCartViewModel.totalFat).thenReturn(0.0);
      when(mockCartViewModel.totalCarbs).thenReturn(0.0);
      when(mockCartViewModel.totalVitamins).thenReturn(0.0);

      await tester.pumpWidget(createTestWidget(cart: mockCartViewModel));

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('200 kcal'), findsOneWidget);
      expect(find.text('0.0 g'), findsNWidgets(3)); // protein, fat, carbs
      expect(find.text('0.0 mg'), findsOneWidget); // vitamins
    });

    testWidgets('geçersiz nutriment değerleri için sıfır gösterilmeli', (
      WidgetTester tester,
    ) async {
      // Arrange - Mock değerleri ayarla (tümü sıfır)
      when(mockCartViewModel.totalKcal).thenReturn(0.0);
      when(mockCartViewModel.totalProtein).thenReturn(0.0);
      when(mockCartViewModel.totalFat).thenReturn(0.0);
      when(mockCartViewModel.totalCarbs).thenReturn(0.0);
      when(mockCartViewModel.totalVitamins).thenReturn(0.0);

      await tester.pumpWidget(createTestWidget(cart: mockCartViewModel));

      // Act
      await tester.pumpAndSettle();

      // Assert - Tüm değerler sıfır olmalı
      expect(find.text('0 kcal'), findsOneWidget);
      expect(find.text('0.0 g'), findsNWidgets(3));
      expect(find.text('0.0 mg'), findsOneWidget);
    });
  });
}
