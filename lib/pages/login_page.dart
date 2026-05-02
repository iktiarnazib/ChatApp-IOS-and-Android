import 'package:chatapps/services/auth/auth_service.dart';
import 'package:chatapps/components/my_sign_button.dart';
import 'package:chatapps/components/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  String errorMessage = '';

  //signin method
  void onSignIn() async {
    try {
      await AuthService().signInWithEmailAndPassword(
        emailController.text,
        passController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        setState(() {
          errorMessage = 'Please enter correct email and password';
        });
      } else if (e.code == 'user-not-found') {
        setState(() {
          errorMessage = 'No User found for this email';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          errorMessage = 'You have typed the wrong password';
        });
      } else {
        setState(() {
          errorMessage = e.code;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 25),
          //logo
          SafeArea(
            child: Center(
              child: Icon(
                Icons.message,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          //welcome back
          Text(
            'Welcome back, you\'ve been missed',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),

          SizedBox(height: 25),

          //email textfield
          MyTextField(
            controller: emailController,
            hintText: 'Email',
            obscureText: false,
            focusNode: null,
          ),

          SizedBox(height: 10),

          //password textfield
          MyTextField(
            controller: passController,
            hintText: 'Password',
            obscureText: true,
            focusNode: null,
          ),
          if (errorMessage.isNotEmpty)
            Column(
              children: [
                SizedBox(height: 10),
                Text(
                  'Error: $errorMessage',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),

          //space between
          SizedBox(height: 25),
          //login button
          MySignButton(buttonText: 'Sign In', onTap: () => onSignIn()),
          //space between
          SizedBox(height: 25),
          //register button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account? ',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  'Register Now',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    // color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
