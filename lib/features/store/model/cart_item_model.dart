class CartItemModel {
  final String id;
  final String productName;
  final String? brands;
  final String? imageThumbUrl;
  final int quantity;
  final Map<String, dynamic> nutriments;

  CartItemModel({
    required this.id,
    required this.productName,
    this.brands,
    this.imageThumbUrl,
    required this.quantity,
    required this.nutriments,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: (map['id'] ?? '').toString(),
      productName: (map['product_name'] ?? 'İsimsiz').toString(),
      brands: map['brands'] != null ? map['brands'].toString() : null,
      imageThumbUrl:
          (map['image_url'] ??
                  map['image_small_url'] ??
                  map['image_thumb_url']) !=
              null
          ? (map['image_url'] ??
                    map['image_small_url'] ??
                    map['image_thumb_url'])
                .toString()
          : null,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      nutriments: map['nutriments'] is Map
          ? Map<String, dynamic>.from(map['nutriments'] as Map)
          : const {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_name': productName,
      'brands': brands,
      // Yüksek çözünürlük için image_url'e de aynı değeri koyuyoruz
      // (liste/detay widget'ları image_url'i öncelediği için net görüntü alacağız)
      'image_thumb_url': imageThumbUrl,
      'image_url': imageThumbUrl,
      'quantity': quantity,
      'nutriments': nutriments,
    };
  }

  CartItemModel copyWith({
    String? id,
    String? productName,
    String? brands,
    String? imageThumbUrl,
    int? quantity,
    Map<String, dynamic>? nutriments,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      brands: brands ?? this.brands,
      imageThumbUrl: imageThumbUrl ?? this.imageThumbUrl,
      quantity: quantity ?? this.quantity,
      nutriments: nutriments ?? this.nutriments,
    );
  }
}
