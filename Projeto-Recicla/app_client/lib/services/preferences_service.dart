import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _keyUserLoggedIn = 'userLoggedIn';
  static Future<bool> get userLoggedIn async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyUserLoggedIn) ?? false;
  }

  static Future<void> setUserLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyUserLoggedIn, value);
  }
}
