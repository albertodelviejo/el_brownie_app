import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'firebase_auth_api.dart';

class AuthRepository {
  final _firebaseAuthAPI = FirebaseAuthAPI();

  Future<User> signInFirebase(email, password) =>
      _firebaseAuthAPI.signIn(email, password);

  Future<User> registerFirebase(email, password) =>
      _firebaseAuthAPI.register(email, password);

  Future<User> singInGoogle() => _firebaseAuthAPI.signInGoogle();

  Future<User> singInFacebook() => _firebaseAuthAPI.signInFacebook();

  signOut() => _firebaseAuthAPI.signOut();
}
