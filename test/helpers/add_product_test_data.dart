import 'dart:io';
import 'package:openfoodfacts/openfoodfacts.dart' as off;

/// AddProduct testleri için merkezi test verileri
class AddProductTestData {
  AddProductTestData._(); // Private constructor

  // ==================== VALID TEST DATA ====================

  /// Geçerli barkod verileri
  static const List<String> validBarcodes = [
    '1234567890123',
    '9876543210987',
    '1111111111111',
    '2222222222222',
    '3333333333333',
  ];

  /// Geçersiz barkod verileri
  static const List<String> invalidBarcodes = [
    '', // Boş
    '123', // Çok kısa
    '123456789012345678901234567890', // Çok uzun
    '!@#\$%^&*()', // Özel karakterler
    'abc123def456', // Harf içeren
  ];

  /// Geçerli ürün adları
  static const List<String> validProductNames = [
    'Test Product',
    'Test Product Name',
    'Ürün Adı Test',
    'Product with Special Characters - Test',
    'Very Long Product Name That Should Still Be Valid',
  ];

  /// Geçersiz ürün adları
  static const List<String> invalidProductNames = [
    '', // Boş
    'A', // Çok kısa
    'X', // Tek karakter
  ];

  /// Geçerli marka verileri
  static const List<String> validBrands = [
    'Test Brand',
    'Brand Name',
    'Marka Adı',
    'Multi Word Brand Name',
  ];

  /// Geçerli kategori verileri
  static const List<String> validCategories = [
    'Test Category',
    'Category Name',
    'Kategori Adı',
    'Multi Word Category Name',
  ];

  /// Geçerli miktar verileri
  static const List<String> validQuantities = [
    '100g',
    '250ml',
    '1kg',
    '500g',
    '1 piece',
  ];

  /// Geçerli içerik verileri
  static const List<String> validIngredients = [
    'Test ingredients',
    'İçerik listesi',
    'Sugar, Flour, Water',
    'Şeker, Un, Su',
  ];

  /// Geçerli besin değeri verileri
  static const List<String> validNutritionValues = [
    '250', // Energy
    '10', // Fat
    '30', // Carbs
    '5', // Protein
    '100', // Sodium
    '3', // Fiber
    '15', // Sugar
  ];

  /// Geçerli alerjen verileri
  static const List<String> validAllergens = [
    'Gluten',
    'Süt, Gluten',
    'Contains nuts',
    'Fındık içerir',
  ];

  /// Geçerli açıklama verileri
  static const List<String> validDescriptions = [
    'Test description',
    'Ürün açıklaması',
    'This is a test product description',
    'Bu bir test ürün açıklamasıdır',
  ];

  /// Geçerli etiket verileri
  static const List<String> validTags = [
    'test, product',
    'test, ürün',
    'healthy, organic',
    'sağlıklı, organik',
  ];

  // ==================== COMPLETE TEST DATA SETS ====================

  /// Tam geçerli ürün veri seti
  static Map<String, String> getCompleteValidProductData() {
    return {
      'barcode': validBarcodes[0],
      'name': validProductNames[0],
      'brands': validBrands[0],
      'categories': validCategories[0],
      'quantity': validQuantities[0],
      'energy': validNutritionValues[0],
      'fat': validNutritionValues[1],
      'carbs': validNutritionValues[2],
      'protein': validNutritionValues[3],
      'ingredients': validIngredients[0],
      'sodium': validNutritionValues[4],
      'fiber': validNutritionValues[5],
      'sugar': validNutritionValues[6],
      'allergens': validAllergens[0],
      'description': validDescriptions[0],
      'tags': validTags[0],
    };
  }

  /// Minimum geçerli ürün veri seti (sadece zorunlu alanlar)
  static Map<String, String> getMinimalValidProductData() {
    return {
      'barcode': validBarcodes[0],
      'name': validProductNames[0],
      'brands': validBrands[0],
      'categories': validCategories[0],
      'quantity': validQuantities[0],
      'ingredients': validIngredients[0],
    };
  }

