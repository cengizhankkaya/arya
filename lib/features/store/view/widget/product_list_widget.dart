import 'package:arya/features/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:arya/product/navigation/app_router.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, model, child) {
        final scheme = Theme.of(context).colorScheme;
        final appColors = Theme.of(context).extension<AppColors>();

        if (model.isLoading) {
          return const Center(child: CircularProgressIndicator());
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
              childAspectRatio: 0.95,
            ),
            itemCount: model.products.length + (model.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == model.products.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final product = model.products[index];
              return GestureDetector(
                onTap: () {
                  context.router.push(ProductDetailRoute(product: product));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: ProjectRadius.xxLarge,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                            ? appColors!.dividerAlt
                            : scheme.shadow.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: _ProductGridImage(product: product)),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Text(
                            product['product_name'] ??
                                'store.product_name_missing'.tr(),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color:
                                      appColors?.textStrong ?? scheme.onSurface,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product['brands'] ?? '',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ),
                          addButton(appColors, scheme, context, product),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ProductGridImage extends StatelessWidget {
  final Map<String, dynamic> product;
  const _ProductGridImage({required this.product});

  @override
  Widget build(BuildContext context) {
    String? imageUrl =
        (product['image_url'] ??
                product['image_small_url'] ??
                product['image_thumb_url'])
            ?.toString();

    // http'yi https'e çevir
    if (imageUrl != null && imageUrl.startsWith('http://')) {
      imageUrl = imageUrl.replaceFirst('http://', 'https://');
    }

    if (imageUrl == null || imageUrl.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 48);
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      cacheWidth: 600,
      cacheHeight: 600,
      headers: const {'User-Agent': 'AryaApp/1.0'},
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.image_not_supported, size: 48),
    );
  }
}
