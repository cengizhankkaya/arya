import 'package:arya/features/store/view_model/store_view_model.dart';
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
      backgroundColor: MaterialStateProperty.all(
        appColors?.primary ?? scheme.primary,
      ),
      shape: MaterialStateProperty.all(const CircleBorder()),
    ),
    onPressed: () async {
      await context.read<StoreViewModel>().addProductToCart(context, product);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ürün sepete eklendi')));
    },
  );
}
