class ProductModel {
  final String? name;
  final String? brand;
  final String? imageUrl;
  final String? ingredients;
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
}
