import 'package:arya/features/store/services/open_food_fackts_service.dart';
import 'package:flutter/material.dart';

import 'package:arya/features/store/services/open_food_fackts_service.dart';
import 'package:flutter/material.dart';

class StoreViewModel extends ChangeNotifier {
  final OpenFoodFactsService _service = OpenFoodFactsService();
  List<dynamic> products = [];
  bool isLoading = false;
  List<String> countries = ['turkey', 'france', 'germany', 'united-states'];
  String selectedCountry = '';

  // Arama fonksiyonu - boşsa rastgele ürün getir
  Future<void> search(String query) async {
    isLoading = true;
    notifyListeners();
    try {
      if (query.trim().isEmpty) {
        await fetchRandomProducts(); // boşsa rastgele getir
      } else {
        products = await _service.searchProducts(
          query,
          country: selectedCountry,
        );
      }
    } catch (e) {
      products = [];
    }
    isLoading = false;
    notifyListeners();
  }

  // Rastgele ürünleri getir
  Future<void> fetchRandomProducts() async {
    isLoading = true;
    notifyListeners();
    try {
      final allProducts = await _service.searchProducts(
        '',
        country: selectedCountry,
      );
      allProducts.shuffle(); // Ürünleri karıştır
      products = allProducts.take(30).toList(); // İlk 20 ürünü al
    } catch (e) {
      products = [];
    }
    isLoading = false;
    notifyListeners();
  }

  // Ülke değiştirme
  void setCountry(String country) {
    selectedCountry = country;
    notifyListeners();
  }
}
