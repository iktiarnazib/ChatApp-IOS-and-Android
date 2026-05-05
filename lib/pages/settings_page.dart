import 'package:chatapps/pages/update_username.dart';
import 'package:chatapps/themes/dark_mode.dart';
import 'package:chatapps/themes/light_mode.dart';
import 'package:chatapps/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends ConsumerStatefulWidget {
  final String userName;
  final String userEmail;
  final String userID;
  const SettingsPage({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userID,
  });

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
      await prefs.setBool('isDark', false);
    } else {
      ref.read(themeProvider.notifier).state = darkMode;
      await prefs.setBool('isDark', true);
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
      body: Column(
        children: [
          CircleAvatar(minRadius: 60, child: Icon(Icons.person, size: 60)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "User: ",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                widget.userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ],
          ),
          Text(
            "Email: ${widget.userEmail}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "User ID: ${widget.userID}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dark Mode',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Switch.adaptive(
                  value: isDark,
                  onChanged: (value) {
                    toggleTheme();
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UpdateUsername()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 25.0,
                horizontal: 25,
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Update Username',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Icon(Icons.arrow_right),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
