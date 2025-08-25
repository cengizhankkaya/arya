import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

@RoutePage()
class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cart = Provider.of<CartViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('appbar.cart'.tr()),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
      ),
      backgroundColor: scheme.surface,
      body: StreamBuilder<List<CartItemModel>>(
        stream: cart.cartStream,
        builder: (context, snapshot) {
          final cartItems = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const CartShimmerWidget();
          }
          if (cartItems.isEmpty) {
            return const EmptyCartWidget();
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: CartSummaryWidget()),
                    16.width, // Extension kullanımı - 16px genişlik
                    Consumer<CartViewModel>(
                      builder: (context, cart, child) {
                        return FloatingActionButton(
                          backgroundColor: scheme.error,
                          foregroundColor: scheme.onError,
                          onPressed: () => cart.clearCart(),
                          tooltip: 'general.tooltip.clear_cart'.tr(),
                          child: const Icon(Icons.delete),
                        );
                      },
                    ),
                  ],
                ),
                ProjectSizedBox.heightMedium, // 16px boşluk
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return CartItemWidget(product: cartItems[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer<CartViewModel>(
        builder: (context, cart, child) {
          final items = cart.cartItems;
          if (items.isEmpty) return ProjectSizedBox.shrink;

          return ProjectSizedBox.shrink;
        },
      ),
    );
  }
}
