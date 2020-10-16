import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'firebase_auth_api.dart';

class AuthRepository {
  final _firebaseAuthAPI = FirebaseAuthAPI();

  Future<User> signInFirebase(email, password) {
    try {
      _firebaseAuthAPI.signIn(email, password);
    } on PlatformException catch (e) {}
  }

  Future<User> registerFirebase(email, password) {
    try {
      _firebaseAuthAPI.register(email, password);
    } on PlatformException catch (e) {}
  }

  Future<User> singInGoogle() => _firebaseAuthAPI.signInGoogle();

  signOut() => _firebaseAuthAPI.signOut();
}
