import 'package:flutter/material.dart';

class ChatBubbles extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubbles({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.green : Colors.grey[500],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: TextStyle(color: isCurrentUser ? Colors.white : Colors.black),
      ),
    );
  }
}
