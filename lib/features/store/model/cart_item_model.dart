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
      brands: map['brands']?.toString(),
      imageThumbUrl:
          (map['image_url'] ?? map['image_small_url'] ?? map['image_thumb_url'])
              ?.toString(),
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

  @override
  String toString() {
    return 'CartItemModel(id: $id, productName: $productName, brands: $brands, imageThumbUrl: $imageThumbUrl, quantity: $quantity, nutriments: $nutriments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemModel &&
        other.id == id &&
        other.productName == productName &&
        other.brands == brands &&
        other.imageThumbUrl == imageThumbUrl &&
        other.quantity == quantity &&
        _mapEquals(other.nutriments, nutriments);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      productName,
      brands,
      imageThumbUrl,
      quantity,
      Object.hashAllUnordered(nutriments.entries),
    );
  }

  /// Helper method to compare maps for equality
  bool _mapEquals(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;

    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) {
        return false;
      }
    }
    return true;
  }
}
