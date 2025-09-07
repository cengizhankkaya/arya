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
                ProjectSizedBox.heightSmall, // 8px boşluk
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
                ProjectSizedBox.customHeight(6), // 6px özel boyut
                NutritionInfoWidget(product: product),
                ProjectSizedBox.customHeight(6), // 6px özel boyut
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product['brands'] ?? 'store.brand_missing'.tr(),
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
