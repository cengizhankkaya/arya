import 'package:arya/features/store/view_model/cart_view_model.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailView extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailView({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int quantity = 1;
  bool showDetail = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final product = widget.product;
    final nutriments = product['nutriments'] ?? {};

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Theme.of(context).colorScheme.onSurface),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          if (product['image_url'] != null)
            Image.network(
              product['image_url'],
              height: 220,
              fit: BoxFit.contain,
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product['product_name'] ?? 'Product',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.favorite_border,
                        color: scheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '1kg, Price',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                  SizedBox(height: 16),
                  // Quantity and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _iconButton(Icons.remove, () {
                            if (quantity > 1) setState(() => quantity--);
                          }),
                          SizedBox(width: 12),
                          Text('$quantity', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 12),
                          _iconButton(Icons.add, () {
                            setState(() => quantity++);
                          }),
                        ],
                      ),
                    ],
                  ),

                  Divider(height: 32, color: scheme.outlineVariant),

                  // Product Detail (collapsible)
                  GestureDetector(
                    onTap: () => setState(() => showDetail = !showDetail),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Product Detail",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          showDetail
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                  if (showDetail) ...[
                    SizedBox(height: 8),
                    Text(
                      product['ingredients_text'] ??
                          "Apples are nutritious. Apples may be good for weight loss and heart health.",
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ],

                  SizedBox(height: 16),

                  // Nutritions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nutritions",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: scheme.surfaceContainerHighest,
                        ),
                        child: Text("100gr", style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  if (nutriments.isNotEmpty) ...[
                    Text(
                      "Energy: ${nutriments['energy-kcal_100g'] ?? '-'} kcal",
                    ),
                    Text("Fat: ${nutriments['fat_100g'] ?? '-'} g"),
                    Text("Sugars: ${nutriments['sugars_100g'] ?? '-'} g"),
                    Text("Protein: ${nutriments['proteins_100g'] ?? '-'} g"),
                  ],

                  SizedBox(height: 16),

                  // Review
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Review",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            Icons.star,
                            color: scheme.tertiary,
                            size: 20,
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Add to Basket Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Provider.of<CartViewModel>(
                    context,
                    listen: false,
                  ).addToCart(product);
                },
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: scheme.onPrimary,
                    ),
                    onPressed: () {
                      Provider.of<CartViewModel>(
                        context,
                        listen: false,
                      ).addToCart(product);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ürün sepete eklendi')),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
