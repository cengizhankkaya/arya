import 'package:arya/features/store/services/open_food_fackts_service.dart';
import 'package:flutter/material.dart';

class StoreViewModel extends ChangeNotifier {
  final OpenFoodFactsService _service = OpenFoodFactsService();
  List<dynamic> products = [];
  bool isLoading = false;
  List<String> countries = ['turkey', 'france', 'germany', 'united-states'];
  String selectedCountry = '';

  Future<void> search(String query) async {
    isLoading = true;
    notifyListeners();
    try {
      products = await _service.searchProducts(query, country: selectedCountry);
    } catch (e) {
      products = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void setCountry(String country) {
    selectedCountry = country;
    notifyListeners();
  }
}
