import 'package:arya/features/index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage(name: 'ProductsRoute')
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
            initialCategory?.isNotEmpty == true
                ? initialCategory!
                : 'store.search_products'.tr(),
          ),
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onSurface,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'store.add_product'.tr(),
              onPressed: () {
                context.router.push(const AddProductRoute());
              },
            ),
          ],
        ),
        backgroundColor: appColors?.surfaceMuted ?? scheme.surface,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [SearchStoreBar()]),
            ),
            Expanded(
              child: Consumer<StoreViewModel>(
                builder: (context, model, child) {
                  return ProductList();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
