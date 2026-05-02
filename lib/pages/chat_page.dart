import 'package:chatapps/components/chat_bubbles.dart';
import 'package:chatapps/components/my_text_field.dart';
import 'package:chatapps/services/auth/auth_service.dart';
import 'package:chatapps/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //sending text controller
  final TextEditingController messageController = TextEditingController();

  //chat and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //for textfield focus
  FocusNode myFocusNote = FocusNode();

  @override
  void initState() {
    super.initState();

    //add listener to my focus note
    myFocusNote.addListener(() {
      if (myFocusNote.hasFocus) {
        //cause a delay so the keyboard has time to show up
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
        //then the amount of remaining space will be calcualted
        //then scroll down
      }
    });

    //wait for listview builder to build, then scroll down
    Future.delayed(const Duration(milliseconds: 200), () => scrollDown());

    // ← ADD THIS: listen to the message stream and scroll on new messages
    final String senderID = _authService.getCurrentUser()!.uid;
    _chatService.getMessages(widget.receiverID, senderID).listen((_) {
      Future.delayed(const Duration(milliseconds: 100), () => scrollDown());
    });
  }

  @override
  void dispose() {
    myFocusNote.dispose();
    messageController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 1000),
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }

  //send message
  void sendMessage() async {
    //if message controller is not empty when clicked
    if (messageController.text.isNotEmpty) {
      //send a message
      _chatService.sendMessage(widget.receiverID, messageController.text);
      //clear controller
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('Receiver:', style: TextStyle(fontSize: 18)),
            Text(
              widget.receiverEmail,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
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
      stream: _chatService.getMessages(widget.receiverID, senderID),
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
          controller: _scrollController,
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

    return Container(
      alignment: alignment,
      child: ChatBubbles(message: data["message"], isCurrentUser: _currentUser),
    );
  }

  //build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          //text field should take most of the spot
          Expanded(
            child: MyTextField(
              controller: messageController,
              hintText: 'Type a message...',
              obscureText: false,
              focusNode: myFocusNote,
            ),
          ),

          //send button
          Container(
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

//finished until 6:41:00
