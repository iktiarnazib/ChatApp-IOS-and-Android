import 'package:chatapps/components/my_text_field.dart';
import 'package:chatapps/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    if (usernameController.text.isNotEmpty) {
      try {
        if (FirebaseAuth.instance.currentUser == null) return;
        await _auth.updateUsername(usernameController.text);
        await FirebaseAuth.instance.currentUser!.reload();

        //updating usenrame into the firebase Users storage.
        //so it is shown if a user changes their name
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
    } else {
      setState(() {
        errorMessage = 'Please write a username';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Username',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Update Your Username',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
          ),
          SizedBox(height: 20),
          MyTextField(
            controller: usernameController,
            hintText: 'Type your new username',
            obscureText: false,
            focusNode: null,
          ),
          if (errorMessage.isNotEmpty)
            Text("Error: $errorMessage", style: TextStyle(color: Colors.red)),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
            child: OutlinedButton(
              onPressed: () {
                onUpdateUser();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Update Username'),
            ),
          ),
        ],
      ),
    );
  }
}
