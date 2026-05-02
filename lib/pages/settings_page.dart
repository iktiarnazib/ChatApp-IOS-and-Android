import 'package:chatapps/themes/dark_mode.dart';
import 'package:chatapps/themes/light_mode.dart';
import 'package:chatapps/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  void toggleTheme() async {
    //initiating shared preference.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isDark = ref.read(themeProvider);
    if (isDark == darkMode) {
      ref.read(themeProvider.notifier).state = lightMode;
    } else {
      ref.read(themeProvider.notifier).state = darkMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(themeProvider) == darkMode;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: Text(
          'Settings',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Dark Mode'),
            Switch.adaptive(
              value: isDark,
              onChanged: (value) {
                toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
