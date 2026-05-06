import 'package:chatapps/components/my_text_field.dart';
import 'package:chatapps/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateUsername extends StatefulWidget {
  const UpdateUsername({super.key});

  @override
  State<UpdateUsername> createState() => _UpdateUsernameState();
}

class _UpdateUsernameState extends State<UpdateUsername> {
  TextEditingController usernameController = TextEditingController();

  final AuthService _auth = AuthService();

  String errorMessage = '';

  void onUpdateUser() async {
    try {
      _auth.updateUsername(usernameController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.code;
      });
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
            child: OutlinedButton(
              onPressed: () {
                onUpdateUser();
              },

              style: OutlinedButton.styleFrom(
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
