import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arya/features/store/model/cart_item_model.dart';

class CartService {
  CartService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _userCartCollection(String uid) {
    return _firestore.collection('carts').doc(uid).collection('items');
  }

  Stream<List<CartItemModel>> streamCart(String uid) {
    print('CartService: Starting stream for user: $uid'); // Debug
    return _userCartCollection(uid)
        .snapshots()
        .map((snapshot) {
          print(
            'CartService: Received snapshot with ${snapshot.docs.length} docs',
          ); // Debug
          return snapshot.docs
              .map((doc) => CartItemModel.fromMap(doc.data()))
              .toList(growable: false);
        })
        .handleError((error) {
          print('CartService: Error in stream: $error'); // Debug
          // Hata durumunda boş liste döndür
          return <CartItemModel>[];
        });
  }

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

  Future<void> setQuantity(String uid, String productId, int quantity) async {
    final docRef = _userCartCollection(uid).doc(productId);
    if (quantity <= 0) {
      await docRef.delete();
      return;
    }
    await docRef.set({'quantity': quantity}, SetOptions(merge: true));
  }

  Future<void> increaseQuantity(String uid, String productId) async {
    final docRef = _userCartCollection(uid).doc(productId);
    await _firestore.runTransaction((transaction) async {
      final existing = await transaction.get(docRef);
      final currentQty = (existing.data()?['quantity'] as num?)?.toInt() ?? 0;
      if (!existing.exists) {
        // Item yoksa bir adet olarak oluşturmayalım; çağıran addToCart kullanmalı
        return;
      }
      transaction.update(docRef, {'quantity': currentQty + 1});
    });
  }

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

  Future<void> removeFromCart(String uid, String productId) async {
    await _userCartCollection(uid).doc(productId).delete();
  }

  Future<void> clearCart(String uid) async {
    final query = await _userCartCollection(uid).get();
    final batch = _firestore.batch();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<void> setAllItems(String uid, List<CartItemModel> items) async {
    final batch = _firestore.batch();
    final col = _userCartCollection(uid);
    for (final item in items) {
      batch.set(col.doc(item.id), item.toMap());
    }
    await batch.commit();
  }
}
