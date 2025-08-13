import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
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
      // Product Map'ini CartItemModel'e dönüştür
      final cartItem = CartItemModel(
        id: product['id']?.toString() ?? '',
        productName: product['product_name']?.toString() ?? 'İsimsiz Ürün',
        brands: product['brands']?.toString(),
        imageThumbUrl: product['image_thumb_url']?.toString(),
        quantity: quantity,
        nutriments:
            (product['nutriments'] as Map<String, dynamic>?) ?? const {},
      );

      Provider.of<CartViewModel>(context, listen: false).addToCart(cartItem);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$quantity adet ürün sepete eklendi'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    },
  );
}
