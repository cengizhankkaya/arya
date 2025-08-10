// lib/product/theme/custom_colors.dart
import 'package:flutter/material.dart';

extension CustomColors on ColorScheme {
  Color get success => brightness == Brightness.light
      ? const Color(0xFF4CAF50) // Light tema success rengi
      : const Color(0xFF81C784); // Dark tema success rengi

  Color get warning => brightness == Brightness.light
      ? const Color(0xFFFFC107) // Light
      : const Color(0xFFFFD54F); // Dark

  Color get info => brightness == Brightness.light
      ? const Color(0xFF2196F3) // Light
      : const Color(0xFF64B5F6); // Dark
}
