import 'package:chatapps/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  String errorMessage = '';
  signOut() async {
    try {
      AuthService().signOut();
    } on FirebaseAuthException catch (e) {
      errorMessage = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(FirebaseAuth.instance.currentUser!.displayName ?? 'User'),
        actions: [
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: signOut),
        ],
      ),
      body: Column(
        children: [
          if (errorMessage.isNotEmpty) Center(child: Text(errorMessage)),
        ],
      ),
    );
  }
}
