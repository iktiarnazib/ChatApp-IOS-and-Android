import 'package:chatapps/components/user_tile.dart';
import 'package:chatapps/pages/chat_page.dart';
import 'package:chatapps/services/auth/auth_service.dart';
import 'package:chatapps/components/my_drawer.dart';
import 'package:chatapps/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String errorMessage = '';
  StreamSubscription? _chatRoomsSubscription; // ← add this

  signOut() async {
    try {
      AuthService().signOut();
    } on FirebaseAuthException catch (e) {
      errorMessage = e.toString();
    }
  }

  @override
  void initState() {
    super.initState();

    _listenToChatRooms();
  }

  void _listenToChatRooms() {
    _chatRoomsSubscription = FirebaseFirestore.instance
        .collection("Chat_rooms")
        .snapshots()
        .listen((_) {
          if (mounted) setState(() {}); // ← triggers StreamBuilder to rebuild
        });
  }

  @override
  void dispose() {
    _chatRoomsSubscription?.cancel(); // ← always cancel subscriptions
    super.dispose();
  }

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(
            context,
          ).colorScheme.primary, // matches your drawer icon color
        ),
        title: Row(
          children: [
            CircleAvatar(child: Icon(Icons.person)),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    FirebaseAuth.instance.currentUser!.displayName ?? 'User',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${_authService.getCurrentUser()!.email}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Tooltip(
            message: 'Reload',
            child: IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.replay_outlined),
            ),
          ),
        ],
      ),
      drawer: MyDrawer(
        userName: _authService.getCurrentUser()!.displayName ?? "User",
        userEmail: _authService.getCurrentUser()!.email!,
        userID: _authService.getCurrentUser()!.uid,
      ),
      body: _buildUserName(),
    );
  }

  //build a list of users except for the current logged in user
  Widget _buildUserName() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //error
        if (snapshot.hasError) {
          return Center(child: const Text('Error'));
        }
        //leading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        }

        //return list view.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Text(
                'Inbox',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView(
                children: snapshot.data!
                    .map<Widget>(
                      (userData) => _buildUserListItems(userData, context),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  //build individual listtile for users
  Widget _buildUserListItems(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    if (userData["email"].toLowerCase() !=
        _authService.getCurrentUser()!.email!.toLowerCase()) {
      final String lastMessage = userData["lastMessage"] ?? "";
      final int unreadCount = userData["unreadCount"] ?? 0;

      return UserTile(
        text: userData["username"] ?? "User",
        lastMessage: lastMessage,
        unreadCount: unreadCount,
        onTap: () async {
          // ← make async
          await Navigator.push(
            // ← await so we know when user comes back
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
                userName: userData["username"] ?? "User",
              ),
            ),
          );

          // runs AFTER user presses back button
          await _chatService.markAsRead(
            userData["uid"],
          ); // ← mark read on return
          setState(() {});
        },
      );
    } else {
      return Container();
    }
  }
}
