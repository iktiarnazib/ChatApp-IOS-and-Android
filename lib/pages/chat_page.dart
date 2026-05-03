import 'package:chatapps/components/chat_bubbles.dart';
import 'package:chatapps/components/my_text_field.dart';
import 'package:chatapps/services/auth/auth_service.dart';
import 'package:chatapps/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  final String userName;
  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    required this.userName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  FocusNode myFocusNote = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // mark as read when chat opens
    _chatService.markAsRead(widget.receiverID);

    myFocusNote.addListener(() {
      if (myFocusNote.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    Future.delayed(const Duration(milliseconds: 200), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNote.dispose();
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
    // ← REMOVED markAsRead from here, home_page handles it after navigator returns
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      // ← safety check added
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 1000),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    }
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, messageController.text);
      messageController.clear();
      scrollDown(); // ← scroll down after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.userName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
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
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(child: const Text('Error'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        }

        // scroll down when new message arrives
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => scrollDown(),
        ); // ← auto scroll on new message

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
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;
    var alignment = isCurrentUser
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: ChatBubbles(
        message: data["message"],
        isCurrentUser: isCurrentUser,
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: messageController,
              hintText: 'Type a message...',
              obscureText: false,
              focusNode: myFocusNote,
            ),
          ),
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
