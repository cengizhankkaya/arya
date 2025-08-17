import 'package:flutter/material.dart';

/// Semantic palette keys for category cards
enum CategoryPalette {
  fruitsVegetables,
  breakfast,
  beverages,
  meatFish,
  snacks,
  dairy,
}

/// App-specific semantic colors that are not covered by Material ColorScheme
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color addbakground;
  final Color textStrong;
  final Color textMuted;
  final Color surfaceMuted;
  final Color dividerAlt;
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

  const AppColors({
    required this.addbakground,
    required this.textStrong,
    required this.textMuted,
    required this.surfaceMuted,
    required this.dividerAlt,
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
  });

  static const AppColors light = AppColors(
    addbakground: Color.fromARGB(255, 4, 65, 114),
    textStrong: Color(0xFF333333),
    textMuted: Color(0xFF7C7C7C),
    surfaceMuted: Color(0xFFF8F8F8),
    dividerAlt: Colors.black12,
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
  );

  static const AppColors dark = AppColors(
    addbakground: Color.fromARGB(255, 204, 132, 0),
    textStrong: Color(0xFFE6E1E5),
    textMuted: Color(0xFFCAC4D0),
    surfaceMuted: Color(0xFF1E1E1E),
    dividerAlt: Color(0xFF49454F),
    categorySoftGreenBg: Color(0xFF284236),
    categorySoftGreenBorder: Color(0xFF3F6B56),
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
  );

  get primary => null;

  @override
  AppColors copyWith({
    Color? addbakground,
    Color? textStrong,
    Color? textMuted,
    Color? surfaceMuted,
    Color? dividerAlt,
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
  }) {
    return AppColors(
      addbakground: addbakground ?? this.addbakground,
      textStrong: textStrong ?? this.textStrong,
      textMuted: textMuted ?? this.textMuted,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      dividerAlt: dividerAlt ?? this.dividerAlt,
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
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      addbakground: Color.lerp(addbakground, other.addbakground, t)!,
      textStrong: Color.lerp(textStrong, other.textStrong, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      dividerAlt: Color.lerp(dividerAlt, other.dividerAlt, t)!,
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
    }
  }
}
