import 'package:chatapps/services/auth/auth_service.dart';
import 'package:chatapps/components/my_sign_button.dart';
import 'package:chatapps/components/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;

  void onSignUp() async {
    if (isLoading) return;
    if (passController.text == confirmPassController.text) {
      try {
        await AuthService().signUp(
          emailController.text,
          passController.text,
          usernameController.text,
        );
      } on FirebaseAuthException catch (e) {
        if (passController.text.isEmpty || confirmPassController.text.isEmpty) {
          setState(() {
            errorMessage = 'Your password field is empty';
          });
        } else {
          if (mounted) {
            setState(() {
              errorMessage = e.code;
            });
          }
        }
      }
    } else {
      setState(() {
        errorMessage = 'Current password doesn\'t match with confirm pass';
      });
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
            'Let\'s create an account for you',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),

          SizedBox(height: 25),
          //email textfield
          MyTextField(
            controller: usernameController,
            hintText: 'Username',
            obscureText: false,
            focusNode: null,
          ),
          SizedBox(height: 10),
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
          //space between
          SizedBox(height: 10),
          //confirm password textfield
          MyTextField(
            controller: confirmPassController,
            hintText: 'Confirm Password',
            obscureText: true,
            focusNode: null,
          ),
          if (errorMessage.isNotEmpty)
            Column(
              children: [
                SizedBox(height: 10),
                Text(errorMessage, style: TextStyle(color: Colors.red)),
              ],
            ),
          //space between
          SizedBox(height: 25),
          //login button
          MySignButton(buttonText: 'Sign Up', onTap: onSignUp),
          //space between
          SizedBox(height: 25),
          //register button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  'Login Now',
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
