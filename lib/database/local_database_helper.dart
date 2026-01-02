import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // GETTERS
  static String? get userType => _prefs.getString("userType");

  static String? get subscribedLang => _prefs.getString("lang_subscribed");

  static String? get appLocale => _prefs.getString("app_locale");

  static bool get isFirstRun => _prefs.getBool("isFirstRun") ?? true;

  static String? get appTheme => _prefs.getString("app_theme");

  static bool get shownUserSuggestion =>
      _prefs.getBool("shownUserSuggestion") ?? false;

  static int get usedManual => _prefs.getInt("usedManual") ?? 0;

  static bool get shownNotificationIntro =>
      _prefs.getBool("shownNotificationIntro") ?? false;

  static Future<void> setShownNotificationIntro() async {
    await _prefs.setBool("shownNotificationIntro", true);
  }

  // SETTERS
  static Future<void> setUserType(String type) async {
    await _prefs.setString("userType", type);
  }

  static Future<void> setShownUserSuggestion() async {
    await _prefs.setBool("shownUserSuggestion", true);
  }

  static Future<void> setFirstRun() async {
    await _prefs.setBool("isFirstRun", false);
  }

  static Future<void> subscribeLanguage(String lang) async {
    await _prefs.setString("lang_subscribed", lang);
  }

  static Future<void> setLocale(String locale) async {
    await _prefs.setString("app_locale", locale);
  }

  static Future<void> setTheme(String theme) async {
    await _prefs.setString("app_theme", theme);
  }
}
