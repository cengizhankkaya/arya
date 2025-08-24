import 'package:arya/features/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final ColorScheme scheme;
  final AppColors? appColors;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.scheme,
    required this.appColors,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: viewModel.getProductCardColor(product, context),
              borderRadius: ProjectRadius.xxLarge,
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: ProductGridImage(product: product)),
                const SizedBox(height: 8),
                Text(
                  product['product_name'] ?? 'store.product_name_missing'.tr(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: appColors?.textStrong ?? scheme.onSurface,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                NutritionInfoWidget(product: product),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product['brands'] ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    _buildAddButton(context),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return addButton(appColors, scheme, context, product);
  }
}
