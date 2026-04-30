import 'package:chatapps/components/user_tile.dart';
import 'package:chatapps/pages/chat_page.dart';
import 'package:chatapps/services/auth/auth_service.dart';
import 'package:chatapps/components/my_drawer.dart';
import 'package:chatapps/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String errorMessage = '';
  signOut() async {
    try {
      AuthService().signOut();
    } on FirebaseAuthException catch (e) {
      errorMessage = e.toString();
    }
  }

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(child: Icon(Icons.person)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                FirebaseAuth.instance.currentUser!.displayName ?? 'User',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
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
          return const Text('Error');
        }
        //leading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        //return list view.
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItems(userData, context))
              .toList(),
        );
      },
    );
  }

  //build individual listtile for users
  Widget _buildUserListItems(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    //display all users except current users
    if (userData["Email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ChatPage(receiverEmail: userData["email"]);
              },
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}

//completed until user clickable in the home page and showing username on the top.
