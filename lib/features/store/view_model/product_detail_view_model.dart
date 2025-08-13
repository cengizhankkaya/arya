import 'package:flutter/foundation.dart';
import 'package:arya/features/store/model/product_model.dart';
import 'package:arya/features/store/model/cart_item_model.dart';

class ProductDetailViewModel extends ChangeNotifier {
  ProductModel? _product;
  int _quantity = 1;
  bool _isFavorite = false;
  bool _isLoading = false;
  String? _error;

  ProductModel? get product => _product;
  int get quantity => _quantity;
  bool get isFavorite => _isFavorite;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void initializeProduct(Map<String, dynamic> productData) {
    _product = ProductModel.fromMap(productData);
    notifyListeners();
  }

  Future<void> loadProduct(Map<String, dynamic> productData) async {
    setLoading(true);
    clearError();

    try {
      // Simüle edilmiş yükleme süresi
      await Future.delayed(const Duration(milliseconds: 500));

      _product = ProductModel.fromMap(productData);
    } catch (e) {
      setError('Ürün yüklenirken hata oluştu: ${e.toString()}');
      // Hata durumunda varsayılan değerler
      _product = ProductModel(
        name: 'Ürün bulunamadı',
        brand: 'Bilinmiyor',
        imageUrl: null,
        ingredients: null,
        quantity: null,
        nutriments: {},
      );
    } finally {
      setLoading(false);
    }
  }

  void setQuantity(int newQuantity) {
    if (newQuantity >= 1) {
      _quantity = newQuantity;
      notifyListeners();
    }
  }

  void increaseQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void updateProductInfo({
    String? name,
    String? brand,
    String? imageUrl,
    String? ingredients,
    String? quantity,
    Map<String, dynamic>? nutriments,
  }) {
    if (_product != null) {
      _product = ProductModel(
        name: name ?? _product!.name,
        brand: brand ?? _product!.brand,
        imageUrl: imageUrl ?? _product!.imageUrl,
        ingredients: ingredients ?? _product!.ingredients,
        quantity: quantity ?? _product!.quantity,
        nutriments: nutriments ?? _product!.nutriments,
      );
      notifyListeners();
    }
  }

  void resetQuantity() {
    _quantity = 1;
    notifyListeners();
  }

  CartItemModel createCartItem() {
    if (_product == null) {
      throw Exception('Product not initialized');
    }

    return CartItemModel(
      id: _product!.name ?? '', // Geçici ID olarak name kullanılıyor
      productName: _product!.name ?? 'İsimsiz Ürün',
      brands: _product!.brand,
      imageThumbUrl: _product!.imageUrl,
      quantity: _quantity,
      nutriments: _product!.nutriments,
    );
  }

  Map<String, dynamic> get productData {
    if (_product == null) return {};

    return {
      'product_name': _product!.name,
      'brands': _product!.brand,
      'image_url': _product!.imageUrl,
      'ingredients_text': _product!.ingredients,
      'quantity': _product!.quantity,
      'nutriments': _product!.nutriments,
    };
  }

  @override
  void dispose() {
    _product = null;
    _quantity = 1;
    _isFavorite = false;
    _isLoading = false;
    _error = null;
    super.dispose();
  }
}
