import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onSurface,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Ürün ekle',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddProductScreen()),
                );
              },
            ),
          ],
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
