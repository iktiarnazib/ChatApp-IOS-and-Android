import 'package:chatapps/components/my_sign_button.dart';
import 'package:chatapps/components/my_text_field.dart';
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

  void onSignUp() async {}

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
          //space between
          SizedBox(height: 10),
          //confirm password textfield
          MyTextField(
            controller: passController,
            hintText: 'Confirm Password',
            obscureText: true,
          ),

          //space between
          SizedBox(height: 10),
          //login button
          MySignButton(buttonText: 'Sign Up', onTap: onSignUp),
          //space between
          SizedBox(height: 25),
          //register button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account? '),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  'Login Now',
                  style: TextStyle(
                    color: Colors.blue,
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
