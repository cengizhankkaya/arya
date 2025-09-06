class ProductModel {
  /// Product name as displayed to users
  final String? name;

  /// Brand or manufacturer of the product
  final String? brand;

  /// URL or asset path to the product image
  final String? imageUrl;

  /// Textual description of product ingredients
  final String? ingredients;

  /// Product quantity or serving size information
  final String? quantity;

  final Map<String, dynamic> nutriments;

  ProductModel({
    this.name,
    this.brand,
    this.imageUrl,
    this.ingredients,
    this.quantity,
    required this.nutriments,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['product_name'],
      brand: map['brands'],
      imageUrl: map['image_url'],
      ingredients: map['ingredients_text'],
      quantity: map['quantity'],
      nutriments: map['nutriments'] ?? {},
    );
  }

  double get proteinValue {
    final proteins = nutriments['proteins'] ?? nutriments['proteins_100g'];
    return double.tryParse(proteins?.toString() ?? '0') ?? 0.0;
  }

  double get carbohydrateValue {
    final carbohydrates =
        nutriments['carbohydrates'] ?? nutriments['carbohydrates_100g'];
    return double.tryParse(carbohydrates?.toString() ?? '0') ?? 0.0;
  }

  double get fatValue {
    final fat = nutriments['fat'] ?? nutriments['fat_100g'];
    return double.tryParse(fat?.toString() ?? '0') ?? 0.0;
  }

  double get vitaminCValue {
    final vitaminC = nutriments['vitamin-c'] ?? nutriments['vitamin-c_100g'];
    return double.tryParse(vitaminC?.toString() ?? '0') ?? 0.0;
  }

  double get calciumValue {
    final calcium = nutriments['calcium'] ?? nutriments['calcium_100g'];
    return double.tryParse(calcium?.toString() ?? '0') ?? 0.0;
  }

  double get fiberValue {
    final fiber = nutriments['fiber'] ?? nutriments['fiber_100g'];
    return double.tryParse(fiber?.toString() ?? '0') ?? 0.0;
  }

  bool get hasNutritionInfo {
    return proteinValue > 0 ||
        carbohydrateValue > 0 ||
        fatValue > 0 ||
        vitaminCValue > 0 ||
        calciumValue > 0 ||
        fiberValue > 0;
  }

  String get dominantNutrient {
    final values = [
      (proteinValue, 'Protein'),
      (carbohydrateValue, 'Karbonhidrat'),
      (fatValue, 'Yağ'),
      (vitaminCValue, 'Vitamin C'),
      (calciumValue, 'Kalsiyum'),
      (fiberValue, 'Lif'),
    ];

    values.sort((a, b) => b.$1.compareTo(a.$1));
    return values.first.$2;
  }

  Map<String, dynamic> toMap() {
    return {
      'product_name': name,
      'brands': brand,
      'image_url': imageUrl,
      'ingredients_text': ingredients,
      'quantity': quantity,
      'nutriments': nutriments,
    };
  }

  ProductModel copyWith({
    String? name,
    String? brand,
    String? imageUrl,
    String? ingredients,
    String? quantity,
    Map<String, dynamic>? nutriments,
  }) {
    return ProductModel(
      name: name ?? this.name,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      quantity: quantity ?? this.quantity,
      nutriments: nutriments ?? this.nutriments,
    );
  }

  @override
  String toString() {
    return 'ProductModel(name: $name, brand: $brand, imageUrl: $imageUrl, ingredients: $ingredients, quantity: $quantity, nutriments: $nutriments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductModel &&
        other.name == name &&
        other.brand == brand &&
        other.imageUrl == imageUrl &&
        other.ingredients == ingredients &&
        other.quantity == quantity &&
        _mapEquals(other.nutriments, nutriments);
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      brand,
      imageUrl,
      ingredients,
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
