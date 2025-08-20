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
          final cartItems = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
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
