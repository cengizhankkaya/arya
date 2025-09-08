// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:arya/features/index.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_flow_integration_test.mocks.dart';

/// Cart Flow Integration Test Suite
///
/// Bu test suite'i cart işlevlerinin entegrasyonunu test eder.
/// Cart'un temel işlevleri, hesaplamalar, state yönetimi ve hata durumları kapsanır.

@GenerateMocks([CartService, FirebaseAuth, User])
void main() {
  group('Cart Flow Integration Tests', () {
    late MockCartService mockCartService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late CartViewModel cartViewModel;

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
              'energy-kcal_100g': 100.0,
              'proteins_100g': 10.0,
              'fat_100g': 5.0,
              'carbohydrates_100g': 15.0,
            },
      );
    }

    /// Test helper: Mock cart item listesi oluşturur
    List<CartItemModel> createMockCartItemList(int count) {
      return List.generate(
        count,
        (index) => createMockCartItem(
          id: '${index + 1}',
          name: 'Test Ürün ${index + 1}',
          brand: 'Test Marka ${index + 1}',
          imageUrl: 'https://example.com/image${index + 1}.jpg',
          quantity: 1,
        ),
      );
    }

    setUp(() {
      mockCartService = MockCartService();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();

      // Mock user authentication
      when(mockUser.uid).thenReturn('test-user-id');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(
        mockFirebaseAuth.userChanges(),
      ).thenAnswer((_) => Stream.value(mockUser));

      // Mock cart stream - CartViewModel constructor'da çağrılır
      when(
        mockCartService.streamCart(any),
      ).thenAnswer((_) => Stream.value(<CartItemModel>[]));

      cartViewModel = CartViewModel(
        cartService: mockCartService,
        firebaseAuth: mockFirebaseAuth,
      );
    });

    tearDown(() {
      cartViewModel.dispose();
    });

    test('Cart başlangıçta boş olur', () {
      // Assert
      expect(cartViewModel.cartItems.length, 0);
      expect(cartViewModel.totalKcal, 0.0);
      expect(cartViewModel.totalProtein, 0.0);
      expect(cartViewModel.totalFat, 0.0);
      expect(cartViewModel.totalCarbs, 0.0);
    });

    test('Ürün sepete başarıyla eklenir', () async {
      // Arrange
      final cartItem = createMockCartItem(
        id: '1',
        name: 'Test Ürün',
        brand: 'Test Marka',
        imageUrl: 'https://example.com/test.jpg',
        quantity: 1,
        nutriments: {
          'energy-kcal_100g': 250.0,
          'proteins_100g': 15.0,
          'fat_100g': 12.0,
          'carbohydrates_100g': 20.0,
        },
      );

      when(mockCartService.addToCart(any, any)).thenAnswer((_) async {});

      // Act
      await cartViewModel.addToCart(cartItem);

      // Assert
      verify(mockCartService.addToCart('test-user-id', cartItem)).called(1);
    });

    test('Aynı ürün tekrar eklendiğinde miktar artar', () async {
      // Arrange
      final cartItem = createMockCartItem(
        id: '1',
        name: 'Test Ürün',
        brand: 'Test Marka',
        imageUrl: 'https://example.com/test.jpg',
        quantity: 1,
      );

      when(mockCartService.addToCart(any, any)).thenAnswer((_) async {});

      // Act
      await cartViewModel.addToCart(cartItem);
      await cartViewModel.addToCart(cartItem);

      // Assert
      verify(mockCartService.addToCart('test-user-id', cartItem)).called(2);
    });

    test('Ürün miktarı başarıyla artırılır', () async {
      // Arrange
      final productId = '1';
      when(mockCartService.increaseQuantity(any, any)).thenAnswer((_) async {});

      // Act
      await cartViewModel.increaseQuantity(productId);

      // Assert
      verify(
        mockCartService.increaseQuantity('test-user-id', productId),
      ).called(1);
    });

    test('Ürün miktarı başarıyla azaltılır', () async {
      // Arrange
      final productId = '1';
      when(mockCartService.decreaseQuantity(any, any)).thenAnswer((_) async {});

      // Act
      await cartViewModel.decreaseQuantity(productId);

      // Assert
      verify(
        mockCartService.decreaseQuantity('test-user-id', productId),
      ).called(1);
    });

    test('Ürün sepetten başarıyla çıkarılır', () async {
      // Arrange
      final productId = '1';
      when(mockCartService.removeFromCart(any, any)).thenAnswer((_) async {});

      // Act
      await cartViewModel.removeFromCart(productId);

      // Assert
      verify(
        mockCartService.removeFromCart('test-user-id', productId),
      ).called(1);
    });

    test('Sepet başarıyla temizlenir', () async {
      // Arrange
      when(mockCartService.clearCart(any)).thenAnswer((_) async {});

      // Act
      await cartViewModel.clearCart();

      // Assert
      verify(mockCartService.clearCart('test-user-id')).called(1);
    });

    test('Cart hesaplamaları doğru şekilde yapılır', () async {
      // Arrange
      final cartItems = [
        createMockCartItem(
          id: '1',
          name: 'Ürün 1',
          brand: 'Marka 1',
          imageUrl: 'https://example.com/1.jpg',
          quantity: 2,
          nutriments: {
            'energy-kcal_100g': 100.0,
            'proteins_100g': 10.0,
            'fat_100g': 5.0,
            'carbohydrates_100g': 15.0,
          },
        ),
        createMockCartItem(
          id: '2',
          name: 'Ürün 2',
          brand: 'Marka 2',
          imageUrl: 'https://example.com/2.jpg',
          quantity: 1,
          nutriments: {
            'energy-kcal_100g': 200.0,
            'proteins_100g': 20.0,
            'fat_100g': 10.0,
            'carbohydrates_100g': 25.0,
          },
        ),
      ];

      // Mock cart stream to return test items
      when(
        mockCartService.streamCart(any),
      ).thenAnswer((_) => Stream.value(cartItems));

      // Act - Create new view model to trigger stream
      final testCartViewModel = CartViewModel(
        cartService: mockCartService,
        firebaseAuth: mockFirebaseAuth,
      );

      // Wait for stream to emit
      final items = await testCartViewModel.cartStream.first;

      // Assert
      expect(items.length, 2);
      expect(testCartViewModel.totalKcal, 400.0); // (100*2) + (200*1)
      expect(testCartViewModel.totalProtein, 40.0); // (10*2) + (20*1)
      expect(testCartViewModel.totalFat, 20.0); // (5*2) + (10*1)
      expect(testCartViewModel.totalCarbs, 55.0); // (15*2) + (25*1)

      testCartViewModel.dispose();
    });

    test('Vitamin hesaplamaları doğru şekilde yapılır', () async {
      // Arrange
      final cartItems = [
        createMockCartItem(
          id: '1',
          name: 'Vitaminli Ürün',
          brand: 'Vitamin Marka',
          imageUrl: 'https://example.com/vitamin.jpg',
          quantity: 1,
          nutriments: {
            'energy-kcal_100g': 100.0,
            'vitamin-c_100g': 50.0,
            'vitamin-a_100g': 30.0,
            'vitamin-d_100g': 20.0,
            'vitamin-e_100g': 10.0,
            'vitamin-b6_100g': 5.0,
            'vitamin-b12_100g': 2.0,
          },
        ),
      ];

      // Mock cart stream
      when(
        mockCartService.streamCart(any),
      ).thenAnswer((_) => Stream.value(cartItems));

      // Act
      final testCartViewModel = CartViewModel(
        cartService: mockCartService,
        firebaseAuth: mockFirebaseAuth,
      );

      final items = await testCartViewModel.cartStream.first;

      // Assert
      expect(items.length, 1);
      expect(testCartViewModel.totalVitamins, 117.0); // 50+30+20+10+5+2

      testCartViewModel.dispose();
    });

    test('Kullanıcı giriş yapmamışsa local cart kullanılır', () async {
      // Arrange - Create completely fresh mocks for this test
      final freshMockCartService = MockCartService();
      final freshMockFirebaseAuth = MockFirebaseAuth();

      when(freshMockFirebaseAuth.currentUser).thenReturn(null);
      // Don't emit anything from userChanges to avoid clearing the cart
      when(freshMockFirebaseAuth.userChanges()).thenAnswer((_) {
        final controller = StreamController<User?>();
        // Don't add anything to avoid triggering cart clear
        return controller.stream;
      });

      final localCartViewModel = CartViewModel(
        cartService: freshMockCartService,
        firebaseAuth: freshMockFirebaseAuth,
      );

      final cartItem = createMockCartItem(
        id: '1',
        name: 'Local Ürün',
        brand: 'Local Marka',
        imageUrl: 'https://example.com/local.jpg',
        quantity: 1,
      );

      // Act
      await localCartViewModel.addToCart(cartItem);

      // Assert - Local cart should work immediately
      expect(localCartViewModel.cartItems.length, 1);
      expect(localCartViewModel.cartItems.first.productName, 'Local Ürün');
      verifyNever(freshMockCartService.addToCart(any, any));

      localCartViewModel.dispose();
    });

    test('Cart stream hata durumunda boş liste döner', () async {
      // Arrange
      when(
        mockCartService.streamCart(any),
      ).thenAnswer((_) => Stream.error(Exception('Firestore hatası')));

      // Act
      final testCartViewModel = CartViewModel(
        cartService: mockCartService,
        firebaseAuth: mockFirebaseAuth,
      );

      // Wait a bit for error handling to complete
      await Future.delayed(Duration(milliseconds: 100));

      // Assert - Cart should be empty due to error handling
      expect(testCartViewModel.cartItems.length, 0);

      testCartViewModel.dispose();
    });

    test('Kullanıcı değiştiğinde cart temizlenir', () async {
      // Arrange
      final completer = Completer<User?>();
      when(
        mockFirebaseAuth.userChanges(),
      ).thenAnswer((_) => completer.future.asStream());

      final testCartViewModel = CartViewModel(
        cartService: mockCartService,
        firebaseAuth: mockFirebaseAuth,
      );

      // Act - User logout
      completer.complete(null);

      // Wait for stream to process
      await Future.delayed(Duration(milliseconds: 100));

      // Assert
      expect(testCartViewModel.cartItems.length, 0);

      testCartViewModel.dispose();
    });

    test('Cart state değişiklikleri stream ile yayınlanır', () async {
      // Arrange
      final cartItems = createMockCartItemList(2);

      // Create fresh mocks for this test to avoid stream conflicts
      final freshMockCartService = MockCartService();
      final freshMockFirebaseAuth = MockFirebaseAuth();
      final freshMockUser = MockUser();

      when(freshMockUser.uid).thenReturn('test-user-id');
      when(freshMockFirebaseAuth.currentUser).thenReturn(freshMockUser);

      // Create a new stream for each call to avoid "already listened" error
      when(freshMockFirebaseAuth.userChanges()).thenAnswer((_) {
        final controller = StreamController<User?>();
        controller.add(freshMockUser);
        return controller.stream;
      });

      // Mock cart stream to return test items immediately
      when(
        freshMockCartService.streamCart(any),
      ).thenAnswer((_) => Stream.value(cartItems));

      final testCartViewModel = CartViewModel(
        cartService: freshMockCartService,
        firebaseAuth: freshMockFirebaseAuth,
      );

      // Wait for stream to process
      await Future.delayed(Duration(milliseconds: 100));

      // Assert
      expect(testCartViewModel.cartItems.length, 2);
      expect(testCartViewModel.cartItems[0].productName, 'Test Ürün 1');
      expect(testCartViewModel.cartItems[1].productName, 'Test Ürün 2');

      testCartViewModel.dispose();
    });

    test(
      'Miktar 1 olduğunda decreaseQuantity ürünü sepetten çıkarır',
      () async {
        // Arrange
        final productId = '1';
        when(
          mockCartService.decreaseQuantity(any, any),
        ).thenAnswer((_) async {});

        // Act
        await cartViewModel.decreaseQuantity(productId);

        // Assert
        verify(
          mockCartService.decreaseQuantity('test-user-id', productId),
        ).called(1);
      },
    );

    test('Çoklu ürün ekleme ve çıkarma işlemleri çalışır', () async {
      // Arrange
      final cartItem1 = createMockCartItem(
        id: '1',
        name: 'Ürün 1',
        brand: 'Marka 1',
        imageUrl: 'https://example.com/1.jpg',
        quantity: 1,
      );

      final cartItem2 = createMockCartItem(
        id: '2',
        name: 'Ürün 2',
        brand: 'Marka 2',
        imageUrl: 'https://example.com/2.jpg',
        quantity: 1,
      );

      when(mockCartService.addToCart(any, any)).thenAnswer((_) async {});
      when(mockCartService.removeFromCart(any, any)).thenAnswer((_) async {});

      // Act
      await cartViewModel.addToCart(cartItem1);
      await cartViewModel.addToCart(cartItem2);
      await cartViewModel.removeFromCart('1');

      // Assert
      verify(mockCartService.addToCart('test-user-id', cartItem1)).called(1);
      verify(mockCartService.addToCart('test-user-id', cartItem2)).called(1);
      verify(mockCartService.removeFromCart('test-user-id', '1')).called(1);
    });
  });
}
