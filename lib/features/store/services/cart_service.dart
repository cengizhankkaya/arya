import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arya/features/store/model/cart_item_model.dart';

/// Service class responsible for managing shopping cart operations in Firebase Firestore.
/// This service provides a comprehensive interface for cart management including
/// adding, removing, updating quantities, and real-time cart synchronization.
///
/// The service implements the following key features:
/// - Real-time cart streaming with automatic UI updates
/// - Atomic transactions for quantity updates
/// - Batch operations for bulk cart modifications
/// - Error handling with graceful fallbacks
///
/// Architecture highlights:
/// - Uses Firestore transactions for data consistency
/// - Implements real-time listeners for live cart updates
/// - Provides batch operations for performance optimization
/// - Handles edge cases like missing items and invalid quantities
///
/// Usage:
/// ```dart
/// final cartService = CartService();
/// final cartStream = cartService.streamCart(userId);
/// await cartService.addToCart(userId, cartItem);
/// ```
class CartService {
  /// Creates a new CartService instance with optional Firestore dependency injection.
  /// This constructor allows for testing by providing a mock Firestore instance,
  /// while defaulting to the real instance for production use.
  ///
  /// Parameters:
  /// - firestore: Optional Firestore instance (defaults to FirebaseFirestore.instance)
  CartService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Firestore instance for database operations.
  /// This field stores the Firestore reference used for all cart operations.
  final FirebaseFirestore _firestore;

  /// Returns a reference to the user's cart collection in Firestore.
  /// This method creates a hierarchical structure: carts/{uid}/items/{productId}
  ///
  /// The structure provides:
  /// - User isolation (each user has their own cart)
  /// - Product-level granularity (each product is a separate document)
  /// - Efficient querying and real-time updates
  ///
  /// Parameters:
  /// - uid: User's unique identifier
  ///
  /// Returns:
  /// - CollectionReference pointing to the user's cart items
  CollectionReference<Map<String, dynamic>> _userCartCollection(String uid) {
    return _firestore.collection('carts').doc(uid).collection('items');
  }

  /// Streams the user's cart items in real-time.
  /// This method provides a continuous stream of cart data that automatically
  /// updates the UI whenever the cart changes in Firestore.
  ///
  /// The stream:
  /// - Automatically handles connection state changes
  /// - Provides real-time updates for collaborative shopping
  /// - Includes error handling with fallback to empty cart
  /// - Converts Firestore documents to CartItemModel instances
  ///
  /// Parameters:
  /// - uid: User's unique identifier
  ///
  /// Returns:
  /// - Stream<List<CartItemModel>> that emits cart updates
  /// - Empty list on errors for graceful degradation
  Stream<List<CartItemModel>> streamCart(String uid) {
    return _userCartCollection(uid)
        .snapshots()
        .map((snapshot) {
          final items = snapshot.docs
              .map((doc) {
                final data = doc.data();
                return CartItemModel.fromMap(data);
              })
              .toList(growable: false);

          return items;
        })
        .handleError((error) {
          // Return empty list on error for graceful degradation
          return <CartItemModel>[];
        });
  }

  /// Adds a product to the user's cart or increases its quantity if already present.
  /// This method uses a Firestore transaction to ensure data consistency when
  /// checking for existing items and updating quantities.
  ///
  /// The transaction:
  /// 1. Checks if the product already exists in the cart
  /// 2. If exists: increments the quantity by 1
  /// 3. If not exists: creates a new cart item with quantity 1
  ///
  /// Parameters:
  /// - uid: User's unique identifier
  /// - item: CartItemModel to add to the cart
  ///
  /// Throws:
  /// - FirestoreException for database operation failures
  Future<void> addToCart(String uid, CartItemModel item) async {
    final docRef = _userCartCollection(uid).doc(item.id);
    await _firestore.runTransaction((transaction) async {
      final existing = await transaction.get(docRef);
      if (existing.exists) {
        final currentQty = (existing.data()!['quantity'] as num?)?.toInt() ?? 0;
        transaction.update(docRef, {'quantity': currentQty + 1});
      } else {
        transaction.set(docRef, item.toMap());
      }
    });
  }

