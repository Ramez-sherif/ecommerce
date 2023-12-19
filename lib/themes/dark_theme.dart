import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Color.fromRGBO(20, 20, 20, 0.5),
      primary: Colors.grey[900]!,
      secondary: Colors.grey[800]!,
    ));
