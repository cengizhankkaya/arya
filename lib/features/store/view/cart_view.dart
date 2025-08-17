import 'package:flutter/material.dart';
import 'package:arya/features/store/model/cart_item_model.dart';
import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/features/store/view/widget/index.dart';
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
        title: const Text('Sepet'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      backgroundColor: appColors?.surfaceMuted ?? scheme.surface,
      body: StreamBuilder<List<CartItemModel>>(
        stream: cart.cartStream,
        builder: (context, snapshot) {
          print(
            'CartView StreamBuilder: hasData=${snapshot.hasData}, connectionState=${snapshot.connectionState}, data=${snapshot.data?.length ?? 0}',
          ); // Debug

          // Eğer veri varsa loading gösterme
          if (snapshot.hasData) {
            final cartItems = snapshot.data!;

            if (cartItems.isEmpty) {
              return const EmptyCartWidget();
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return CartItemWidget(product: cartItems[index]);
                },
              ),
            );
          }

          // Sadece ilk kez yüklenirken loading göster
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Varsayılan olarak boş sepet göster
          return const EmptyCartWidget();
        },
      ),
      bottomNavigationBar: StreamBuilder<List<CartItemModel>>(
        stream: cart.cartStream,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          if (items.isEmpty) return const SizedBox.shrink();

          return const CartSummaryWidget();
        },
      ),
      floatingActionButton: StreamBuilder<List<CartItemModel>>(
        stream: cart.cartStream,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          if (items.isEmpty) return const SizedBox.shrink();

          return FloatingActionButton(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            onPressed: () => cart.clearCart(),
            tooltip: 'Sepeti Temizle',
            child: const Icon(Icons.delete),
          );
        },
      ),
    );
  }
}
