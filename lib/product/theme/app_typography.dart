import 'package:flutter/material.dart';

/// Uygulama genelinde tutarlı tipografi için merkezi TextTheme tanımı
final class AppTypography {
  AppTypography._();

  static const double _displaySize = 32;
  static const double _headlineSize = 24;
  static const double _titleSize = 20;
  static const double _bodyLargeSize = 16;
  static const double _bodySize = 14;
  static const double _labelSize = 12;

  static TextTheme get lightTextTheme => _baseTextTheme(Colors.black87);

  static TextTheme get darkTextTheme =>
      _baseTextTheme(Colors.white.withValues(alpha: 0.94));

  static TextTheme _baseTextTheme(Color baseColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: _displaySize,
        fontWeight: FontWeight.w700,
        height: 1.15,
        color: baseColor,
      ),
      headlineLarge: TextStyle(
        fontSize: _headlineSize,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: baseColor,
      ),
      titleLarge: TextStyle(
        fontSize: _titleSize,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontSize: _bodyLargeSize,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: baseColor,
      ),
      bodyLarge: TextStyle(
        fontSize: _bodyLargeSize,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontSize: _bodySize,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: baseColor,
      ),
      bodySmall: TextStyle(
        fontSize: _labelSize,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: baseColor.withValues(alpha: 0.9),
      ),
      labelLarge: TextStyle(
        fontSize: _bodySize,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontSize: _labelSize,
        fontWeight: FontWeight.w600,
        height: 1.15,
        color: baseColor,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 1.1,
        color: baseColor.withValues(alpha: 0.9),
      ),
    );
  }
}
