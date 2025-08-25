/// Represents a food product with comprehensive nutritional information.
/// This model encapsulates product details including basic information,
/// ingredients, and detailed nutritional data for dietary analysis.
///
/// The ProductModel is designed to work with Open Food Facts API data,
/// providing a clean interface for accessing nutritional information
/// and performing dietary calculations.
///
/// Key features:
/// - Flexible nutritional data access with fallback values
/// - Computed nutritional properties for easy consumption
/// - Support for both per-serving and per-100g nutritional values
/// - Dominant nutrient identification for dietary categorization
///
/// Usage:
/// ```dart
/// final product = ProductModel.fromMap(apiResponse);
/// final protein = product.proteinValue;
/// final dominant = product.dominantNutrient;
/// ```
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

  /// Complete nutritional information map containing all available nutrients.
  /// This map stores raw nutritional data from the API, supporting both
  /// per-serving and per-100g values for comprehensive dietary analysis.
  ///
  /// Expected keys include:
  /// - proteins, proteins_100g
  /// - carbohydrates, carbohydrates_100g
  /// - fat, fat_100g
  /// - vitamin-c, vitamin-c_100g
  /// - calcium, calcium_100g
  /// - fiber, fiber_100g
  final Map<String, dynamic> nutriments;

  /// Creates a new ProductModel instance with the specified product information.
  ///
  /// Parameters:
  /// - name: Product name (optional)
  /// - brand: Product brand (optional)
  /// - imageUrl: Product image URL (optional)
  /// - ingredients: Ingredients list (optional)
  /// - quantity: Product quantity (optional)
  /// - nutriments: Required nutritional data map
  ProductModel({
    this.name,
    this.brand,
    this.imageUrl,
    this.ingredients,
    this.quantity,
    required this.nutriments,
  });

  /// Factory constructor that creates a ProductModel from API response data.
  /// This method handles the mapping of raw API data to the ProductModel structure,
  /// providing fallback values and data normalization.
  ///
  /// The method supports flexible API response formats and handles:
  /// - Missing or null nutritional values
  /// - Different key naming conventions
  /// - Data type conversion and validation
  ///
  /// Parameters:
  /// - map: Raw API response data as Map<String, dynamic>
  ///
  /// Returns:
  /// - ProductModel instance populated with API data
  /// - Default empty map for nutriments if not provided
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

  /// Computed property that returns the protein content of the product.
  /// This getter provides flexible access to protein data, supporting both
  /// per-serving and per-100g values with fallback handling.
  ///
  /// Returns:
  /// - Protein value in grams, or 0.0 if not available
  /// - Handles both 'proteins' and 'proteins_100g' keys
  double get proteinValue {
    final proteins = nutriments['proteins'] ?? nutriments['proteins_100g'];
    return double.tryParse(proteins?.toString() ?? '0') ?? 0.0;
  }

  /// Computed property that returns the carbohydrate content of the product.
  /// This getter provides flexible access to carbohydrate data, supporting both
  /// per-serving and per-100g values with fallback handling.
  ///
  /// Returns:
  /// - Carbohydrate value in grams, or 0.0 if not available
  /// - Handles both 'carbohydrates' and 'carbohydrates_100g' keys
  double get carbohydrateValue {
    final carbohydrates =
        nutriments['carbohydrates'] ?? nutriments['carbohydrates_100g'];
    return double.tryParse(carbohydrates?.toString() ?? '0') ?? 0.0;
  }

  /// Computed property that returns the fat content of the product.
  /// This getter provides flexible access to fat data, supporting both
  /// per-serving and per-100g values with fallback handling.
  ///
  /// Returns:
  /// - Fat value in grams, or 0.0 if not available
  /// - Handles both 'fat' and 'fat_100g' keys
  double get fatValue {
    final fat = nutriments['fat'] ?? nutriments['fat_100g'];
    return double.tryParse(fat?.toString() ?? '0') ?? 0.0;
  }

  /// Computed property that returns the Vitamin C content of the product.
  /// This getter provides flexible access to Vitamin C data, supporting both
  /// per-serving and per-100g values with fallback handling.
  ///
  /// Returns:
  /// - Vitamin C value in milligrams, or 0.0 if not available
  /// - Handles both 'vitamin-c' and 'vitamin-c_100g' keys
  double get vitaminCValue {
    final vitaminC = nutriments['vitamin-c'] ?? nutriments['vitamin-c_100g'];
    return double.tryParse(vitaminC?.toString() ?? '0') ?? 0.0;
  }

  /// Computed property that returns the calcium content of the product.
  /// This getter provides flexible access to calcium data, supporting both
  /// per-serving and per-100g values with fallback handling.
  ///
  /// Returns:
  /// - Calcium value in milligrams, or 0.0 if not available
  /// - Handles both 'calcium' and 'calcium_100g' keys
  double get calciumValue {
    final calcium = nutriments['calcium'] ?? nutriments['calcium_100g'];
    return double.tryParse(calcium?.toString() ?? '0') ?? 0.0;
  }

  /// Computed property that returns the fiber content of the product.
  /// This getter provides flexible access to fiber data, supporting both
  /// per-serving and per-100g values with fallback handling.
  ///
  /// Returns:
  /// - Fiber value in grams, or 0.0 if not available
  /// - Handles both 'fiber' and 'fiber_100g' keys
  double get fiberValue {
    final fiber = nutriments['fiber'] ?? nutriments['fiber_100g'];
    return double.tryParse(fiber?.toString() ?? '0') ?? 0.0;
  }

  /// Determines whether the product has meaningful nutritional information.
  /// This computed property checks if any of the tracked nutrients have
  /// values greater than zero, indicating the presence of nutritional data.
  ///
  /// This is useful for:
  /// - Filtering products with nutritional information
  /// - Determining if detailed analysis is possible
  /// - Providing user feedback about data completeness
  ///
  /// Returns:
  /// - true if any nutrient has a value > 0
  /// - false if all nutrients are 0 or unavailable
  bool get hasNutritionInfo {
    return proteinValue > 0 ||
        carbohydrateValue > 0 ||
        fatValue > 0 ||
        vitaminCValue > 0 ||
        calciumValue > 0 ||
        fiberValue > 0;
  }

  /// Identifies the dominant nutrient in the product based on relative values.
  /// This computed property analyzes all available nutrients and returns
  /// the nutrient with the highest value, useful for dietary categorization
  /// and nutritional education.
  ///
  /// The method:
  /// 1. Collects all nutrient values and their names
  /// 2. Sorts them in descending order by value
  /// 3. Returns the name of the highest-value nutrient
  ///
  /// Returns:
  /// - Name of the dominant nutrient in Turkish
  /// - Useful for product categorization and dietary planning
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
