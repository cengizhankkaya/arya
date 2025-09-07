import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/store/view/widget/empty_cart_widget.dart';
import 'package:arya/product/theme/app_colors.dart';

/// EmptyCartWidget için kapsamlı test dosyası
///
/// Bu test dosyası EmptyCartWidget'ın tüm özelliklerini test eder:
/// - Widget yapısı ve bileşenleri
/// - İkon ve metin özellikleri
/// - Tema uyumluluğu
/// - Responsive tasarım
void main() {
  group('EmptyCartWidget', () {
    // Test sabitleri
    const double _iconSize = 80.0;
    const double _spacingLarge = 16.0;
    const double _spacingSmall = 8.0;
    const int _expectedColumnChildren = 5;
    const FontWeight _expectedTitleWeight = FontWeight.w600;

    // Test verileri
    late ColorScheme colorScheme;
    late AppColors appColors;

    setUp(() {
      colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      appColors = AppColors.light;
    });

    /// Test widget'ı oluşturur
    Widget createTestWidget({
      ColorScheme? customColorScheme,
      AppColors? customAppColors,
    }) {
      return MaterialApp(
        theme: ThemeData(
          colorScheme: customColorScheme ?? colorScheme,
          extensions: [customAppColors ?? appColors],
        ),
        home: const Scaffold(body: EmptyCartWidget()),
      );
    }

    /// Widget'ı test ortamına yükler ve yerleştirir
    Future<void> pumpAndSettleWidget(WidgetTester tester, Widget widget) async {
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
    }

    /// İkon widget'ını bulur ve döndürür
    Icon findIconWidget(WidgetTester tester) {
      final iconFinder = find.byIcon(Icons.shopping_cart_outlined);
      return tester.widget<Icon>(iconFinder);
    }

    /// Metin widget'ını bulur ve döndürür
    Text findTextWidget(WidgetTester tester, String text) {
      final textFinder = find.text(text);
      return tester.widget<Text>(textFinder);
    }

    /// Column widget'ını bulur ve döndürür
    Column findColumnWidget(WidgetTester tester) {
      final columnFinder = find.byType(Column);
      return tester.widget<Column>(columnFinder);
    }

    group('Widget Yapısı', () {
      testWidgets('temel widget bileşenleri doğru olmalı', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await pumpAndSettleWidget(tester, createTestWidget());

        // Assert - Ana widget yapısı
        expect(find.byType(Center), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
        expect(find.byType(Text), findsNWidgets(2)); // Başlık ve alt başlık
        expect(find.byType(SizedBox), findsAtLeastNWidgets(2)); // İki boşluk
      });

      testWidgets('Column yapısı doğru olmalı', (WidgetTester tester) async {
        // Arrange & Act
        await pumpAndSettleWidget(tester, createTestWidget());

        // Assert - Column özellikleri
        final columnWidget = findColumnWidget(tester);
        expect(columnWidget.mainAxisAlignment, MainAxisAlignment.center);
        expect(columnWidget.children.length, _expectedColumnChildren);
      });

      testWidgets('SizedBox yükseklikleri doğru olmalı', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await pumpAndSettleWidget(tester, createTestWidget());

        // Assert - SizedBox yükseklikleri
        final sizedBoxWidgets = tester.widgetList<SizedBox>(
          find.byType(SizedBox),
        );

        final height16Box = sizedBoxWidgets
            .where((box) => box.height == _spacingLarge)
            .first;
        final height8Box = sizedBoxWidgets
            .where((box) => box.height == _spacingSmall)
            .first;

        expect(height16Box.height, _spacingLarge);
        expect(height8Box.height, _spacingSmall);
      });
    });

    group('İkon Özellikleri', () {
      testWidgets('alışveriş sepeti ikonu doğru gösterilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await pumpAndSettleWidget(tester, createTestWidget());

        // Assert - İkon varlığı ve özellikleri
        expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);

        final iconWidget = findIconWidget(tester);
        expect(iconWidget.size, _iconSize);
        expect(iconWidget.color, colorScheme.outlineVariant);
      });
    });

    group('Metin Özellikleri', () {
      testWidgets('başlık metni doğru gösterilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await pumpAndSettleWidget(tester, createTestWidget());

        // Assert - Başlık metni varlığı ve stili
        expect(find.text('store.empty_cart_title'), findsOneWidget);

        final titleWidget = findTextWidget(tester, 'store.empty_cart_title');
        expect(titleWidget.style?.fontWeight, _expectedTitleWeight);
        expect(titleWidget.style?.color, colorScheme.onSurfaceVariant);
      });

      testWidgets('alt başlık metni doğru gösterilmeli', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await pumpAndSettleWidget(tester, createTestWidget());

        // Assert - Alt başlık metni varlığı ve stili
        expect(find.text('store.empty_cart_subtitle'), findsOneWidget);

        final subtitleWidget = findTextWidget(
          tester,
          'store.empty_cart_subtitle',
        );
        expect(subtitleWidget.style?.color, colorScheme.onSurfaceVariant);
      });

      testWidgets('çeviri anahtarları doğru kullanılmalı', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await pumpAndSettleWidget(tester, createTestWidget());

        // Assert - Çeviri anahtarlarının varlığı
        expect(find.text('store.empty_cart_title'), findsOneWidget);
        expect(find.text('store.empty_cart_subtitle'), findsOneWidget);
      });
    });

    group('Tema Uyumluluğu', () {
      testWidgets('koyu tema ile uyumlu olmalı', (WidgetTester tester) async {
        // Arrange - Koyu tema
        final darkColorScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );
        final darkAppColors = AppColors.dark;

        // Act
        await pumpAndSettleWidget(
          tester,
          createTestWidget(
            customColorScheme: darkColorScheme,
            customAppColors: darkAppColors,
          ),
        );

        // Assert - Koyu temada renkler doğru olmalı
        final iconWidget = findIconWidget(tester);
        expect(iconWidget.color, darkColorScheme.outlineVariant);

        final titleWidget = findTextWidget(tester, 'store.empty_cart_title');
        expect(titleWidget.style?.color, darkColorScheme.onSurfaceVariant);

        final subtitleWidget = findTextWidget(
          tester,
          'store.empty_cart_subtitle',
        );
        expect(subtitleWidget.style?.color, darkColorScheme.onSurfaceVariant);
      });

      testWidgets('farklı renk şemalarında çalışmalı', (
        WidgetTester tester,
      ) async {
        // Arrange - Özel renk şeması
        final customColorScheme = ColorScheme.fromSeed(seedColor: Colors.red);

        // Act
        await pumpAndSettleWidget(
          tester,
          createTestWidget(customColorScheme: customColorScheme),
        );

        // Assert - Özel renk şemasında renkler doğru olmalı
        final iconWidget = findIconWidget(tester);
        expect(iconWidget.color, customColorScheme.outlineVariant);

        final titleWidget = findTextWidget(tester, 'store.empty_cart_title');
        expect(titleWidget.style?.color, customColorScheme.onSurfaceVariant);
      });
    });

    group('Responsive ve Tutarlılık', () {
      testWidgets('widget yeniden oluşturulduğunda tutarlı olmalı', (
        WidgetTester tester,
      ) async {
        // Arrange & Act - İlk yükleme
        await pumpAndSettleWidget(tester, createTestWidget());

        // Act - Widget'ı yeniden oluştur
        await pumpAndSettleWidget(tester, createTestWidget());

        // Assert - Tüm bileşenler hala mevcut olmalı
        expect(find.byType(Center), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsOneWidget);
        expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
        expect(find.text('store.empty_cart_title'), findsOneWidget);
        expect(find.text('store.empty_cart_subtitle'), findsOneWidget);
      });

      testWidgets('farklı ekran boyutlarında çalışmalı', (
        WidgetTester tester,
      ) async {
        // Test edilecek ekran boyutları
        const testSizes = [
          Size(300, 400), // Küçük ekran
          Size(800, 1200), // Büyük ekran
        ];

        for (final size in testSizes) {
          // Arrange - Ekran boyutunu ayarla
          await tester.binding.setSurfaceSize(size);

          // Act
          await pumpAndSettleWidget(tester, createTestWidget());

          // Assert - Widget hala doğru çalışmalı
          expect(find.byType(Center), findsAtLeastNWidgets(1));
          expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
          expect(find.text('store.empty_cart_title'), findsOneWidget);
          expect(find.text('store.empty_cart_subtitle'), findsOneWidget);
        }

        // Cleanup
        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}
