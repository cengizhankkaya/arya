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
        if (selectedCategory.toLowerCase().contains('protein') ||
            selectedCategory.toLowerCase().contains('yüksek')) {
          newProducts = await _service.searchProductsByCategory(
            'Protein Oranı Yüksek',
            country: selectedCountry,
            page: currentPage,
            pageSize: 20,
          );
        } else if (selectedCategory.toLowerCase().contains('karbonhidrat') ||
            selectedCategory.toLowerCase().contains('carbohydrate')) {
          newProducts = await _service.searchProductsByCategory(
            'Karbonhidrat Oranı Yüksek',
            country: selectedCountry,
            page: currentPage,
            pageSize: 20,
          );
        } else if (selectedCategory.toLowerCase().contains('yağ') ||
            selectedCategory.toLowerCase().contains('fat')) {
          newProducts = await _service.searchProductsByCategory(
            'Yağ Oranı Yüksek',
            country: selectedCountry,
            page: currentPage,
            pageSize: 20,
          );
        } else if (selectedCategory.toLowerCase().contains('vitamin') ||
            selectedCategory.toLowerCase().contains('mineral')) {
          newProducts = await _service.searchProductsByCategory(
            'Vitamin / Mineral Oranı Yüksek',
            country: selectedCountry,
            page: currentPage,
            pageSize: 20,
          );
        } else if (selectedCategory.toLowerCase().contains('lif') ||
            selectedCategory.toLowerCase().contains('fiber')) {
          newProducts = await _service.searchProductsByCategory(
            'Lif Oranı Yüksek',
            country: selectedCountry,
            page: currentPage,
            pageSize: 20,
          );
        } else {
          newProducts = await _service.searchProductsByCategory(
            selectedCategory,
            country: selectedCountry,
            page: currentPage,
            pageSize: 20,
          );
        }
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
      // Protein oranı yüksek kategorisi için özel işlem
      if (category.toLowerCase().contains('protein') ||
          category.toLowerCase().contains('yüksek')) {
        products = await _service.searchProductsByCategory(
          'Protein Oranı Yüksek',
          country: selectedCountry,
          page: currentPage,
          pageSize: 20,
        );
      } else if (category.toLowerCase().contains('karbonhidrat') ||
          category.toLowerCase().contains('carbohydrate')) {
        // Karbonhidrat oranı yüksek kategorisi için özel işlem
        products = await _service.searchProductsByCategory(
          'Karbonhidrat Oranı Yüksek',
          country: selectedCountry,
          page: currentPage,
          pageSize: 20,
        );
      } else if (category.toLowerCase().contains('yağ') ||
          category.toLowerCase().contains('fat')) {
        // Yağ oranı yüksek kategorisi için özel işlem
        products = await _service.searchProductsByCategory(
          'Yağ Oranı Yüksek',
          country: selectedCountry,
          page: currentPage,
          pageSize: 20,
        );
      } else if (category.toLowerCase().contains('vitamin') ||
          category.toLowerCase().contains('mineral')) {
        // Vitamin/mineral oranı yüksek kategorisi için özel işlem
        products = await _service.searchProductsByCategory(
          'Vitamin / Mineral Oranı Yüksek',
          country: selectedCountry,
          page: currentPage,
          pageSize: 20,
        );
      } else if (category.toLowerCase().contains('lif') ||
          category.toLowerCase().contains('fiber')) {
        // Lif oranı yüksek kategorisi için özel işlem
        products = await _service.searchProductsByCategory(
          'Lif Oranı Yüksek',
          country: selectedCountry,
          page: currentPage,
          pageSize: 20,
        );
      } else {
        products = await _service.searchProductsByCategory(
          category,
          country: selectedCountry,
          page: currentPage,
          pageSize: 20,
        );
      }
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

  // Besin değeri renk hesaplama metodları
  Color getProductCardColor(Map<String, dynamic> product) {
    try {
      final nutriments = product['nutriments'] as Map<String, dynamic>?;
      if (nutriments == null) return const Color(0xFFE8F5E9);

      // Protein oranına göre renk belirle
      final proteinValue = NutritionCalculatorService.getProteinValue(
        nutriments,
      );
      if (proteinValue > 0) {
        if (proteinValue >= 20.0) {
          return Colors.red.shade50; // Çok yüksek protein
        } else if (proteinValue >= 15.0) {
          return Colors.orange.shade50; // Yüksek protein
        } else if (proteinValue >= 10.0) {
          return Colors.amber.shade50; // Orta protein
        } else {
          return Colors.green.shade50; // Düşük protein
        }
      }

      // Karbonhidrat oranına göre renk belirle (protein yoksa)
      final carbohydrateValue = NutritionCalculatorService.getCarbohydrateValue(
        nutriments,
      );
      if (carbohydrateValue > 0) {
        if (carbohydrateValue >= 50.0) {
          return Colors.purple.shade50; // Çok yüksek karbonhidrat
        } else if (carbohydrateValue >= 30.0) {
          return Colors.indigo.shade50; // Yüksek karbonhidrat
        } else if (carbohydrateValue >= 15.0) {
          return Colors.blue.shade50; // Orta karbonhidrat
        } else {
          return Colors.cyan.shade50; // Düşük karbonhidrat
        }
      }

      // Yağ oranına göre renk belirle (protein ve karbonhidrat yoksa)
      final fatValue = NutritionCalculatorService.getFatValue(nutriments);
      if (fatValue > 0) {
        if (fatValue >= 30.0) {
          return Colors.brown.shade50; // Çok yüksek yağ
        } else if (fatValue >= 20.0) {
          return Colors.deepOrange.shade50; // Yüksek yağ
        } else if (fatValue >= 15.0) {
          return Colors.orange.shade50; // Orta yağ
        } else {
          return Colors.amber.shade50; // Düşük yağ
        }
      }

      // Vitamin/mineral oranına göre renk belirle (diğerleri yoksa)
      final vitaminCValue = NutritionCalculatorService.getVitaminCValue(
        nutriments,
      );
      final calciumValue = NutritionCalculatorService.getCalciumValue(
        nutriments,
      );
      if (vitaminCValue > 0 || calciumValue > 0) {
        final maxValue = vitaminCValue > calciumValue
            ? vitaminCValue
            : calciumValue;

        if (maxValue > 0) {
          if (maxValue >= 100.0) {
            return Colors.green.shade50; // Çok yüksek vitamin/mineral
          } else if (maxValue >= 50.0) {
            return Colors.teal.shade50; // Yüksek vitamin/mineral
          } else if (maxValue >= 10.0) {
            return Colors.cyan.shade50; // Orta vitamin/mineral
          } else {
            return Colors.blue.shade50; // Düşük vitamin/mineral
          }
        }
      }

      // Lif oranına göre renk belirle (diğerleri yoksa)
      final fiberValue = NutritionCalculatorService.getFiberValue(nutriments);
      if (fiberValue > 0) {
        if (fiberValue >= 10.0) {
          return Colors.lime.shade50; // Çok yüksek lif
        } else if (fiberValue >= 6.0) {
          return Colors.lightGreen.shade50; // Yüksek lif
        } else if (fiberValue >= 3.0) {
          return Colors.green.shade50; // Orta lif
        } else {
          return Colors.teal.shade50; // Düşük lif
        }
      }
    } catch (_) {
      // Hata durumunda varsayılan renk
    }
    return const Color(0xFFE8F5E9); // Varsayılan yeşil renk
  }

  // Besin değeri renk getter'ları - NutritionCalculatorService kullanarak
  Color getProteinColor(double value) =>
      NutritionCalculatorService.getProteinColor(value);
  Color getCarbohydrateColor(double value) =>
      NutritionCalculatorService.getCarbohydrateColor(value);
  Color getFatColor(double value) =>
      NutritionCalculatorService.getFatColor(value);
  Color getVitaminMineralColor(double value) =>
      NutritionCalculatorService.getVitaminMineralColor(value);
  Color getFiberColor(double value) =>
      NutritionCalculatorService.getFiberColor(value);
}
