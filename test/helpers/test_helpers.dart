import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:provider/provider.dart';

/// Test helper'ları için widget wrapper'ları
class TestHelpers {
  /// Test için Easy Localization setup'ı
  static void setupEasyLocalization() {
    EasyLocalization.logger.enableBuildModes = [];
  }

  /// AppColors extension'ını içeren MaterialApp wrapper'ı
  static Widget createTestApp({required Widget child, ThemeData? theme}) {
    return MaterialApp(
      theme: theme ?? _createDefaultTheme(),
      home: Scaffold(body: child),
    );
  }

  /// AppColors extension'ını içeren varsayılan tema
  static ThemeData _createDefaultTheme() {
    final appColors = _createDefaultAppColors();
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      extensions: <ThemeExtension<dynamic>>[appColors],
    );
  }

  /// Dark tema ile AppColors extension'ı
  static ThemeData createDarkTheme() {
    final appColors = _createDarkAppColors();
    return ThemeData.dark().copyWith(
      extensions: <ThemeExtension<dynamic>>[appColors],
    );
  }

  /// Custom tema ile AppColors extension'ı
  static ThemeData createCustomTheme({
    required Color seedColor,
    AppColors? appColors,
  }) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      extensions: <ThemeExtension<dynamic>>[
        appColors ?? _createDefaultAppColors(),
      ],
    );
  }

  /// Varsayılan AppColors instance'ı
  static AppColors _createDefaultAppColors() {
    return AppColors(
      addbackground: Colors.white,
      textStrong: Colors.black87,
      textMuted: Colors.black54,
      dividerAlt: Colors.grey[300]!,
      openfoodfacts: Colors.green,
      shimmerBase: Colors.grey[200]!,
      shimmerHighlight: Colors.grey[100]!,
      shimmerBorder: Colors.grey[300]!,
      grey200: Colors.grey[200]!,
      formFieldBorder: Colors.grey[300]!,
      cardBackground: Colors.white,
      categorySoftGreenBg: Colors.green[50]!,
      categorySoftGreenBorder: Colors.green[200]!,
      categorySoftPurpleBg: Colors.purple[50]!,
      categorySoftPurpleBorder: Colors.purple[200]!,
      categorySoftBlueBg: Colors.blue[50]!,
      categorySoftBlueBorder: Colors.blue[200]!,
      categorySoftPinkBg: Colors.pink[50]!,
      categorySoftPinkBorder: Colors.pink[200]!,
      categorySoftPeachBg: Colors.orange[50]!,
      categorySoftPeachBorder: Colors.orange[200]!,
      categorySoftYellowBg: Colors.yellow[50]!,
      categorySoftYellowBorder: Colors.yellow[200]!,
      categorySoftOrangeBg: Colors.orange[50]!,
      categorySoftOrangeBorder: Colors.orange[200]!,
      categorySoftTealBg: Colors.teal[50]!,
      categorySoftTealBorder: Colors.teal[200]!,
      categorySoftBrownBg: Colors.brown[50]!,
      categorySoftBrownBorder: Colors.brown[200]!,
      categorySoftEmeraldBg: Colors.green[50]!,
      categorySoftEmeraldBorder: Colors.green[200]!,
      categorySoftLimeBg: Colors.lime[50]!,
      categorySoftLimeBorder: Colors.lime[200]!,
      red50: Colors.red[50]!,
      red200: Colors.red[200]!,
      red600: Colors.red[600]!,
      red700: Colors.red[700]!,
      redAccent: Colors.redAccent,
      green50: Colors.green[50]!,
      green200: Colors.green[200]!,
      green600: Colors.green[600]!,
      green700: Colors.green[700]!,
      lightGreen: Colors.lightGreen,
      primaryGreen: Colors.green,
      transparent: Colors.transparent,
      nutritionProteinHigh: Colors.red,
      nutritionProteinMedium: Colors.orange,
      nutritionProteinLow: Colors.green,
      nutritionCarbohydrateHigh: Colors.red,
      nutritionCarbohydrateMedium: Colors.orange,
      nutritionCarbohydrateLow: Colors.green,
      nutritionFatHigh: Colors.red,
      nutritionFatMedium: Colors.orange,
      nutritionFatLow: Colors.green,
      nutritionVitaminMineralHigh: Colors.green,
      nutritionVitaminMineralMedium: Colors.orange,
      nutritionVitaminMineralLow: Colors.red,
      nutritionFiberHigh: Colors.green,
      nutritionFiberMedium: Colors.orange,
      nutritionFiberLow: Colors.red,
      white: Colors.white,
      black: Colors.black,
      grey: Colors.grey,
      red: Colors.red,
    );
  }

  /// Dark tema için AppColors instance'ı
  static AppColors _createDarkAppColors() {
    return AppColors(
      addbackground: Colors.grey[900]!,
      textStrong: Colors.white,
      textMuted: Colors.grey[400]!,
      dividerAlt: Colors.grey[700]!,
      openfoodfacts: Colors.green,
      shimmerBase: Colors.grey[800]!,
      shimmerHighlight: Colors.grey[700]!,
      shimmerBorder: Colors.grey[600]!,
      grey200: Colors.grey[700]!,
      formFieldBorder: Colors.grey[600]!,
      cardBackground: Colors.grey[900]!,
      categorySoftGreenBg: Colors.green[900]!,
      categorySoftGreenBorder: Colors.green[700]!,
      categorySoftPurpleBg: Colors.purple[900]!,
      categorySoftPurpleBorder: Colors.purple[700]!,
      categorySoftBlueBg: Colors.blue[900]!,
      categorySoftBlueBorder: Colors.blue[700]!,
      categorySoftPinkBg: Colors.pink[900]!,
      categorySoftPinkBorder: Colors.pink[700]!,
      categorySoftPeachBg: Colors.orange[900]!,
      categorySoftPeachBorder: Colors.orange[700]!,
      categorySoftYellowBg: Colors.yellow[900]!,
      categorySoftYellowBorder: Colors.yellow[700]!,
      categorySoftOrangeBg: Colors.orange[900]!,
      categorySoftOrangeBorder: Colors.orange[700]!,
      categorySoftTealBg: Colors.teal[900]!,
      categorySoftTealBorder: Colors.teal[700]!,
      categorySoftBrownBg: Colors.brown[900]!,
      categorySoftBrownBorder: Colors.brown[700]!,
      categorySoftEmeraldBg: Colors.green[900]!,
      categorySoftEmeraldBorder: Colors.green[700]!,
      categorySoftLimeBg: Colors.lime[900]!,
      categorySoftLimeBorder: Colors.lime[700]!,
      red50: Colors.red[900]!,
      red200: Colors.red[700]!,
      red600: Colors.red[400]!,
      red700: Colors.red[300]!,
      redAccent: Colors.redAccent,
      green50: Colors.green[900]!,
      green200: Colors.green[700]!,
      green600: Colors.green[400]!,
      green700: Colors.green[300]!,
      lightGreen: Colors.lightGreen,
      primaryGreen: Colors.green,
      transparent: Colors.transparent,
      nutritionProteinHigh: Colors.red,
      nutritionProteinMedium: Colors.orange,
      nutritionProteinLow: Colors.green,
      nutritionCarbohydrateHigh: Colors.red,
      nutritionCarbohydrateMedium: Colors.orange,
      nutritionCarbohydrateLow: Colors.green,
      nutritionFatHigh: Colors.red,
      nutritionFatMedium: Colors.orange,
      nutritionFatLow: Colors.green,
      nutritionVitaminMineralHigh: Colors.green,
      nutritionVitaminMineralMedium: Colors.orange,
      nutritionVitaminMineralLow: Colors.red,
      nutritionFiberHigh: Colors.green,
      nutritionFiberMedium: Colors.orange,
      nutritionFiberLow: Colors.red,
      white: Colors.white,
      black: Colors.black,
      grey: Colors.grey,
      red: Colors.red,
    );
  }
}
