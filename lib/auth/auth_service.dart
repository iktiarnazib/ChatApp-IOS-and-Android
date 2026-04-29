import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  //sign in
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  //sign up
  Future<UserCredential> signUp(
    String email,
    String password,
    String username,
  ) async {
    //sign up account
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    //enter username
    await userCredential.user!.updateDisplayName(username);
    await userCredential.user!.reload();
    //returning user credentail
    userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential;
  }

  //sign out
  Future<void> signOut() async {
    //firebase signout
    await auth.signOut();
  }

  //others
}
