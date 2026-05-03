import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: const Color.fromARGB(255, 118, 118, 118),
    secondary: Colors.grey.shade200,
    tertiary: Colors.black,
    inversePrimary: Colors.grey.shade900,
  ),
);
