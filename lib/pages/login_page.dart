import 'package:chatapps/components/my_sign_button.dart';
import 'package:chatapps/components/my_text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void onSignIn() async {}

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
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          SizedBox(height: 25),

          //email textfield
          MyTextField(
            controller: emailController,
            hintText: 'Email',
            obscureText: false,
          ),

          SizedBox(height: 10),

          //password textfield
          MyTextField(
            controller: passController,
            hintText: 'Password',
            obscureText: true,
          ),

          //login button
          MySignButton(buttonText: 'Sign In', onTap: onSignIn),

          //register button
        ],
      ),
    );
  }
}
