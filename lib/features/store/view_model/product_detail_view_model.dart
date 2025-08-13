import 'package:flutter/material.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final Map<String, dynamic> product;

  int _quantity = 1;
  bool _showDetail = false;
  bool _isFavorite = false;
  bool _isLoading = false;
  String? _errorMessage;

  ProductDetailViewModel({required this.product});

  // Getters
  int get quantity => _quantity;
  bool get showDetail => _showDetail;
  bool get isFavorite => _isFavorite;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Methods
  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  void toggleDetail() {
    _showDetail = !_showDetail;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Product related methods
  String get productName => product['product_name'] ?? 'Product Name';
  String? get brand => product['brands'];
  String? get imageUrl => product['image_url'];
  String? get ingredients => product['ingredients_text'];
  String? get quantityText => product['quantity'];
  String? get categories => product['categories'];
  Map<String, dynamic> get nutriments => product['nutriments'] ?? {};

  // Nutrition data
  List<Map<String, String>> get nutritionData => [
    {'key': 'energy-kcal_100g', 'label': 'Energy', 'unit': 'kcal'},
    {'key': 'fat_100g', 'label': 'Fat', 'unit': 'g'},
    {'key': 'saturated-fat_100g', 'label': 'Saturated Fat', 'unit': 'g'},
    {'key': 'carbohydrates_100g', 'label': 'Carbohydrates', 'unit': 'g'},
    {'key': 'sugars_100g', 'label': 'Sugars', 'unit': 'g'},
    {'key': 'proteins_100g', 'label': 'Proteins', 'unit': 'g'},
    {'key': 'salt_100g', 'label': 'Salt', 'unit': 'g'},
  ];

  // Business logic methods
  Future<void> addToCart() async {
    try {
      setLoading(true);
      setError(null);

      // TODO: Implement cart functionality
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Show success message or navigate to cart
      setLoading(false);
    } catch (e) {
      setError('Sepete eklenirken bir hata oluştu: $e');
      setLoading(false);
    }
  }

  void shareProduct() {
    // TODO: Implement share functionality
    // This could use url_launcher or share_plus package
  }

  // Validation methods
  bool get canAddToCart => quantity > 0 && !isLoading;

  // Reset methods
  void resetQuantity() {
    _quantity = 1;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
