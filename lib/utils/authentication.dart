import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;

  static Future<dynamic> signUp({required String email, required String pass}) async{
    try{
      UserCredential newAccount = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
      print("Auth 完了");
      return newAccount;
    } on FirebaseAuthException catch(e){
      print("Auth signUp Error: $e ");
      return false;
    }
  }

  static Future<dynamic> emailSignIn({required String email, required String password})async {
    try {
      final UserCredential _result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password);
      currentFirebaseUser = _result.user;
      print("Auth signin ok");
      return true;
    } on FirebaseAuthException catch(e){
      print("Auth emailSignIn Error: $e ");
      return false;
    }

  }
}