import 'package:arya/product/theme/custom_color_shame.dart';
import 'package:arya/product/theme/custom_theme.dart';
import 'package:flutter/material.dart';

/// Custom light theme for project design
final class CustomDarkTheme implements CustomTheme {
  @override
  ThemeData get themeData => ThemeData(
    useMaterial3: true,
    colorScheme: CustomColorScheme.darkColorScheme,
    floatingActionButtonTheme: floatingActionButtonThemeData,
  );

  @override
  final FloatingActionButtonThemeData floatingActionButtonThemeData =
      const FloatingActionButtonThemeData();
}
