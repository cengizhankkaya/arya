import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/features/store/view/widget/index.dart';
import 'package:arya/features/store/view/widget/empty_cart_widget.dart';
import 'package:arya/features/store/view/widget/cart_summary_widget.dart';
import 'package:arya/features/store/view/product_detail_view.dart';
import 'package:arya/product/index.dart';
import 'package:provider/provider.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    final cart = Provider.of<CartViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('appbar.cart'.tr()),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      backgroundColor: appColors?.surfaceMuted ?? scheme.surface,
      body: StreamBuilder<List<CartItemModel>>(
        stream: cart.cartStream,
        builder: (context, snapshot) {
          print('CartView: StreamBuilder rebuild');
          print('  ConnectionState: ${snapshot.connectionState}');
          print('  HasData: ${snapshot.hasData}');
          print('  HasError: ${snapshot.hasError}');
          print('  Data length: ${snapshot.data?.length ?? 0}');

          // Stream'den gelen veriyi kullan
          final cartItems = snapshot.data ?? [];

          // Eğer stream henüz hiç veri göndermediyse loading göster
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            print('CartView: Showing loading indicator');
            return const Center(child: CircularProgressIndicator());
          }

          // Veri varsa göster
          if (cartItems.isEmpty) {
            print('CartView: Showing empty cart');
            return const EmptyCartWidget();
          }

          print('CartView: Showing cart with ${cartItems.length} items');
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return _CartItemDetailWidget(product: cartItems[index]);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer<CartViewModel>(
        builder: (context, cart, child) {
          final items = cart.cartItems;
          if (items.isEmpty) return const SizedBox.shrink();

          return const CartSummaryWidget();
        },
      ),
      floatingActionButton: Consumer<CartViewModel>(
        builder: (context, cart, child) {
          final items = cart.cartItems;
          if (items.isEmpty) return const SizedBox.shrink();

          return FloatingActionButton(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            onPressed: () => cart.clearCart(),
            tooltip: 'general.tooltip.clear_cart'.tr(),
            child: const Icon(Icons.delete),
          );
        },
      ),
    );
  }
}

class _CartItemDetailWidget extends StatelessWidget {
  final CartItemModel product;

  const _CartItemDetailWidget({required this.product});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    final cart = Provider.of<CartViewModel>(context, listen: false);

    // Besin değerlerini hesapla
    final kcal =
        (product.nutriments['energy-kcal_100g'] as num?)?.toDouble() ?? 0.0;
    final protein =
        (product.nutriments['proteins_100g'] as num?)?.toDouble() ?? 0.0;
    final carbs =
        (product.nutriments['carbohydrates_100g'] as num?)?.toDouble() ?? 0.0;
    final fat = (product.nutriments['fat_100g'] as num?)?.toDouble() ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        children: [
          // Ürün bilgileri
          ListTile(
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

          // Besin değerleri
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Column(
              children: [
                // Besin değerleri başlığı
                Row(
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 16,
                      color: scheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'store.nutrition_title'.tr(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Besin değerleri grid
                Row(
                  children: [
                    Expanded(
                      child: _NutrientTile(
                        label: 'store.kcal'.tr(),
                        value: '${kcal.toStringAsFixed(0)}',
                        unit: 'kcal',
                        icon: Icons.local_fire_department,
                        color: Colors.orange,
                        scheme: scheme,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _NutrientTile(
                        label: 'store.protein'.tr(),
                        value: '${protein.toStringAsFixed(1)}',
                        unit: 'g',
                        icon: Icons.fitness_center,
                        color: Colors.blue,
                        scheme: scheme,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _NutrientTile(
                        label: 'store.carbs'.tr(),
                        value: '${carbs.toStringAsFixed(1)}',
                        unit: 'g',
                        icon: Icons.grain,
                        color: Colors.green,
                        scheme: scheme,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _NutrientTile(
                        label: 'store.fat'.tr(),
                        value: '${fat.toStringAsFixed(1)}',
                        unit: 'g',
                        icon: Icons.opacity,
                        color: Colors.red,
                        scheme: scheme,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(ColorScheme scheme) {
    // Debug bilgisi ekle
    print('CartView: Building image for product: ${product.productName}');
    print('CartView: Image URL: ${product.imageThumbUrl}');

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
                // Cache için headers ekle
                headers: const {'User-Agent': 'AryaApp/1.0'},
                errorBuilder: (context, error, stackTrace) {
                  print(
                    'CartView: Image error for ${product.productName}: $error',
                  );
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: scheme.surfaceContainerHighest,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 20,
                          color: scheme.outlineVariant,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'general.no_image'.tr(),
                          style: TextStyle(
                            fontSize: 8,
                            color: scheme.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    print(
                      'CartView: Image loaded successfully for ${product.productName}',
                    );
                    return child;
                  }
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
                        color: scheme.primary,
                      ),
                    ),
                  );
                },
                // Timeout ekle
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: child,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 20,
                    color: scheme.outlineVariant,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'general.no_image'.tr(),
                    style: TextStyle(fontSize: 8, color: scheme.outlineVariant),
                  ),
                ],
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
    print('CartView: Navigating to product detail');
    print('  Product: ${product.productName}');
    print('  Image URL: ${product.imageThumbUrl}');

    final productMap = product.toMap();
    print('  Product map keys: ${productMap.keys.toList()}');
    print('  image_thumb_url in map: ${productMap['image_thumb_url']}');
    print('  image_url in map: ${productMap['image_url']}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailView(product: productMap),
      ),
    );
  }
}

class _NutrientTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final ColorScheme scheme;

  const _NutrientTile({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            '$value $unit',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
