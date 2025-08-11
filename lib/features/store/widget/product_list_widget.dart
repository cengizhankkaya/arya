import 'package:arya/features/store/view/product_detail_view.dart';
import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/features/store/view_model/store_view_model.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:arya/product/utility/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, model, child) {
        final scheme = Theme.of(context).colorScheme;
        final appColors = Theme.of(context).extension<AppColors>();
        if (model.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (model.products.isEmpty) {
          return Center(child: Text('Ürün bulunamadı'));
        }
        return GridView.builder(
          padding: ProjectPadding.allSmall(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemCount: model.products.length,
          itemBuilder: (context, index) {
            final product = model.products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailView(product: product),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: ProjectRadius.xxLarge,
                  boxShadow: [
                    BoxShadow(
                      color: (Theme.of(context).brightness == Brightness.light)
                          ? Colors.black12
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
                    Expanded(
                      child: product['image_thumb_url'] != null
                          ? Image.network(
                              product['image_thumb_url'],
                              fit: BoxFit.contain,
                            )
                          : Icon(Icons.image_not_supported, size: 48),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Text(
                          product['product_name'] ?? 'Ürün adı yok',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: appColors?.textStrong ?? scheme.onSurface,
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
                            style: TextStyle(
                              fontSize: 12,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        _addButton(appColors, scheme, context, product),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconButton _addButton(
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
}
