
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_language.dart';

class AppTheme {
  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static const String _themeKey = 'travel_nest_dark_mode';
  static const String _languageKey = 'travel_nest_language';
  static const String _currencyKey = 'travel_nest_currency';

  static String language = 'English';
  static String currency = 'INR (₹)';

  static Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool(_themeKey) ?? false;

    themeMode.value =
        isDark ? ThemeMode.dark : ThemeMode.light;

    language = prefs.getString(_languageKey) ?? 'English';

    if (!AppLanguage.supportedLanguages.contains(language)) {
      language = 'English';
    }

    AppLanguage.changeLanguage(language);

    currency = prefs.getString(_currencyKey) ?? 'INR (₹)';
  }

  static Future<void> setDarkMode(bool enabled) async {
    themeMode.value =
        enabled ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_themeKey, enabled);
  }

  static Future<void> setLanguage(String value) async {
    if (!AppLanguage.supportedLanguages.contains(value)) {
      return;
    }

    language = value;

    AppLanguage.changeLanguage(value);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_languageKey, value);
  }

  static Future<void> setCurrency(String value) async {
    currency = value;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_currencyKey, value);
  }
}