  /// Eksik alanlı ürün veri seti (validasyon hataları için)
  static Map<String, String> getIncompleteProductData() {
    return {
      'barcode': '', // Boş - hata verecek
      'name': validProductNames[0],
      'brands': validBrands[0],
      'categories': validCategories[0],
      'quantity': validQuantities[0],
      'ingredients': validIngredients[0],
    };
  }

  // ==================== MOCK OBJECTS ====================

  /// Mock resim dosyası oluşturur
  static File createMockImageFile() {
    return File('/tmp/test_image.jpg');
  }

  /// Başarılı OpenFoodFacts Status mock'u
  static off.Status createSuccessStatus() {
    return off.Status(status: 1, statusVerbose: 'Success');
  }

  /// Başarısız OpenFoodFacts Status mock'u
  static off.Status createFailureStatus() {
    return off.Status(status: -1, statusVerbose: 'Save failed');
  }

  /// Ağ hatası Status mock'u
  static off.Status createNetworkErrorStatus() {
    return off.Status(status: -1, statusVerbose: 'Network error');
  }

  /// Sunucu hatası Status mock'u
  static off.Status createServerErrorStatus() {
    return off.Status(
      status: -1,
      statusVerbose: 'Server error: 500 Internal Server Error',
    );
  }

  /// Resim yükleme hatası Status mock'u
  static off.Status createImageUploadErrorStatus() {
    return off.Status(
      status: 1,
      statusVerbose: 'Product saved but image upload failed',
    );
  }

  // ==================== TEST SCENARIOS ====================

  /// Farklı test senaryoları için veri setleri
  static List<Map<String, String>> getTestScenarios() {
    return [
      // Senaryo 1: Tam veri seti
      getCompleteValidProductData(),

      // Senaryo 2: Minimum veri seti
      getMinimalValidProductData(),

      // Senaryo 3: Farklı barkod
      {...getCompleteValidProductData(), 'barcode': validBarcodes[1]},

      // Senaryo 4: Farklı ürün adı
      {...getCompleteValidProductData(), 'name': validProductNames[1]},

      // Senaryo 5: Farklı marka
      {...getCompleteValidProductData(), 'brands': validBrands[1]},
    ];
  }

  // ==================== EDGE CASES ====================

  /// Sınır değer testleri için veriler
  static Map<String, String> getEdgeCaseData() {
    return {
      'barcode': '12345678', // Minimum geçerli uzunluk
      'name': 'AB', // Minimum geçerli uzunluk
      'brands': 'X', // Minimum geçerli uzunluk
      'categories': 'Y', // Minimum geçerli uzunluk
      'quantity': '1g', // Minimum geçerli uzunluk
      'ingredients': 'Z', // Minimum geçerli uzunluk
    };
  }

  /// Çok uzun veri seti (maksimum uzunluk testleri için)
  static Map<String, String> getLongData() {
    return {
      'barcode': '123456789012345678901234567890', // Çok uzun
      'name':
          'Very Long Product Name That Exceeds Normal Limits And Should Be Tested For Edge Cases',
      'brands': 'Very Long Brand Name That Exceeds Normal Limits',
      'categories': 'Very Long Category Name That Exceeds Normal Limits',
      'quantity': 'Very Long Quantity Description That Exceeds Normal Limits',
      'ingredients':
          'Very Long Ingredients List That Exceeds Normal Limits And Contains Many Different Items',
    };
  }

  // ==================== VALIDATION TEST DATA ====================

  /// Her alan için ayrı ayrı geçersiz veri testleri
  static Map<String, List<String>> getValidationTestData() {
    return {
      'barcode': invalidBarcodes,
      'name': invalidProductNames,
      'brands': ['', '   '], // Boş ve sadece boşluk
      'categories': ['', '   '], // Boş ve sadece boşluk
      'quantity': ['', '   '], // Boş ve sadece boşluk
      'ingredients': ['', '   '], // Boş ve sadece boşluk
    };
  }
}
