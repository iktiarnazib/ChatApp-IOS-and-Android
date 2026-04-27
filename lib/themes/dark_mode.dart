import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade700,
    primary: Colors.grey.shade400,
    secondary: Colors.grey.shade800,
    tertiary: Colors.black,
    inversePrimary: Colors.grey.shade100,
  ),
);
