import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/features/store/model/cart_item_model.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final Map<String, dynamic> product;

  int _quantity = 1;
  bool _showDetail = false;
  bool _isFavorite = false;
  bool _isLoading = false;
  String? _errorMessage;

  ProductDetailViewModel({required this.product}) {
    print('ProductDetailViewModel: Constructor called');
    print('  Product keys: ${product.keys.toList()}');
    print('  image_thumb_url: ${product['image_thumb_url']}');
    print('  image_url: ${product['image_url']}');
    print('  product_name: ${product['product_name']}');
  }

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
  String get productName =>
      (product['product_name'] ?? 'Product Name').toString();
  String? get brand =>
      product['brands'] != null ? product['brands'].toString() : null;
  String? get imageUrl {
    // Debug bilgisi ekle
    print('ProductDetailViewModel: Getting image URL');
    print('  image_thumb_url: ${product['image_thumb_url']}');
    print('  image_url: ${product['image_url']}');

    // Önce image_thumb_url'i kontrol et, yoksa image_url'i kullan
    final url = (product['image_thumb_url'] ?? product['image_url'])
        ?.toString();
    print('  Final URL: $url');
    return url;
  }

  String? get ingredients => product['ingredients_text'] != null
      ? product['ingredients_text'].toString()
      : null;
  String? get quantityText =>
      product['quantity'] != null ? product['quantity'].toString() : null;
  String? get categories =>
      product['categories'] != null ? product['categories'].toString() : null;
  Map<String, dynamic> get nutriments => product['nutriments'] is Map
      ? Map<String, dynamic>.from(product['nutriments'] as Map)
      : const {};

  // Nutrition data
  List<Map<String, String>> get nutritionData => [
    {'key': 'energy-kcal_100g', 'label': 'detail.energy', 'unit': 'kcal'},
    {'key': 'fat_100g', 'label': 'detail.fat', 'unit': 'g'},
    {'key': 'saturated-fat_100g', 'label': 'detail.saturated_fat', 'unit': 'g'},
    {'key': 'carbohydrates_100g', 'label': 'detail.carbohydrates', 'unit': 'g'},
    {'key': 'sugars_100g', 'label': 'detail.sugars', 'unit': 'g'},
    {'key': 'proteins_100g', 'label': 'detail.proteins', 'unit': 'g'},
    {'key': 'salt_100g', 'label': 'detail.salt', 'unit': 'g'},
  ];

  // Business logic methods
  Future<void> addToCart(BuildContext context) async {
    try {
      setLoading(true);
      setError(null);

      final imageUrl = (product['image_thumb_url'] ?? product['image_url'])
          ?.toString();
      print('  Product image URL: ${product['image_thumb_url']}');
      print('  Final image URL: $imageUrl');

      final cartItem = CartItemModel(
        id: product['id']?.toString() ?? '',
        productName: product['product_name']?.toString() ?? 'İsimsiz Ürün',
        brands: product['brands']?.toString(),
        imageThumbUrl: imageUrl,
        quantity: _quantity,
        nutriments:
            (product['nutriments'] as Map<String, dynamic>?) ?? const {},
      );

      print('  Cart item image URL: ${cartItem.imageThumbUrl}');
      await context.read<CartViewModel>().addToCart(cartItem);

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
