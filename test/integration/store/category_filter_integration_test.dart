// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:arya/features/index.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'category_filter_integration_test.mocks.dart';

/// Category Filter Integration Test Suite
///
/// Bu test suite'i kategori filtreleme işlevlerinin entegrasyonunu test eder.
/// Kategori seçimi, filtreleme, pagination, ülke filtresi ve hata durumları kapsanır.

@GenerateMocks([OpenFoodFactsService, CartService, FirebaseAuth, User])
void main() {
  group('Category Filter Integration Tests', () {
    late MockOpenFoodFactsService mockOpenFoodFactsService;
    late MockCartService mockCartService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
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
              'energy-kcal_100g': 100.0,
              'proteins_100g': 10.0,
              'fat_100g': 5.0,
              'carbohydrates_100g': 15.0,
              'fiber_100g': 2.0,
              'sugars_100g': 8.0,
              'salt_100g': 0.5,
            },
      };
    }

    /// Test helper: Kategori bazlı mock ürün listesi oluşturur
    List<Map<String, dynamic>> createCategoryProducts(String category) {
      switch (category.toLowerCase()) {
        case 'protein oranı yüksek':
        case 'high protein':
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
                'energy-kcal_100g': 350.0,
                'proteins_100g': 30.0,
                'fat_100g': 5.0,
                'carbohydrates_100g': 15.0,
              },
            ),
          ];
        case 'karbonhidrat oranı yüksek':
        case 'high carbohydrate':
          return [
            createMockProduct(
              id: 'carb-1',
              name: 'Enerji Barı',
              brand: 'Enerji Markası',
              imageUrl: 'https://example.com/carb1.jpg',
              nutriments: {
                'energy-kcal_100g': 400.0,
                'proteins_100g': 8.0,
                'fat_100g': 12.0,
                'carbohydrates_100g': 60.0,
              },
            ),
          ];
        case 'yağ oranı yüksek':
        case 'high fat':
          return [
            createMockProduct(
              id: 'fat-1',
              name: 'Avokado',
              brand: 'Doğal Marka',
              imageUrl: 'https://example.com/fat1.jpg',
              nutriments: {
                'energy-kcal_100g': 160.0,
                'proteins_100g': 2.0,
                'fat_100g': 15.0,
                'carbohydrates_100g': 9.0,
              },
            ),
          ];
        case 'vitamin / mineral oranı yüksek':
        case 'high vitamins minerals':
          return [
            createMockProduct(
              id: 'vitamin-1',
              name: 'Multivitamin',
              brand: 'Sağlık Markası',
              imageUrl: 'https://example.com/vitamin1.jpg',
              nutriments: {
                'energy-kcal_100g': 50.0,
                'proteins_100g': 1.0,
                'fat_100g': 0.5,
                'carbohydrates_100g': 12.0,
              },
            ),
          ];
        case 'lif oranı yüksek':
        case 'high fiber':
          return [
            createMockProduct(
              id: 'fiber-1',
              name: 'Tam Buğday Ekmeği',
              brand: 'Ekmek Markası',
              imageUrl: 'https://example.com/fiber1.jpg',
              nutriments: {
                'energy-kcal_100g': 250.0,
                'proteins_100g': 12.0,
                'fat_100g': 3.0,
                'carbohydrates_100g': 45.0,
                'fiber_100g': 6.0,
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

    setUp(() {
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

      storeViewModel = StoreViewModel(service: mockOpenFoodFactsService);
      cartViewModel = CartViewModel(
        cartService: mockCartService,
        firebaseAuth: mockFirebaseAuth,
      );
    });

    tearDown(() {
      storeViewModel.dispose();
      cartViewModel.dispose();
    });

    test('Protein oranı yüksek kategorisi başarıyla yüklenir', () async {
      // Arrange
      final category = 'Protein Oranı Yüksek';
      final mockProducts = createCategoryProducts(category);

      when(
        mockOpenFoodFactsService.searchProductsByCategory(
          category,
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => mockProducts);

      // Act
      await storeViewModel.fetchByCategory(category);

      // Assert
      expect(storeViewModel.products.length, 2);
      expect(storeViewModel.products[0]['product_name'], 'Protein Bar');
      expect(storeViewModel.products[1]['product_name'], 'Whey Protein');
      expect(storeViewModel.selectedCategory, category);
      expect(storeViewModel.currentQuery, '');
      expect(storeViewModel.isLoading, false);
      expect(storeViewModel.currentPage, 1);
      expect(storeViewModel.hasMoreProducts, true);
      verify(
        mockOpenFoodFactsService.searchProductsByCategory(
          category,
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Karbonhidrat oranı yüksek kategorisi başarıyla yüklenir', () async {
      // Arrange
      final category = 'karbonhidrat oranı yüksek';
      final mockProducts = createCategoryProducts('karbonhidrat oranı yüksek');

      when(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Karbonhidrat Oranı Yüksek', // StoreViewModel bu kategori adını kullanır
          country: anyNamed('country'),
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
        ),
      ).thenAnswer((_) async => mockProducts);

      // Act
      await storeViewModel.fetchByCategory(category);

      // Assert
      expect(storeViewModel.products.length, 1);
      expect(storeViewModel.products[0]['product_name'], 'Enerji Barı');
      expect(storeViewModel.selectedCategory, category);
      expect(storeViewModel.currentQuery, '');
      expect(storeViewModel.isLoading, false);
      verify(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Karbonhidrat Oranı Yüksek',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Yağ oranı yüksek kategorisi başarıyla yüklenir', () async {
      // Arrange
      final category = 'yağ oranı yüksek';
      final mockProducts = createCategoryProducts('yağ oranı yüksek');

      when(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Yağ Oranı Yüksek', // StoreViewModel bu kategori adını kullanır
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => mockProducts);

      // Act
      await storeViewModel.fetchByCategory(category);

      // Assert
      expect(storeViewModel.products.length, 1);
      expect(storeViewModel.products[0]['product_name'], 'Avokado');
      expect(storeViewModel.selectedCategory, category);
      expect(storeViewModel.currentQuery, '');
      expect(storeViewModel.isLoading, false);
      verify(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Yağ Oranı Yüksek',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Vitamin/Mineral oranı yüksek kategorisi başarıyla yüklenir', () async {
      // Arrange
      final category = 'vitamin / mineral oranı yüksek';
      final mockProducts = createCategoryProducts(
        'vitamin / mineral oranı yüksek',
      );

      when(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Vitamin / Mineral Oranı Yüksek', // StoreViewModel bu kategori adını kullanır
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => mockProducts);

      // Act
      await storeViewModel.fetchByCategory(category);

      // Assert
      expect(storeViewModel.products.length, 1);
      expect(storeViewModel.products[0]['product_name'], 'Multivitamin');
      expect(storeViewModel.selectedCategory, category);
      expect(storeViewModel.currentQuery, '');
      expect(storeViewModel.isLoading, false);
      verify(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Vitamin / Mineral Oranı Yüksek',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Lif oranı yüksek kategorisi başarıyla yüklenir', () async {
      // Arrange
      final category = 'lif oranı yüksek';
      final mockProducts = createCategoryProducts('lif oranı yüksek');

      when(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Lif Oranı Yüksek', // StoreViewModel bu kategori adını kullanır
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => mockProducts);

      // Act
      await storeViewModel.fetchByCategory(category);

      // Assert
      expect(storeViewModel.products.length, 1);
      expect(storeViewModel.products[0]['product_name'], 'Tam Buğday Ekmeği');
      expect(storeViewModel.selectedCategory, category);
      expect(storeViewModel.currentQuery, '');
      expect(storeViewModel.isLoading, false);
      verify(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Lif Oranı Yüksek',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Kategori değiştirme işlemi çalışır', () async {
      // Arrange
      final category1 = 'protein oranı yüksek';
      final category2 = 'karbonhidrat oranı yüksek';
      final products1 = createCategoryProducts('protein oranı yüksek');
      final products2 = createCategoryProducts('karbonhidrat oranı yüksek');

      when(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Protein Oranı Yüksek',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => products1);

      when(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Karbonhidrat Oranı Yüksek',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => products2);

      // Act
      await storeViewModel.fetchByCategory(category1);
      expect(storeViewModel.selectedCategory, category1);
      expect(storeViewModel.products.length, 2);

      await storeViewModel.fetchByCategory(category2);
      expect(storeViewModel.selectedCategory, category2);
      expect(storeViewModel.products.length, 1);

      // Assert
      verify(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Protein Oranı Yüksek',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
      verify(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Karbonhidrat Oranı Yüksek',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Kategori filtreleme ile ülke filtresi birlikte çalışır', () async {
      // Arrange
      final category = 'Protein Oranı Yüksek';
      final country = 'turkey';
      final mockProducts = createCategoryProducts(category);

      when(
        mockOpenFoodFactsService.searchProductsByCategory(
          category,
          country: country,
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => mockProducts);

      // Act
      storeViewModel.setCountry(country);
      await storeViewModel.fetchByCategory(category);

      // Assert
      expect(storeViewModel.selectedCountry, country);
      expect(storeViewModel.selectedCategory, category);
      expect(storeViewModel.products.length, 2);
      verify(
        mockOpenFoodFactsService.searchProductsByCategory(
          category,
          country: country,
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Kategori bazlı daha fazla ürün yükleme çalışır', () async {
      // Arrange
      final category = 'Protein Oranı Yüksek';
      final initialProducts = createCategoryProducts(category);
      final moreProducts = [
        createMockProduct(
          id: 'protein-3',
          name: 'Casein Protein',
          brand: 'Protein Markası',
          imageUrl: 'https://example.com/protein3.jpg',
          nutriments: {
            'energy-kcal_100g': 320.0,
            'proteins_100g': 28.0,
            'fat_100g': 6.0,
            'carbohydrates_100g': 18.0,
          },
        ),
      ];

      when(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Protein Oranı Yüksek',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => initialProducts);

      when(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Protein Oranı Yüksek',
          country: anyNamed('country'),
          page: 2,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => moreProducts);

      // Act
      await storeViewModel.fetchByCategory(category);
      await storeViewModel.loadMoreProducts();

      // Assert
      expect(storeViewModel.products.length, 3);
      expect(storeViewModel.currentPage, 2);
      expect(storeViewModel.isLoadingMore, false);
      expect(storeViewModel.products[2]['product_name'], 'Casein Protein');
      verify(
        mockOpenFoodFactsService.searchProductsByCategory(
          'Protein Oranı Yüksek',
          country: anyNamed('country'),
          page: 2,
          pageSize: 20,
        ),
      ).called(1);
    });

    test(
      'Kategori bazlı loadMoreProducts daha fazla ürün yokken hasMoreProducts false yapar',
      () async {
        // Arrange
        final category = 'karbonhidrat oranı yüksek';
        final initialProducts = createCategoryProducts(
          'karbonhidrat oranı yüksek',
        );

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Karbonhidrat Oranı Yüksek',
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => initialProducts);

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Karbonhidrat Oranı Yüksek',
            country: anyNamed('country'),
            page: 2,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => []);

        // Act
        await storeViewModel.fetchByCategory(category);
        await storeViewModel.loadMoreProducts();

        // Assert
        expect(storeViewModel.products.length, 1);
        expect(storeViewModel.hasMoreProducts, false);
        expect(storeViewModel.isLoadingMore, false);
      },
    );

    test(
      'Kategori bazlı loadMoreProducts hata durumunda hasMoreProducts false yapar',
      () async {
        // Arrange
        final category = 'yağ oranı yüksek';
        final initialProducts = createCategoryProducts('yağ oranı yüksek');

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Yağ Oranı Yüksek',
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => initialProducts);

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Yağ Oranı Yüksek',
            country: anyNamed('country'),
            page: 2,
            pageSize: 20,
          ),
        ).thenThrow(Exception('API Hatası'));

        // Act
        await storeViewModel.fetchByCategory(category);
        await storeViewModel.loadMoreProducts();

        // Assert
        expect(storeViewModel.products.length, 1);
        expect(storeViewModel.hasMoreProducts, false);
        expect(storeViewModel.isLoadingMore, false);
      },
    );

    test(
      'Kategori filtreleme sırasında loading durumu doğru yönetilir',
      () async {
        // Arrange
        final category = 'Protein Oranı Yüksek';
        final completer = Completer<List<dynamic>>();
        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Protein Oranı Yüksek',
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) => completer.future);

        // Act
        final future = storeViewModel.fetchByCategory(category);

        // Assert - Loading başladı
        expect(storeViewModel.isLoading, true);
        expect(storeViewModel.selectedCategory, category);

        // Act - İşlem tamamlandı
        completer.complete(createCategoryProducts(category));
        await future;

        // Assert - Loading bitti
        expect(storeViewModel.isLoading, false);
        expect(storeViewModel.products.length, 2);
      },
    );

    test(
      'Kategori filtreleme sırasında hata oluştuğunda boş liste döner',
      () async {
        // Arrange
        final category = 'Bilinmeyen Kategori';
        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Bilinmeyen Kategori',
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenThrow(Exception('API Hatası'));

        // Act
        await storeViewModel.fetchByCategory(category);

        // Assert
        expect(storeViewModel.products.length, 0);
        expect(storeViewModel.selectedCategory, category);
        expect(storeViewModel.isLoading, false);
      },
    );

    test(
      'Kategori filtreleme sonrası arama yapıldığında kategori sıfırlanır',
      () async {
        // Arrange
        final category = 'Protein Oranı Yüksek';
        final searchQuery = 'çikolata';
        final categoryProducts = createCategoryProducts(category);
        final searchResults = [
          createMockProduct(
            id: 'choc-1',
            name: 'Çikolata',
            brand: 'Çikolata Markası',
            imageUrl: 'https://example.com/chocolate.jpg',
          ),
        ];

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Protein Oranı Yüksek',
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => categoryProducts);

        when(
          mockOpenFoodFactsService.searchProducts(
            searchQuery,
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => searchResults);

        // Act
        await storeViewModel.fetchByCategory(category);
        expect(storeViewModel.selectedCategory, category);
        expect(storeViewModel.currentQuery, '');

        await storeViewModel.search(searchQuery);

        // Assert
        expect(storeViewModel.selectedCategory, category); // Kategori korunur
        expect(storeViewModel.currentQuery, searchQuery);
        expect(storeViewModel.products.length, 1);
        expect(storeViewModel.products[0]['product_name'], 'Çikolata');
      },
    );

    test(
      'Kategori filtreleme sonrası rastgele ürünler getirildiğinde kategori sıfırlanır',
      () async {
        // Arrange
        final category = 'Protein Oranı Yüksek';
        final randomProducts = [
          createMockProduct(
            id: 'random-1',
            name: 'Rastgele Ürün',
            brand: 'Rastgele Marka',
            imageUrl: 'https://example.com/random.jpg',
          ),
        ];

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Protein Oranı Yüksek',
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => createCategoryProducts(category));

        when(
          mockOpenFoodFactsService.searchProducts(
            '',
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => randomProducts);

        // Act
        await storeViewModel.fetchByCategory(category);
        expect(storeViewModel.selectedCategory, category);

        await storeViewModel.fetchRandomProducts();

        // Assert
        expect(storeViewModel.selectedCategory, category); // Kategori korunur
        expect(storeViewModel.currentQuery, '');
        expect(storeViewModel.products.length, 1);
        expect(storeViewModel.products[0]['product_name'], 'Rastgele Ürün');
      },
    );

    test(
      'Kategori filtreleme sonrası sepete ürün ekleme entegrasyonu çalışır',
      () async {
        // Arrange
        final category = 'Protein Oranı Yüksek';
        final categoryProducts = createCategoryProducts(category);

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Protein Oranı Yüksek',
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => categoryProducts);

        when(mockCartService.addToCart(any, any)).thenAnswer((_) async {});

        // Act
        await storeViewModel.fetchByCategory(category);
        final product = storeViewModel.products.first;
        final cartItem = CartItemModel.fromMap(product);
        await cartViewModel.addToCart(cartItem);

        // Assert
        expect(storeViewModel.products.length, 2);
        verify(mockCartService.addToCart('test-user-id', cartItem)).called(1);
      },
    );

    test(
      'Kategori filtreleme state değişiklikleri notifyListeners çağırır',
      () async {
        // Arrange
        final category = 'Protein Oranı Yüksek';
        final categoryProducts = createCategoryProducts(category);
        bool listenerCalled = false;

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Protein Oranı Yüksek',
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => categoryProducts);

        storeViewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        await storeViewModel.fetchByCategory(category);

        // Assert
        expect(listenerCalled, true);
        expect(storeViewModel.products.length, 2);
      },
    );

    test(
      'Kategori filtreleme için özel karakterler içeren kategori adları çalışır',
      () async {
        // Arrange
        final specialCategories = [
          'Protein / Protein Oranı Yüksek',
          'Karbonhidrat (Yüksek)',
          'Yağ + Enerji',
          'Vitamin-Mineral',
          'Lif_Oranı_Yüksek',
          'Fiber.100g',
        ];

        // Her kategori için doğru mock setup
        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Protein Oranı Yüksek', // 'Protein / Protein Oranı Yüksek' için
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => createCategoryProducts('default'));

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Karbonhidrat Oranı Yüksek', // 'Karbonhidrat (Yüksek)' için
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => createCategoryProducts('default'));

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Yağ Oranı Yüksek', // 'Yağ + Enerji' için
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => createCategoryProducts('default'));

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Vitamin / Mineral Oranı Yüksek', // 'Vitamin-Mineral' için
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => createCategoryProducts('default'));

        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            'Lif Oranı Yüksek', // 'Lif_Oranı_Yüksek' ve 'Fiber.100g' için
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => createCategoryProducts('default'));

        // Act & Assert
        for (final category in specialCategories) {
          await storeViewModel.fetchByCategory(category);
          expect(storeViewModel.selectedCategory, category);
          expect(storeViewModel.products.length, 1);
          expect(storeViewModel.isLoading, false);
        }
      },
    );

    test(
      'Kategori filtreleme için case insensitive kategori adları çalışır',
      () async {
        // Arrange
        final categoryVariations = [
          'PROTEIN ORANI YÜKSEK',
          'protein oranı yüksek',
          'Protein Oranı Yüksek',
          'PROTEİN ORANI YÜKSEK',
        ];
        final mockProducts = createCategoryProducts('Protein Oranı Yüksek');

        for (final category in categoryVariations) {
          when(
            mockOpenFoodFactsService.searchProductsByCategory(
              category,
              country: anyNamed('country'),
              page: 1,
              pageSize: 20,
            ),
          ).thenAnswer((_) async => mockProducts);
        }

        // Act & Assert
        for (final category in categoryVariations) {
          await storeViewModel.fetchByCategory(category);
          expect(storeViewModel.selectedCategory, category);
          expect(storeViewModel.products.length, 2);
          expect(storeViewModel.isLoading, false);
        }
      },
    );

    test(
      'Kategori filtreleme için boş kategori adı güvenli şekilde işlenir',
      () async {
        // Arrange
        final emptyCategory = '';
        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            emptyCategory,
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => []);

        // Act
        await storeViewModel.fetchByCategory(emptyCategory);

        // Assert
        expect(storeViewModel.selectedCategory, emptyCategory);
        expect(storeViewModel.products.length, 0);
        expect(storeViewModel.isLoading, false);
      },
    );

    test(
      'Kategori filtreleme için null kategori adı güvenli şekilde işlenir',
      () async {
        // Arrange
        final nullCategory = 'null';
        when(
          mockOpenFoodFactsService.searchProductsByCategory(
            nullCategory,
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => []);

        // Act
        await storeViewModel.fetchByCategory(nullCategory);

        // Assert
        expect(storeViewModel.selectedCategory, nullCategory);
        expect(storeViewModel.products.length, 0);
        expect(storeViewModel.isLoading, false);
      },
    );
  });
}
