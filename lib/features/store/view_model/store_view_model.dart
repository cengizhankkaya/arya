import 'package:arya/features/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreViewModel extends ChangeNotifier {
  final OpenFoodFactsService _service = OpenFoodFactsService();
  List<dynamic> products = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMoreProducts = true;
  int currentPage = 1;
  String currentQuery = '';
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
    currentQuery = query;
    currentPage = 1;
    hasMoreProducts = true;
    safeNotify();
    try {
      if (query.trim().isEmpty) {
        await fetchRandomProducts();
        return;
      }
      products = await _service.searchProducts(
        query,
        country: selectedCountry,
        page: currentPage,
        pageSize: 20,
      );
    } catch (e) {
      products = [];
    }
    isLoading = false;
    safeNotify();
  }

  Future<void> fetchRandomProducts() async {
    isLoading = true;
    currentPage = 1;
    hasMoreProducts = true;
    safeNotify();
    try {
      final allProducts = await _service.searchProducts(
        '',
        country: selectedCountry,
        page: currentPage,
        pageSize: 20,
      );
      allProducts.shuffle();
      products = allProducts.take(20).toList();
    } catch (e) {
      products = [];
    }
    isLoading = false;
    safeNotify();
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore || !hasMoreProducts) return;

    isLoadingMore = true;
    safeNotify();

    try {
      List<dynamic> newProducts = [];
      currentPage++;

      if (selectedCategory.isNotEmpty) {
        // Kategori aramaları için
        newProducts = await _service.searchProductsByCategory(
          selectedCategory,
          country: selectedCountry,
          page: currentPage,
          pageSize: 20,
        );
      } else if (currentQuery.trim().isEmpty) {
        // Rastgele ürünler için
        final allProducts = await _service.searchProducts(
          '',
          country: selectedCountry,
          page: currentPage,
          pageSize: 20,
        );
        allProducts.shuffle();
        newProducts = allProducts.take(20).toList();
      } else {
        // Arama sonuçları için
        newProducts = await _service.searchProducts(
          currentQuery,
          country: selectedCountry,
          page: currentPage,
          pageSize: 20,
        );
      }

      if (newProducts.isNotEmpty) {
        products.addAll(newProducts);
      } else {
        hasMoreProducts = false;
      }
    } catch (e) {
      hasMoreProducts = false;
    }

    isLoadingMore = false;
    safeNotify();
  }

  void setCountry(String country) {
    selectedCountry = country;
    safeNotify();
  }

  Future<void> fetchByCategory(String category) async {
    isLoading = true;
    selectedCategory = category;
    currentPage = 1;
    hasMoreProducts = true;
    currentQuery = '';
    safeNotify();
    try {
      products = await _service.searchProductsByCategory(
        category,
        country: selectedCountry,
        page: currentPage,
        pageSize: 20,
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
    String? imageUrl =
        (product['image_url'] ??
                product['image_small_url'] ??
                product['image_thumb_url'])
            ?.toString();
    if (imageUrl != null && imageUrl.startsWith('http://')) {
      imageUrl = imageUrl.replaceFirst('http://', 'https://');
    }
    print('  Final image URL (hi-res preferred): $imageUrl');

    final cartItem = CartItemModel(
      id: product['id']?.toString() ?? '',
      productName: product['product_name']?.toString() ?? 'İsimsiz Ürün',
      brands: product['brands']?.toString(),
      imageThumbUrl: imageUrl,
      quantity: 1,
      nutriments: (product['nutriments'] as Map<String, dynamic>?) ?? const {},
    );
    await context.read<CartViewModel>().addToCart(cartItem);
  }
}
