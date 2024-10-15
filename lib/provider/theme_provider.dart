import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _themeData = AppTheme.lightTheme;

  ThemeData get themeData => _themeData;

  /// Toggles the theme of the app and saves it to the preferences.
  ///
  /// When this method is called, the theme of the app is toggled between
  /// light and dark. The theme is then saved to the preferences and
  /// the provider is notified to update the UI.
  void toggleTheme() async {
    _themeData = (_themeData == AppTheme.lightTheme)
        ? AppTheme.darkTheme
        : AppTheme.lightTheme;
    await saveTheme();
    notifyListeners();
  }

  /// Saves the theme to the preferences as an integer value.
  ///
  /// If the theme is light, the value 0 is saved. If the theme is dark, the
  /// value 1 is saved. The theme is saved to the preferences with the key
  /// 'theme'.
  ///
  /// This method is asynchronous and must be `await`ed.
  Future<void> saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? theme = (_themeData == AppTheme.lightTheme) ? 0 : 1;
    prefs.setInt('theme', theme);
  }

  /// Loads the theme from the preferences.
  ///
  /// If the theme is not stored in the preferences, the light theme is loaded.
  /// Otherwise, the theme is loaded from the preferences and the UI is updated.
  ///
  /// This method is asynchronous and must be `await`ed.
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? theme = prefs.getInt('theme');
    if (theme == null) {
      _themeData = AppTheme.lightTheme;
    } else {
      _themeData = (theme == 0) ? AppTheme.lightTheme : AppTheme.darkTheme;
    }
    notifyListeners();
  }
}
