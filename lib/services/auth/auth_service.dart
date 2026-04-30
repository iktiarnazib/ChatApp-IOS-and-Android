import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //instance of auth & firestore
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser() {
    return auth.currentUser;
  }

  //sign user in
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    //save user info if it doesn't already exist
    _firestore.collection("Users").doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
    });

    return userCredential;
  }

  //sign up
  Future<UserCredential> signUp(
    String email,
    String password,
    String username,
  ) async {
    //create user
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    //save user info in a separate folder
    _firestore.collection("Users").doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
    });

    //enter username
    await userCredential.user!.updateDisplayName(username);
    await userCredential.user!.reload();

    return userCredential;
  }

  //sign out
  Future<void> signOut() async {
    //firebase signout
    await auth.signOut();
  }

  //others
}
