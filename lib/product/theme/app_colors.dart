import 'package:flutter/material.dart';

/// Semantic palette keys for category cards
enum CategoryPalette {
  fruitsVegetables,
  breakfast,
  beverages,
  meatFish,
  snacks,
  dairy,
  highProtein,
  highCarbohydrate,
  highFat,
  highVitaminsMinerals,
  highFiber,
}

/// App-specific semantic colors that are not covered by Material ColorScheme
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color addbackground;
  final Color textStrong;
  final Color textMuted;
  final Color dividerAlt;
  final Color openfoodfacts;
  // Shimmer colors
  final Color shimmerBase;
  final Color shimmerHighlight;
  // Category card soft colors
  final Color categorySoftGreenBg;
  final Color categorySoftGreenBorder;
  final Color categorySoftPurpleBg;
  final Color categorySoftPurpleBorder;
  final Color categorySoftBlueBg;
  final Color categorySoftBlueBorder;
  final Color categorySoftPinkBg;
  final Color categorySoftPinkBorder;
  final Color categorySoftPeachBg;
  final Color categorySoftPeachBorder;
  final Color categorySoftYellowBg;
  final Color categorySoftYellowBorder;
  final Color categorySoftOrangeBg;
  final Color categorySoftOrangeBorder;
  final Color categorySoftTealBg;
  final Color categorySoftTealBorder;
  final Color categorySoftBrownBg;
  final Color categorySoftBrownBorder;
  final Color categorySoftEmeraldBg;
  final Color categorySoftEmeraldBorder;
  final Color categorySoftLimeBg;
  final Color categorySoftLimeBorder;
  // Additional colors for hardcoded replacements
  final Color white;
  final Color black;
  final Color grey;
  final Color red;
  final Color red50;
  final Color red200;
  final Color red600;
  final Color red700;
  final Color redAccent;
  final Color green50;
  final Color green200;
  final Color green600;
  final Color green700;
  final Color lightGreen;
  final Color primaryGreen;
  final Color transparent;

  const AppColors({
    required this.addbackground,
    required this.textStrong,
    required this.textMuted,
    required this.dividerAlt,
    required this.openfoodfacts,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.categorySoftGreenBg,
    required this.categorySoftGreenBorder,
    required this.categorySoftPurpleBg,
    required this.categorySoftPurpleBorder,
    required this.categorySoftBlueBg,
    required this.categorySoftBlueBorder,
    required this.categorySoftPinkBg,
    required this.categorySoftPinkBorder,
    required this.categorySoftPeachBg,
    required this.categorySoftPeachBorder,
    required this.categorySoftYellowBg,
    required this.categorySoftYellowBorder,
    required this.categorySoftOrangeBg,
    required this.categorySoftOrangeBorder,
    required this.categorySoftTealBg,
    required this.categorySoftTealBorder,
    required this.categorySoftBrownBg,
    required this.categorySoftBrownBorder,
    required this.categorySoftEmeraldBg,
    required this.categorySoftEmeraldBorder,
    required this.categorySoftLimeBg,
    required this.categorySoftLimeBorder,
    required this.white,
    required this.black,
    required this.grey,
    required this.red,
    required this.red50,
    required this.red200,
    required this.red600,
    required this.red700,
    required this.redAccent,
    required this.green50,
    required this.green200,
    required this.green600,
    required this.green700,
    required this.lightGreen,
    required this.primaryGreen,
    required this.transparent,
  });

  static const AppColors light = AppColors(
    addbackground: Color.fromARGB(255, 4, 65, 114),
    textStrong: Color(0xFF333333),
    textMuted: Color(0xFF7C7C7C),
    dividerAlt: Colors.black12,
    openfoodfacts: Color(0xFFFFCC80),
    shimmerBase: Color(0xFFE0E0E0),
    shimmerHighlight: Color(0xFFF5F5F5),
    categorySoftGreenBg: Color(0xFFE8F7EE),
    categorySoftGreenBorder: Color(0xFFB7E4C7),
    categorySoftPurpleBg: Color(0xFFF0E6FF),
    categorySoftPurpleBorder: Color(0xFFD4C2FF),
    categorySoftBlueBg: Color(0xFFEFF7FF),
    categorySoftBlueBorder: Color(0xFFBBDFFF),
    categorySoftPinkBg: Color(0xFFFFEEF1),
    categorySoftPinkBorder: Color(0xFFFFC7D1),
    categorySoftPeachBg: Color(0xFFFFF1E6),
    categorySoftPeachBorder: Color(0xFFFFD4B3),
    categorySoftYellowBg: Color(0xFFFFF6DD),
    categorySoftYellowBorder: Color(0xFFFFE9A9),
    categorySoftOrangeBg: Color(0xFFFFF3E0),
    categorySoftOrangeBorder: Color(0xFFFFCC80),
    categorySoftTealBg: Color(0xFFE0F2F1),
    categorySoftTealBorder: Color(0xFF80CBC4),
    categorySoftBrownBg: Color(0xFFEFEBE9),
    categorySoftBrownBorder: Color(0xFFBCAAA4),
    categorySoftEmeraldBg: Color(0xFFE8F5E8),
    categorySoftEmeraldBorder: Color(0xFFA5D6A7),
    categorySoftLimeBg: Color(0xFFF1F8E9),
    categorySoftLimeBorder: Color(0xFFC5E1A5),
    white: Colors.white,
    black: Colors.black,
    grey: Colors.grey,
    red: Colors.red,
    red50: Color(0xFFFFEBEE),
    red200: Color(0xFFEF9A9A),
    red600: Color(0xFFE53935),
    red700: Color(0xFFD32F2F),
    redAccent: Color(0xFFFF5252),
    green50: Color(0xFFE8F5E8),
    green200: Color(0xFFA5D6A7),
    green600: Color(0xFF43A047),
    green700: Color(0xFF388E3C),
    lightGreen: Color(0xFFE8F7EE),
    primaryGreen: Color(0xFF4CAF50),
    transparent: Colors.transparent,
  );

  static const AppColors dark = AppColors(
    addbackground: Color.fromARGB(255, 204, 132, 0),
    textStrong: Color(0xFFE6E1E5),
    textMuted: Color(0xFFCAC4D0),
    dividerAlt: Color(0xFF49454F),
    openfoodfacts: Color(0xFFEF6C00),
    shimmerBase: Color(0xFF333333),
    shimmerHighlight: Color(0xFF49454F),
    categorySoftGreenBg: Color(0xFF284236),
    categorySoftPurpleBg: Color(0xFF2E2946),
    categorySoftPurpleBorder: Color(0xFF574A8A),
    categorySoftBlueBg: Color(0xFF223041),
    categorySoftBlueBorder: Color(0xFF3F5A7A),
    categorySoftPinkBg: Color(0xFF432C35),
    categorySoftPinkBorder: Color(0xFF7A4B59),
    categorySoftPeachBg: Color(0xFF4A3729),
    categorySoftPeachBorder: Color(0xFF8A6244),
    categorySoftYellowBg: Color(0xFF4A4325),
    categorySoftYellowBorder: Color(0xFF8A7A3C),
    categorySoftOrangeBg: Color(0xFF4A3A29),
    categorySoftOrangeBorder: Color(0xFF8A6A44),
    categorySoftTealBg: Color(0xFF2A3A39),
    categorySoftTealBorder: Color(0xFF4A6A64),
    categorySoftBrownBg: Color(0xFF3A2A29),
    categorySoftBrownBorder: Color(0xFF6A4A44),
    categorySoftEmeraldBg: Color(0xFF2A3A29),
    categorySoftEmeraldBorder: Color(0xFF4A6A44),
    categorySoftLimeBg: Color(0xFF2A3A29),
    categorySoftLimeBorder: Color(0xFF4A6A44),
    categorySoftGreenBorder: Color(0xFF3F6B56),
    white: Colors.white,
    black: Colors.black,
    grey: Colors.grey,
    red: Colors.red,
    red50: Color(0xFFFFEBEE),
    red200: Color(0xFFEF9A9A),
    red600: Color(0xFFE53935),
    red700: Color(0xFFD32F2F),
    redAccent: Color(0xFFFF5252),
    green50: Color(0xFFE8F5E8),
    green200: Color(0xFFA5D6A7),
    green600: Color(0xFF43A047),
    green700: Color(0xFF388E3C),
    lightGreen: Color(0xFF284236),
    primaryGreen: Color(0xFF4CAF50),
    transparent: Colors.transparent,
  );

  get primary => null;

  @override
  AppColors copyWith({
    Color? addbakground,
    Color? textStrong,
    Color? textMuted,
    Color? surfaceMuted,
    Color? dividerAlt,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? categorySoftGreenBg,
    Color? categorySoftGreenBorder,
    Color? categorySoftPurpleBg,
    Color? categorySoftPurpleBorder,
    Color? categorySoftBlueBg,
    Color? categorySoftBlueBorder,
    Color? categorySoftPinkBg,
    Color? categorySoftPinkBorder,
    Color? categorySoftPeachBg,
    Color? categorySoftPeachBorder,
    Color? categorySoftYellowBg,
    Color? categorySoftYellowBorder,
    Color? categorySoftOrangeBg,
    Color? categorySoftOrangeBorder,
    Color? categorySoftTealBg,
    Color? categorySoftTealBorder,
    Color? categorySoftBrownBg,
    Color? categorySoftBrownBorder,
    Color? categorySoftEmeraldBg,
    Color? categorySoftEmeraldBorder,
    Color? categorySoftLimeBg,
    Color? categorySoftLimeBorder,
    Color? white,
    Color? black,
    Color? grey,
    Color? red,
    Color? red50,
    Color? red200,
    Color? red600,
    Color? red700,
    Color? redAccent,
    Color? green50,
    Color? green200,
    Color? green600,
    Color? green700,
    Color? lightGreen,
    Color? primaryGreen,
    Color? transparent,
  }) {
    return AppColors(
      addbackground: addbackground,
      textStrong: textStrong ?? this.textStrong,
      textMuted: textMuted ?? this.textMuted,
      dividerAlt: dividerAlt ?? this.dividerAlt,
      openfoodfacts: openfoodfacts,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      categorySoftGreenBg: categorySoftGreenBg ?? this.categorySoftGreenBg,
      categorySoftGreenBorder:
          categorySoftGreenBorder ?? this.categorySoftGreenBorder,
      categorySoftPurpleBg: categorySoftPurpleBg ?? this.categorySoftPurpleBg,
      categorySoftPurpleBorder:
          categorySoftPurpleBorder ?? this.categorySoftPurpleBorder,
      categorySoftBlueBg: categorySoftBlueBg ?? this.categorySoftBlueBg,
      categorySoftBlueBorder:
          categorySoftBlueBorder ?? this.categorySoftBlueBorder,
      categorySoftPinkBg: categorySoftPinkBg ?? this.categorySoftPinkBg,
      categorySoftPinkBorder:
          categorySoftPinkBorder ?? this.categorySoftPinkBorder,
      categorySoftPeachBg: categorySoftPeachBg ?? this.categorySoftPeachBg,
      categorySoftPeachBorder:
          categorySoftPeachBorder ?? this.categorySoftPeachBorder,
      categorySoftYellowBg: categorySoftYellowBg ?? this.categorySoftYellowBg,
      categorySoftYellowBorder:
          categorySoftYellowBorder ?? this.categorySoftYellowBorder,
      white: white ?? this.white,
      black: black ?? this.black,
      grey: grey ?? this.grey,
      red: red ?? this.red,
      red50: red50 ?? this.red50,
      red200: red200 ?? this.red200,
      red600: red600 ?? this.red600,
      red700: red700 ?? this.red700,
      redAccent: redAccent ?? this.redAccent,
      green50: green50 ?? this.green50,
      green200: green200 ?? this.green200,
      green600: green600 ?? this.green600,
      green700: green700 ?? this.green700,
      lightGreen: lightGreen ?? this.lightGreen,
      primaryGreen: primaryGreen ?? this.primaryGreen,
      transparent: transparent ?? this.transparent,
      categorySoftOrangeBg: categorySoftOrangeBg ?? this.categorySoftOrangeBg,
      categorySoftOrangeBorder:
          categorySoftOrangeBorder ?? this.categorySoftOrangeBorder,
      categorySoftTealBg: categorySoftTealBg ?? this.categorySoftTealBg,
      categorySoftTealBorder:
          categorySoftTealBorder ?? this.categorySoftTealBorder,
      categorySoftBrownBg: categorySoftBrownBg ?? this.categorySoftBrownBg,
      categorySoftBrownBorder:
          categorySoftBrownBorder ?? this.categorySoftBrownBorder,
      categorySoftEmeraldBg:
          categorySoftEmeraldBg ?? this.categorySoftEmeraldBg,
      categorySoftEmeraldBorder:
          categorySoftEmeraldBorder ?? this.categorySoftEmeraldBorder,
      categorySoftLimeBg: categorySoftLimeBg ?? this.categorySoftLimeBg,
      categorySoftLimeBorder:
          categorySoftLimeBorder ?? this.categorySoftLimeBorder,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      addbackground: Color.lerp(addbackground, other.addbackground, t)!,
      textStrong: Color.lerp(textStrong, other.textStrong, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      dividerAlt: Color.lerp(dividerAlt, other.dividerAlt, t)!,
      openfoodfacts: openfoodfacts,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(
        shimmerHighlight,
        other.shimmerHighlight,
        t,
      )!,
      categorySoftGreenBg: Color.lerp(
        categorySoftGreenBg,
        other.categorySoftGreenBg,
        t,
      )!,
      categorySoftGreenBorder: Color.lerp(
        categorySoftGreenBorder,
        other.categorySoftGreenBorder,
        t,
      )!,
      categorySoftPurpleBg: Color.lerp(
        categorySoftPurpleBg,
        other.categorySoftPurpleBg,
        t,
      )!,
      categorySoftPurpleBorder: Color.lerp(
        categorySoftPurpleBorder,
        other.categorySoftPurpleBorder,
        t,
      )!,
      categorySoftBlueBg: Color.lerp(
        categorySoftBlueBg,
        other.categorySoftBlueBg,
        t,
      )!,
      categorySoftBlueBorder: Color.lerp(
        categorySoftBlueBorder,
        other.categorySoftBlueBorder,
        t,
      )!,
      categorySoftPinkBg: Color.lerp(
        categorySoftPinkBg,
        other.categorySoftPinkBg,
        t,
      )!,
      categorySoftPinkBorder: Color.lerp(
        categorySoftPinkBorder,
        other.categorySoftPinkBorder,
        t,
      )!,
      categorySoftPeachBg: Color.lerp(
        categorySoftPeachBg,
        other.categorySoftPeachBg,
        t,
      )!,
      categorySoftPeachBorder: Color.lerp(
        categorySoftPeachBorder,
        other.categorySoftPeachBorder,
        t,
      )!,
      categorySoftYellowBg: Color.lerp(
        categorySoftYellowBg,
        other.categorySoftYellowBg,
        t,
      )!,
      categorySoftYellowBorder: Color.lerp(
        categorySoftYellowBorder,
        other.categorySoftYellowBorder,
        t,
      )!,
      categorySoftOrangeBg: Color.lerp(
        categorySoftOrangeBg,
        other.categorySoftOrangeBg,
        t,
      )!,
      categorySoftOrangeBorder: Color.lerp(
        categorySoftOrangeBorder,
        other.categorySoftOrangeBorder,
        t,
      )!,
      categorySoftTealBg: Color.lerp(
        categorySoftTealBg,
        other.categorySoftTealBg,
        t,
      )!,
      categorySoftTealBorder: Color.lerp(
        categorySoftTealBorder,
        other.categorySoftTealBorder,
        t,
      )!,
      categorySoftBrownBg: Color.lerp(
        categorySoftBrownBg,
        other.categorySoftBrownBg,
        t,
      )!,
      categorySoftBrownBorder: Color.lerp(
        categorySoftBrownBorder,
        other.categorySoftBrownBorder,
        t,
      )!,
      categorySoftEmeraldBg: Color.lerp(
        categorySoftEmeraldBg,
        other.categorySoftEmeraldBg,
        t,
      )!,
      categorySoftEmeraldBorder: Color.lerp(
        categorySoftEmeraldBorder,
        other.categorySoftEmeraldBorder,
        t,
      )!,
      categorySoftLimeBg: Color.lerp(
        categorySoftLimeBg,
        other.categorySoftLimeBg,
        t,
      )!,
      categorySoftLimeBorder: Color.lerp(
        categorySoftLimeBorder,
        other.categorySoftLimeBorder,
        t,
      )!,
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
      grey: Color.lerp(grey, other.grey, t)!,
      red: Color.lerp(red, other.red, t)!,
      red50: Color.lerp(red50, other.red50, t)!,
      red200: Color.lerp(red200, other.red200, t)!,
      red600: Color.lerp(red600, other.red600, t)!,
      red700: Color.lerp(red700, other.red700, t)!,
      redAccent: Color.lerp(redAccent, other.redAccent, t)!,
      green50: Color.lerp(green50, other.green50, t)!,
      green200: Color.lerp(green200, other.green200, t)!,
      green600: Color.lerp(green600, other.green600, t)!,
      green700: Color.lerp(green700, other.green700, t)!,
      lightGreen: Color.lerp(lightGreen, other.lightGreen, t)!,
      primaryGreen: Color.lerp(primaryGreen, other.primaryGreen, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
    );
  }

  // Helpers to access category colors via enum
  Color categoryBg(CategoryPalette palette) {
    switch (palette) {
      case CategoryPalette.fruitsVegetables:
        return categorySoftGreenBg;
      case CategoryPalette.breakfast:
        return categorySoftPurpleBg;
      case CategoryPalette.beverages:
        return categorySoftBlueBg;
      case CategoryPalette.meatFish:
        return categorySoftPinkBg;
      case CategoryPalette.snacks:
        return categorySoftPeachBg;
      case CategoryPalette.dairy:
        return categorySoftYellowBg;
      case CategoryPalette.highProtein:
        return categorySoftOrangeBg;
      case CategoryPalette.highCarbohydrate:
        return categorySoftTealBg;
      case CategoryPalette.highFat:
        return categorySoftBrownBg;
      case CategoryPalette.highVitaminsMinerals:
        return categorySoftEmeraldBg;
      case CategoryPalette.highFiber:
        return categorySoftLimeBg;
    }
  }

  Color categoryBorder(CategoryPalette palette) {
    switch (palette) {
      case CategoryPalette.fruitsVegetables:
        return categorySoftGreenBorder;
      case CategoryPalette.breakfast:
        return categorySoftPurpleBorder;
      case CategoryPalette.beverages:
        return categorySoftBlueBorder;
      case CategoryPalette.meatFish:
        return categorySoftPinkBorder;
      case CategoryPalette.snacks:
        return categorySoftPeachBorder;
      case CategoryPalette.dairy:
        return categorySoftYellowBorder;
      case CategoryPalette.highProtein:
        return categorySoftOrangeBorder;
      case CategoryPalette.highCarbohydrate:
        return categorySoftTealBorder;
      case CategoryPalette.highFat:
        return categorySoftBrownBorder;
      case CategoryPalette.highVitaminsMinerals:
        return categorySoftEmeraldBorder;
      case CategoryPalette.highFiber:
        return categorySoftLimeBorder;
    }
  }

  // Static method for easier access
  static AppColors of(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    if (colors == null) {
      throw FlutterError(
        'AppColors extension not found. Make sure to add AppColors to your theme.',
      );
    }
    return colors;
  }
}
