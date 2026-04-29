import 'package:chatapps/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

//providing lightmode
final themeProvider = StateProvider<ThemeData>((ref) {
  return lightMode;
});
