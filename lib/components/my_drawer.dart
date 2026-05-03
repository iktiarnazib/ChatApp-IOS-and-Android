import 'package:chatapps/pages/settings_page.dart';
import 'package:chatapps/services/auth/auth_service.dart';
import 'package:chatapps/components/my_drawer_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final String userEmail;
  final String userName;
  final String userID;
  const MyDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userID,
  });

  void onHomeTap(BuildContext context) {
    Navigator.pop(context);
  }

  void onSettingsTap(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SettingsPage(
            userName: userName,
            userEmail: userEmail,
            userID: userID,
          );
        },
      ),
    );
  }

  void onSingOut() async {
    await AuthService().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          //drawer header (Logo and app name)
          DrawerHeader(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Icon(
                    Icons.message,
                    size: 40,
                    color: Colors.green[700],
                  ),
                ),
                Text(
                  'JUST CHAT',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          //space
          SizedBox(height: 25),
          //chat page
          MyDrawerTile(
            text: 'H O M E',
            icon: Icons.home,

            onTap: () => onHomeTap(context),
          ),

          //settings page
          MyDrawerTile(
            text: 'S E T T I N G S',
            icon: Icons.settings,
            onTap: () => onSettingsTap(context),
          ),
          Expanded(child: SizedBox()),
          //sign out
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: MyDrawerTile(
              text: 'L O G O U T',
              icon: Icons.exit_to_app,
              onTap: onSingOut,
            ),
          ),
        ],
      ),
    );
  }
}
