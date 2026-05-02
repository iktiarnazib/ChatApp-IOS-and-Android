import 'package:chatapps/services/auth/auth_gate.dart';
import 'package:chatapps/pages/settings_page.dart';
import 'package:chatapps/themes/dark_mode.dart';
import 'package:chatapps/themes/light_mode.dart';
import 'package:chatapps/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  //flutter engine and frameworks are fully initialized before your app runs
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isDarkMode = prefs.getBool('isDark') ?? false;
  runApp(
    ProviderScope(
      overrides: [
        themeProvider.overrideWith((ref) => isDarkMode ? darkMode : lightMode),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {'settingsPage': (context) => SettingsPage()},
      theme: themeMode,
      home: AuthGate(),
    );
  }
}
