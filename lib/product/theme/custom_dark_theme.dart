import 'package:arya/product/theme/custom_color_scheme.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:arya/product/theme/custom_theme.dart';
import 'package:flutter/material.dart';

/// Custom light theme for project design
final class CustomDarkTheme implements CustomTheme {
  @override
  ThemeData get themeData {
    final scheme = CustomColorScheme.darkColorScheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      extensions: const <ThemeExtension<dynamic>>[AppColors.dark],
      floatingActionButtonTheme: floatingActionButtonThemeData,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return scheme.primary.withOpacity(0.4);
            }
            return scheme.primary;
          }),
          foregroundColor: WidgetStatePropertyAll(scheme.onPrimary),
        ),
      ),
    );
  }

  @override
  final FloatingActionButtonThemeData floatingActionButtonThemeData =
      const FloatingActionButtonThemeData();
}
