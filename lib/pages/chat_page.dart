import 'package:chatapps/services/auth/auth_service.dart';
import 'package:chatapps/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //sending text controller
  final TextEditingController messageController = TextEditingController();

  //chat and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //send message
  void sendMessage() async {
    //if message controller is not empty when clicked
    if (messageController.text.isNotEmpty) {
      //send a message
      _chatService.sendMessage(widget.receiverEmail, messageController.text);
      //clear controller
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverEmail)),
      body: Column(
        children: [
          //build message list
          Expanded(child: _buildMessageList),
          //user input
        ],
      ),
    );
  }
}
