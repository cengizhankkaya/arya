import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser?.uid ?? '';

  Stream<List<Map<String, dynamic>>> get cartStream {
    if (userId.isEmpty) return const Stream.empty();
    return _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            final quantityRaw = data['quantity'];
            final quantity = quantityRaw is int
                ? quantityRaw
                : (quantityRaw is num ? quantityRaw.toInt() : 1);
            return {
              ...data,
              'id': doc.id,
              'quantity': quantity < 1 ? 1 : quantity,
            };
          }).toList(),
        );
  }

  Future<void> addToCart(
    Map<String, dynamic> product, {
    int quantity = 1,
  }) async {
    if (userId.isEmpty) return;
    // Null ve tip kontrolleri
    final safeProduct = <String, dynamic>{
      'product_name': product['product_name'] ?? 'İsimsiz',
      'brands': product['brands'] ?? '-',
      'image_thumb_url': product['image_thumb_url'] ?? '',
      'code': product['code']?.toString() ?? '-',
      'ingredients_text': product['ingredients_text'] ?? '-',
      'nutriments': product['nutriments'] is Map<String, dynamic>
          ? product['nutriments']
          : {},
    };
    try {
      // Aynı üründen varsa miktarı artır, yoksa yeni ekle
      final code = safeProduct['code'];
      final itemsRef = _firestore
          .collection('carts')
          .doc(userId)
          .collection('items');

      if (code != null && code != '-') {
        final existing = await itemsRef
            .where('code', isEqualTo: code)
            .limit(1)
            .get();
        if (existing.docs.isNotEmpty) {
          final docRef = existing.docs.first.reference;
          await _firestore.runTransaction((txn) async {
            final snap = await txn.get(docRef);
            final currentQtyRaw = snap.data()?['quantity'];
            final currentQty = currentQtyRaw is int
                ? currentQtyRaw
                : (currentQtyRaw is num ? currentQtyRaw.toInt() : 0);
            final newQty = (currentQty) + (quantity <= 0 ? 1 : quantity);
            txn.update(docRef, {'quantity': newQty});
          });
        } else {
          await itemsRef.add({
            ...safeProduct,
            'quantity': quantity <= 0 ? 1 : quantity,
          });
        }
      } else {
        await itemsRef.add({
          ...safeProduct,
          'quantity': quantity <= 0 ? 1 : quantity,
        });
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Sepete eklerken hata: \\${e.toString()}');
    }
  }

  Future<void> removeFromCart(String productId) async {
    if (userId.isEmpty) return;
    await _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(productId)
        .delete();
    notifyListeners();
  }

  Future<void> clearCart() async {
    if (userId.isEmpty) return;
    final batch = _firestore.batch();
    final items = await _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .get();
    for (var doc in items.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    notifyListeners();
  }

  Future<void> increaseQuantity(String productId, {int by = 1}) async {
    if (userId.isEmpty) return;
    final docRef = _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(productId);
    await _firestore.runTransaction((txn) async {
      final snap = await txn.get(docRef);
      if (!snap.exists) return;
      final currentQtyRaw = snap.data()?['quantity'];
      final currentQty = currentQtyRaw is int
          ? currentQtyRaw
          : (currentQtyRaw is num ? currentQtyRaw.toInt() : 0);
      final newQty = (currentQty) + (by <= 0 ? 1 : by);
      txn.update(docRef, {'quantity': newQty});
    });
    notifyListeners();
  }

  Future<void> decreaseQuantity(String productId, {int by = 1}) async {
    if (userId.isEmpty) return;
    final docRef = _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(productId);
    await _firestore.runTransaction((txn) async {
      final snap = await txn.get(docRef);
      if (!snap.exists) return;
      final currentQtyRaw = snap.data()?['quantity'];
      final currentQty = currentQtyRaw is int
          ? currentQtyRaw
          : (currentQtyRaw is num ? currentQtyRaw.toInt() : 0);
      final newQty = currentQty - (by <= 0 ? 1 : by);
      if (newQty <= 0) {
        txn.delete(docRef);
      } else {
        txn.update(docRef, {'quantity': newQty});
      }
    });
    notifyListeners();
  }
}
