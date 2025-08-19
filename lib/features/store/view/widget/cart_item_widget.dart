import 'package:flutter/material.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/features/store/view/product_detail_view.dart';
import 'package:arya/product/index.dart';
import 'package:provider/provider.dart';

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
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: (Theme.of(context).brightness == Brightness.light)
                ? Colors.black12
                : scheme.shadow.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: _buildProductImage(scheme),
        title: Text(
          product.productName,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: appColors?.textStrong ?? scheme.onSurface,
          ),
        ),
        subtitle: Text(
          product.brands ?? '',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        trailing: _buildQuantityControls(cart, appColors, scheme),
        onTap: () => _navigateToProductDetail(context, product),
      ),
    );
  }

  Widget _buildProductImage(ColorScheme scheme) {
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
                product.imageThumbUrl!,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
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
                  if (loadingProgress == null) return Container();
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
          icon: Icon(
            Icons.remove_circle_outline,
            color: appColors?.textMuted ?? scheme.outline,
          ),
          onPressed: () => cart.decreaseQuantity(product.id),
        ),
        Builder(
          builder: (context) => Text(
            product.quantity.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: appColors?.textStrong ?? scheme.onSurface,
              fontWeight: FontWeight.w700,
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailView(product: product.toMap()),
      ),
    );
  }
}
