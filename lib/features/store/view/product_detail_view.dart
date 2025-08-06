import 'package:flutter/material.dart';

class ProductDetailView extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailView({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nutriments = product['nutriments'] ?? {};
    return Scaffold(
      appBar: AppBar(title: Text(product['product_name'] ?? 'Ürün Detayı')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (product['image_url'] != null)
              Image.network(product['image_url'], height: 200),
            SizedBox(height: 16),
            Text(
              'Marka: 	${product['brands'] ?? '-'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Barkod: ${product['code'] ?? '-'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'İçindekiler: ${product['ingredients_text'] ?? '-'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            if (nutriments.isNotEmpty) ...[
              Text(
                'Besin Değerleri:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Enerji: ${nutriments['energy-kcal_100g'] ?? '-'} kcal/100g',
              ),
              Text('Yağ: ${nutriments['fat_100g'] ?? '-'} g/100g'),
              Text('Şeker: ${nutriments['sugars_100g'] ?? '-'} g/100g'),
              Text('Protein: ${nutriments['proteins_100g'] ?? '-'} g/100g'),
            ],
          ],
        ),
      ),
    );
  }
}
