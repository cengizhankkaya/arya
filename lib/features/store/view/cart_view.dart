import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    final cart = Provider.of<CartViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sepet'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      backgroundColor: appColors?.surfaceMuted ?? scheme.surface,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: cart.cartStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final cartItems = snapshot.data ?? [];
          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: scheme.outlineVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sepet boş',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Henüz ürün eklenmemiş',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                            ? Colors.black12
                            : scheme.shadow.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: scheme.surfaceContainerHighest,
                      ),
                      child: product['image_thumb_url'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                product['image_thumb_url'],
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.image,
                              size: 30,
                              color: scheme.outlineVariant,
                            ),
                    ),
                    title: Text(
                      product['product_name'] ?? 'İsimsiz',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: appColors?.textStrong ?? scheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      product['brands'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: appColors?.textMuted ?? scheme.outline,
                          ),
                          onPressed: () => cart.decreaseQuantity(product['id']),
                        ),
                        Text(
                          (product['quantity'] ?? 1).toString(),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color:
                                    appColors?.textStrong ?? scheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: scheme.primary,
                          ),
                          onPressed: () => cart.increaseQuantity(product['id']),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: appColors?.textMuted ?? scheme.outline,
                          ),
                          onPressed: () => cart.removeFromCart(product['id']),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailView(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: StreamBuilder<List<Map<String, dynamic>>>(
        stream: cart.cartStream,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          if (items.isEmpty) return const SizedBox.shrink();

          double parseNumber(dynamic v) {
            if (v is num) return v.toDouble();
            if (v is String) {
              final parsed = double.tryParse(v.replaceAll(',', '.'));
              return parsed ?? 0.0;
            }
            return 0.0;
          }

          double totalKcal = 0;
          double totalProtein = 0;
          for (final item in items) {
            final nutriments = (item['nutriments'] as Map?) ?? const {};
            final qty = (item['quantity'] is num)
                ? (item['quantity'] as num).toDouble()
                : 1.0;
            totalKcal += parseNumber(nutriments['energy-kcal_100g']) * qty;
            totalProtein += parseNumber(nutriments['proteins_100g']) * qty;
          }

          return Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _TotalTile(
                        label: 'Toplam Kalori',
                        value: '${totalKcal.toStringAsFixed(0)} kcal',
                        scheme: scheme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TotalTile(
                        label: 'Toplam Protein',
                        value: '${totalProtein.toStringAsFixed(1)} g',
                        scheme: scheme,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        child: const Icon(Icons.delete),
        onPressed: () => cart.clearCart(),
        tooltip: 'Sepeti Temizle',
      ),
    );
  }
}

class _TotalTile extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme scheme;

  const _TotalTile({
    required this.label,
    required this.value,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
