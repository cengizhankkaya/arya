import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/cart_view_model.dart';
import 'product_detail_view.dart';

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sepet'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
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
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sepet boş',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Henüz ürün eklenmemiş',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
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
                        color: Colors.grey[100],
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
                              color: Colors.grey[400],
                            ),
                    ),
                    title: Text(
                      product['product_name'] ?? 'İsimsiz',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    subtitle: Text(
                      product['brands'] ?? '',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Color(0xFF7C7C7C),
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
        backgroundColor: const Color(0xFF7C7C7C),
        foregroundColor: Colors.white,
        child: const Icon(Icons.delete),
        onPressed: () => cart.clearCart(),
        tooltip: 'Sepeti Temizle',
      ),
    );
  }
}
