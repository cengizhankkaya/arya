import 'package:flutter/material.dart';

class NutritionCalculatorService {
  static double getProteinValue(Map<String, dynamic> nutriments) {
    final proteins = nutriments['proteins'] ?? nutriments['proteins_100g'];
    return double.tryParse(proteins?.toString() ?? '0') ?? 0.0;
  }

  static double getCarbohydrateValue(Map<String, dynamic> nutriments) {
    final carbohydrates = nutriments['carbohydrates'] ?? nutriments['carbohydrates_100g'];
    return double.tryParse(carbohydrates?.toString() ?? '0') ?? 0.0;
  }

  static double getFatValue(Map<String, dynamic> nutriments) {
    final fat = nutriments['fat'] ?? nutriments['fat_100g'];
    return double.tryParse(fat?.toString() ?? '0') ?? 0.0;
  }

  static double getVitaminCValue(Map<String, dynamic> nutriments) {
    final vitaminC = nutriments['vitamin-c'] ?? nutriments['vitamin-c_100g'];
    return double.tryParse(vitaminC?.toString() ?? '0') ?? 0.0;
  }

  static double getCalciumValue(Map<String, dynamic> nutriments) {
    final calcium = nutriments['calcium'] ?? nutriments['calcium_100g'];
    return double.tryParse(calcium?.toString() ?? '0') ?? 0.0;
  }

  static double getFiberValue(Map<String, dynamic> nutriments) {
    final fiber = nutriments['fiber'] ?? nutriments['fiber_100g'];
    return double.tryParse(fiber?.toString() ?? '0') ?? 0.0;
  }

  static bool hasNutritionInfo(Map<String, dynamic> nutriments) {
    return getProteinValue(nutriments) > 0 ||
        getCarbohydrateValue(nutriments) > 0 ||
        getFatValue(nutriments) > 0 ||
        getVitaminCValue(nutriments) > 0 ||
        getCalciumValue(nutriments) > 0 ||
        getFiberValue(nutriments) > 0;
  }

  static String getDominantNutrient(Map<String, dynamic> nutriments) {
    final values = [
      (getProteinValue(nutriments), 'Protein'),
      (getCarbohydrateValue(nutriments), 'Karbonhidrat'),
      (getFatValue(nutriments), 'Yağ'),
      (getVitaminCValue(nutriments), 'Vitamin C'),
      (getCalciumValue(nutriments), 'Kalsiyum'),
      (getFiberValue(nutriments), 'Lif'),
    ];
    
    values.sort((a, b) => b.$1.compareTo(a.$1));
    return values.first.$2;
  }

  static Color getProteinColor(double value) {
    if (value >= 20.0) return Colors.red.shade700;
    if (value >= 15.0) return Colors.orange.shade700;
    if (value >= 10.0) return Colors.amber.shade700;
    return Colors.green.shade700;
  }

  static Color getCarbohydrateColor(double value) {
    if (value >= 50.0) return Colors.purple.shade700;
    if (value >= 30.0) return Colors.indigo.shade700;
    if (value >= 15.0) return Colors.blue.shade700;
    return Colors.cyan.shade700;
  }

  static Color getFatColor(double value) {
    if (value >= 30.0) return Colors.brown.shade700;
    if (value >= 20.0) return Colors.deepOrange.shade700;
    if (value >= 15.0) return Colors.orange.shade700;
    return Colors.amber.shade700;
  }

  static Color getVitaminMineralColor(double value) {
    if (value >= 100.0) return Colors.green.shade700;
    if (value >= 50.0) return Colors.teal.shade700;
    if (value >= 10.0) return Colors.cyan.shade700;
    return Colors.blue.shade700;
  }

  static Color getFiberColor(double value) {
    if (value >= 10.0) return Colors.lime.shade700;
    if (value >= 6.0) return Colors.lightGreen.shade700;
    if (value >= 3.0) return Colors.green.shade700;
    return Colors.teal.shade700;
  }
}
