import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 28, 28, 28),
    primary: Colors.grey.shade400,
    secondary: const Color.fromARGB(255, 40, 40, 40),
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade100,
  ),
);
