import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:arya/features/store/model/cart_item_model.dart';

class CartViewModel extends ChangeNotifier {
  final List<CartItemModel> _cartItems = [];
  final StreamController<List<CartItemModel>> _cartController =
      StreamController<List<CartItemModel>>.broadcast();

  Stream<List<CartItemModel>> get cartStream => _cartController.stream;
  List<CartItemModel> get cartItems => List.unmodifiable(_cartItems);

  void addToCart(CartItemModel item) {
    final existingIndex = _cartItems.indexWhere(
      (element) => element.id == item.id,
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + 1,
      );
    } else {
      _cartItems.add(item);
    }

    _updateCart();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.id == productId);
    _updateCart();
  }

  void increaseQuantity(String productId) {
    final index = _cartItems.indexWhere((item) => item.id == productId);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity + 1,
      );
      _updateCart();
    }
  }

  void decreaseQuantity(String productId) {
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
  }

  void clearCart() {
    _cartItems.clear();
    _updateCart();
  }

  void _updateCart() {
    _cartController.add(List.unmodifiable(_cartItems));
    notifyListeners();
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
    _cartController.close();
    super.dispose();
  }
}
