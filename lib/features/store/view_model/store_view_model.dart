import 'package:arya/features/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreViewModel extends ChangeNotifier {
  final OpenFoodFactsService _service = OpenFoodFactsService();
  List<dynamic> products = [];
  bool isLoading = false;
  // List<String> countries = ['turkey', 'france', 'germany', 'united-states'];
  String selectedCountry = '';
  String selectedCategory = '';

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> search(String query) async {
    isLoading = true;
    safeNotify();
    try {
      if (query.trim().isEmpty) {
        await fetchRandomProducts();
        return;
      }
      products = await _service.searchProducts(query, country: selectedCountry);
    } catch (e) {
      products = [];
    }
    isLoading = false;
    safeNotify();
  }

  Future<void> fetchRandomProducts() async {
    isLoading = true;
    safeNotify();
    try {
      final allProducts = await _service.searchProducts(
        '',
        country: selectedCountry,
      );
      allProducts.shuffle();
      products = allProducts.take(30).toList();
    } catch (e) {
      products = [];
    }
    isLoading = false;
    safeNotify();
  }

  void setCountry(String country) {
    selectedCountry = country;
    safeNotify();
  }

  Future<void> fetchByCategory(String category) async {
    isLoading = true;
    selectedCategory = category;
    safeNotify();
    try {
      products = await _service.searchProductsByCategory(
        category,
        country: selectedCountry,
      );
    } catch (e) {
      products = [];
    }
    isLoading = false;
    safeNotify();
  }

  Future<void> addProductToCart(
    BuildContext context,
    Map<String, dynamic> product,
  ) async {
    final cartItem = CartItemModel(
      id: product['id']?.toString() ?? '',
      productName: product['product_name']?.toString() ?? 'İsimsiz Ürün',
      brands: product['brands']?.toString(),
      imageThumbUrl: (product['image_thumb_url'] ?? product['image_url'])
          ?.toString(),
      quantity: 1,
      nutriments: (product['nutriments'] as Map<String, dynamic>?) ?? const {},
    );

    await context.read<CartViewModel>().addToCart(cartItem);
  }
}
