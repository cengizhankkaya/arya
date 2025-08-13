import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

ElevatedButton addElevatedButton(
  ColorScheme scheme,
  BuildContext context,
  Map<String, dynamic> product, {
  int quantity = 1,
}) {
  return ElevatedButton.icon(
    style:
        ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4, // Normalde gölge
          shadowColor: Colors.black.withOpacity(0.3),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(
            scheme.onPrimary.withOpacity(0.1), // Basıldığında renk değişimi
          ),
          elevation: WidgetStateProperty.resolveWith<double>(
            (states) => states.contains(WidgetState.pressed)
                ? 1
                : 4, // Basınca gölge azalır
          ),
        ),
    icon: const Icon(Icons.add_shopping_cart),
    label: const Text(
      'Sepete Ekle',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    onPressed: () {
      Provider.of<CartViewModel>(
        context,
        listen: false,
      ).addToCart(product, quantity: quantity);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ürün sepete eklendi')));
    },
  );
}
