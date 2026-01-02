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
      notifyListeners();

      _runInitLanguageSubscription(code);
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;
    notifyListeners();

    await LocalStorageService.setLocale(newLocale.languageCode);

    _runInitLanguageSubscription(newLocale.languageCode);
  }

  void _runInitLanguageSubscription(String code) {
    Future.microtask(() async {
      try {
        await initLanguageSubscription(code);
      } catch (e, s) {
        debugPrint('initLanguageSubscription error: $e');
      }
    });
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
