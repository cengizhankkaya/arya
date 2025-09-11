import 'package:flutter/material.dart';
import 'package:arya/product/utility/storage/app_prefs.dart';
import 'package:arya/product/theme/custom_light_theme.dart';
import 'package:arya/product/theme/custom_dark_theme.dart';

class ThemeViewModel extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme =>
      _isDarkMode ? CustomDarkTheme().themeData : CustomLightTheme().themeData;

  ThemeViewModel() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    _isDarkMode = await AppPrefs.getIsDarkMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await AppPrefs.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> setTheme(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      await AppPrefs.setIsDarkMode(_isDarkMode);
      notifyListeners();
    }
  }
}
