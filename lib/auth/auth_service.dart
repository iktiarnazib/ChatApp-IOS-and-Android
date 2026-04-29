import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  //sign in
  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign up
  Future<void> signUp(String email, password, username) async {
    try {
      //sign up account
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //enter username
      await userCredential.user!.updateDisplayName(username);
      await userCredential.user!.reload();
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  //sign out
  Future<void> signOut() async {
    //firebase signout
    await auth.signOut();
  }

  //others
}
