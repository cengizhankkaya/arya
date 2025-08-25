// removed unused Flutter material import

/// Model class representing a product to be added to the system.
/// This class encapsulates all the necessary information for creating
/// a new product entry, including nutritional data, product details,
/// and validation logic.
///
/// The AddProductModel serves multiple purposes:
/// - Form data collection and validation
/// - Data transformation for API submission
/// - Immutable data representation with copy-with functionality
/// - Centralized validation rules for product creation
///
/// Key features:
/// - Comprehensive product information fields
/// - Built-in validation methods for form fields
/// - Factory constructor for form data processing
/// - API data transformation capabilities
/// - Immutable design with copy-with pattern
///
/// Usage:
/// ```dart
/// final product = AddProductModel.fromForm(
///   barcode: '123456789',
///   name: 'Product Name',
///   brands: 'Brand Name',
///   // ... other required fields
/// );
///
/// final validationError = AddProductModel.validateBarcode(barcode);
/// final apiData = product.toApiData();
/// ```
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

  /// Creates a new AddProductModel instance with the specified product information.
  ///
  /// Parameters:
  /// - id: Optional unique identifier
  /// - barcode: Required product barcode
  /// - name: Required product name
  /// - brands: Required brand information
  /// - categories: Required category classification
  /// - quantity: Required quantity information
  /// - energy: Energy content (defaults to empty string)
  /// - fat: Fat content (defaults to empty string)
  /// - carbs: Carbohydrate content (defaults to empty string)
  /// - protein: Protein content (defaults to empty string)
  /// - ingredients: Required ingredients list
  /// - sodium: Sodium content (defaults to empty string)
  /// - fiber: Fiber content (defaults to empty string)
  /// - sugar: Sugar content (defaults to empty string)
  /// - allergens: Allergen information (defaults to empty string)
  /// - description: Product description (defaults to empty string)
  /// - tags: Product tags (defaults to empty string)
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

  /// Validates the barcode field according to business rules.
  /// This static method provides centralized validation logic for barcode input,
  /// ensuring consistency across the application.
  ///
  /// Validation rules:
  /// - Barcode cannot be null or empty
  /// - Barcode must be at least 8 characters long
  ///
  /// Parameters:
  /// - value: Barcode string to validate
  ///
  /// Returns:
  /// - null if validation passes
  /// - Error message string if validation fails
  static String? validateBarcode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Barkod gerekli';
    }
    if (value.length < 8) {
      return 'Barkod en az 8 karakter olmalı';
    }
    return null;
  }

  /// Validates the product name field according to business rules.
  /// This static method ensures product names meet minimum requirements
  /// for user experience and data quality.
  ///
  /// Validation rules:
  /// - Name cannot be null or empty
  /// - Name must be at least 2 characters long
  ///
  /// Parameters:
  /// - value: Product name string to validate
  ///
  /// Returns:
  /// - null if validation passes
  /// - Error message string if validation fails
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ürün adı gerekli';
    }
    if (value.length < 2) {
      return 'Ürün adı en az 2 karakter olmalı';
    }
    return null;
  }

  /// Validates the brands field according to business rules.
  /// This static method ensures brand information is provided for product identification.
  ///
  /// Validation rules:
  /// - Brands cannot be null or empty
  ///
  /// Parameters:
  /// - value: Brand string to validate
  ///
  /// Returns:
  /// - null if validation passes
  /// - Error message string if validation fails
  static String? validateBrands(String? value) {
    if (value == null || value.isEmpty) {
      return 'Marka bilgisi gerekli';
    }
    return null;
  }

  /// Validates the categories field according to business rules.
  /// This static method ensures products are properly categorized for organization.
  ///
  /// Validation rules:
  /// - Categories cannot be null or empty
  ///
  /// Parameters:
  /// - value: Categories string to validate
  ///
  /// Returns:
  /// - null if validation passes
  /// - Error message string if validation fails
  static String? validateCategories(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kategori bilgisi gerekli';
    }
    return null;
  }

  /// Validates the quantity field according to business rules.
  /// This static method ensures quantity information is provided for product specification.
  ///
  /// Validation rules:
  /// - Quantity cannot be null or empty
  ///
  /// Parameters:
  /// - value: Quantity string to validate
  ///
  /// Returns:
  /// - null if validation passes
  /// - Error message string if validation fails
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Miktar bilgisi gerekli';
    }
    return null;
  }

  /// Validates the ingredients field according to business rules.
  /// This static method ensures ingredient information is provided for dietary awareness.
  ///
  /// Validation rules:
  /// - Ingredients cannot be null or empty
  ///
  /// Parameters:
  /// - value: Ingredients string to validate
  ///
  /// Returns:
  /// - null if validation passes
  /// - Error message string if validation fails
  static String? validateIngredients(String? value) {
    if (value == null || value.isEmpty) {
      return 'İçerik bilgisi gerekli';
    }
    return null;
  }

  /// Factory constructor that creates an AddProductModel from form data.
  /// This constructor processes form input data, applies trimming to remove
  /// unnecessary whitespace, and provides sensible defaults for optional fields.
  ///
  /// The method:
  /// - Trims all string inputs to remove leading/trailing whitespace
  /// - Sets default empty strings for optional nutritional fields
  /// - Ensures all required fields are properly handled
  ///
  /// Parameters:
  /// - barcode: Product barcode (required)
  /// - name: Product name (required)
  /// - brands: Brand information (required)
  /// - categories: Product categories (required)
  /// - quantity: Product quantity (required)
  /// - energy: Energy content (optional, defaults to empty)
  /// - fat: Fat content (optional, defaults to empty)
  /// - carbs: Carbohydrate content (optional, defaults to empty)
  /// - protein: Protein content (optional, defaults to empty)
  /// - ingredients: Ingredients list (required)
  /// - sodium: Sodium content (optional, defaults to empty)
  /// - fiber: Fiber content (optional, defaults to empty)
  /// - sugar: Sugar content (optional, defaults to empty)
  /// - allergens: Allergen information (optional, defaults to empty)
  /// - description: Product description (optional, defaults to empty)
  /// - tags: Product tags (optional, defaults to empty)
  ///
  /// Returns:
  /// - AddProductModel instance with processed form data
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

  /// Converts the AddProductModel instance to a map suitable for API submission.
  /// This method transforms the internal model structure to match the expected
  /// API format, mapping field names to API-specific keys.
  ///
  /// The transformation:
  /// - Maps internal field names to API field names
  /// - Includes only fields that are relevant for API submission
  /// - Maintains data integrity and structure
  ///
  /// API field mappings:
  /// - barcode -> 'code'
  /// - name -> 'product_name'
  /// - brands -> 'brands'
  /// - categories -> 'categories'
  /// - quantity -> 'quantity'
  /// - ingredients -> 'ingredients_text'
  /// - sodium -> 'nutriment_sodium'
  /// - fiber -> 'nutriment_fiber'
  /// - sugar -> 'nutriment_sugars'
  /// - allergens -> 'allergens_tags'
  /// - description -> 'generic_name'
  /// - tags -> 'labels_tags'
  ///
  /// Returns:
  /// - Map<String, String> with API-formatted data
  Map<String, String> toApiData() {
    final data = <String, String>{
      'code': barcode,
      'product_name': name,
      'brands': brands,
      'categories': categories,
      'quantity': quantity,
      'ingredients_text': ingredients,
      'nutriment_sodium': sodium,
      'nutriment_fiber': fiber,
      'nutriment_sugars': sugar,
      'allergens_tags': allergens,
      'generic_name': description,
      'labels_tags': tags,
    };

    return data;
  }

  /// Creates a copy of the current AddProductModel with updated values.
  /// This method follows the copy-with pattern commonly used in immutable data models,
  /// allowing for easy creation of modified instances while preserving unchanged fields.
  ///
  /// The method:
  /// - Creates a new instance with the same values as the current one
  /// - Replaces specified fields with new values
  /// - Preserves all unspecified fields unchanged
  ///
  /// Parameters:
  /// - id: New product ID (optional)
  /// - barcode: New barcode (optional)
  /// - name: New product name (optional)
  /// - brands: New brand information (optional)
  /// - categories: New categories (optional)
  /// - quantity: New quantity (optional)
  /// - energy: New energy content (optional)
  /// - fat: New fat content (optional)
  /// - carbs: New carbohydrate content (optional)
  /// - protein: New protein content (optional)
  /// - ingredients: New ingredients (optional)
  /// - sodium: New sodium content (optional)
  /// - fiber: New fiber content (optional)
  /// - sugar: New sugar content (optional)
  /// - allergens: New allergen information (optional)
  /// - description: New description (optional)
  /// - tags: New tags (optional)
  ///
  /// Returns:
  /// - New AddProductModel instance with updated values
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
