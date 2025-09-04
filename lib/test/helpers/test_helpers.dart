import 'package:flutter/material.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

/// Test helper'ları için widget wrapper'ları
class TestHelpers {
  /// AppColors extension'ını içeren MaterialApp wrapper'ı
  static Widget createTestApp({required Widget child, ThemeData? theme}) {
    return MaterialApp(
      theme: theme ?? _createDefaultTheme(),
      home: Material(
        child: Scaffold(body: Material(child: child)),
      ),
    );
  }

  /// AppColors extension'ını içeren varsayılan tema
  static ThemeData _createDefaultTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      extensions: [AppColors.light],
    );
  }

  /// Dark tema ile AppColors extension'ı
  static ThemeData createDarkTheme() {
    return ThemeData.dark().copyWith(extensions: [AppColors.dark]);
  }

  /// Custom tema ile AppColors extension'ı
  static ThemeData createCustomTheme({
    required Color seedColor,
    AppColors? appColors,
  }) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      extensions: [appColors ?? AppColors.light],
    );
  }

  /// Test ortamını kurar
  static void setUpTestEnvironment() {
    // Test ortamı için gerekli setup'lar
  }
}
