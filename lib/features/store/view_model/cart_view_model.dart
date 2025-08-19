import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
import 'package:arya/features/store/services/cart_service.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel({CartService? cartService, FirebaseAuth? firebaseAuth})
    : _cartService = cartService ?? CartService(),
      _auth = firebaseAuth ?? FirebaseAuth.instance {
    print('CartViewModel constructor called'); // Debug
    // Constructor'da hemen boş liste yayınla
    _cartController.add([]);
    // Auth dinlemeyi başlat
    _listenAuthAndCart();
  }

  final CartService _cartService;
  final FirebaseAuth _auth;

  final List<CartItemModel> _cartItems = [];
  final StreamController<List<CartItemModel>> _cartController =
      StreamController<List<CartItemModel>>.broadcast();
  StreamSubscription? _cartSub;

  Stream<List<CartItemModel>> get cartStream => _cartController.stream;
  List<CartItemModel> get cartItems => List.unmodifiable(_cartItems);

  Future<void> addToCart(CartItemModel item) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      _addLocal(item);
      return;
    }
    await _cartService.addToCart(uid, item);
  }

  Future<void> removeFromCart(String productId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      _cartItems.removeWhere((item) => item.id == productId);
      _updateCart();
      return;
    }
    await _cartService.removeFromCart(uid, productId);
  }

  Future<void> increaseQuantity(String productId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      final index = _cartItems.indexWhere((item) => item.id == productId);
      if (index != -1) {
        _cartItems[index] = _cartItems[index].copyWith(
          quantity: _cartItems[index].quantity + 1,
        );
        _updateCart();
      }
      return;
    }
    await _cartService.increaseQuantity(uid, productId);
  }

  Future<void> decreaseQuantity(String productId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      final index = _cartItems.indexWhere((item) => item.id == productId);
      if (index != -1) {
        if (_cartItems[index].quantity > 1) {
          _cartItems[index] = _cartItems[index].copyWith(
            quantity: _cartItems[index].quantity - 1,
          );
        } else {
          _cartItems.removeAt(index);
        }
        _updateCart();
      }
      return;
    }
    await _cartService.decreaseQuantity(uid, productId);
  }

  Future<void> clearCart() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      _cartItems.clear();
      _updateCart();
      return;
    }
    await _cartService.clearCart(uid);
  }

  void _updateCart() {
    print('CartViewModel: Updating cart: ${_cartItems.length} items');
    for (final item in _cartItems) {
      print('  - ${item.productName}: ${item.imageThumbUrl}');
    }
    print('CartViewModel: Publishing to stream');
    _cartController.add(List.unmodifiable(_cartItems));
    notifyListeners();
  }

  void _addLocal(CartItemModel item) {
    print('CartViewModel: Adding to local cart:');
    print('  Product: ${item.productName}');
    print('  Image URL: ${item.imageThumbUrl}');

    final existingIndex = _cartItems.indexWhere(
      (element) => element.id == item.id,
    );
    if (existingIndex != -1) {
      print('  Item already exists, increasing quantity');
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + 1,
      );
    } else {
      print('  Adding new item to local cart');
      _cartItems.add(item);
    }
    _updateCart();
  }

  void _listenAuthAndCart() {
    // Mevcut kullanıcı varsa hemen sepeti yükle
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      print('Current user exists: ${currentUser.uid}'); // Debug
      _setupCartStream(currentUser.uid);
    } else {
      // Kullanıcı giriş yapmamışsa hemen boş liste yayınla
      print('No user logged in, publishing empty cart'); // Debug
      _cartController.add([]);
    }

    // Auth değişince sepet akışını yeniden bağla
    _auth.userChanges().listen((user) {
      print('Auth changed: ${user?.uid}'); // Debug
      _cartSub?.cancel();
      if (user == null) {
        print('User logged out, clearing cart'); // Debug
        _cartItems.clear();
        _updateCart();
        return;
      }

      print('User logged in, setting up cart stream'); // Debug
      _setupCartStream(user.uid);
    });
  }

  void _setupCartStream(String uid) {
    print('CartViewModel: Setting up cart stream for user: $uid'); // Debug

    // Firebase stream'ini dinle
    _cartSub = _cartService
        .streamCart(uid)
        .listen(
          (items) {
            print('Cart stream received: ${items.length} items'); // Debug
            _cartItems
              ..clear()
              ..addAll(items);
            _updateCart();
          },
          onError: (error) {
            print('Cart stream error: $error'); // Debug
            // Hata durumunda boş liste yayınla
            _cartItems.clear();
            _updateCart();
          },
        );
  }

  double get totalKcal {
    double total = 0;
    for (final item in _cartItems) {
      final energyKcal = _parseNumber(item.nutriments['energy-kcal_100g']);
      total += energyKcal * item.quantity;
    }
    return total;
  }

  double get totalProtein {
    double total = 0;
    for (final item in _cartItems) {
      final protein = _parseNumber(item.nutriments['proteins_100g']);
      total += protein * item.quantity;
    }
    return total;
  }

  double _parseNumber(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value.replaceAll(',', '.'));
      return parsed ?? 0.0;
    }
    return 0.0;
  }

  @override
  void dispose() {
    _cartSub?.cancel();
    _cartController.close();
    super.dispose();
  }
}
