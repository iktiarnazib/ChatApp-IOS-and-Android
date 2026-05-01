import 'package:chatapps/components/my_text_field.dart';
import 'package:chatapps/services/auth/auth_service.dart';
import 'package:chatapps/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

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
      _chatService.sendMessage(receiverID, messageController.text);
      //clear controller
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receiverEmail)),
      body: Column(
        children: [
          //build message list
          Expanded(child: _buildMessageList()),
          //user input
          _buildUserInput(),
        ],
      ),
    );
  }

  //building message lists
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //if error
        if (snapshot.hasError) {
          return Center(child: const Text('Error'));
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        }

        //if snapshot has data, fallback listview
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildMessageItems(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItems(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //is current user
    bool _currentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    //align messages to right if the sender is the current user, otherwise left
    var alignment = _currentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(alignment: alignment, child: Text(data["message"]));
  }

  //build message input
  Widget _buildUserInput() {
    return Row(
      children: [
        //text field should take most of the spot
        Expanded(
          child: MyTextField(
            controller: messageController,
            hintText: 'Type your text',
            obscureText: false,
          ),
        ),

        //send button
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.arrow_upward),
        ),
      ],
    );
  }
}
