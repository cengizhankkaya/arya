import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const String _hasOnboardedKey = 'hasOnboarded';
  static const String _offUsernameKey = 'off_username';
  static const String _offPasswordKey = 'off_password';
  static const String _hasSeenOffWelcomeDialogKey =
      'has_seen_off_welcome_dialog';
  static const String _isDarkModeKey = 'is_dark_mode';

  const AppPrefs._();

  static Future<bool> getHasOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasOnboardedKey) ?? false;
  }

  static Future<void> setHasOnboarded(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasOnboardedKey, value);
  }

  // Open Food Facts credentials
  static Future<void> setOffCredentials({
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_offUsernameKey, username);
    await prefs.setString(_offPasswordKey, password);
  }

  static Future<String?> getOffUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_offUsernameKey);
  }

  static Future<String?> getOffPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_offPasswordKey);
  }

  static Future<void> clearOffCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_offUsernameKey);
    await prefs.remove(_offPasswordKey);
  }

  // Open Food Facts welcome dialog (only show once)
  static Future<bool> getHasSeenOffWelcomeDialog() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenOffWelcomeDialogKey) ?? false;
  }

  static Future<void> setHasSeenOffWelcomeDialog(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOffWelcomeDialogKey, value);
  }

  // Theme preferences
  static Future<bool> getIsDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? false;
  }

  static Future<void> setIsDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, value);
  }
}
