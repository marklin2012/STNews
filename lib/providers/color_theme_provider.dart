import 'package:flutter/material.dart';

class ColorThemeProvider extends ChangeNotifier {
  late ThemeMode _themeMode;

  static ColorThemeProvider? _shared;

  static ColorThemeProvider get shared => ColorThemeProvider.sharedColorTheme();

  static ColorThemeProvider sharedColorTheme() {
    _shared ??= ColorThemeProvider._();
    return _shared!;
  }

  ThemeMode get themeMode => _themeMode;

  ColorThemeProvider._() {
    _themeMode = ThemeMode.light;
  }

  set themeMode(ThemeMode? mode) {
    if (mode != null) {
      _themeMode = mode;
      notifyListeners();
    }
  }
}
