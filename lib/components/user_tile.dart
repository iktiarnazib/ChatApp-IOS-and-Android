import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final bool hasUnread = unreadCount > 0;

    return ListTile(
      leading: CircleAvatar(child: Icon(Icons.person)),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        lastMessage.isEmpty ? "No messages yet" : lastMessage,
        style: TextStyle(
          fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
          color: hasUnread ? Colors.black : Colors.grey,
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
