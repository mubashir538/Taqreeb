import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final theme = await MyStorage.getToken(MyTokens.theme) ?? "";
    if (theme == MyTokens.Light) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  Future<void> switchTheme() async {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
      await MyStorage.saveToken(MyTokens.Light, MyTokens.theme);
    } else {
      _themeMode = ThemeMode.dark;
      await MyStorage.saveToken(MyTokens.dark, MyTokens.theme);
    }
    notifyListeners();
  }
}
