// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:arya/features/index.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_flow_integration_test.mocks.dart';

/// Search Flow Integration Test Suite
///
/// Bu test suite'i store search işlevlerinin entegrasyonunu test eder.
/// Arama işlevselliği, filtreleme, sıralama, pagination ve hata durumları kapsanır.

@GenerateMocks([OpenFoodFactsService, CartService, FirebaseAuth, User])
void main() {
  group('Search Flow Integration Tests', () {
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

    /// Test helper: Mock ürün listesi oluşturur
    List<Map<String, dynamic>> createMockProductList(int count) {
      return List.generate(
        count,
        (index) => createMockProduct(
          id: '${index + 1}',
          name: 'Test Ürün ${index + 1}',
          brand: 'Test Marka ${index + 1}',
          imageUrl: 'https://example.com/image${index + 1}.jpg',
        ),
      );
    }

    /// Test helper: Arama sonuçları için mock ürünler oluşturur
    List<Map<String, dynamic>> createSearchResults(String query) {
      switch (query.toLowerCase()) {
        case 'çikolata':
          return [
            createMockProduct(
              id: 'choc-1',
              name: 'Bitter Çikolata',
              brand: 'Çikolata Markası',
              imageUrl: 'https://example.com/chocolate1.jpg',
              nutriments: {
                'energy-kcal_100g': 500.0,
                'proteins_100g': 5.0,
                'fat_100g': 30.0,
                'carbohydrates_100g': 60.0,
                'sugars_100g': 45.0,
              },
            ),
            createMockProduct(
              id: 'choc-2',
              name: 'Sütlü Çikolata',
              brand: 'Çikolata Markası',
              imageUrl: 'https://example.com/chocolate2.jpg',
              nutriments: {
                'energy-kcal_100g': 450.0,
                'proteins_100g': 7.0,
                'fat_100g': 25.0,
                'carbohydrates_100g': 55.0,
                'sugars_100g': 50.0,
              },
            ),
          ];
        case 'ekmek':
          return [
            createMockProduct(
              id: 'bread-1',
              name: 'Tam Buğday Ekmeği',
              brand: 'Ekmek Markası',
              imageUrl: 'https://example.com/bread1.jpg',
              nutriments: {
                'energy-kcal_100g': 250.0,
                'proteins_100g': 12.0,
                'fat_100g': 3.0,
                'carbohydrates_100g': 45.0,
                'fiber_100g': 6.0,
              },
            ),
          ];
        case 'protein':
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
          ];
        default:
          return createMockProductList(3);
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

    test('Basit arama sorgusu başarıyla çalışır', () async {
      // Arrange
      final searchQuery = 'çikolata';
      final mockSearchResults = createSearchResults(searchQuery);

      when(
        mockOpenFoodFactsService.searchProducts(
          searchQuery,
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => mockSearchResults);

      // Act
      await storeViewModel.search(searchQuery);

      // Assert
      expect(storeViewModel.products.length, 2);
      expect(storeViewModel.products[0]['product_name'], 'Bitter Çikolata');
      expect(storeViewModel.products[1]['product_name'], 'Sütlü Çikolata');
      expect(storeViewModel.currentQuery, searchQuery);
      expect(storeViewModel.isLoading, false);
      expect(storeViewModel.currentPage, 1);
      verify(
        mockOpenFoodFactsService.searchProducts(
          searchQuery,
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Boş arama sorgusu rastgele ürünleri getirir', () async {
      // Arrange
      final mockRandomProducts = createMockProductList(5);

      when(
        mockOpenFoodFactsService.searchProducts(
          '',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => mockRandomProducts);

      // Act
      await storeViewModel.search('');

      // Assert
      expect(storeViewModel.products.length, 5);
      expect(storeViewModel.currentQuery, '');
      expect(storeViewModel.isLoading, false);
      verify(
        mockOpenFoodFactsService.searchProducts(
          '',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test(
      'Sadece boşluk karakteri içeren arama rastgele ürünleri getirir',
      () async {
        // Arrange
        final mockRandomProducts = createMockProductList(3);

        when(
          mockOpenFoodFactsService.searchProducts(
            '',
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => mockRandomProducts);

        // Act
        await storeViewModel.search('   ');

        // Assert
        expect(storeViewModel.products.length, 3);
        expect(storeViewModel.currentQuery, '   ');
        expect(storeViewModel.isLoading, false);
        verify(
          mockOpenFoodFactsService.searchProducts(
            '',
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).called(1);
      },
    );

    test('Arama sonuçları bulunamadığında boş liste döner', () async {
      // Arrange
      when(
        mockOpenFoodFactsService.searchProducts(
          'bulunamayan-ürün',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => []);

      // Act
      await storeViewModel.search('bulunamayan-ürün');

      // Assert
      expect(storeViewModel.products.length, 0);
      expect(storeViewModel.currentQuery, 'bulunamayan-ürün');
      expect(storeViewModel.isLoading, false);
      verify(
        mockOpenFoodFactsService.searchProducts(
          'bulunamayan-ürün',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Arama sırasında loading durumu doğru yönetilir', () async {
      // Arrange
      final completer = Completer<List<dynamic>>();
      when(
        mockOpenFoodFactsService.searchProducts(
          any,
          country: anyNamed('country'),
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
        ),
      ).thenAnswer((_) => completer.future);

      // Act
      final future = storeViewModel.search('test');

      // Assert - Loading başladı
      expect(storeViewModel.isLoading, true);
      expect(storeViewModel.currentQuery, 'test');

      // Act - İşlem tamamlandı
      completer.complete([
        createMockProduct(
          id: 'test-1',
          name: 'Test Ürün',
          brand: 'Test Marka',
          imageUrl: 'https://example.com/test.jpg',
        ),
      ]);
      await future;

      // Assert - Loading bitti
      expect(storeViewModel.isLoading, false);
      expect(storeViewModel.products.length, 1);
    });

    test('Arama sırasında hata oluştuğunda boş liste döner', () async {
      // Arrange
      when(
        mockOpenFoodFactsService.searchProducts(
          any,
          country: anyNamed('country'),
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
        ),
      ).thenThrow(Exception('API Hatası'));

      // Act
      await storeViewModel.search('hata-test');

      // Assert
      expect(storeViewModel.products.length, 0);
      expect(storeViewModel.currentQuery, 'hata-test');
      expect(storeViewModel.isLoading, false);
    });

    test('Ülke filtresi ile arama çalışır', () async {
      // Arrange
      final searchQuery = 'ekmek';
      final country = 'turkey';
      final mockSearchResults = createSearchResults(searchQuery);

      when(
        mockOpenFoodFactsService.searchProducts(
          searchQuery,
          country: country,
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => mockSearchResults);

      // Act
      storeViewModel.setCountry(country);
      await storeViewModel.search(searchQuery);

      // Assert
      expect(storeViewModel.selectedCountry, country);
      expect(storeViewModel.products.length, 1);
      expect(storeViewModel.products[0]['product_name'], 'Tam Buğday Ekmeği');
      verify(
        mockOpenFoodFactsService.searchProducts(
          searchQuery,
          country: country,
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Arama sonuçları için daha fazla ürün yükleme çalışır', () async {
      // Arrange
      final searchQuery = 'çikolata';
      final initialResults = createSearchResults(searchQuery);
      final moreResults = [
        createMockProduct(
          id: 'choc-3',
          name: 'Beyaz Çikolata',
          brand: 'Çikolata Markası',
          imageUrl: 'https://example.com/chocolate3.jpg',
        ),
      ];

      when(
        mockOpenFoodFactsService.searchProducts(
          searchQuery,
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => initialResults);

      when(
        mockOpenFoodFactsService.searchProducts(
          searchQuery,
          country: anyNamed('country'),
          page: 2,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => moreResults);

      // Act
      await storeViewModel.search(searchQuery);
      await storeViewModel.loadMoreProducts();

      // Assert
      expect(storeViewModel.products.length, 3);
      expect(storeViewModel.currentPage, 2);
      expect(storeViewModel.isLoadingMore, false);
      expect(storeViewModel.products[2]['product_name'], 'Beyaz Çikolata');
      verify(
        mockOpenFoodFactsService.searchProducts(
          searchQuery,
          country: anyNamed('country'),
          page: 2,
          pageSize: 20,
        ),
      ).called(1);
    });

    test(
      'Daha fazla ürün yokken loadMoreProducts hasMoreProducts false yapar',
      () async {
        // Arrange
        final searchQuery = 'protein';
        final initialResults = createSearchResults(searchQuery);

        when(
          mockOpenFoodFactsService.searchProducts(
            searchQuery,
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => initialResults);

        when(
          mockOpenFoodFactsService.searchProducts(
            searchQuery,
            country: anyNamed('country'),
            page: 2,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => []);

        // Act
        await storeViewModel.search(searchQuery);
        await storeViewModel.loadMoreProducts();

        // Assert
        expect(storeViewModel.products.length, 1);
        expect(storeViewModel.hasMoreProducts, false);
        expect(storeViewModel.isLoadingMore, false);
      },
    );

    test(
      'Arama sonuçları için loadMoreProducts hata durumunda hasMoreProducts false yapar',
      () async {
        // Arrange
        final searchQuery = 'test';
        final initialResults = createMockProductList(2);

        when(
          mockOpenFoodFactsService.searchProducts(
            searchQuery,
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => initialResults);

        when(
          mockOpenFoodFactsService.searchProducts(
            searchQuery,
            country: anyNamed('country'),
            page: 2,
            pageSize: 20,
          ),
        ).thenThrow(Exception('API Hatası'));

        // Act
        await storeViewModel.search(searchQuery);
        await storeViewModel.loadMoreProducts();

        // Assert
        expect(storeViewModel.products.length, 2);
        expect(storeViewModel.hasMoreProducts, false);
        expect(storeViewModel.isLoadingMore, false);
      },
    );

    test(
      'Arama sonuçları için loadMoreProducts loading durumu doğru yönetilir',
      () async {
        // Arrange
        final searchQuery = 'test';
        final initialResults = createMockProductList(2);
        final moreResults = [
          createMockProduct(
            id: 'test-3',
            name: 'Test Ürün 3',
            brand: 'Test Marka 3',
            imageUrl: 'https://example.com/test3.jpg',
          ),
        ];

        when(
          mockOpenFoodFactsService.searchProducts(
            searchQuery,
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => initialResults);

        when(
          mockOpenFoodFactsService.searchProducts(
            searchQuery,
            country: anyNamed('country'),
            page: 2,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => moreResults);

        // Act
        await storeViewModel.search(searchQuery);

        // Assert - hasMoreProducts true olmalı
        expect(storeViewModel.hasMoreProducts, true);
        expect(storeViewModel.products.length, 2);
        expect(storeViewModel.currentPage, 1);

        await storeViewModel.loadMoreProducts();

        // Assert - Loading more bitti
        expect(storeViewModel.isLoadingMore, false);
        expect(storeViewModel.products.length, 3);
        expect(storeViewModel.currentPage, 2);
      },
    );

    test(
      'Arama sonuçlarından sepete ürün ekleme entegrasyonu çalışır',
      () async {
        // Arrange
        final searchQuery = 'çikolata';
        final mockSearchResults = createSearchResults(searchQuery);

        when(
          mockOpenFoodFactsService.searchProducts(
            searchQuery,
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => mockSearchResults);

        when(mockCartService.addToCart(any, any)).thenAnswer((_) async {});

        // Act
        await storeViewModel.search(searchQuery);
        final product = storeViewModel.products.first;
        final cartItem = CartItemModel.fromMap(product);
        await cartViewModel.addToCart(cartItem);

        // Assert
        expect(storeViewModel.products.length, 2);
        verify(mockCartService.addToCart('test-user-id', cartItem)).called(1);
      },
    );

    test('Çoklu arama işlemi sıralı olarak çalışır', () async {
      // Arrange
      final searchQuery1 = 'çikolata';
      final searchQuery2 = 'ekmek';
      final results1 = createSearchResults(searchQuery1);
      final results2 = createSearchResults(searchQuery2);

      when(
        mockOpenFoodFactsService.searchProducts(
          searchQuery1,
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => results1);

      when(
        mockOpenFoodFactsService.searchProducts(
          searchQuery2,
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => results2);

      // Act
      await storeViewModel.search(searchQuery1);
      expect(storeViewModel.currentQuery, searchQuery1);
      expect(storeViewModel.products.length, 2);

      await storeViewModel.search(searchQuery2);
      expect(storeViewModel.currentQuery, searchQuery2);
      expect(storeViewModel.products.length, 1);

      // Assert
      verify(
        mockOpenFoodFactsService.searchProducts(
          searchQuery1,
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
      verify(
        mockOpenFoodFactsService.searchProducts(
          searchQuery2,
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test(
      'Arama sonuçları state değişiklikleri notifyListeners çağırır',
      () async {
        // Arrange
        final searchQuery = 'test';
        final mockResults = createMockProductList(2);
        bool listenerCalled = false;

        when(
          mockOpenFoodFactsService.searchProducts(
            searchQuery,
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => mockResults);

        storeViewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        await storeViewModel.search(searchQuery);

        // Assert
        expect(listenerCalled, true);
        expect(storeViewModel.products.length, 2);
      },
    );

    test(
      'Arama sonuçları için özel karakterler içeren sorgular çalışır',
      () async {
        // Arrange
        final specialQueries = [
          'çikolata & fındık',
          'ekmek (tam buğday)',
          'süt + şeker',
          'ürün-1',
          'ürün_2',
          'ürün.3',
        ];

        for (final query in specialQueries) {
          when(
            mockOpenFoodFactsService.searchProducts(
              query,
              country: anyNamed('country'),
              page: 1,
              pageSize: 20,
            ),
          ).thenAnswer((_) async => createMockProductList(1));
        }

        // Act & Assert
        for (final query in specialQueries) {
          await storeViewModel.search(query);
          expect(storeViewModel.currentQuery, query);
          expect(storeViewModel.products.length, 1);
          expect(storeViewModel.isLoading, false);
        }
      },
    );

    test('Arama sonuçları için çok uzun sorgular çalışır', () async {
      // Arrange
      final longQuery =
          'çok uzun bir arama sorgusu bu çok uzun bir arama sorgusu bu çok uzun bir arama sorgusu bu';
      final mockResults = createMockProductList(1);

      when(
        mockOpenFoodFactsService.searchProducts(
          longQuery,
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => mockResults);

      // Act
      await storeViewModel.search(longQuery);

      // Assert
      expect(storeViewModel.currentQuery, longQuery);
      expect(storeViewModel.products.length, 1);
      expect(storeViewModel.isLoading, false);
      verify(
        mockOpenFoodFactsService.searchProducts(
          longQuery,
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Arama sonuçları için case insensitive arama çalışır', () async {
      // Arrange
      final queries = ['ÇİKOLATA', 'çikolata', 'Çikolata', 'ÇİKOLATA'];
      final mockResults = createSearchResults('çikolata');

      for (final query in queries) {
        when(
          mockOpenFoodFactsService.searchProducts(
            query,
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => mockResults);
      }

      // Act & Assert
      for (final query in queries) {
        await storeViewModel.search(query);
        expect(storeViewModel.currentQuery, query);
        expect(storeViewModel.products.length, 2);
        expect(storeViewModel.isLoading, false);
      }
    });

    test(
      'Arama sonuçları için null ve undefined değerler güvenli şekilde işlenir',
      () async {
        // Arrange
        final searchQuery = 'test';
        final mockResultsWithNulls = [
          {
            'id': '1',
            'product_name': null,
            'brands': null,
            'image_url': null,
            'nutriments': null,
          },
          {
            'id': '2',
            'product_name': 'Valid Product',
            'brands': 'Valid Brand',
            'image_url': 'https://example.com/valid.jpg',
            'nutriments': {'energy-kcal_100g': 100.0},
          },
        ];

        when(
          mockOpenFoodFactsService.searchProducts(
            searchQuery,
            country: anyNamed('country'),
            page: 1,
            pageSize: 20,
          ),
        ).thenAnswer((_) async => mockResultsWithNulls);

        // Act
        await storeViewModel.search(searchQuery);

        // Assert
        expect(storeViewModel.products.length, 2);
        expect(storeViewModel.products[0]['product_name'], null);
        expect(storeViewModel.products[1]['product_name'], 'Valid Product');
        expect(storeViewModel.isLoading, false);
      },
    );
  });
}
