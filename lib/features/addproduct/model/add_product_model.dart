class AddProductModel {
  /// Unique identifier for the product (optional, assigned by system)
  final String? id;

  /// Product barcode for identification and scanning
  final String barcode;

  /// Product name as displayed to users
  final String name;

  /// Brand or manufacturer information
  final String brands;

  /// Product category classification
  final String categories;

  /// Product quantity or serving size
  final String quantity;

  /// Energy content (calories)
  final String energy;

  /// Fat content in grams
  final String fat;

  /// Carbohydrate content in grams
  final String carbs;

  /// Protein content in grams
  final String protein;

  /// List of product ingredients
  final String ingredients;

  /// Sodium content in milligrams
  final String sodium;

  /// Fiber content in grams
  final String fiber;

  /// Sugar content in grams
  final String sugar;

  /// Allergen information and warnings
  final String allergens;

  /// Product description and additional details
  final String description;

  /// Product tags for categorization and search
  final String tags;

  AddProductModel({
    this.id,
    required this.barcode,
    required this.name,
    required this.brands,
    required this.categories,
    required this.quantity,
    required this.energy,
    required this.fat,
    required this.carbs,
    required this.protein,
    required this.ingredients,
    required this.sodium,
    required this.fiber,
    required this.sugar,
    required this.allergens,
    required this.description,
    required this.tags,
  });

  static String? validateBarcode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Barkod gerekli';
    }
    if (value.length < 8) {
      return 'Barkod en az 8 karakter olmalı';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ürün adı gerekli';
    }
    if (value.length < 2) {
      return 'Ürün adı en az 2 karakter olmalı';
    }
    return null;
  }

  static String? validateBrands(String? value) {
    if (value == null || value.isEmpty) {
      return 'Marka bilgisi gerekli';
    }
    return null;
  }

  static String? validateCategories(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kategori bilgisi gerekli';
    }
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Miktar bilgisi gerekli';
    }
    return null;
  }

  static String? validateIngredients(String? value) {
    if (value == null || value.isEmpty) {
      return 'İçerik bilgisi gerekli';
    }
    return null;
  }

  factory AddProductModel.fromForm({
    required String barcode,
    required String name,
    required String brands,
    required String categories,
    required String quantity,
    String energy = '',
    String fat = '',
    String carbs = '',
    String protein = '',
    required String ingredients,
    String sodium = '',
    String fiber = '',
    String sugar = '',
    String allergens = '',
    String description = '',
    String tags = '',
  }) {
    return AddProductModel(
      barcode: barcode.trim(),
      name: name.trim(),
      brands: brands.trim(),
      categories: categories.trim(),
      quantity: quantity.trim(),
      energy: energy.trim(),
      fat: fat.trim(),
      carbs: carbs.trim(),
      protein: protein.trim(),
      ingredients: ingredients.trim(),
      sodium: sodium.trim(),
      fiber: fiber.trim(),
      sugar: sugar.trim(),
      allergens: allergens.trim(),
      description: description.trim(),
      tags: tags.trim(),
    );
  }

  Map<String, String> toApiData() {
    final data = <String, String>{
      'code': barcode,
      'product_name': name,
      'brands': brands,
      'categories': categories,
      'quantity': quantity,
      'ingredients_text': ingredients,
      'nutriment_fiber': fiber,
      'nutriment_sugars': sugar,
      'allergens_tags': allergens,
      'generic_name': description,
      'labels_tags': tags,
    };

    if (energy.isNotEmpty) {
      data['nutriment_energy-kcal'] = energy;
      data['nutriment_energy-kcal_unit'] = 'kcal';
    }
    if (fat.isNotEmpty) {
      data['nutriment_fat'] = fat;
      data['nutriment_fat_unit'] = 'g';
    }
    if (carbs.isNotEmpty) {
      data['nutriment_carbohydrates'] = carbs;
      data['nutriment_carbohydrates_unit'] = 'g';
    }
    if (protein.isNotEmpty) {
      data['nutriment_proteins'] = protein;
      data['nutriment_proteins_unit'] = 'g';
    }

    // Tuz için doğru field ismi (sodium yerine salt)
    if (sodium.isNotEmpty) {
      data['nutriment_salt'] = sodium;
      data['nutriment_salt_unit'] = 'g';
    }

    return data;
  }

  AddProductModel copyWith({
    String? id,
    String? barcode,
    String? name,
    String? brands,
    String? categories,
    String? quantity,
    String? energy,
    String? fat,
    String? carbs,
    String? protein,
    String? ingredients,
    String? sodium,
    String? fiber,
    String? sugar,
    String? allergens,
    String? description,
    String? tags,
  }) {
    return AddProductModel(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      brands: brands ?? this.brands,
      categories: categories ?? this.categories,
      quantity: quantity ?? this.quantity,
      energy: energy ?? this.energy,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      ingredients: ingredients ?? this.ingredients,
      sodium: sodium ?? this.sodium,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      allergens: allergens ?? this.allergens,
      description: description ?? this.description,
      tags: tags ?? this.tags,
    );
  }
}
