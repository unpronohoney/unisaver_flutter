import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisaver_flutter/utils/app_theme.dart';

class ThemeController extends ChangeNotifier {
  static const _key = 'app_theme';

  AppTheme _theme = AppTheme.light;
  AppTheme get theme => _theme;

  ThemeMode get themeMode =>
      _theme == AppTheme.dark ? ThemeMode.dark : ThemeMode.light;

  ThemeController() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_key);

    if (savedTheme == 'dark') {
      _theme = AppTheme.dark;
    } else {
      _theme = AppTheme.light;
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _theme = _theme == AppTheme.dark ? AppTheme.light : AppTheme.dark;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _theme == AppTheme.dark ? 'dark' : 'light');

    notifyListeners();
  }
}
