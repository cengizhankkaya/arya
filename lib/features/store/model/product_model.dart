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

  // Besin değeri getter'ları
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

  // Besin değeri var mı kontrolü
  bool get hasNutritionInfo {
    return proteinValue > 0 ||
        carbohydrateValue > 0 ||
        fatValue > 0 ||
        vitaminCValue > 0 ||
        calciumValue > 0 ||
        fiberValue > 0;
  }

  // En yüksek besin değeri
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
}
