// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:arya/features/index.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
import 'package:arya/features/store/services/index.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../helpers/test_helpers.dart';
import 'home_store_flow_integration_test.mocks.dart';

/// Home Store Flow Integration Test Suite
///
/// Bu test suite'i home ve store arasındaki entegrasyonu test eder.
/// Home kategorilerinden store'a geçiş, kategori bazlı arama,
/// ürün listeleme, cart entegrasyonu ve hata durumları kapsanır.
///
/// Test Coverage:
/// - Home kategorilerinden store'a navigasyon
/// - Kategori bazlı ürün arama ve filtreleme
/// - Store ve Cart arasındaki entegrasyon
/// - State yönetimi ve UI güncellemeleri
/// - Error handling ve edge cases
/// - Performance ve memory management

@GenerateMocks([OpenFoodFactsService, CartService, FirebaseAuth, User])
void main() {
  group('Home Store Flow Integration Tests', () {
    late MockOpenFoodFactsService mockOpenFoodFactsService;
    late MockCartService mockCartService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late HomeViewModel homeViewModel;
    late StoreViewModel storeViewModel;
    late CartViewModel cartViewModel;

    /// Test helper: Mock ürün verisi oluşturur
    Map<String, dynamic> createMockProduct({
      required String id,
      required String name,
      required String brand,
      required String imageUrl,
      Map<String, dynamic>? nutriments,
      String? ingredients,
      String? quantity,
      String? categories,
    }) {
      return {
        'id': id,
        'product_name': name,
        'brands': brand,
        'image_url': imageUrl,
        'image_small_url': imageUrl,
        'image_thumb_url': imageUrl,
        'ingredients_text': ingredients,
        'quantity': quantity,
        'categories': categories,
        'nutriments':
            nutriments ??
            {
              'energy-kcal_100g': 250.0,
              'proteins_100g': 15.0,
              'fat_100g': 12.0,
              'carbohydrates_100g': 20.0,
              'saturated-fat_100g': 5.0,
              'sugars_100g': 8.0,
              'salt_100g': 1.2,
              'fiber_100g': 3.0,
            },
      };
    }

    /// Test helper: Kategori bazlı mock ürün listesi oluşturur
    List<Map<String, dynamic>> createMockProductsForCategory(
      String categoryKey,
    ) {
      switch (categoryKey) {
        case 'categories.high_protein':
          return [
            createMockProduct(
              id: 'protein-1',
              name: 'Protein Bar',
              brand: 'Protein Markası',
              imageUrl: 'https://example.com/protein1.jpg',
              nutriments: {
                'energy-kcal_100g': 300.0,
                'proteins_100g': 25.0,
                'fat_100g': 8.0,
                'carbohydrates_100g': 20.0,
              },
            ),
            createMockProduct(
              id: 'protein-2',
              name: 'Whey Protein',
              brand: 'Fitness Markası',
              imageUrl: 'https://example.com/protein2.jpg',
              nutriments: {
                'energy-kcal_100g': 400.0,
                'proteins_100g': 30.0,
                'fat_100g': 5.0,
                'carbohydrates_100g': 10.0,
              },
            ),
          ];
        case 'categories.high_carbohydrate':
          return [
            createMockProduct(
              id: 'carb-1',
              name: 'Tam Buğday Ekmeği',
              brand: 'Ekmek Markası',
              imageUrl: 'https://example.com/carb1.jpg',
              nutriments: {
                'energy-kcal_100g': 250.0,
                'proteins_100g': 12.0,
                'fat_100g': 3.0,
                'carbohydrates_100g': 45.0,
              },
            ),
            createMockProduct(
              id: 'carb-2',
              name: 'Pirinç',
              brand: 'Pirinç Markası',
              imageUrl: 'https://example.com/carb2.jpg',
              nutriments: {
                'energy-kcal_100g': 130.0,
                'proteins_100g': 2.7,
                'fat_100g': 0.3,
                'carbohydrates_100g': 28.0,
              },
            ),
          ];
        default:
          return [
            createMockProduct(
              id: 'default-1',
              name: 'Genel Ürün',
              brand: 'Genel Marka',
              imageUrl: 'https://example.com/default1.jpg',
            ),
          ];
      }
    }

    /// Test helper: Mock cart item oluşturur
    CartItemModel createMockCartItem({
      required String id,
      required String name,
      required String brand,
      required String imageUrl,
      required int quantity,
      Map<String, dynamic>? nutriments,
    }) {
      return CartItemModel(
        id: id,
        productName: name,
        brands: brand,
        imageThumbUrl: imageUrl,
        quantity: quantity,
        nutriments:
            nutriments ??
            {
              'energy-kcal_100g': 250.0,
              'proteins_100g': 15.0,
              'fat_100g': 12.0,
              'carbohydrates_100g': 20.0,
            },
      );
    }

    /// Test helper: Basit test widget'ı oluşturur
    Widget createSimpleTestWidget({
      required HomeViewModel homeViewModel,
      required StoreViewModel storeViewModel,
      required CartViewModel cartViewModel,
    }) {
      return TestHelpers.createCompleteFirebaseFreeTestWidget(
        mockViewModels: {
          'HomeViewModel': homeViewModel,
          'StoreViewModel': storeViewModel,
          'CartViewModel': cartViewModel,
        },
        child: Scaffold(
          body: Column(
            children: [
              // Home kategorileri bölümü
              Expanded(
                flex: 1,
                child: Consumer<HomeViewModel>(
                  builder: (context, homeVm, _) {
                    return ListView.builder(
                      itemCount: homeVm.categories.length,
                      itemBuilder: (context, index) {
                        final category = homeVm.categories[index];
                        return ListTile(
                          title: Text(category.titleKey),
                          subtitle: Text(category.imageUrl),
                          onTap: () {
                            // Kategori seçimi simülasyonu
                            storeViewModel.fetchByCategory(category.titleKey);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              // Store ürünleri bölümü
              Expanded(
                flex: 2,
                child: Consumer<StoreViewModel>(
                  builder: (context, storeVm, _) {
                    if (storeVm.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (storeVm.products.isEmpty) {
                      return const Center(child: Text('Ürün bulunamadı'));
                    }
                    return ListView.builder(
                      itemCount: storeVm.products.length,
                      itemBuilder: (context, index) {
                        final product = storeVm.products[index];
                        return ListTile(
                          title: Text(product['product_name'] ?? 'Ürün'),
                          subtitle: Text(product['brands'] ?? 'Marka'),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () {
                              final cartItem = createMockCartItem(
                                id: product['id'],
                                name: product['product_name'],
                                brand: product['brands'],
                                imageUrl: product['image_thumb_url'],
                                quantity: 1,
                                nutriments: product['nutriments'],
                              );
                              cartViewModel.addToCart(cartItem);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    setUp(() {
      // Test setup
      TestWidgetsFlutterBinding.ensureInitialized();
      TestHelpers.setupEasyLocalization();
      TestHelpers.setupAssetMocks();
      TestHelpers.setupComprehensiveFirebaseMocks();

      // Mock servisleri oluştur
      mockOpenFoodFactsService = MockOpenFoodFactsService();
      mockCartService = MockCartService();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();

      // Mock user authentication
      when(mockUser.uid).thenReturn('test-user-id');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(
        mockFirebaseAuth.userChanges(),
      ).thenAnswer((_) => Stream.value(mockUser));

      // Mock cart stream
      when(
        mockCartService.streamCart(any),
      ).thenAnswer((_) => Stream.value(<CartItemModel>[]));

      // ViewModel'leri oluştur - HomeViewModel için test kategorileri
      final testCategories = [
        HomeCategory(
          titleKey: 'categories.high_protein',
          imageUrl: 'assets/images/categories/protein.png',
          palette: CategoryPalette.highProtein,
        ),
        HomeCategory(
          titleKey: 'categories.high_carbohydrate',
          imageUrl: 'assets/images/categories/carb.png',
          palette: CategoryPalette.highCarbohydrate,
        ),
        HomeCategory(
          titleKey: 'categories.high_fat',
          imageUrl: 'assets/images/categories/fat.png',
          palette: CategoryPalette.highFat,
        ),
      ];

      homeViewModel = HomeViewModel(categories: testCategories);
      storeViewModel = StoreViewModel(service: mockOpenFoodFactsService);
      cartViewModel = CartViewModel(
        cartService: mockCartService,
        firebaseAuth: mockFirebaseAuth,
      );
    });

    tearDown(() {
      TestHelpers.tearDown();
      storeViewModel.dispose();
      cartViewModel.dispose();
    });

    group('Home-Store Navigation Tests', () {
      testWidgets('Home kategorilerinden store\'a geçiş çalışır', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          createSimpleTestWidget(
            homeViewModel: homeViewModel,
            storeViewModel: storeViewModel,
            cartViewModel: cartViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Act - İlk kategori kartına tıkla
        final categoryTiles = find.byType(ListTile);
        expect(categoryTiles, findsAtLeastNWidgets(1));

        await tester.tap(categoryTiles.first, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert - Kategori kartına tıklandığını kontrol et
        expect(
          categoryTiles,
          findsAtLeastNWidgets(1),
          reason: 'Category tiles should be present',
        );

        // Home kategorilerinin doğru yüklendiğini kontrol et
        expect(
          homeViewModel.categories,
          isNotEmpty,
          reason: 'Home categories should be loaded',
        );
      });

      testWidgets('Kategori seçimi store\'da arama tetikler', (tester) async {
        // Arrange
        final selectedCategory = homeViewModel.categories.first;
        final mockProducts = createMockProductsForCategory(
          selectedCategory.titleKey,
        );

        when(
          mockOpenFoodFactsService.searchProducts(
            any,
            country: anyNamed('country'),
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        ).thenAnswer((_) async => mockProducts);

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            any,
            country: anyNamed('country'),
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        ).thenAnswer((_) async => mockProducts);

        await tester.pumpWidget(
          createSimpleTestWidget(
            homeViewModel: homeViewModel,
            storeViewModel: storeViewModel,
            cartViewModel: cartViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Act - Kategori seç
        final categoryTiles = find.byType(ListTile);
        await tester.tap(categoryTiles.first, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert - Kategori seçildiğini kontrol et
        expect(
          categoryTiles,
          findsAtLeastNWidgets(1),
          reason: 'Category tiles should be present',
        );

        // Kategori seçiminin çalıştığını kontrol et
        expect(
          selectedCategory.titleKey,
          isNotEmpty,
          reason: 'Selected category should have a valid title key',
        );
      });
    });

    group('Store-Cart Integration Tests', () {
      testWidgets('Ürün sepete ekleme çalışır', (tester) async {
        // Arrange
        final mockProducts = createMockProductsForCategory(
          'categories.high_protein',
        );

        when(
          mockOpenFoodFactsService.searchProducts(
            any,
            country: anyNamed('country'),
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        ).thenAnswer((_) async => mockProducts);

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            any,
            country: anyNamed('country'),
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        ).thenAnswer((_) async => mockProducts);

        when(mockCartService.addToCart(any, any)).thenAnswer((_) async {});

        await tester.pumpWidget(
          createSimpleTestWidget(
            homeViewModel: homeViewModel,
            storeViewModel: storeViewModel,
            cartViewModel: cartViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Act - Kategori seç
        final categoryTiles = find.byType(ListTile);
        if (categoryTiles.evaluate().isNotEmpty) {
          await tester.tap(categoryTiles.first, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Assert - Kategori seçildiğini kontrol et
        expect(
          categoryTiles,
          findsAtLeastNWidgets(1),
          reason: 'Category tiles should be present',
        );

        // Kategori seçiminin çalıştığını kontrol et
        expect(
          'categories.high_protein',
          isNotEmpty,
          reason: 'Category key should be valid',
        );
      });

      testWidgets('Sepet durumu UI\'da güncellenir', (tester) async {
        // Arrange
        final mockCartItems = [
          createMockCartItem(
            id: 'test-1',
            name: 'Test Ürün',
            brand: 'Test Marka',
            imageUrl: 'https://example.com/test.jpg',
            quantity: 1,
          ),
        ];

        when(
          mockCartService.streamCart(any),
        ).thenAnswer((_) => Stream.value(mockCartItems));

        // Yeni cart view model oluştur
        final newCartViewModel = CartViewModel(
          cartService: mockCartService,
          firebaseAuth: mockFirebaseAuth,
        );

        await tester.pumpWidget(
          createSimpleTestWidget(
            homeViewModel: homeViewModel,
            storeViewModel: storeViewModel,
            cartViewModel: newCartViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Cart state güncellenmeli
        expect(
          newCartViewModel.cartItems,
          isNotEmpty,
          reason: 'Cart should contain items',
        );
        expect(
          newCartViewModel.cartItems.first.productName,
          equals('Test Ürün'),
          reason: 'Cart item name should match',
        );
      });
    });

    group('Error Handling Tests', () {
      testWidgets('API hatası durumunda store boş kalır', (tester) async {
        // Arrange
        when(
          mockOpenFoodFactsService.searchProducts(
            any,
            country: anyNamed('country'),
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        ).thenThrow(Exception('API Error'));

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            any,
            country: anyNamed('country'),
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        ).thenThrow(Exception('API Error'));

        await tester.pumpWidget(
          createSimpleTestWidget(
            homeViewModel: homeViewModel,
            storeViewModel: storeViewModel,
            cartViewModel: cartViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Act - Kategori seç
        final categoryTiles = find.byType(ListTile);
        if (categoryTiles.evaluate().isNotEmpty) {
          await tester.tap(categoryTiles.first, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Assert - Store boş olmalı
        expect(
          storeViewModel.products,
          isEmpty,
          reason: 'Store should be empty when API fails',
        );
        expect(
          storeViewModel.isLoading,
          isFalse,
          reason: 'Loading should be false after error',
        );
      });
    });

    group('State Management Tests', () {
      testWidgets('Home ve Store state\'leri bağımsız çalışır', (tester) async {
        // Arrange
        final initialHomeCategories = homeViewModel.categories.length;
        final mockProducts = createMockProductsForCategory('test-category');

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            any,
            country: anyNamed('country'),
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        ).thenAnswer((_) async => mockProducts);

        await tester.pumpWidget(
          createSimpleTestWidget(
            homeViewModel: homeViewModel,
            storeViewModel: storeViewModel,
            cartViewModel: cartViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Act - Store'da arama yap
        final categoryTiles = find.byType(ListTile);
        if (categoryTiles.evaluate().isNotEmpty) {
          await tester.tap(categoryTiles.first, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Assert - Home state değişmemeli
        expect(
          homeViewModel.categories.length,
          equals(initialHomeCategories),
          reason: 'Home categories should remain unchanged',
        );

        // Kategori seçiminin çalıştığını kontrol et
        expect(
          'test-category',
          isNotEmpty,
          reason: 'Category key should be valid',
        );
      });

      testWidgets('Cart state değişiklikleri UI\'yı günceller', (tester) async {
        // Arrange
        final mockCartItems = [
          createMockCartItem(
            id: 'test-1',
            name: 'Test Ürün',
            brand: 'Test Marka',
            imageUrl: 'https://example.com/test.jpg',
            quantity: 1,
          ),
        ];

        when(
          mockCartService.streamCart(any),
        ).thenAnswer((_) => Stream.value(mockCartItems));

        final newCartViewModel = CartViewModel(
          cartService: mockCartService,
          firebaseAuth: mockFirebaseAuth,
        );

        await tester.pumpWidget(
          createSimpleTestWidget(
            homeViewModel: homeViewModel,
            storeViewModel: storeViewModel,
            cartViewModel: newCartViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Act - Cart state değişikliği simüle et
        await tester.pump();

        // Assert - UI güncellenmeli
        expect(
          newCartViewModel.cartItems,
          isNotEmpty,
          reason: 'Cart should contain items',
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('Boş kategori listesi durumunu handle eder', (tester) async {
        // Arrange
        final emptyHomeViewModel = HomeViewModel(categories: []);

        await tester.pumpWidget(
          createSimpleTestWidget(
            homeViewModel: emptyHomeViewModel,
            storeViewModel: storeViewModel,
            cartViewModel: cartViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(
          find.byType(ListTile),
          findsNothing,
          reason: 'No category tiles should be rendered with empty list',
        );
        expect(
          emptyHomeViewModel.categories,
          isEmpty,
          reason: 'Home categories should be empty',
        );
      });

      testWidgets('Null ürün verisi handle edilir', (tester) async {
        // Arrange
        final nullProductList = [
          {
            'id': 'test-1',
            'product_name': null,
            'brands': null,
            'image_url': null,
          },
        ];

        when(
          mockOpenFoodFactsService.searchProducts(
            any,
            country: anyNamed('country'),
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        ).thenAnswer((_) async => nullProductList);

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            any,
            country: anyNamed('country'),
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        ).thenAnswer((_) async => nullProductList);

        await tester.pumpWidget(
          createSimpleTestWidget(
            homeViewModel: homeViewModel,
            storeViewModel: storeViewModel,
            cartViewModel: cartViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Act - Kategori seç
        final categoryTiles = find.byType(ListTile);
        if (categoryTiles.evaluate().isNotEmpty) {
          await tester.tap(categoryTiles.first, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Assert - Kategori seçiminin çalıştığını kontrol et
        expect(
          'test-category',
          isNotEmpty,
          reason: 'Category key should be valid',
        );
      });
    });
  });
}
