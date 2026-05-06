import 'package:chatapps/components/my_text_field.dart';
import 'package:chatapps/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateUsername extends StatefulWidget {
  final TextEditingController usernameController;
  const UpdateUsername({super.key, required this.usernameController});

  @override
  State<UpdateUsername> createState() => _UpdateUsernameState();
}

class _UpdateUsernameState extends State<UpdateUsername> {
  TextEditingController usernameController = TextEditingController();

  final AuthService _auth = AuthService();

  String errorMessage = '';

  void onUpdateUser() async {
    try {
      if (FirebaseAuth.instance.currentUser == null) return;
      await _auth.updateUsername(usernameController.text);
      await FirebaseAuth.instance.currentUser!.reload();
      //save user info in a separate folde
      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"username": usernameController.text});
      if (mounted) {
        Navigator.pop(context);
      }
      setState(() {});
    } on FirebaseAuthException catch (e) {
      errorMessage = e.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Username')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyTextField(
            controller: usernameController,
            hintText: 'Type your username',
            obscureText: false,
            focusNode: null,
          ),
          if (errorMessage.isNotEmpty) Text("Error: $errorMessage"),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
            child: FilledButton(
              onPressed: () {
                onUpdateUser();
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('UPDATE USERNAME'),
            ),
          ),
        ],
      ),
    );
  }
}
