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
          (snapshot) => snapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList(),
        );
  }

  Future<void> addToCart(Map<String, dynamic> product) async {
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
      await _firestore
          .collection('carts')
          .doc(userId)
          .collection('items')
          .add(safeProduct);
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
}
