import 'package:arya/features/store/widget/country_dropdown_widget.dart';
import 'package:arya/features/store/widget/product_list_widget.dart';
import 'package:arya/features/store/widget/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../view_model/store_view_model.dart';

class ProductsPage extends StatelessWidget {
  final String? initialCategory;

  ProductsPage({this.initialCategory});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    return ChangeNotifierProvider(
      create: (_) {
        final vm = StoreViewModel();
        if (initialCategory != null && initialCategory!.isNotEmpty) {
          vm.fetchByCategory(initialCategory!);
        } else {
          vm.fetchRandomProducts();
        }
        return vm;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            initialCategory?.isNotEmpty == true ? initialCategory! : 'Ürün Ara',
          ),
          backgroundColor: scheme.surface,
          foregroundColor: scheme.onSurface,
          elevation: 0,
        ),
        backgroundColor: appColors?.surfaceMuted ?? scheme.surface,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CountryDropdown(),
                  const SizedBox(height: 16),
                  SearchStoreBar(),
                ],
              ),
            ),
            Expanded(child: ProductList()),
          ],
        ),
      ),
    );
  }
}
