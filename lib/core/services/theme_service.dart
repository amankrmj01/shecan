import 'package:flutter/material.dart';

enum AppThemeMode { light, dark, system }

class ThemeService extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.light;

  AppThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == AppThemeMode.dark;

  bool get isLightMode => _themeMode == AppThemeMode.light;

  bool get isSystemMode => _themeMode == AppThemeMode.system;

  String get themeModeString {
    switch (_themeMode) {
      case AppThemeMode.light:
        return 'Light Mode';
      case AppThemeMode.dark:
        return 'Dark Mode';
      case AppThemeMode.system:
        return 'System Mode';
    }
  }

  void setThemeMode(AppThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  void toggleTheme() {
    if (_themeMode == AppThemeMode.light) {
      setThemeMode(AppThemeMode.dark);
    } else {
      setThemeMode(AppThemeMode.light);
    }
  }

  void setLightMode() => setThemeMode(AppThemeMode.light);

  void setDarkMode() => setThemeMode(AppThemeMode.dark);

  void setSystemMode() => setThemeMode(AppThemeMode.system);
}
