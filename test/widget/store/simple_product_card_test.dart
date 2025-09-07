import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:arya/features/store/view/widget/product_card_widget.dart';
import 'package:arya/features/store/view_model/store_view_model.dart';
import 'package:arya/product/theme/app_colors.dart';

import 'simple_product_card_test.mocks.dart';

@GenerateMocks([StoreViewModel])
void main() {
  group('ProductCard Simple Widget Tests', () {
    late MockStoreViewModel mockStoreViewModel;
    late ColorScheme colorScheme;
    late AppColors appColors;
    late Map<String, dynamic> sampleProduct;

    setUp(() {
      mockStoreViewModel = MockStoreViewModel();
      colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      appColors = AppColors.light;

      sampleProduct = {
        'id': 'test-product-1',
        'product_name': 'Test Product',
        'brands': 'Test Brand',
        'image_url': 'https://example.com/image.jpg',
        'nutriments': {
          'proteins_100g': 15.0,
          'carbohydrates_100g': 30.0,
          'fat_100g': 10.0,
        },
      };
    });

    Widget createTestWidget({
      required Map<String, dynamic> product,
      VoidCallback? onTap,
      VoidCallback? onAddToCart,
    }) {
      return MaterialApp(
        theme: ThemeData(colorScheme: colorScheme, extensions: [appColors]),
        home: ChangeNotifierProvider<StoreViewModel>.value(
          value: mockStoreViewModel,
          child: Scaffold(
            body: ProductCard(
              product: product,
              scheme: colorScheme,
              appColors: appColors,
              onTap: onTap ?? () {},
              onAddToCart: onAddToCart ?? () {},
            ),
          ),
        ),
      );
    }

    group('Basic Rendering Tests', () {
      testWidgets('should render product card with basic elements', (
        tester,
      ) async {
        // Arrange
        when(
          mockStoreViewModel.getProductCardColor(any, any),
        ).thenReturn(Colors.green);

        // Act
        await tester.pumpWidget(createTestWidget(product: sampleProduct));

        // Assert
        expect(find.text('Test Product'), findsOneWidget);
        expect(find.text('Test Brand'), findsOneWidget);
        expect(find.byType(ProductCard), findsOneWidget);
      });

      testWidgets('should render product card with null values', (
        tester,
      ) async {
        // Arrange
        final productWithNulls = {
          'id': 'test-product-1',
          'product_name': null,
          'brands': null,
          'image_url': null,
          'nutriments': null,
        };

        when(
          mockStoreViewModel.getProductCardColor(any, any),
        ).thenReturn(Colors.green);

        // Act
        await tester.pumpWidget(createTestWidget(product: productWithNulls));

        // Assert
        expect(find.byType(Text), findsWidgets);
        expect(find.byType(ProductCard), findsOneWidget);
      });

      testWidgets('should render product card with empty data', (tester) async {
        // Arrange
        final emptyProduct = <String, dynamic>{};

        when(
          mockStoreViewModel.getProductCardColor(any, any),
        ).thenReturn(Colors.green);

        // Act
        await tester.pumpWidget(createTestWidget(product: emptyProduct));

        // Assert
        expect(find.byType(Text), findsWidgets);
        expect(find.byType(ProductCard), findsOneWidget);
      });
    });

    group('User Interaction Tests', () {
      testWidgets('should call onTap when card is tapped', (tester) async {
        // Arrange
        bool onTapCalled = false;
        when(
          mockStoreViewModel.getProductCardColor(any, any),
        ).thenReturn(Colors.green);

        // Act
        await tester.pumpWidget(
          createTestWidget(
            product: sampleProduct,
            onTap: () => onTapCalled = true,
          ),
        );

        await tester.tap(find.byType(ProductCard));
        await tester.pump();

        // Assert
        expect(onTapCalled, isTrue);
      });

      testWidgets('should call onAddToCart when add button is tapped', (
        tester,
      ) async {
        // Arrange
        when(
          mockStoreViewModel.getProductCardColor(any, any),
        ).thenReturn(Colors.green);

        when(
          mockStoreViewModel.addProductToCart(any, any),
        ).thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(
          createTestWidget(product: sampleProduct, onAddToCart: () {}),
        );

        // Find the add button (Icon with Icons.add)
        final addButton = find.byIcon(Icons.add);
        expect(addButton, findsOneWidget);

        await tester.tap(addButton);
        await tester.pump();

        // Assert
        verify(mockStoreViewModel.addProductToCart(any, any)).called(1);
      });
    });

    group('Color Tests', () {
      testWidgets('should use color from StoreViewModel', (tester) async {
        // Arrange
        when(
          mockStoreViewModel.getProductCardColor(any, any),
        ).thenReturn(Colors.red);

        // Act
        await tester.pumpWidget(createTestWidget(product: sampleProduct));

        // Assert
        verify(
          mockStoreViewModel.getProductCardColor(sampleProduct, any),
        ).called(1);
      });

      testWidgets('should handle different colors from StoreViewModel', (
        tester,
      ) async {
        // Arrange
        when(
          mockStoreViewModel.getProductCardColor(any, any),
        ).thenReturn(Colors.blue);

        // Act
        await tester.pumpWidget(createTestWidget(product: sampleProduct));

        // Assert
        final productCard = tester.widget<ProductCard>(
          find.byType(ProductCard),
        );
        expect(productCard, isNotNull);
      });
    });

    group('Text Overflow Tests', () {
      testWidgets('should handle long product names', (tester) async {
        // Arrange
        final productWithLongName = Map<String, dynamic>.from(sampleProduct);
        productWithLongName['product_name'] = 'A' * 100; // Very long name

        when(
          mockStoreViewModel.getProductCardColor(any, any),
        ).thenReturn(Colors.green);

        // Act
        await tester.pumpWidget(createTestWidget(product: productWithLongName));

        // Assert
        expect(find.text('A' * 100), findsOneWidget);

        // Check that maxLines is set to 2
        final textWidget = tester.widget<Text>(find.text('A' * 100));
        expect(textWidget.maxLines, equals(2));
        expect(textWidget.overflow, equals(TextOverflow.ellipsis));
      });

      testWidgets('should handle long brand names', (tester) async {
        // Arrange
        final productWithLongBrand = Map<String, dynamic>.from(sampleProduct);
        productWithLongBrand['brands'] = 'B' * 100; // Very long brand

        when(
          mockStoreViewModel.getProductCardColor(any, any),
        ).thenReturn(Colors.green);

        // Act
        await tester.pumpWidget(
          createTestWidget(product: productWithLongBrand),
        );

        // Assert
        expect(find.text('B' * 100), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle special characters in product data', (
        tester,
      ) async {
        // Arrange
        final productWithSpecialChars = {
          'id': 'test@#\$%^&*()_+{}|:"<>?[]\\\\;\',./',
          'product_name': 'Test@#\$%^&*()_+{}|:"<>?[]\\\\;\',./',
          'brands': 'Brand@#\$%^&*()_+{}|:"<>?[]\\\\;\',./',
          'nutriments': {},
        };

        when(
          mockStoreViewModel.getProductCardColor(any, any),
        ).thenReturn(Colors.green);

        // Act
        await tester.pumpWidget(
          createTestWidget(product: productWithSpecialChars),
        );

        // Assert
        expect(
          find.text('Test@#\$%^&*()_+{}|:"<>?[]\\\\;\',./'),
          findsOneWidget,
        );
        expect(
          find.text('Brand@#\$%^&*()_+{}|:"<>?[]\\\\;\',./'),
          findsOneWidget,
        );
      });

      testWidgets('should handle very large nutrition values', (tester) async {
        // Arrange
        final productWithLargeValues = Map<String, dynamic>.from(sampleProduct);
        productWithLargeValues['nutriments'] = {
          'proteins_100g': 999999.99,
          'carbohydrates_100g': 888888.88,
          'fat_100g': 777777.77,
        };

        when(
          mockStoreViewModel.getProductCardColor(any, any),
        ).thenReturn(Colors.green);

        // Act
        await tester.pumpWidget(
          createTestWidget(product: productWithLargeValues),
        );

        // Assert
        expect(find.text('Test Product'), findsOneWidget);
        expect(find.text('Test Brand'), findsOneWidget);
      });
    });
  });
}
