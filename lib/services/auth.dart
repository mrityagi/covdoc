import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heydoc/models/user.dart';
import 'package:heydoc/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool usedEmailPwdSignIn = true;

  User _userFromFirebaseUser(auth.User user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final auth.UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final auth.User user = authResult.user;
      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);
        if (authResult.additionalUserInfo.isNewUser) {
          await DatabaseService(uid: user.uid)
              .updateData(user.displayName, "", "", "", "");
        }
        usedEmailPwdSignIn = false;
        print('signInWithGoogle succeeded: $user');
        return user;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      auth.User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(
      String email,
      String password,
      String name,
      String phone,
      String address,
      String gender,
      String dob) async {
    try {
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      auth.User user = result.user;
      await DatabaseService(uid: user.uid)
          .updateData(name, phone, address, gender, dob);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      if (usedEmailPwdSignIn)
        return await _auth.signOut();
      else
        return await googleSignIn.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
