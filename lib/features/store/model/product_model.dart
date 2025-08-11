class ProductModel {
  final String name;
  final String brand;
  final String? imageUrl;

  ProductModel({required this.name, required this.brand, this.imageUrl});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['product_name'] ?? '',
      brand: json['brands'] ?? '',
      imageUrl: json['image_thumb_url'],
    );
  }
}
