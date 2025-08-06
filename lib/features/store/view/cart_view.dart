import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/cart_view_model.dart';
import 'product_detail_view.dart';

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Sepet')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: cart.cartStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final cartItems = snapshot.data ?? [];
          if (cartItems.isEmpty) {
            return Center(child: Text('Sepet boş'));
          }
          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final product = cartItems[index];
              return ListTile(
                leading: product['image_thumb_url'] != null
                    ? Image.network(product['image_thumb_url'], width: 50)
                    : Icon(Icons.image, size: 40),
                title: Text(product['product_name'] ?? 'İsimsiz'),
                subtitle: Text(product['brands'] ?? ''),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () => cart.removeFromCart(product['id']),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailView(product: product),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () => cart.clearCart(),
        tooltip: 'Sepeti Temizle',
      ),
    );
  }
}
