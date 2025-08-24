import 'package:arya/features/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, model, child) {
        final scheme = Theme.of(context).colorScheme;
        final appColors = Theme.of(context).extension<AppColors>();

        if (model.isLoading) {
          return const ProductShimmerWidget();
        }

        if (model.products.isEmpty) {
          return Center(child: Text('store.no_products'.tr()));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              if (!model.isLoadingMore && model.hasMoreProducts) {
                model.loadMoreProducts();
              }
            }
            return false;
          },
          child: GridView.builder(
            padding: ProjectPadding.allSmall(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: model.products.length + (model.isLoadingMore ? 2 : 0),
            itemBuilder: (context, index) {
              if (index == model.products.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleProductShimmerCard(),
                );
              }
              if (index == model.products.length + 1) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleProductShimmerCard(),
                );
              }

              final product = model.products[index];
              return ProductCard(
                product: product,
                scheme: scheme,
                appColors: appColors,
                onTap: () {
                  context.router.push(ProductDetailRoute(product: product));
                },
                onAddToCart: () async {
                  await model.addProductToCart(context, product);
                },
              );
            },
          ),
        );
      },
    );
  }
}
