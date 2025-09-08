// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:arya/features/index.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'store_flow_integration_test.mocks.dart';

/// Store Flow Integration Test Suite
///
/// Bu test suite'i store ve cart arasındaki entegrasyonu test eder.
/// Store'un temel işlevleri, cart ile etkileşimi ve hata durumları kapsanır.

@GenerateMocks([OpenFoodFactsService, CartService, FirebaseAuth, User])
void main() {
  group('Store Flow Integration Tests', () {
    late MockOpenFoodFactsService mockOpenFoodFactsService;
    late MockCartService mockCartService;
    late MockFirebaseAuth mockFirebaseAuth;
    late StoreViewModel storeViewModel;
    late CartViewModel cartViewModel;

    /// Test helper: Mock ürün verisi oluşturur
    Map<String, dynamic> createMockProduct({
      required String id,
      required String name,
      required String brand,
      required String imageUrl,
      Map<String, dynamic>? nutriments,
    }) {
      return {
        'id': id,
        'product_name': name,
        'brands': brand,
        'image_url': imageUrl,
        'nutriments':
            nutriments ??
            {
              'energy-kcal_100g': 100.0,
              'proteins_100g': 10.0,
              'fat_100g': 5.0,
              'carbohydrates_100g': 15.0,
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

    setUp(() {
      mockOpenFoodFactsService = MockOpenFoodFactsService();
      mockCartService = MockCartService();
      mockFirebaseAuth = MockFirebaseAuth();

      // FirebaseAuth currentUser stub'ını ekle
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      // FirebaseAuth userChanges stream stub'ını ekle
      when(
        mockFirebaseAuth.userChanges(),
      ).thenAnswer((_) => Stream.value(null));

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

    test('Store başlangıçta rastgele ürünleri yükler', () async {
      // Arrange
      final mockProducts = createMockProductList(2);

      when(
        mockOpenFoodFactsService.searchProducts(
          '',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => mockProducts);

      // Act
      await storeViewModel.fetchRandomProducts();

      // Assert
      expect(storeViewModel.products.length, 2);
      // Ürünlerin sırası değişebilir, bu yüzden her iki ürünün de listede olduğunu kontrol edelim
      final productNames = storeViewModel.products
          .map((p) => p['product_name'])
          .toList();
      expect(productNames, contains('Test Ürün 1'));
      expect(productNames, contains('Test Ürün 2'));
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

    test('Ürün arama işlemi başarılı şekilde çalışır', () async {
      // Arrange
      final searchQuery = 'çikolata';
      final mockSearchResults = [
        {
          'id': '3',
          'product_name': 'Çikolata',
          'brands': 'Çikolata Markası',
          'image_url': 'https://example.com/chocolate.jpg',
          'nutriments': {
            'energy-kcal_100g': 500.0,
            'proteins_100g': 5.0,
            'fat_100g': 30.0,
            'carbohydrates_100g': 60.0,
          },
        },
      ];

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
      expect(storeViewModel.products.length, 1);
      expect(storeViewModel.products[0]['product_name'], 'Çikolata');
      expect(storeViewModel.currentQuery, searchQuery);
      expect(storeViewModel.isLoading, false);
      verify(
        mockOpenFoodFactsService.searchProducts(
          searchQuery,
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Kategori bazlı ürün getirme işlemi çalışır', () async {
      // Arrange
      final category = 'Protein Oranı Yüksek';
      final mockCategoryProducts = [
        {
          'id': '4',
          'product_name': 'Yüksek Protein Ürünü',
          'brands': 'Protein Markası',
          'image_url': 'https://example.com/protein.jpg',
          'nutriments': {
            'energy-kcal_100g': 300.0,
            'proteins_100g': 25.0,
            'fat_100g': 8.0,
            'carbohydrates_100g': 10.0,
          },
        },
      ];

      when(
        mockOpenFoodFactsService.searchProductsByCategory(
          category,
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => mockCategoryProducts);

      // Act
      await storeViewModel.fetchByCategory(category);

      // Assert
      expect(storeViewModel.products.length, 1);
      expect(
        storeViewModel.products[0]['product_name'],
        'Yüksek Protein Ürünü',
      );
      expect(storeViewModel.selectedCategory, category);
      expect(storeViewModel.isLoading, false);
      verify(
        mockOpenFoodFactsService.searchProductsByCategory(
          category,
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Daha fazla ürün yükleme işlemi çalışır', () async {
      // Arrange
      final initialProducts = [
        {
          'id': '1',
          'product_name': 'İlk Ürün',
          'brands': 'Marka',
          'image_url': 'https://example.com/image1.jpg',
          'nutriments': {'energy-kcal_100g': 100.0},
        },
      ];

      final moreProducts = [
        {
          'id': '2',
          'product_name': 'İkinci Ürün',
          'brands': 'Marka 2',
          'image_url': 'https://example.com/image2.jpg',
          'nutriments': {'energy-kcal_100g': 200.0},
        },
      ];

      when(
        mockOpenFoodFactsService.searchProducts(
          '',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => initialProducts);

      when(
        mockOpenFoodFactsService.searchProducts(
          '',
          country: anyNamed('country'),
          page: 2,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => moreProducts);

      // Act
      await storeViewModel.fetchRandomProducts();
      await storeViewModel.loadMoreProducts();

      // Assert
      expect(storeViewModel.products.length, 2);
      expect(storeViewModel.products[0]['product_name'], 'İlk Ürün');
      expect(storeViewModel.products[1]['product_name'], 'İkinci Ürün');
      expect(storeViewModel.currentPage, 2);
      expect(storeViewModel.isLoadingMore, false);
    });

    test('Ülke değiştirme işlemi çalışır', () async {
      // Arrange
      final newCountry = 'turkey';
      final mockProducts = [
        {
          'id': '5',
          'product_name': 'Türk Ürünü',
          'brands': 'Türk Markası',
          'image_url': 'https://example.com/turkish.jpg',
          'nutriments': {'energy-kcal_100g': 150.0},
        },
      ];

      when(
        mockOpenFoodFactsService.searchProducts(
          '',
          country: newCountry,
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => mockProducts);

      // Act
      storeViewModel.setCountry(newCountry);
      await storeViewModel.fetchRandomProducts();

      // Assert
      expect(storeViewModel.selectedCountry, newCountry);
      expect(storeViewModel.products.length, 1);
      expect(storeViewModel.products[0]['product_name'], 'Türk Ürünü');
      verify(
        mockOpenFoodFactsService.searchProducts(
          '',
          country: newCountry,
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Hata durumunda ürün listesi boş kalır', () async {
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
      await storeViewModel.fetchRandomProducts();

      // Assert
      expect(storeViewModel.products.length, 0);
      expect(storeViewModel.isLoading, false);
    });

    test('Boş arama sorgusu rastgele ürünleri getirir', () async {
      // Arrange
      final mockProducts = [
        {
          'id': '6',
          'product_name': 'Rastgele Ürün',
          'brands': 'Rastgele Marka',
          'image_url': 'https://example.com/random.jpg',
          'nutriments': {'energy-kcal_100g': 120.0},
        },
      ];

      when(
        mockOpenFoodFactsService.searchProducts(
          '',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => mockProducts);

      // Act
      await storeViewModel.search('');

      // Assert
      expect(storeViewModel.products.length, 1);
      expect(storeViewModel.products[0]['product_name'], 'Rastgele Ürün');
      verify(
        mockOpenFoodFactsService.searchProducts(
          '',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).called(1);
    });

    test('Loading durumları doğru şekilde yönetilir', () async {
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
      final future = storeViewModel.fetchRandomProducts();

      // Assert - Loading başladı
      expect(storeViewModel.isLoading, true);

      // Act - İşlem tamamlandı
      completer.complete([
        {
          'id': '7',
          'product_name': 'Test Ürün',
          'brands': 'Test Marka',
          'image_url': 'https://example.com/test.jpg',
          'nutriments': {'energy-kcal_100g': 100.0},
        },
      ]);
      await future;

      // Assert - Loading bitti
      expect(storeViewModel.isLoading, false);
      expect(storeViewModel.products.length, 1);
    });

    test('Store\'dan sepete ürün ekleme entegrasyonu çalışır', () async {
      // Arrange
      final mockProduct = createMockProduct(
        id: '8',
        name: 'Sepete Eklenecek Ürün',
        brand: 'Test Marka',
        imageUrl: 'https://example.com/cart.jpg',
        nutriments: {
          'energy-kcal_100g': 250.0,
          'proteins_100g': 15.0,
          'fat_100g': 12.0,
          'carbohydrates_100g': 20.0,
        },
      );

      when(
        mockOpenFoodFactsService.searchProducts(
          '',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => [mockProduct]);

      // Mock user authentication
      final mockUser = MockUser();
      when(mockUser.uid).thenReturn('test-user-id');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      when(mockCartService.addToCart(any, any)).thenAnswer((_) async {});

      // Act
      await storeViewModel.fetchRandomProducts();
      final product = storeViewModel.products.first;
      final cartItem = CartItemModel.fromMap(product);
      await cartViewModel.addToCart(cartItem);

      // Assert
      verify(mockCartService.addToCart('test-user-id', cartItem)).called(1);
    });

    test('Store ve Cart arasında temel entegrasyon çalışır', () async {
      // Arrange
      final mockProducts = [
        createMockProduct(
          id: '9',
          name: 'Senkronizasyon Test Ürünü',
          brand: 'Test Marka',
          imageUrl: 'https://example.com/sync.jpg',
          nutriments: {'energy-kcal_100g': 180.0},
        ),
      ];

      when(
        mockOpenFoodFactsService.searchProducts(
          '',
          country: anyNamed('country'),
          page: 1,
          pageSize: 20,
        ),
      ).thenAnswer((_) async => mockProducts);

      // Act
      await storeViewModel.fetchRandomProducts();

      // Assert
      expect(storeViewModel.products.length, 1);
      expect(
        storeViewModel.products[0]['product_name'],
        'Senkronizasyon Test Ürünü',
      );
      expect(cartViewModel.cartItems.length, 0); // Başlangıçta boş
    });
  });
}
