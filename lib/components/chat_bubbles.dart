import 'package:chatapps/themes/dark_mode.dart';
import 'package:chatapps/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatBubbles extends ConsumerWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubbles({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //theme provider
    final isDark = ref.watch(themeProvider) == darkMode;
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? (isDark ? Colors.green : Colors.green[400])
            : (isDark ? Colors.grey.shade800 : Colors.white70),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isCurrentUser
              ? (isDark ? Colors.white : Colors.white)
              : (isDark ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