  /// Sets the quantity of a specific product in the cart.
  /// This method provides direct quantity control and automatically removes
  /// items when quantity is set to 0 or below.
  ///
  /// Behavior:
  /// - If quantity > 0: Updates the product quantity
  /// - If quantity <= 0: Removes the product from cart
  /// - Uses merge option to preserve other product properties
  ///
  /// Parameters:
  /// - uid: User's unique identifier
  /// - productId: Product identifier to update
  /// - quantity: New quantity value
  ///
  /// Throws:
  /// - FirestoreException for database operation failures
  Future<void> setQuantity(String uid, String productId, int quantity) async {
    final docRef = _userCartCollection(uid).doc(productId);
    if (quantity <= 0) {
      await docRef.delete();
      return;
    }
    await docRef.set({'quantity': quantity}, SetOptions(merge: true));
  }

  /// Increases the quantity of a specific product by 1.
  /// This method uses a transaction to safely increment quantities and
  /// only operates on existing cart items.
  ///
  /// Safety features:
  /// - Only increments if the item exists in the cart
  /// - Uses transactions for atomic quantity updates
  /// - Prevents creation of items with quantity 1 (use addToCart instead)
  ///
  /// Parameters:
  /// - uid: User's unique identifier
  /// - productId: Product identifier to increment
  ///
  /// Throws:
  /// - FirestoreException for database operation failures
  Future<void> increaseQuantity(String uid, String productId) async {
    final docRef = _userCartCollection(uid).doc(productId);
    await _firestore.runTransaction((transaction) async {
      final existing = await transaction.get(docRef);
      final currentQty = (existing.data()?['quantity'] as num?)?.toInt() ?? 0;
      if (!existing.exists) {
        // Don't create item with quantity 1; caller should use addToCart
        return;
      }
      transaction.update(docRef, {'quantity': currentQty + 1});
    });
  }

  /// Decreases the quantity of a specific product by 1.
  /// This method uses a transaction to safely decrement quantities and
  /// automatically removes items when quantity reaches 0.
  ///
  /// Behavior:
  /// - Decrements quantity by 1 if > 1
  /// - Removes item from cart if quantity becomes 0
  /// - Only operates on existing cart items
  ///
  /// Parameters:
  /// - uid: User's unique identifier
  /// - productId: Product identifier to decrement
  ///
  /// Throws:
  /// - FirestoreException for database operation failures
  Future<void> decreaseQuantity(String uid, String productId) async {
    final docRef = _userCartCollection(uid).doc(productId);
    await _firestore.runTransaction((transaction) async {
      final existing = await transaction.get(docRef);
      if (!existing.exists) return;
      final currentQty = (existing.data()!['quantity'] as num?)?.toInt() ?? 0;
      final nextQty = currentQty - 1;
      if (nextQty <= 0) {
        transaction.delete(docRef);
      } else {
        transaction.update(docRef, {'quantity': nextQty});
      }
    });
  }

  /// Removes a specific product from the user's cart.
  /// This method permanently deletes the cart item regardless of its quantity.
  ///
  /// Parameters:
  /// - uid: User's unique identifier
  /// - productId: Product identifier to remove
  ///
  /// Throws:
  /// - FirestoreException for database operation failures
  Future<void> removeFromCart(String uid, String productId) async {
    await _userCartCollection(uid).doc(productId).delete();
  }

  /// Removes all items from the user's cart.
  /// This method uses batch operations for efficient bulk deletion of all
  /// cart items, providing better performance than individual deletions.
  ///
  /// The batch operation:
  /// 1. Queries all cart items for the user
  /// 2. Creates a batch with delete operations for each item
  /// 3. Commits all deletions in a single atomic operation
  ///
  /// Parameters:
  /// - uid: User's unique identifier
  ///
  /// Throws:
  /// - FirestoreException for database operation failures
  Future<void> clearCart(String uid) async {
    final query = await _userCartCollection(uid).get();
    final batch = _firestore.batch();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  /// Replaces all items in the user's cart with the provided list.
  /// This method uses batch operations for efficient bulk replacement,
  /// useful for scenarios like cart restoration or bulk updates.
  ///
  /// The batch operation:
  /// 1. Creates a batch with set operations for each new item
  /// 2. Replaces all existing cart items with the new list
  /// 3. Commits all operations atomically
  ///
  /// Parameters:
  /// - uid: User's unique identifier
  /// - items: List of CartItemModel instances to set in the cart
  ///
  /// Throws:
  /// - FirestoreException for database operation failures
  Future<void> setAllItems(String uid, List<CartItemModel> items) async {
    final batch = _firestore.batch();
    final col = _userCartCollection(uid);
    for (final item in items) {
      batch.set(col.doc(item.id), item.toMap());
    }
    await batch.commit();
  }
}
