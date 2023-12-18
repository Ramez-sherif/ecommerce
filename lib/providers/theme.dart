import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeMode thememode = ThemeMode.light;
  bool get isDarkMode => thememode == ThemeMode.dark; 
}
class MyThemes{
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(),
  );

  static final LightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(),
  );
}