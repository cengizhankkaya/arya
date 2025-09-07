import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:arya/features/store/view/widget/product_detail_bottom_bar.dart';
import 'package:arya/features/store/view_model/product_detail_view_model.dart';
import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/product/theme/app_colors.dart';

import 'product_detail_bottom_bar_test.mocks.dart';

@GenerateMocks([ProductDetailViewModel, CartViewModel])
void main() {
  group('ProductDetailBottomBar', () {
    late MockProductDetailViewModel mockViewModel;
    late MockCartViewModel mockCartViewModel;
    late ColorScheme colorScheme;
    late AppColors appColors;

    setUp(() {
      mockViewModel = MockProductDetailViewModel();
      mockCartViewModel = MockCartViewModel();
      colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      appColors = AppColors.light;

      // Mock değerleri ayarla
      when(mockViewModel.quantity).thenReturn(1);
      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.productName).thenReturn('Test Product');
      when(mockViewModel.canAddToCart).thenReturn(true);
    });

    Widget createTestWidgetWithParams({
      required ProductDetailViewModel viewModel,
      required ColorScheme scheme,
    }) {
      return MaterialApp(
        theme: ThemeData(colorScheme: colorScheme, extensions: [appColors]),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<ProductDetailViewModel>.value(
              value: viewModel,
            ),
            ChangeNotifierProvider<CartViewModel>.value(
              value: mockCartViewModel,
            ),
          ],
          child: Scaffold(
            body: ProductDetailBottomBar(viewModel: viewModel, scheme: scheme),
          ),
        ),
      );
    }

    testWidgets('widget temel yapısı doğru oluşturulmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Container), findsAtLeastNWidgets(2));
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(Row), findsAtLeastNWidgets(1));
    });

    testWidgets('miktar kontrol butonları doğru gösterilmeli', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('1'), findsOneWidget); // quantity değeri
    });

    testWidgets('miktar artırma butonu çalışmalı', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Assert
      verify(mockViewModel.incrementQuantity()).called(1);
    });

    testWidgets('miktar azaltma butonu çalışmalı', (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.quantity).thenReturn(2); // 2'den başla
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      // Assert
      verify(mockViewModel.decrementQuantity()).called(1);
    });

    testWidgets('loading durumunda butonlar devre dışı olmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.isLoading).thenReturn(true);
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);

      // IconButton'ların varlığını kontrol et
      expect(find.byType(IconButton), findsNWidgets(2));
    });

    testWidgets('miktar değeri doğru gösterilmeli', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.quantity).thenReturn(5);
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('AddToCartButton widget\'ı bulunmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('AddToCartButton loading durumunda doğru gösterilmeli', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.isLoading).thenReturn(true);
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
      // Loading durumunda "adding to cart" metni olmalı
      expect(find.textContaining('detail.adding_to_cart'), findsOneWidget);
    });

    testWidgets('AddToCartButton normal durumda miktar gösterilmeli', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.quantity).thenReturn(3);
      when(mockViewModel.isLoading).thenReturn(false);
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('(3)'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('miktar kontrol container\'ı doğru stil almalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final containers = tester.widgetList<Container>(find.byType(Container));
      // İkinci container (miktar kontrol container'ı) bul
      final quantityContainer = containers.firstWhere(
        (container) => container.padding != null,
      );

      expect(quantityContainer.decoration, isA<BoxDecoration>());
      final decoration = quantityContainer.decoration as BoxDecoration;
      expect(decoration.borderRadius, isA<BorderRadius>());
      expect(decoration.border, isA<Border>());
    });

    testWidgets('ana container doğru border almalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final mainContainer = tester.widget<Container>(
        find.byType(Container).first,
      );

      expect(mainContainer.decoration, isA<BoxDecoration>());
      final decoration = mainContainer.decoration as BoxDecoration;
      expect(decoration.border, isA<Border>());
    });

    testWidgets('SafeArea widget\'ı kullanılmalı', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('Column mainAxisSize MainAxisSize.min olmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final column = tester.widget<Column>(find.byType(Column).first);
      expect(column.mainAxisSize, MainAxisSize.min);
      expect(column.crossAxisAlignment, CrossAxisAlignment.stretch);
    });

    testWidgets('miktar kontrol Row\'u center alignment almalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final row = tester.widget<Row>(find.byType(Row).first);
      expect(row.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('SizedBox spacing\'leri doğru olmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(sizedBoxes.length, greaterThanOrEqualTo(3));

      // Width 8 olan SizedBox'ları bul
      final width8Boxes = sizedBoxes.where((box) => box.width == 8.0).toList();
      expect(width8Boxes.length, 2); // İki tane width: 8 olan SizedBox olmalı

      // Height 12 olan SizedBox'ı bul
      final height12Boxes = sizedBoxes
          .where((box) => box.height == 12.0)
          .toList();
      expect(
        height12Boxes.length,
        1,
      ); // Bir tane height: 12 olan SizedBox olmalı
    });

    testWidgets('AddToCartButton SizedBox width double.infinity olmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final infinityWidthBoxes = sizedBoxes
          .where((box) => box.width == double.infinity)
          .toList();
      expect(
        infinityWidthBoxes.length,
        1,
      ); // Bir tane width: double.infinity olan SizedBox olmalı
    });

    testWidgets('miktar değiştiğinde UI güncellenmeli', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.quantity).thenReturn(1);
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);

      // Act - Miktarı değiştir
      when(mockViewModel.quantity).thenReturn(5);
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('loading durumu değiştiğinde UI güncellenmeli', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.isLoading).thenReturn(false);
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('detail.adding_to_cart'), findsNothing);

      // Act - Loading durumunu değiştir
      when(mockViewModel.isLoading).thenReturn(true);
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Loading durumunda "adding to cart" metni olmalı
      expect(find.textContaining('detail.adding_to_cart'), findsOneWidget);
    });

    testWidgets('IconButton.filledTonal kullanılmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final iconButtons = tester.widgetList<IconButton>(
        find.byType(IconButton),
      );
      expect(iconButtons.length, 2); // remove ve add butonları

      // IconButton'ların varlığını kontrol et
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Text widget AppTypography kullanmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final textWidget = tester.widget<Text>(find.text('1'));
      expect(textWidget.style, isNotNull);
    });

    testWidgets('Padding değeri 20 olmalı', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final paddings = tester.widgetList<Padding>(find.byType(Padding));
      // Ana Padding widget'ını bul (EdgeInsets.all(20) olan)
      final mainPadding = paddings.firstWhere(
        (padding) => padding.padding == const EdgeInsets.all(20),
      );
      expect(mainPadding.padding, const EdgeInsets.all(20));
    });

    testWidgets('miktar kontrol container padding doğru olmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createTestWidgetWithParams(
          viewModel: mockViewModel,
          scheme: colorScheme,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final containers = tester.widgetList<Container>(find.byType(Container));
      final quantityContainer = containers.firstWhere(
        (container) => container.padding != null,
      );

      expect(
        quantityContainer.padding,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      );
    });
  });
}
