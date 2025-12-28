import 'package:flutter/material.dart';
import 'package:unisaver_flutter/database/local_database_helper.dart';
import 'package:unisaver_flutter/utils/language_firebase.dart';

class LanguageProvider extends ChangeNotifier {
  Locale? _locale; // null = sistem dili kullan

  Locale? get locale => _locale;

  LanguageProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final code = LocalStorageService.appLocale;

    if (code != null) {
      _locale = Locale(code);
      await initLanguageSubscription(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;
    await LocalStorageService.setLocale(newLocale.languageCode);
    await initLanguageSubscription(newLocale.languageCode);
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
