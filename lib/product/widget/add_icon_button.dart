import 'package:arya/features/store/view_model/store_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
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
    icon: Icon(
      Icons.add, // sadece artı işareti
      color: AppColors.of(context).white,
    ),
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        appColors?.primary ?? scheme.primary,
      ),
      shape: WidgetStateProperty.all(const CircleBorder()),
    ),
    onPressed: () async {
      await context.read<StoreViewModel>().addProductToCart(context, product);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('store.added_to_cart'.tr())));
    },
  );
}
