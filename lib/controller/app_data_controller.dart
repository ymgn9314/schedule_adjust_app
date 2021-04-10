import 'package:flutter/material.dart';

class AppDataController extends ChangeNotifier {
  // ダークテーマにするか
  bool isDarkTheme = false;

  // 選択されているテーマカラー
  MaterialColor color = Colors.orange;
  MaterialAccentColor acColor = Colors.orangeAccent;

  // 初期のテーマ
  ThemeData themeData = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.orange,
    primaryColor: Colors.orange[500],
    primaryColorBrightness: Brightness.light,
    accentColor: Colors.orangeAccent,
    accentColorBrightness: Brightness.light,
    buttonColor: Colors.orange[50],
  );

  void applyColorThemeChange(MaterialColor color, MaterialAccentColor acColor) {
    themeData = ThemeData(
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      primarySwatch: color,
      primaryColor: color[500],
      primaryColorBrightness: isDarkTheme ? Brightness.dark : Brightness.light,
      accentColor: acColor,
      accentColorBrightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonColor: color[50],
    );
    this.color = color;
    this.acColor = acColor;
    notifyListeners();
  }

  void toggleDarkLightTheme() {
    isDarkTheme = !isDarkTheme;
    applyColorThemeChange(color, acColor);
  }
}
