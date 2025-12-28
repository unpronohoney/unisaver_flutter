import 'package:flutter/material.dart';
import 'package:unisaver_flutter/database/local_database_helper.dart';
import 'package:unisaver_flutter/utils/app_theme.dart';

class ThemeController extends ChangeNotifier {
  AppTheme _theme = AppTheme.light;
  AppTheme get theme => _theme;

  ThemeMode get themeMode =>
      _theme == AppTheme.dark ? ThemeMode.dark : ThemeMode.light;

  ThemeController() {
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = LocalStorageService.appTheme;

    if (savedTheme == 'dark') {
      _theme = AppTheme.dark;
    } else {
      _theme = AppTheme.light;
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _theme = _theme == AppTheme.dark ? AppTheme.light : AppTheme.dark;
    await LocalStorageService.setTheme(
      _theme == AppTheme.dark ? 'dark' : 'ligth',
    );
    notifyListeners();
  }
}
