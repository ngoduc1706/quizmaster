import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported languages
enum AppLanguage {
  vietnamese(Locale('vi', 'VN'), 'Tiếng Việt'),
  english(Locale('en', 'US'), 'English');

  const AppLanguage(this.locale, this.displayName);
  final Locale locale;
  final String displayName;
}

/// Service to manage language preferences
class LanguageService {
  static const String _languageKey = 'app_language';
  static const String _defaultLanguage = 'vi';

  /// Get current language code
  static Future<String> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? _defaultLanguage;
  }

  /// Set language code
  static Future<void> setLanguageCode(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  /// Get current locale
  static Future<Locale> getLocale() async {
    final languageCode = await getLanguageCode();
    return AppLanguage.values
        .firstWhere(
          (lang) => lang.locale.languageCode == languageCode,
          orElse: () => AppLanguage.vietnamese,
        )
        .locale;
  }

  /// Get AppLanguage from language code
  static AppLanguage getLanguageFromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.locale.languageCode == code,
      orElse: () => AppLanguage.vietnamese,
    );
  }
}


