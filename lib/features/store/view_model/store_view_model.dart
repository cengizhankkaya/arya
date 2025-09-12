import 'package:arya/features/index.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreViewModel extends ChangeNotifier {
  final OpenFoodFactsService _service;

  StoreViewModel({OpenFoodFactsService? service})
    : _service = service ?? OpenFoodFactsService();
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

      // Barkod numarası kontrolü (sadece rakamlar ve 8-14 karakter arası)
      final cleanQuery = query.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanQuery.length >= 8 && cleanQuery.length <= 14) {
        // Barkod arama
        final barcodeProduct = await _service.searchProductByBarcode(
          cleanQuery,
        );
        if (barcodeProduct != null) {
          products = [barcodeProduct];
        } else {
          products = [];
        }
      } else {
        // Normal metin arama
        products = await _service.searchProducts(
          query,
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
        if (selectedCategory.toLowerCase().contains('protein')) {
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
      if (category.toLowerCase().contains('protein')) {
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
  Color getProductCardColor(
    Map<String, dynamic> product,
    BuildContext context,
  ) {
    try {
      final nutriments = product['nutriments'] as Map<String, dynamic>?;
      if (nutriments == null)
        return AppColors.of(context).green50.withValues(alpha: 0.25);

      // Protein oranına göre renk belirle
      final proteinValue = NutritionCalculatorService.getProteinValue(
        nutriments,
      );
      if (proteinValue > 0) {
        if (proteinValue >= 20.0) {
          return AppColors.of(
            context,
          ).nutritionProteinHigh.withValues(alpha: 0.25); // Çok yüksek protein
        } else if (proteinValue >= 15.0) {
          return AppColors.of(
            context,
          ).nutritionProteinMedium.withValues(alpha: 0.25); // Yüksek protein
        } else if (proteinValue >= 10.0) {
          return AppColors.of(
            context,
          ).nutritionProteinMedium.withValues(alpha: 0.25); // Orta protein
        } else {
          return AppColors.of(
            context,
          ).nutritionProteinLow.withValues(alpha: 0.25); // Düşük protein
        }
      }

      // Karbonhidrat oranına göre renk belirle (protein yoksa)
      final carbohydrateValue = NutritionCalculatorService.getCarbohydrateValue(
        nutriments,
      );
      if (carbohydrateValue > 0) {
        if (carbohydrateValue >= 50.0) {
          return AppColors.of(context).nutritionCarbohydrateHigh.withValues(
            alpha: 0.25,
          ); // Çok yüksek karbonhidrat
        } else if (carbohydrateValue >= 30.0) {
          return AppColors.of(
            context,
          ).nutritionCarbohydrateHigh.withValues(alpha: 0.25);
        } else if (carbohydrateValue >= 15.0) {
          return AppColors.of(
            context,
          ).nutritionCarbohydrateMedium.withValues(alpha: 0.25);
        } else {
          return AppColors.of(
            context,
          ).nutritionCarbohydrateLow.withValues(alpha: 0.25);
        }
      }

      // Yağ oranına göre renk belirle (protein ve karbonhidrat yoksa)
      final fatValue = NutritionCalculatorService.getFatValue(nutriments);
      if (fatValue > 0) {
        if (fatValue >= 30.0) {
          return AppColors.of(
            context,
          ).nutritionFatHigh.withValues(alpha: 0.25); // Çok yüksek yağ
        } else if (fatValue >= 20.0) {
          return AppColors.of(
            context,
          ).nutritionFatHigh.withValues(alpha: 0.25); // Yüksek yağ
        } else if (fatValue >= 15.0) {
          return AppColors.of(
            context,
          ).nutritionFatMedium.withValues(alpha: 0.25); // Orta yağ
        } else {
          return AppColors.of(
            context,
          ).nutritionFatLow.withValues(alpha: 0.25); // Düşük yağ
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
            return AppColors.of(context).nutritionVitaminMineralHigh.withValues(
              alpha: 0.25,
            ); // Çok yüksek vitamin/mineral
          } else if (maxValue >= 50.0) {
            return AppColors.of(context).nutritionVitaminMineralHigh.withValues(
              alpha: 0.25,
            ); // Yüksek vitamin/mineral
          } else if (maxValue >= 10.0) {
            return AppColors.of(context).nutritionVitaminMineralMedium
                .withValues(alpha: 0.25); // Orta vitamin/mineral
          } else {
            return AppColors.of(context).nutritionVitaminMineralLow.withValues(
              alpha: 0.25,
            ); // Düşük vitamin/mineral
          }
        }
      }

      // Lif oranına göre renk belirle (diğerleri yoksa)
      final fiberValue = NutritionCalculatorService.getFiberValue(nutriments);
      if (fiberValue > 0) {
        if (fiberValue >= 10.0) {
          return AppColors.of(
            context,
          ).nutritionFiberHigh.withValues(alpha: 0.25); // Çok yüksek lif
        } else if (fiberValue >= 6.0) {
          return AppColors.of(
            context,
          ).nutritionFiberHigh.withValues(alpha: 0.25); // Yüksek lif
        } else if (fiberValue >= 3.0) {
          return AppColors.of(
            context,
          ).nutritionFiberMedium.withValues(alpha: 0.25); // Orta lif
        } else {
          return AppColors.of(
            context,
          ).nutritionFiberLow.withValues(alpha: 0.25); // Düşük lif
        }
      }
    } catch (_) {
      // Hata durumunda varsayılan renk
    }
    return AppColors.of(
      context,
    ).green50.withValues(alpha: 0.25); // Varsayılan yeşil renk
  }
}
