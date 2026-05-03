import 'package:chatapps/themes/dark_mode.dart';
import 'package:chatapps/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserTile extends ConsumerWidget {
  final String text;
  final String lastMessage;
  final int unreadCount;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    required this.lastMessage,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final bool hasUnread = unreadCount > 0;

    return ListTile(
      leading: CircleAvatar(child: Icon(Icons.person)),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: hasUnread ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
      subtitle: Text(
        lastMessage.isEmpty ? "Type a message.." : lastMessage,

        style: TextStyle(
          fontWeight: themeMode == darkMode
              ? (hasUnread ? FontWeight.w800 : FontWeight.normal)
              : (hasUnread ? FontWeight.w800 : FontWeight.normal),
          color: themeMode == darkMode
              ? (hasUnread ? Colors.white : Colors.grey)
              : (hasUnread ? Colors.black : Colors.grey),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: hasUnread
          ? CircleAvatar(
              radius: 10,
              backgroundColor: Colors.green,
              child: Text(
                '$unreadCount',
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
