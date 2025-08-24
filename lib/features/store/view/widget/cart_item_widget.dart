import 'package:flutter/material.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/product/index.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel product;

  const CartItemWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    final cart = Provider.of<CartViewModel>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: ProjectRadius.xxLarge,
        border: Border.all(color: scheme.onSurface, width: 1.5),
      ),
      child: ListTile(
        contentPadding: ProjectPadding.allLarge(),
        leading: _buildProductImage(context, scheme),
        title: Text(
          product.productName,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: AppTypography.labelWeight,
            color: appColors?.textStrong ?? scheme.onSurface,
          ),
        ),
        subtitle: Text(
          product.brands ?? '',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: appColors?.textMuted),
        ),
        trailing: _buildQuantityControls(cart, appColors, scheme),
        onTap: () => _navigateToProductDetail(context, product),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context, ColorScheme scheme) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final targetCacheSize = (60 * devicePixelRatio).round();
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: scheme.surfaceContainerHighest,
      ),
      child: product.imageThumbUrl != null && product.imageThumbUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.imageThumbUrl!.startsWith('http://')
                    ? product.imageThumbUrl!.replaceFirst('http://', 'https://')
                    : product.imageThumbUrl!,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
                cacheWidth: targetCacheSize,
                cacheHeight: targetCacheSize,
                filterQuality: FilterQuality.high,
                gaplessPlayback: true,
                headers: const {'User-Agent': 'AryaApp/1.0'},
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: scheme.surfaceContainerHighest,
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      size: 30,
                      color: scheme.outlineVariant,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: scheme.surfaceContainerHighest,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            )
          : Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: scheme.surfaceContainerHighest,
              ),
              child: Icon(
                Icons.image_not_supported,
                size: 30,
                color: scheme.outlineVariant,
              ),
            ),
    );
  }

  Widget _buildQuantityControls(
    CartViewModel cart,
    AppColors? appColors,
    ColorScheme scheme,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle_outline, color: appColors?.textMuted),
          onPressed: () => cart.decreaseQuantity(product.id),
        ),
        Builder(
          builder: (context) => Text(
            product.quantity.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: appColors?.textStrong,
              fontWeight: AppTypography.displayWeight,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline, color: scheme.primary),
          onPressed: () => cart.increaseQuantity(product.id),
        ),
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: appColors?.textMuted ?? scheme.outline,
          ),
          onPressed: () => cart.removeFromCart(product.id),
        ),
      ],
    );
  }

  void _navigateToProductDetail(BuildContext context, CartItemModel product) {
    context.router.push(ProductDetailRoute(product: product.toMap()));
  }
}
