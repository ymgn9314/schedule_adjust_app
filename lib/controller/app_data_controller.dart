import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDataController extends ChangeNotifier {
  // ダークテーマにするか
  bool isDarkTheme = false;
  // 何番目のカラーテーマが選択されているか(shared preferenceで保存)
  int themeIndex = 0;
  List<Map<String, dynamic>> colorTheme = [
    <String, dynamic>{
      'materialColor': Colors.red,
      'MaterialAccentColor': Colors.redAccent,
    },
    <String, dynamic>{
      'materialColor': Colors.deepOrange,
      'MaterialAccentColor': Colors.deepOrangeAccent,
    },
    <String, dynamic>{
      'materialColor': Colors.green,
      'MaterialAccentColor': Colors.greenAccent,
    },
    <String, dynamic>{
      'materialColor': Colors.blue,
      'MaterialAccentColor': Colors.blueAccent,
    },
  ];

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

  void applyColorThemeChange(int index) {
    final matColor = colorTheme[index]['materialColor'] as MaterialColor;
    final matAcColor =
        colorTheme[index]['MaterialAccentColor'] as MaterialAccentColor;
    themeData = ThemeData(
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      primarySwatch: matColor,
      primaryColor: matColor[500],
      primaryColorBrightness: isDarkTheme ? Brightness.dark : Brightness.light,
      accentColor: matColor[400],
      accentColorBrightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonColor: matColor[500],
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: matColor[600],
      ),
    );
    themeIndex = index;
    color = matColor;
    acColor = matAcColor;

    setSharedPreferenceTheme();
    notifyListeners();
  }

  void toggleDarkLightTheme() {
    isDarkTheme = !isDarkTheme;
    applyColorThemeChange(themeIndex);
  }

  Future<void> setSharedPreferenceTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDarkTheme);
    await prefs.setInt('themeIndex', themeIndex);
    print('saved shared_preferences(isDark: $isDarkTheme, index: $themeIndex)');
  }

  Future<void> loadSharedPreferenceTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    themeIndex = prefs.getInt('themeIndex') ?? 0;
    applyColorThemeChange(themeIndex);
  }
}
