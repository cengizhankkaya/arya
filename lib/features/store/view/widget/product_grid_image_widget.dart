import 'package:flutter/material.dart';

class ProductGridImage extends StatelessWidget {
  final Map<String, dynamic> product;
  
  const ProductGridImage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    String? imageUrl =
        (product['image_url'] ??
                product['image_small_url'] ??
                product['image_thumb_url'])
            ?.toString();

    // http'yi https'e çevir
    if (imageUrl != null && imageUrl.startsWith('http://')) {
      imageUrl = imageUrl.replaceFirst('http://', 'https://');
    }

    if (imageUrl == null || imageUrl.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 48);
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      cacheWidth: 600,
      cacheHeight: 600,
      headers: const {'User-Agent': 'AryaApp/1.0'},
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.image_not_supported, size: 48),
    );
  }
}
