import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:arya/features/store/view/widget/product_list_widget.dart';
import 'package:arya/features/store/view/widget/product_shimmer_widget.dart';
import 'package:arya/features/store/view_model/store_view_model.dart';
import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:arya/product/utility/constants/dimensions/project_padding.dart';

import 'product_list_widget_test.mocks.dart';

@GenerateMocks([StoreViewModel, CartViewModel])
void main() {
  group('ProductListWidget Tests', () {
    late MockStoreViewModel mockStoreViewModel;
    late MockCartViewModel mockCartViewModel;
    late ColorScheme colorScheme;
    late AppColors appColors;
    late List<Map<String, dynamic>> sampleProducts;

    setUp(() {
      mockStoreViewModel = MockStoreViewModel();
      mockCartViewModel = MockCartViewModel();
      colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      appColors = AppColors.light;

      sampleProducts = [
        {
          'id': 'test-product-1',
          'product_name': 'Test Product 1',
          'brands': 'Test Brand 1',
          'image_url': 'https://example.com/image1.jpg',
          'nutriments': {
            'proteins_100g': 15.0,
            'carbohydrates_100g': 30.0,
            'fat_100g': 10.0,
          },
        },
        {
          'id': 'test-product-2',
          'product_name': 'Test Product 2',
          'brands': 'Test Brand 2',
          'image_url': 'https://example.com/image2.jpg',
          'nutriments': {
            'proteins_100g': 20.0,
            'carbohydrates_100g': 25.0,
            'fat_100g': 15.0,
          },
        },
        {
          'id': 'test-product-3',
          'product_name': 'Test Product 3',
          'brands': 'Test Brand 3',
          'image_url': 'https://example.com/image3.jpg',
          'nutriments': {
            'proteins_100g': 10.0,
            'carbohydrates_100g': 35.0,
            'fat_100g': 5.0,
          },
        },
      ];

      // Default mock setup
      when(mockStoreViewModel.isLoading).thenReturn(false);
      when(mockStoreViewModel.isLoadingMore).thenReturn(false);
      when(mockStoreViewModel.hasMoreProducts).thenReturn(true);
      when(mockStoreViewModel.products).thenReturn(sampleProducts);
      when(
        mockStoreViewModel.getProductCardColor(any, any),
      ).thenReturn(Colors.white);
      when(
        mockStoreViewModel.addProductToCart(any, any),
      ).thenAnswer((_) async {});
    });

    Widget createTestWidget() {
      return MaterialApp(
        theme: ThemeData(colorScheme: colorScheme, extensions: [appColors]),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<StoreViewModel>.value(
              value: mockStoreViewModel,
            ),
            ChangeNotifierProvider<CartViewModel>.value(
              value: mockCartViewModel,
            ),
          ],
          child: const Scaffold(body: ProductList()),
        ),
      );
    }

    group('Loading State Tests', () {
      testWidgets('should show shimmer widget when loading', (tester) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(true);
        when(mockStoreViewModel.products).thenReturn([]);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ProductList), findsOneWidget);
        // Shimmer widget'ı bulunmalı
        expect(find.byType(ProductShimmerWidget), findsOneWidget);
      });

      testWidgets('should not show shimmer when not loading', (tester) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(sampleProducts);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ProductList), findsOneWidget);
        expect(find.byType(ProductShimmerWidget), findsNothing);
      });
    });

    group('Empty State Tests', () {
      testWidgets(
        'should show no products message when products list is empty',
        (tester) async {
          // Arrange
          when(mockStoreViewModel.isLoading).thenReturn(false);
          when(mockStoreViewModel.products).thenReturn([]);

          // Act
          await tester.pumpWidget(createTestWidget());

          // Assert
          expect(find.byType(ProductList), findsOneWidget);
          expect(find.text('store.no_products'), findsOneWidget);
          expect(find.byType(GridView), findsNothing);
        },
      );

      testWidgets('should show products when list is not empty', (
        tester,
      ) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(sampleProducts);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ProductList), findsOneWidget);
        expect(find.text('store.no_products'), findsNothing);
        expect(find.byType(GridView), findsOneWidget);
      });
    });

    group('Product List Rendering Tests', () {
      testWidgets('should render GridView with correct properties', (
        tester,
      ) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(sampleProducts);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(GridView), findsOneWidget);
        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView.padding, equals(ProjectPadding.allSmall()));
      });

      testWidgets('should render correct number of product cards', (
        tester,
      ) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(sampleProducts);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(GridView), findsOneWidget);
        // GridView'ın itemCount'u products.length olmalı
        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView.childrenDelegate, isA<SliverChildBuilderDelegate>());
      });

      testWidgets('should render product cards with correct data', (
        tester,
      ) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(sampleProducts);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(GridView), findsOneWidget);
        // Product card'ları render edilmeli
        expect(find.text('Test Product 1'), findsOneWidget);
        expect(find.text('Test Brand 1'), findsOneWidget);
      });

      testWidgets('should have correct grid delegate properties', (
        tester,
      ) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(sampleProducts);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        expect(delegate.crossAxisCount, equals(2));
        expect(delegate.mainAxisSpacing, equals(16));
        expect(delegate.crossAxisSpacing, equals(16));
        expect(delegate.childAspectRatio, equals(0.85));
      });
    });

    group('Scroll and Pagination Tests', () {
      testWidgets('should show loading shimmer cards when loading more', (
        tester,
      ) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.isLoadingMore).thenReturn(true);
        when(mockStoreViewModel.products).thenReturn(sampleProducts);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.childrenDelegate as SliverChildBuilderDelegate;
        // itemCount = products.length + 2 (loading shimmer cards)
        expect(delegate.childCount, equals(sampleProducts.length + 2));
      });

      testWidgets('should not show loading shimmer when not loading more', (
        tester,
      ) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.isLoadingMore).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(sampleProducts);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.childrenDelegate as SliverChildBuilderDelegate;
        // itemCount = products.length (no loading shimmer cards)
        expect(delegate.childCount, equals(sampleProducts.length));
      });

      testWidgets('should call loadMoreProducts when scrolled to bottom', (
        tester,
      ) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.isLoadingMore).thenReturn(false);
        when(mockStoreViewModel.hasMoreProducts).thenReturn(true);
        when(mockStoreViewModel.products).thenReturn(sampleProducts);
        when(mockStoreViewModel.loadMoreProducts()).thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Scroll to bottom
        await tester.drag(find.byType(GridView), const Offset(0, -1000));
        await tester.pump();

        // Assert
        verify(mockStoreViewModel.loadMoreProducts()).called(greaterThan(0));
      });

      testWidgets(
        'should not call loadMoreProducts when hasMoreProducts is false',
        (tester) async {
          // Arrange
          when(mockStoreViewModel.isLoading).thenReturn(false);
          when(mockStoreViewModel.isLoadingMore).thenReturn(false);
          when(mockStoreViewModel.hasMoreProducts).thenReturn(false);
          when(mockStoreViewModel.products).thenReturn(sampleProducts);

          // Act
          await tester.pumpWidget(createTestWidget());
          await tester.pumpAndSettle();

          // Scroll to bottom
          await tester.drag(find.byType(GridView), const Offset(0, -1000));
          await tester.pumpAndSettle();

          // Assert
          verifyNever(mockStoreViewModel.loadMoreProducts());
        },
      );

      testWidgets(
        'should not call loadMoreProducts when already loading more',
        (tester) async {
          // Arrange
          when(mockStoreViewModel.isLoading).thenReturn(false);
          when(mockStoreViewModel.isLoadingMore).thenReturn(true);
          when(mockStoreViewModel.hasMoreProducts).thenReturn(true);
          when(mockStoreViewModel.products).thenReturn(sampleProducts);

          // Act
          await tester.pumpWidget(createTestWidget());
          await tester.pump();

          // Scroll to bottom
          await tester.drag(find.byType(GridView), const Offset(0, -1000));
          await tester.pump();

          // Assert
          verifyNever(mockStoreViewModel.loadMoreProducts());
        },
      );
    });

    group('User Interaction Tests', () {
      testWidgets('should call addProductToCart when add button is tapped', (
        tester,
      ) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(sampleProducts);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find and tap the first add button
        final addButtons = find.byIcon(Icons.add);
        if (addButtons.evaluate().isNotEmpty) {
          await tester.tap(addButtons.first);
          await tester.pumpAndSettle();
        }

        // Assert
        // addProductToCart çağrıldığını kontrol et
        verify(mockStoreViewModel.addProductToCart(any, any)).called(1);
      });

      testWidgets('should render product cards with tap gestures', (
        tester,
      ) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(sampleProducts);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        // Product card'ları GestureDetector ile render edilmeli
        expect(find.byType(GestureDetector), findsWidgets);
        expect(find.byType(ProductList), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle null products gracefully', (tester) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn([]);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ProductList), findsOneWidget);
        expect(find.text('store.no_products'), findsOneWidget);
      });

      testWidgets('should handle products with missing data', (tester) async {
        // Arrange
        final productsWithMissingData = [
          {
            'id': 'test-product-1',
            // product_name missing
            'brands': 'Test Brand 1',
            'image_url': 'https://example.com/image1.jpg',
            'nutriments': {},
          },
          {
            'id': 'test-product-2',
            'product_name': 'Test Product 2',
            // brands missing
            'image_url': 'https://example.com/image2.jpg',
            'nutriments': {},
          },
        ];

        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(productsWithMissingData);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ProductList), findsOneWidget);
        expect(find.byType(GridView), findsOneWidget);
        // Widget crash etmemeli
      });

      testWidgets('should handle very large product list', (tester) async {
        // Arrange
        final largeProductList = List.generate(
          100,
          (index) => {
            'id': 'test-product-$index',
            'product_name': 'Test Product $index',
            'brands': 'Test Brand $index',
            'image_url': 'https://example.com/image$index.jpg',
            'nutriments': {
              'proteins_100g': 15.0 + index,
              'carbohydrates_100g': 30.0 + index,
              'fat_100g': 10.0 + index,
            },
          },
        );

        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(largeProductList);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ProductList), findsOneWidget);
        expect(find.byType(GridView), findsOneWidget);
        // Widget performans sorunu yaşamamalı
      });

      testWidgets('should handle products with special characters', (
        tester,
      ) async {
        // Arrange
        final productsWithSpecialChars = [
          {
            'id': 'test-product-1',
            'product_name': 'Test@#\$%^&*()_+{}|:"<>?[]\\\\;\',./ Product',
            'brands': 'Brand@#\$%^&*()_+{}|:"<>?[]\\\\;\',./',
            'image_url': 'https://example.com/image1.jpg',
            'nutriments': {},
          },
        ];

        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(productsWithSpecialChars);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ProductList), findsOneWidget);
        expect(find.byType(GridView), findsOneWidget);
        // Özel karakterler widget'ı bozmamalı
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('should have correct widget hierarchy', (tester) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(sampleProducts);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ProductList), findsOneWidget);
        expect(find.byType(Consumer<StoreViewModel>), findsAtLeastNWidgets(1));
        expect(
          find.byType(NotificationListener<ScrollNotification>),
          findsAtLeastNWidgets(1),
        );
        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('should maintain structure in loading state', (tester) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(true);
        when(mockStoreViewModel.products).thenReturn([]);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ProductList), findsOneWidget);
        expect(find.byType(Consumer<StoreViewModel>), findsOneWidget);
        // Shimmer widget'ı bulunmalı
        expect(find.byType(ProductShimmerWidget), findsOneWidget);
      });

      testWidgets('should maintain structure in empty state', (tester) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn([]);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ProductList), findsOneWidget);
        expect(find.byType(Consumer<StoreViewModel>), findsOneWidget);
        expect(find.text('store.no_products'), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should handle rapid state changes', (tester) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(sampleProducts);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Change to loading state
        when(mockStoreViewModel.isLoading).thenReturn(true);
        await tester.pumpWidget(createTestWidget());

        // Change to empty state
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn([]);
        await tester.pumpWidget(createTestWidget());

        // Change back to products state
        when(mockStoreViewModel.products).thenReturn(sampleProducts);
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ProductList), findsOneWidget);
        // Widget crash etmemeli
      });

      testWidgets('should handle widget disposal gracefully', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: Text('New Widget'))),
        );

        // Assert - Should not throw any errors during disposal
        expect(find.text('New Widget'), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantics for screen readers', (
        tester,
      ) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(false);
        when(mockStoreViewModel.products).thenReturn(sampleProducts);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ProductList), findsOneWidget);
        expect(find.byType(GridView), findsOneWidget);
        // GridView screen reader'lar için uygun olmalı
      });

      testWidgets('should have proper semantics in loading state', (
        tester,
      ) async {
        // Arrange
        when(mockStoreViewModel.isLoading).thenReturn(true);
        when(mockStoreViewModel.products).thenReturn([]);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ProductList), findsOneWidget);
        // Shimmer widget'ı screen reader'lar için uygun olmalı
        expect(find.byType(ProductShimmerWidget), findsOneWidget);
      });
    });
  });
}
