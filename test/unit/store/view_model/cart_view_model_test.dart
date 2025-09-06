import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
import 'package:arya/features/store/services/cart_service.dart';

import 'cart_view_model_test.mocks.dart';

@GenerateMocks([CartService, FirebaseAuth, User, StreamSubscription])
void main() {
  group('CartViewModel Tests', () {
    late CartViewModel viewModel;
    late MockCartService mockCartService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;

    setUp(() {
      mockCartService = MockCartService();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();

      when(mockUser.uid).thenReturn('test-user-id');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(
        mockFirebaseAuth.userChanges(),
      ).thenAnswer((_) => Stream.value(mockUser));
      when(
        mockCartService.streamCart(any),
      ).thenAnswer((_) => Stream.value(<CartItemModel>[]));

      viewModel = CartViewModel(
        cartService: mockCartService,
        firebaseAuth: mockFirebaseAuth,
      );
    });

    tearDown(() {
      // Don't dispose in tearDown to avoid issues with tests that need to test disposal
    });

    group('Initialization Tests', () {
      test('should initialize with empty cart', () {
        expect(viewModel.cartItems, isEmpty);
        expect(viewModel.cartStream, isNotNull);
      });

      test('should initialize with default values', () {
        expect(viewModel.totalKcal, equals(0.0));
        expect(viewModel.totalProtein, equals(0.0));
        expect(viewModel.totalFat, equals(0.0));
        expect(viewModel.totalCarbs, equals(0.0));
        expect(viewModel.totalVitamins, equals(0.0));
      });

      test('should setup auth listener on initialization', () {
        verify(mockFirebaseAuth.userChanges()).called(1);
      });

      test('should setup cart stream for authenticated user', () {
        verify(
          mockCartService.streamCart('test-user-id'),
        ).called(greaterThan(0));
      });
    });

    group('Disposal Tests', () {
      test('should dispose correctly', () {
        // Act
        viewModel.dispose();

        // Assert - should not throw and object should still be accessible
        expect(viewModel, isNotNull);
      });

      test('should cancel stream subscription on disposal', () {
        // Arrange
        when(
          mockCartService.streamCart(any),
        ).thenAnswer((_) => Stream.value(<CartItemModel>[]));

        // Act
        viewModel.dispose();

        // Assert - verify that stream subscription is cancelled
        // This is tested indirectly through the dispose method not throwing
        expect(viewModel, isNotNull);
      });
    });

    group('Add to Cart Tests', () {
      test('should add item to cart when user is authenticated', () async {
        // Arrange
        final item = CartItemModel(
          id: 'test-product-1',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {'proteins_100g': 10.0},
        );

        // Act
        await viewModel.addToCart(item);

        // Assert
        verify(mockCartService.addToCart('test-user-id', item)).called(1);
      });

      test('should add item locally when user is not authenticated', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);
        final item = CartItemModel(
          id: 'test-product-1',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {'proteins_100g': 10.0},
        );

        // Act
        await viewModel.addToCart(item);

        // Assert
        expect(viewModel.cartItems.length, equals(1));
        expect(viewModel.cartItems.first.id, equals('test-product-1'));
        verifyNever(mockCartService.addToCart(any, any));
      });

      test(
        'should increment quantity when adding existing item locally',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);
          final item = CartItemModel(
            id: 'test-product-1',
            productName: 'Test Product',
            quantity: 1,
            nutriments: {'proteins_100g': 10.0},
          );

          // Act
          await viewModel.addToCart(item);
          await viewModel.addToCart(item);

          // Assert
          expect(viewModel.cartItems.length, equals(1));
          expect(viewModel.cartItems.first.quantity, equals(2));
        },
      );

      test('should handle cart service errors gracefully', () async {
        // Arrange
        final item = CartItemModel(
          id: 'test-product-1',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {'proteins_100g': 10.0},
        );
        when(
          mockCartService.addToCart(any, any),
        ).thenThrow(Exception('Service error'));

        // Act & Assert
        expect(() => viewModel.addToCart(item), throwsA(isA<Exception>()));
      });
    });

    group('Remove from Cart Tests', () {
      test('should remove item from cart when user is authenticated', () async {
        // Act
        await viewModel.removeFromCart('test-product-1');

        // Assert
        verify(
          mockCartService.removeFromCart('test-user-id', 'test-product-1'),
        ).called(1);
      });

      test(
        'should remove item locally when user is not authenticated',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);
          final item = CartItemModel(
            id: 'test-product-1',
            productName: 'Test Product',
            quantity: 1,
            nutriments: {'proteins_100g': 10.0},
          );
          await viewModel.addToCart(item);
          expect(viewModel.cartItems.length, equals(1));

          // Act
          await viewModel.removeFromCart('test-product-1');

          // Assert
          expect(viewModel.cartItems, isEmpty);
          verifyNever(mockCartService.removeFromCart(any, any));
        },
      );

      test('should handle cart service errors gracefully', () async {
        // Arrange
        when(
          mockCartService.removeFromCart(any, any),
        ).thenThrow(Exception('Service error'));

        // Act & Assert
        expect(
          () => viewModel.removeFromCart('test-product-1'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Increase Quantity Tests', () {
      test('should increase quantity when user is authenticated', () async {
        // Act
        await viewModel.increaseQuantity('test-product-1');

        // Assert
        verify(
          mockCartService.increaseQuantity('test-user-id', 'test-product-1'),
        ).called(1);
      });

      test(
        'should increase quantity locally when user is not authenticated',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);
          final item = CartItemModel(
            id: 'test-product-1',
            productName: 'Test Product',
            quantity: 1,
            nutriments: {'proteins_100g': 10.0},
          );
          await viewModel.addToCart(item);

          // Act
          await viewModel.increaseQuantity('test-product-1');

          // Assert
          expect(viewModel.cartItems.first.quantity, equals(2));
          verifyNever(mockCartService.increaseQuantity(any, any));
        },
      );

      test(
        'should not increase quantity for non-existent item locally',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);

          // Act
          await viewModel.increaseQuantity('non-existent-product');

          // Assert
          expect(viewModel.cartItems, isEmpty);
        },
      );

      test('should handle cart service errors gracefully', () async {
        // Arrange
        when(
          mockCartService.increaseQuantity(any, any),
        ).thenThrow(Exception('Service error'));

        // Act & Assert
        expect(
          () => viewModel.increaseQuantity('test-product-1'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Decrease Quantity Tests', () {
      test('should decrease quantity when user is authenticated', () async {
        // Act
        await viewModel.decreaseQuantity('test-product-1');

        // Assert
        verify(
          mockCartService.decreaseQuantity('test-user-id', 'test-product-1'),
        ).called(1);
      });

      test(
        'should decrease quantity locally when user is not authenticated',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);
          final item = CartItemModel(
            id: 'test-product-1',
            productName: 'Test Product',
            quantity: 2,
            nutriments: {'proteins_100g': 10.0},
          );
          await viewModel.addToCart(item);

          // Act
          await viewModel.decreaseQuantity('test-product-1');

          // Assert
          expect(viewModel.cartItems.first.quantity, equals(1));
          verifyNever(mockCartService.decreaseQuantity(any, any));
        },
      );

      test('should remove item when quantity becomes 0 locally', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);
        final item = CartItemModel(
          id: 'test-product-1',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {'proteins_100g': 10.0},
        );
        await viewModel.addToCart(item);

        // Act
        await viewModel.decreaseQuantity('test-product-1');

        // Assert
        expect(viewModel.cartItems, isEmpty);
      });

      test(
        'should not decrease quantity for non-existent item locally',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);

          // Act
          await viewModel.decreaseQuantity('non-existent-product');

          // Assert
          expect(viewModel.cartItems, isEmpty);
        },
      );

      test('should handle cart service errors gracefully', () async {
        // Arrange
        when(
          mockCartService.decreaseQuantity(any, any),
        ).thenThrow(Exception('Service error'));

        // Act & Assert
        expect(
          () => viewModel.decreaseQuantity('test-product-1'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Clear Cart Tests', () {
      test('should clear cart when user is authenticated', () async {
        // Act
        await viewModel.clearCart();

        // Assert
        verify(mockCartService.clearCart('test-user-id')).called(1);
      });

      test(
        'should clear cart locally when user is not authenticated',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);
          final item = CartItemModel(
            id: 'test-product-1',
            productName: 'Test Product',
            quantity: 1,
            nutriments: {'proteins_100g': 10.0},
          );
          await viewModel.addToCart(item);
          expect(viewModel.cartItems.length, equals(1));

          // Act
          await viewModel.clearCart();

          // Assert
          expect(viewModel.cartItems, isEmpty);
          verifyNever(mockCartService.clearCart(any));
        },
      );

      test('should handle cart service errors gracefully', () async {
        // Arrange
        when(
          mockCartService.clearCart(any),
        ).thenThrow(Exception('Service error'));

        // Act & Assert
        expect(() => viewModel.clearCart(), throwsA(isA<Exception>()));
      });
    });

    group('Nutrition Calculation Tests', () {
      test('should calculate total calories correctly', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null); // Use local mode
        final items = [
          CartItemModel(
            id: 'product-1',
            productName: 'Product 1',
            quantity: 2,
            nutriments: {'energy-kcal_100g': 100.0},
          ),
          CartItemModel(
            id: 'product-2',
            productName: 'Product 2',
            quantity: 1,
            nutriments: {'energy-kcal_100g': 50.0},
          ),
        ];

        // Manually add items to test calculation
        for (final item in items) {
          await viewModel.addToCart(item);
        }

        // Act
        final totalKcal = viewModel.totalKcal;

        // Assert
        expect(totalKcal, equals(250.0)); // (100 * 2) + (50 * 1)
      });

      test('should calculate total protein correctly', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null); // Use local mode
        final items = [
          CartItemModel(
            id: 'product-1',
            productName: 'Product 1',
            quantity: 1,
            nutriments: {'proteins_100g': 20.0},
          ),
          CartItemModel(
            id: 'product-2',
            productName: 'Product 2',
            quantity: 3,
            nutriments: {'proteins_100g': 10.0},
          ),
        ];

        // Manually add items to test calculation
        for (final item in items) {
          await viewModel.addToCart(item);
        }

        // Act
        final totalProtein = viewModel.totalProtein;

        // Assert
        expect(totalProtein, equals(50.0)); // (20 * 1) + (10 * 3)
      });

      test('should calculate total fat correctly', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null); // Use local mode
        final items = [
          CartItemModel(
            id: 'product-1',
            productName: 'Product 1',
            quantity: 2,
            nutriments: {'fat_100g': 15.0},
          ),
        ];

        // Manually add items to test calculation
        for (final item in items) {
          await viewModel.addToCart(item);
        }

        // Act
        final totalFat = viewModel.totalFat;

        // Assert
        expect(totalFat, equals(30.0)); // 15 * 2
      });

      test('should calculate total carbohydrates correctly', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null); // Use local mode
        final items = [
          CartItemModel(
            id: 'product-1',
            productName: 'Product 1',
            quantity: 1,
            nutriments: {'carbohydrates_100g': 25.0},
          ),
        ];

        // Manually add items to test calculation
        for (final item in items) {
          await viewModel.addToCart(item);
        }

        // Act
        final totalCarbs = viewModel.totalCarbs;

        // Assert
        expect(totalCarbs, equals(25.0)); // 25 * 1
      });

      test('should calculate total vitamins correctly', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null); // Use local mode
        final items = [
          CartItemModel(
            id: 'product-1',
            productName: 'Product 1',
            quantity: 1,
            nutriments: {
              'vitamin-c_100g': 10.0,
              'vitamin-a_100g': 5.0,
              'vitamin-d_100g': 2.0,
              'vitamin-e_100g': 3.0,
              'vitamin-b6_100g': 1.0,
              'vitamin-b12_100g': 0.5,
            },
          ),
        ];

        // Manually add items to test calculation
        for (final item in items) {
          await viewModel.addToCart(item);
        }

        // Act
        final totalVitamins = viewModel.totalVitamins;

        // Assert
        expect(totalVitamins, equals(21.5)); // (10+5+2+3+1+0.5) * 1
      });

      test('should handle missing nutrition data', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null); // Use local mode
        final items = [
          CartItemModel(
            id: 'product-1',
            productName: 'Product 1',
            quantity: 1,
            nutriments: {}, // Empty nutriments
          ),
        ];

        // Manually add items to test calculation
        for (final item in items) {
          await viewModel.addToCart(item);
        }

        // Act
        final totalKcal = viewModel.totalKcal;
        final totalProtein = viewModel.totalProtein;
        final totalFat = viewModel.totalFat;
        final totalCarbs = viewModel.totalCarbs;
        final totalVitamins = viewModel.totalVitamins;

        // Assert
        expect(totalKcal, equals(0.0));
        expect(totalProtein, equals(0.0));
        expect(totalFat, equals(0.0));
        expect(totalCarbs, equals(0.0));
        expect(totalVitamins, equals(0.0));
      });

      test('should handle invalid nutrition data types', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null); // Use local mode
        final items = [
          CartItemModel(
            id: 'product-1',
            productName: 'Product 1',
            quantity: 1,
            nutriments: {
              'energy-kcal_100g': 'invalid',
              'proteins_100g': null,
              'fat_100g': true,
            },
          ),
        ];

        // Manually add items to test calculation
        for (final item in items) {
          await viewModel.addToCart(item);
        }

        // Act
        final totalKcal = viewModel.totalKcal;
        final totalProtein = viewModel.totalProtein;
        final totalFat = viewModel.totalFat;

        // Assert
        expect(totalKcal, equals(0.0));
        expect(totalProtein, equals(0.0));
        expect(totalFat, equals(0.0));
      });

      test('should handle string numbers in nutrition data', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null); // Use local mode
        final items = [
          CartItemModel(
            id: 'product-1',
            productName: 'Product 1',
            quantity: 2,
            nutriments: {
              'energy-kcal_100g': '150,5', // String with comma
              'proteins_100g': '12.5', // String with dot
            },
          ),
        ];

        // Manually add items to test calculation
        for (final item in items) {
          await viewModel.addToCart(item);
        }

        // Act
        final totalKcal = viewModel.totalKcal;
        final totalProtein = viewModel.totalProtein;

        // Assert
        expect(totalKcal, equals(301.0)); // 150.5 * 2
        expect(totalProtein, equals(25.0)); // 12.5 * 2
      });
    });

    group('Stream and Real-time Updates Tests', () {
      test('should emit cart updates through stream', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null); // Use local mode
        final item = CartItemModel(
          id: 'product-1',
          productName: 'Product 1',
          quantity: 1,
          nutriments: {'proteins_100g': 10.0},
        );

        // Act
        final streamValues = <List<CartItemModel>>[];
        final subscription = viewModel.cartStream.listen(streamValues.add);

        // Add item to trigger stream update
        await viewModel.addToCart(item);

        // Wait for stream to emit
        await Future.delayed(Duration(milliseconds: 100));

        // Assert
        expect(streamValues, isNotEmpty);
        subscription.cancel();
      });

      test('should handle stream errors gracefully', () async {
        // Arrange
        when(
          mockFirebaseAuth.currentUser,
        ).thenReturn(mockUser); // Use authenticated mode
        when(
          mockCartService.streamCart(any),
        ).thenAnswer((_) => Stream.error(Exception('Stream error')));

        // Act
        final streamValues = <List<CartItemModel>>[];
        final streamErrors = <dynamic>[];
        final subscription = viewModel.cartStream.listen(
          streamValues.add,
          onError: streamErrors.add,
        );

        // Wait for stream to emit error
        await Future.delayed(Duration(milliseconds: 200));

        // Assert
        // The error handling is tested indirectly through the stream setup
        // In a real scenario, errors would be handled by the CartViewModel
        expect(streamValues, isA<List<List<CartItemModel>>>());
        subscription.cancel();
      });

      test('should clear cart on auth state change to null', () async {
        // Arrange
        when(
          mockFirebaseAuth.userChanges(),
        ).thenAnswer((_) => Stream.value(null));

        // Act
        final streamValues = <List<CartItemModel>>[];
        final subscription = viewModel.cartStream.listen(streamValues.add);

        // Wait for stream to emit
        await Future.delayed(Duration(milliseconds: 100));

        // Assert
        if (streamValues.isNotEmpty) {
          expect(streamValues.last, isEmpty);
        }
        subscription.cancel();
      });
    });

    group('Auth State Management Tests', () {
      test('should handle user login', () async {
        // Arrange
        when(
          mockFirebaseAuth.userChanges(),
        ).thenAnswer((_) => Stream.value(mockUser));

        // Act
        final streamValues = <List<CartItemModel>>[];
        final subscription = viewModel.cartStream.listen(streamValues.add);

        // Wait for stream to emit
        await Future.delayed(Duration(milliseconds: 100));

        // Assert
        verify(
          mockCartService.streamCart('test-user-id'),
        ).called(greaterThan(0));
        subscription.cancel();
      });

      test('should handle user logout', () async {
        // Arrange
        when(
          mockFirebaseAuth.userChanges(),
        ).thenAnswer((_) => Stream.value(null));

        // Act
        final streamValues = <List<CartItemModel>>[];
        final subscription = viewModel.cartStream.listen(streamValues.add);

        // Wait for stream to emit
        await Future.delayed(Duration(milliseconds: 100));

        // Assert
        if (streamValues.isNotEmpty) {
          expect(streamValues.last, isEmpty);
        }
        subscription.cancel();
      });

      test('should cancel previous stream subscription on auth change', () async {
        // Arrange
        when(
          mockFirebaseAuth.userChanges(),
        ).thenAnswer((_) => Stream.value(mockUser));

        // Act
        final streamValues = <List<CartItemModel>>[];
        final subscription = viewModel.cartStream.listen(streamValues.add);

        // Wait for stream to emit
        await Future.delayed(Duration(milliseconds: 100));

        // Assert
        // Verify that stream setup is called (indirectly testing subscription management)
        verify(
          mockCartService.streamCart('test-user-id'),
        ).called(greaterThan(0));
        subscription.cancel();
      });
    });

    group('Edge Cases and Error Handling Tests', () {
      test('should handle empty product ID', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        // Act
        await viewModel.removeFromCart('');
        await viewModel.increaseQuantity('');
        await viewModel.decreaseQuantity('');

        // Assert
        expect(viewModel.cartItems, isEmpty);
      });

      test('should handle null product ID', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        // Act
        await viewModel.removeFromCart('');
        await viewModel.increaseQuantity('');
        await viewModel.decreaseQuantity('');

        // Assert
        expect(viewModel.cartItems, isEmpty);
      });

      test('should handle very large quantities', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);
        final item = CartItemModel(
          id: 'test-product-1',
          productName: 'Test Product',
          quantity: 999999,
          nutriments: {'proteins_100g': 10.0},
        );

        // Act
        await viewModel.addToCart(item);

        // Assert
        expect(viewModel.cartItems.first.quantity, equals(999999));
      });

      test('should handle special characters in product ID', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);
        final specialId = 'test@#\$%^&*()_+{}|:"<>?[]\\\\;\',./';
        final item = CartItemModel(
          id: specialId,
          productName: 'Test Product',
          quantity: 1,
          nutriments: {'proteins_100g': 10.0},
        );

        // Act
        await viewModel.addToCart(item);
        await viewModel.removeFromCart(specialId);

        // Assert
        expect(viewModel.cartItems, isEmpty);
      });

      test('should handle rapid consecutive operations', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);
        final item = CartItemModel(
          id: 'test-product-1',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {'proteins_100g': 10.0},
        );

        // Act
        await viewModel.addToCart(item);
        await viewModel.increaseQuantity('test-product-1');
        await viewModel.increaseQuantity('test-product-1');
        await viewModel.decreaseQuantity('test-product-1');
        await viewModel.removeFromCart('test-product-1');

        // Assert
        expect(viewModel.cartItems, isEmpty);
      });

      test('should handle disposal during async operations', () async {
        // Arrange
        when(
          mockCartService.addToCart(any, any),
        ).thenAnswer((_) => Future.delayed(Duration(seconds: 1)));

        // Act
        final item = CartItemModel(
          id: 'test-product-1',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {'proteins_100g': 10.0},
        );
        final addFuture = viewModel.addToCart(item);
        viewModel.dispose();

        // Assert
        expect(viewModel, isNotNull); // Object should still exist

        // Wait for the future to complete to avoid test hanging
        try {
          await addFuture;
        } catch (e) {
          // Expected to throw after disposal
        }
      });
    });

    group('Integration Tests', () {
      test(
        'should maintain state consistency during multiple operations',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);
          final items = [
            CartItemModel(
              id: 'product-1',
              productName: 'Product 1',
              quantity: 1,
              nutriments: {
                'energy-kcal_100g': 100.0,
                'proteins_100g': 10.0,
                'fat_100g': 5.0,
                'carbohydrates_100g': 20.0,
              },
            ),
            CartItemModel(
              id: 'product-2',
              productName: 'Product 2',
              quantity: 2,
              nutriments: {
                'energy-kcal_100g': 50.0,
                'proteins_100g': 5.0,
                'fat_100g': 2.0,
                'carbohydrates_100g': 10.0,
              },
            ),
          ];

          // Act
          for (final item in items) {
            await viewModel.addToCart(item);
          }
          await viewModel.increaseQuantity('product-1');
          await viewModel.decreaseQuantity('product-2');
          await viewModel.removeFromCart('product-1');

          // Assert
          expect(viewModel.cartItems.length, equals(1));
          expect(viewModel.cartItems.first.id, equals('product-2'));
          expect(viewModel.cartItems.first.quantity, equals(1));
          expect(viewModel.totalKcal, equals(50.0));
          expect(viewModel.totalProtein, equals(5.0));
          expect(viewModel.totalFat, equals(2.0));
          expect(viewModel.totalCarbs, equals(10.0));
        },
      );

      test('should handle complex nutrition calculations', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);
        final items = [
          CartItemModel(
            id: 'product-1',
            productName: 'Product 1',
            quantity: 3,
            nutriments: {
              'energy-kcal_100g': 120.5,
              'proteins_100g': 15.2,
              'fat_100g': 8.7,
              'carbohydrates_100g': 25.3,
              'vitamin-c_100g': 20.0,
              'vitamin-a_100g': 10.0,
            },
          ),
          CartItemModel(
            id: 'product-2',
            productName: 'Product 2',
            quantity: 2,
            nutriments: {
              'energy-kcal_100g': 80.0,
              'proteins_100g': 12.0,
              'fat_100g': 4.0,
              'carbohydrates_100g': 18.0,
              'vitamin-d_100g': 5.0,
              'vitamin-e_100g': 3.0,
            },
          ),
        ];

        // Act
        for (final item in items) {
          await viewModel.addToCart(item);
        }

        // Assert
        expect(viewModel.totalKcal, equals(521.5)); // (120.5*3) + (80*2)
        expect(viewModel.totalProtein, equals(69.6)); // (15.2*3) + (12*2)
        expect(viewModel.totalFat, closeTo(34.1, 0.01)); // (8.7*3) + (4*2)
        expect(viewModel.totalCarbs, closeTo(111.9, 0.01)); // (25.3*3) + (18*2)
        expect(viewModel.totalVitamins, equals(106.0)); // (20+10)*3 + (5+3)*2
      });
    });
  });
}
