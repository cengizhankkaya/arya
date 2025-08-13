class ProductModel {
  final String name;
  final String brand;
  final String? imageUrl;
  final String? quantity;
  final String? categories;
  final String? ingredients;
  final double? energyKcal;
  final double? fat;
  final double? saturatedFat;
  final double? carbohydrates;
  final double? sugars;
  final double? proteins;
  final double? salt;

  ProductModel({
    required this.name,
    required this.brand,
    this.imageUrl,
    this.quantity,
    this.categories,
    this.ingredients,
    this.energyKcal,
    this.fat,
    this.saturatedFat,
    this.carbohydrates,
    this.sugars,
    this.proteins,
    this.salt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final nutriments = json['nutriments'] ?? {};

    return ProductModel(
      name: json['product_name'] ?? '',
      brand: json['brands'] ?? '',
      imageUrl: json['image_thumb_url'],
      quantity: json['quantity'],
      categories: json['categories'],
      ingredients: json['ingredients_text'],
      energyKcal: (nutriments['energy-kcal_100g'] is num)
          ? nutriments['energy-kcal_100g'].toDouble()
          : null,
      fat: (nutriments['fat_100g'] is num)
          ? nutriments['fat_100g'].toDouble()
          : null,
      saturatedFat: (nutriments['saturated-fat_100g'] is num)
          ? nutriments['saturated-fat_100g'].toDouble()
          : null,
      carbohydrates: (nutriments['carbohydrates_100g'] is num)
          ? nutriments['carbohydrates_100g'].toDouble()
          : null,
      sugars: (nutriments['sugars_100g'] is num)
          ? nutriments['sugars_100g'].toDouble()
          : null,
      proteins: (nutriments['proteins_100g'] is num)
          ? nutriments['proteins_100g'].toDouble()
          : null,
      salt: (nutriments['salt_100g'] is num)
          ? nutriments['salt_100g'].toDouble()
          : null,
    );
  }
}

// class ProductModel {
//   final String name;
//   final String brand;
//   final String? imageUrl;

//   ProductModel({required this.name, required this.brand, this.imageUrl});

//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       name: json['product_name'] ?? '',
//       brand: json['brands'] ?? '',
//       imageUrl: json['image_thumb_url'],

//     );
//   }
// }
