import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage theme preferences
class ThemeService {
  static const String _darkModeKey = 'dark_mode';

  /// Get dark mode preference
  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  /// Set dark mode preference
  static Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDark);
  }

  /// Toggle dark mode
  static Future<bool> toggleDarkMode() async {
    final current = await getDarkMode();
    await setDarkMode(!current);
    return !current;
  }
}


