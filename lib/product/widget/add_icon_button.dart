import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

IconButton addButton(
  AppColors? appColors,
  ColorScheme scheme,
  BuildContext context,
  Map<String, dynamic> product,
) {
  return IconButton(
    icon: const Icon(
      Icons.add, // sadece artı işareti
      color: Colors.white,
    ),
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        appColors?.primary ?? scheme.primary,
      ),
      shape: WidgetStateProperty.all(const CircleBorder()),
    ),
    onPressed: () {
      // Product Map'ini CartItemModel'e dönüştür
      final cartItem = CartItemModel(
        id: product['id']?.toString() ?? '',
        productName: product['product_name']?.toString() ?? 'İsimsiz Ürün',
        brands: product['brands']?.toString(),
        imageThumbUrl: product['image_thumb_url']?.toString(),
        quantity: 1,
        nutriments:
            (product['nutriments'] as Map<String, dynamic>?) ?? const {},
      );

      Provider.of<CartViewModel>(context, listen: false).addToCart(cartItem);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ürün sepete eklendi')));
    },
  );
}
