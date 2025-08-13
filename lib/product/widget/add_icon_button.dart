import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

IconButton addButton(
  AppColors? appColors,
  ColorScheme scheme,
  BuildContext context,
  product,
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
      Provider.of<CartViewModel>(context, listen: false).addToCart(product);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ürün sepete eklendi')));
    },
  );
}
