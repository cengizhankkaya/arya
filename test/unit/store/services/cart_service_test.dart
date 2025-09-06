import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:arya/features/store/services/cart_service.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
import '../../../helpers/test_helpers.dart';

import 'cart_service_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  QuerySnapshot,
  QueryDocumentSnapshot,
  Transaction,
  WriteBatch,
  Stream,
  StreamSubscription,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestHelpers.setupFirebaseCoreMocks();

  group('CartService Tests', () {
    late CartService cartService;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollection;
    late MockDocumentReference<Map<String, dynamic>> mockDocRef;
    late MockDocumentSnapshot<Map<String, dynamic>> mockDocSnapshot;
    late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
    late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocSnapshot;
    late MockTransaction mockTransaction;
    late MockWriteBatch mockBatch;
    late MockStream<QuerySnapshot<Map<String, dynamic>>> mockStream;
    late MockStreamSubscription<QuerySnapshot<Map<String, dynamic>>>
    mockSubscription;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference<Map<String, dynamic>>();
      mockDocRef = MockDocumentReference<Map<String, dynamic>>();
      mockDocSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      mockQueryDocSnapshot = MockQueryDocumentSnapshot<Map<String, dynamic>>();
      mockTransaction = MockTransaction();
      mockBatch = MockWriteBatch();
      mockStream = MockStream<QuerySnapshot<Map<String, dynamic>>>();
      mockSubscription =
          MockStreamSubscription<QuerySnapshot<Map<String, dynamic>>>();

      cartService = CartService(firestore: mockFirestore);

      // Setup common mocks
      when(mockFirestore.collection('carts')).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocRef);
      when(mockDocRef.collection('items')).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocRef);
      when(mockCollection.snapshots()).thenAnswer((_) => mockStream);
      when(mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockFirestore.runTransaction(any)).thenAnswer((_) async => null);
      when(mockFirestore.batch()).thenReturn(mockBatch);

      // Setup stream map mock
      when(mockStream.map(any)).thenAnswer((invocation) {
        final mapper = invocation.positionalArguments[0] as Function;
        return Stream<List<CartItemModel>>.value(mapper(mockQuerySnapshot));
      });

      // Setup document snapshot data mock
      when(mockDocSnapshot.data()).thenReturn(<String, dynamic>{});

      // Setup query snapshot docs mock
      when(mockQuerySnapshot.docs).thenReturn([]);
    });

    tearDown(() {
      // Clean up
    });

    group('Constructor Tests', () {
      test('should create CartService with default Firestore instance', () {
        // Act
        final service = CartService(firestore: mockFirestore);

        // Assert
        expect(service, isNotNull);
      });

      test('should create CartService with custom Firestore instance', () {
        // Act
        final service = CartService(firestore: mockFirestore);

        // Assert
        expect(service, isNotNull);
      });
    });

    group('Stream Cart Tests', () {
      test('should stream cart items successfully', () async {
        // Arrange
        final cartItems = [
          {
            'id': 'product-1',
            'product_name': 'Test Product 1',
            'quantity': 2,
            'nutriments': {'proteins_100g': 10.0},
          },
          {
            'id': 'product-2',
            'product_name': 'Test Product 2',
            'quantity': 1,
            'nutriments': {'proteins_100g': 15.0},
          },
        ];

        when(
          mockQuerySnapshot.docs,
        ).thenReturn([mockQueryDocSnapshot, mockQueryDocSnapshot]);
        when(mockQueryDocSnapshot.data()).thenReturn(cartItems[0]);
        when(mockStream.listen(any, onError: anyNamed('onError'))).thenAnswer((
          invocation,
        ) {
          final onData = invocation.positionalArguments[0] as Function;
          onData(mockQuerySnapshot);
          return mockSubscription;
        });

        // Act
        final stream = cartService.streamCart('test-user-id');
        final items = await stream.first;

        // Assert
        expect(items, isA<List<CartItemModel>>());
        verify(mockFirestore.collection('carts')).called(1);
        verify(mockCollection.doc('test-user-id')).called(1);
        verify(mockDocRef.collection('items')).called(1);
        verify(mockCollection.snapshots()).called(1);
      });

      test('should handle stream errors gracefully', () async {
        // Arrange
        when(mockStream.listen(any, onError: anyNamed('onError'))).thenAnswer((
          invocation,
        ) {
          final onError = invocation.namedArguments[#onError] as Function;
          onError(Exception('Stream error'));
          return mockSubscription;
        });

        // Act
        final stream = cartService.streamCart('test-user-id');
        final items = await stream.first;

        // Assert
        expect(items, isEmpty);
      });

      test('should return empty list when no items in cart', () async {
        // Arrange
        when(mockQuerySnapshot.docs).thenReturn([]);
        when(mockStream.listen(any, onError: anyNamed('onError'))).thenAnswer((
          invocation,
        ) {
          final onData = invocation.positionalArguments[0] as Function;
          onData(mockQuerySnapshot);
          return mockSubscription;
        });

        // Act
        final stream = cartService.streamCart('test-user-id');
        final items = await stream.first;

        // Assert
        expect(items, isEmpty);
      });
    });

    group('Add to Cart Tests', () {
      test('should add new item to cart', () async {
        // Arrange
        final item = CartItemModel(
          id: 'product-1',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {'proteins_100g': 10.0},
        );

        when(mockDocSnapshot.exists).thenReturn(false);
        when(mockTransaction.get(any)).thenAnswer((_) async => mockDocSnapshot);
        when(mockTransaction.set(any, any)).thenReturn(mockTransaction);
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionCallback =
              invocation.positionalArguments[0] as Function;
          await transactionCallback(mockTransaction);
          return null;
        });

        // Act
        await cartService.addToCart('test-user-id', item);

        // Assert
        verify(mockFirestore.runTransaction(any)).called(1);
        verify(mockTransaction.get(mockDocRef)).called(1);
        verify(mockTransaction.set(mockDocRef, item.toMap())).called(1);
        verifyNever(mockTransaction.update(any, any));
      });

      test('should increment quantity when item already exists', () async {
        // Arrange
        final item = CartItemModel(
          id: 'product-1',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {'proteins_100g': 10.0},
        );

        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn({'quantity': 2});
        when(mockTransaction.get(any)).thenAnswer((_) async => mockDocSnapshot);
        when(mockTransaction.update(any, any)).thenReturn(mockTransaction);
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionCallback =
              invocation.positionalArguments[0] as Function;
          await transactionCallback(mockTransaction);
          return null;
        });

        // Act
        await cartService.addToCart('test-user-id', item);

        // Assert
        verify(mockFirestore.runTransaction(any)).called(1);
        verify(mockTransaction.get(mockDocRef)).called(1);
        verify(mockTransaction.update(mockDocRef, {'quantity': 3})).called(1);
        verifyNever(mockTransaction.set(any, any));
      });

      test('should handle null quantity in existing item', () async {
        // Arrange
        final item = CartItemModel(
          id: 'product-1',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {'proteins_100g': 10.0},
        );

        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn({});
        when(mockTransaction.get(any)).thenAnswer((_) async => mockDocSnapshot);
        when(mockTransaction.update(any, any)).thenReturn(mockTransaction);
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionCallback =
              invocation.positionalArguments[0] as Function;
          await transactionCallback(mockTransaction);
          return null;
        });

        // Act
        await cartService.addToCart('test-user-id', item);

        // Assert
        verify(mockTransaction.update(mockDocRef, {'quantity': 1})).called(1);
      });

      test('should handle FirestoreException', () async {
        // Arrange
        final item = CartItemModel(
          id: 'product-1',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {'proteins_100g': 10.0},
        );

        when(
          mockFirestore.runTransaction(any),
        ).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () => cartService.addToCart('test-user-id', item),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Set Quantity Tests', () {
      test('should set quantity for existing item', () async {
        // Arrange
        when(mockDocRef.set(any, any)).thenAnswer((_) async => null);

        // Act
        await cartService.setQuantity('test-user-id', 'product-1', 5);

        // Assert
        verify(mockDocRef.set({'quantity': 5}, any)).called(1);
      });

      test('should remove item when quantity is zero', () async {
        // Arrange
        when(mockDocRef.delete()).thenAnswer((_) async => null);

        // Act
        await cartService.setQuantity('test-user-id', 'product-1', 0);

        // Assert
        verify(mockDocRef.delete()).called(1);
        verifyNever(mockDocRef.set(any, any));
      });

      test('should remove item when quantity is negative', () async {
        // Arrange
        when(mockDocRef.delete()).thenAnswer((_) async => null);

        // Act
        await cartService.setQuantity('test-user-id', 'product-1', -1);

        // Assert
        verify(mockDocRef.delete()).called(1);
        verifyNever(mockDocRef.set(any, any));
      });

      test('should handle FirestoreException', () async {
        // Arrange
        when(mockDocRef.set(any, any)).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () => cartService.setQuantity('test-user-id', 'product-1', 5),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Increase Quantity Tests', () {
      test('should increase quantity for existing item', () async {
        // Arrange
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn({'quantity': 3});
        when(mockTransaction.get(any)).thenAnswer((_) async => mockDocSnapshot);
        when(mockTransaction.update(any, any)).thenReturn(mockTransaction);
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionCallback =
              invocation.positionalArguments[0] as Function;
          await transactionCallback(mockTransaction);
          return null;
        });

        // Act
        await cartService.increaseQuantity('test-user-id', 'product-1');

        // Assert
        verify(mockTransaction.update(mockDocRef, {'quantity': 4})).called(1);
      });

      test('should not increase quantity for non-existent item', () async {
        // Arrange
        when(mockDocSnapshot.exists).thenReturn(false);
        when(mockTransaction.get(any)).thenAnswer((_) async => mockDocSnapshot);
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionCallback =
              invocation.positionalArguments[0] as Function;
          await transactionCallback(mockTransaction);
          return null;
        });

        // Act
        await cartService.increaseQuantity('test-user-id', 'product-1');

        // Assert
        verifyNever(mockTransaction.update(any, any));
        verifyNever(mockTransaction.set(any, any));
      });

      test('should handle null quantity in existing item', () async {
        // Arrange
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn({});
        when(mockTransaction.get(any)).thenAnswer((_) async => mockDocSnapshot);
        when(mockTransaction.update(any, any)).thenReturn(mockTransaction);
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionCallback =
              invocation.positionalArguments[0] as Function;
          await transactionCallback(mockTransaction);
          return null;
        });

        // Act
        await cartService.increaseQuantity('test-user-id', 'product-1');

        // Assert
        verify(mockTransaction.update(mockDocRef, {'quantity': 1})).called(1);
      });

      test('should handle FirestoreException', () async {
        // Arrange
        when(
          mockFirestore.runTransaction(any),
        ).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () => cartService.increaseQuantity('test-user-id', 'product-1'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Decrease Quantity Tests', () {
      test('should decrease quantity for existing item', () async {
        // Arrange
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn({'quantity': 3});
        when(mockTransaction.get(any)).thenAnswer((_) async => mockDocSnapshot);
        when(mockTransaction.update(any, any)).thenReturn(mockTransaction);
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionCallback =
              invocation.positionalArguments[0] as Function;
          await transactionCallback(mockTransaction);
          return null;
        });

        // Act
        await cartService.decreaseQuantity('test-user-id', 'product-1');

        // Assert
        verify(mockTransaction.update(mockDocRef, {'quantity': 2})).called(1);
        verifyNever(mockTransaction.delete(any));
      });

      test('should remove item when quantity becomes zero', () async {
        // Arrange
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn({'quantity': 1});
        when(mockTransaction.get(any)).thenAnswer((_) async => mockDocSnapshot);
        when(mockTransaction.delete(any)).thenReturn(mockTransaction);
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionCallback =
              invocation.positionalArguments[0] as Function;
          await transactionCallback(mockTransaction);
          return null;
        });

        // Act
        await cartService.decreaseQuantity('test-user-id', 'product-1');

        // Assert
        verify(mockTransaction.delete(mockDocRef)).called(1);
        verifyNever(mockTransaction.update(any, any));
      });

      test('should not decrease quantity for non-existent item', () async {
        // Arrange
        when(mockDocSnapshot.exists).thenReturn(false);
        when(mockTransaction.get(any)).thenAnswer((_) async => mockDocSnapshot);
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionCallback =
              invocation.positionalArguments[0] as Function;
          await transactionCallback(mockTransaction);
          return null;
        });

        // Act
        await cartService.decreaseQuantity('test-user-id', 'product-1');

        // Assert
        verifyNever(mockTransaction.update(any, any));
        verifyNever(mockTransaction.delete(any));
      });

      test('should handle null quantity in existing item', () async {
        // Arrange
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn({});
        when(mockTransaction.get(any)).thenAnswer((_) async => mockDocSnapshot);
        when(mockTransaction.delete(any)).thenReturn(mockTransaction);
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionCallback =
              invocation.positionalArguments[0] as Function;
          await transactionCallback(mockTransaction);
          return null;
        });

        // Act
        await cartService.decreaseQuantity('test-user-id', 'product-1');

        // Assert
        verify(mockTransaction.delete(mockDocRef)).called(1);
      });

      test('should handle FirestoreException', () async {
        // Arrange
        when(
          mockFirestore.runTransaction(any),
        ).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () => cartService.decreaseQuantity('test-user-id', 'product-1'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Remove from Cart Tests', () {
      test('should remove item from cart', () async {
        // Arrange
        when(mockDocRef.delete()).thenAnswer((_) async => null);

        // Act
        await cartService.removeFromCart('test-user-id', 'product-1');

        // Assert
        verify(mockDocRef.delete()).called(1);
      });

      test('should handle FirestoreException', () async {
        // Arrange
        when(mockDocRef.delete()).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () => cartService.removeFromCart('test-user-id', 'product-1'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Clear Cart Tests', () {
      test('should clear all items from cart', () async {
        // Arrange
        when(
          mockQuerySnapshot.docs,
        ).thenReturn([mockQueryDocSnapshot, mockQueryDocSnapshot]);
        when(mockQueryDocSnapshot.reference).thenReturn(mockDocRef);
        when(mockBatch.delete(any)).thenReturn(null);
        when(mockBatch.commit()).thenAnswer((_) async => null);

        // Act
        await cartService.clearCart('test-user-id');

        // Assert
        verify(mockCollection.get()).called(1);
        verify(mockBatch.delete(mockDocRef)).called(2);
        verify(mockBatch.commit()).called(1);
      });

      test('should handle empty cart', () async {
        // Arrange
        when(mockQuerySnapshot.docs).thenReturn([]);
        when(mockBatch.commit()).thenAnswer((_) async => null);

        // Act
        await cartService.clearCart('test-user-id');

        // Assert
        verify(mockCollection.get()).called(1);
        verifyNever(mockBatch.delete(any));
        verify(mockBatch.commit()).called(1);
      });

      test('should handle FirestoreException', () async {
        // Arrange
        when(mockCollection.get()).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () => cartService.clearCart('test-user-id'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Set All Items Tests', () {
      test('should set all items in cart', () async {
        // Arrange
        final items = [
          CartItemModel(
            id: 'product-1',
            productName: 'Test Product 1',
            quantity: 2,
            nutriments: {'proteins_100g': 10.0},
          ),
          CartItemModel(
            id: 'product-2',
            productName: 'Test Product 2',
            quantity: 1,
            nutriments: {'proteins_100g': 15.0},
          ),
        ];

        when(mockBatch.set(any, any)).thenReturn(null);
        when(mockBatch.commit()).thenAnswer((_) async => null);

        // Act
        await cartService.setAllItems('test-user-id', items);

        // Assert
        verify(mockBatch.set(any, any)).called(2);
        verify(mockBatch.commit()).called(1);
      });

      test('should handle empty items list', () async {
        // Arrange
        when(mockBatch.commit()).thenAnswer((_) async => null);

        // Act
        await cartService.setAllItems('test-user-id', []);

        // Assert
        verifyNever(mockBatch.set(any, any));
        verify(mockBatch.commit()).called(1);
      });

      test('should handle FirestoreException', () async {
        // Arrange
        final items = [
          CartItemModel(
            id: 'product-1',
            productName: 'Test Product 1',
            quantity: 1,
            nutriments: {'proteins_100g': 10.0},
          ),
        ];

        when(mockBatch.commit()).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () => cartService.setAllItems('test-user-id', items),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Edge Cases Tests', () {
      test('should handle empty user ID', () async {
        // Arrange
        final item = CartItemModel(
          id: 'product-1',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {'proteins_100g': 10.0},
        );

        when(mockDocSnapshot.exists).thenReturn(false);
        when(mockTransaction.get(any)).thenAnswer((_) async => mockDocSnapshot);
        when(mockTransaction.set(any, any)).thenReturn(mockTransaction);
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionCallback =
              invocation.positionalArguments[0] as Function;
          await transactionCallback(mockTransaction);
          return null;
        });

        // Act
        await cartService.addToCart('', item);

        // Assert
        verify(mockFirestore.collection('carts')).called(1);
        verify(mockCollection.doc('')).called(1);
      });

      test('should handle special characters in user ID', () async {
        // Arrange
        final specialUserId = 'user@#\$%^&*()_+{}|:"<>?[]\\\\;\',./';
        final item = CartItemModel(
          id: 'product-1',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {'proteins_100g': 10.0},
        );

        when(mockDocSnapshot.exists).thenReturn(false);
        when(mockTransaction.get(any)).thenAnswer((_) async => mockDocSnapshot);
        when(mockTransaction.set(any, any)).thenReturn(mockTransaction);
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionCallback =
              invocation.positionalArguments[0] as Function;
          await transactionCallback(mockTransaction);
          return null;
        });

        // Act
        await cartService.addToCart(specialUserId, item);

        // Assert
        verify(mockCollection.doc(specialUserId)).called(1);
      });

      test('should handle very large quantity values', () async {
        // Arrange
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn({'quantity': 999999});
        when(mockTransaction.get(any)).thenAnswer((_) async => mockDocSnapshot);
        when(mockTransaction.update(any, any)).thenReturn(mockTransaction);
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionCallback =
              invocation.positionalArguments[0] as Function;
          await transactionCallback(mockTransaction);
          return null;
        });

        // Act
        await cartService.increaseQuantity('test-user-id', 'product-1');

        // Assert
        verify(
          mockTransaction.update(mockDocRef, {'quantity': 1000000}),
        ).called(1);
      });
    });
  });
}
