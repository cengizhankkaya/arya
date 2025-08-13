import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const String _hasOnboardedKey = 'hasOnboarded';

  const AppPrefs._();

  static Future<bool> getHasOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasOnboardedKey) ?? false;
  }

  static Future<void> setHasOnboarded(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasOnboardedKey, value);
  }
}
