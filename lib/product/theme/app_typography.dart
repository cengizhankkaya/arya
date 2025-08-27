import 'package:flutter/material.dart';

/// Uygulama genelinde tutarlı tipografi için merkezi TextTheme tanımı
final class AppTypography {
  AppTypography._();

  // Font boyutları
  static const double _displaySize = 32;
  static const double _headlineSize = 24;
  static const double _titleSize = 20;
  static const double _bodyLargeSize = 16;
  static const double _bodySize = 14;
  static const double _labelSize = 12;
  static const double _smallSize = 10;

  // Font ağırlıkları
  static const FontWeight _displayWeight = FontWeight.w700;
  static const FontWeight _headlineWeight = FontWeight.w700;
  static const FontWeight _titleWeight = FontWeight.w600;
  static const FontWeight _bodyLargeWeight = FontWeight.w500;
  static const FontWeight _bodyWeight = FontWeight.w400;
  static const FontWeight _labelWeight = FontWeight.w600;
  static const FontWeight _boldWeight = FontWeight.bold;

  static TextTheme get lightTextTheme =>
      _baseTextTheme(const Color(0xFF424242));

  static TextTheme get darkTextTheme => _baseTextTheme(const Color(0xFFF0F0F0));

  static TextTheme _baseTextTheme(Color baseColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: _displaySize,
        fontWeight: _displayWeight,
        height: 1.15,
        color: baseColor,
      ),
      headlineLarge: TextStyle(
        fontSize: _headlineSize,
        fontWeight: _headlineWeight,
        height: 1.2,
        color: baseColor,
        letterSpacing: 1.2,
        wordSpacing: 2.0,
      ),
      titleLarge: TextStyle(
        fontSize: _titleSize,
        fontWeight: _titleWeight,
        height: 1.25,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontSize: _bodyLargeSize,
        fontWeight: _titleWeight,
        height: 1.25,
        color: baseColor,
      ),
      bodyLarge: TextStyle(
        fontSize: _bodyLargeSize,
        fontWeight: _bodyLargeWeight,
        height: 1.5,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontSize: _bodySize,
        fontWeight: _bodyWeight,
        height: 1.4,
        color: baseColor,
      ),
      bodySmall: TextStyle(
        fontSize: _labelSize,
        fontWeight: _bodyWeight,
        height: 1.35,
        color: baseColor.withValues(alpha: 0.9),
      ),
      labelLarge: TextStyle(
        fontSize: _bodySize,
        fontWeight: _labelWeight,
        height: 1.2,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontSize: _labelSize,
        fontWeight: _labelWeight,
        height: 1.15,
        color: baseColor,
      ),
      labelSmall: TextStyle(
        fontSize: _smallSize,
        fontWeight: _labelWeight,
        height: 1.1,
        color: baseColor.withValues(alpha: 0.9),
      ),
    );
  }

  // Font boyutları için getter metodları
  static double get displaySize => _displaySize;
  static double get headlineSize => _headlineSize;
  static double get titleSize => _titleSize;
  static double get bodyLargeSize => _bodyLargeSize;
  static double get bodySize => _bodySize;
  static double get labelSize => _labelSize;
  static double get smallSize => _smallSize;

  // Font ağırlıkları için getter metodları
  static FontWeight get displayWeight => _displayWeight;
  static FontWeight get headlineWeight => _headlineWeight;
  static FontWeight get titleWeight => _titleWeight;
  static FontWeight get bodyLargeWeight => _bodyLargeWeight;
  static FontWeight get bodyWeight => _bodyWeight;
  static FontWeight get labelWeight => _labelWeight;
  static FontWeight get boldWeight => _boldWeight;

  // Animation durations
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Curve pageTransitionCurve = Curves.easeInOut;
}
