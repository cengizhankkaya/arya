import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arya/product/theme/app_colors.dart';
import '../view_model/cart_view_model.dart';
import 'product_detail_view.dart';

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    final cart = Provider.of<CartViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sepet'),
        backgroundColor: scheme.surface,
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Henüz ürün eklenmemiş',
                    style: TextStyle(
                      fontSize: 14,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: appColors?.textStrong ?? scheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      product['brands'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        color: appColors?.textMuted ?? scheme.outline,
                        size: 28,
                      ),
                      onPressed: () => cart.removeFromCart(product['id']),
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
