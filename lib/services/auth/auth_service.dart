import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //authorization instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //sign in
  Future<Type> signInWithEmailAndPassword(String email, password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //save user info in a seperate doc
      _firestore.collection("Users").doc(result.user!.uid).set(
        {
          'uid': result.user!.uid,
          'email': email,
        },
      );

      return UserCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  //sign up
  Future<Type> createUserWithEmailAndPassword(
      String email, password, userName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //save user info in a seperate doc
      _firestore.collection("Users").doc(result.user!.uid).set(
        {
          'uid': result.user!.uid,
          'email': email,
          'userName': userName ?? email,
        },
      );

      return UserCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //deal eith errors
}
