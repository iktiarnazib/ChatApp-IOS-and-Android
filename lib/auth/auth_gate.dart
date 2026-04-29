import 'package:chatapps/auth/login_or_register.dart';
import 'package:chatapps/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),

        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          }
          //if the user is not logged in, return login page
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
