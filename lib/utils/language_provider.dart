import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale? _locale; // null = sistem dili kullan

  Locale? get locale => _locale;

  LanguageProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('app_locale');

    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', newLocale.languageCode);

    notifyListeners();
  }

  Future<void> toggleLanguage(Locale systemLocale) async {
    final current = _locale ?? systemLocale;

    if (current.languageCode == 'tr') {
      await setLocale(const Locale('en'));
    } else {
      await setLocale(const Locale('tr'));
    }
  }
}
