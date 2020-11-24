import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_auth_api.dart';

class AuthRepository {
  final _firebaseAuthAPI = FirebaseAuthAPI();

  Future<dynamic> signInFirebase(email, password) =>
      _firebaseAuthAPI.signIn(email, password);

  Future<void> resetPassword(email) => _firebaseAuthAPI.resetPassword(email);

  Future<dynamic> registerFirebase(email, password) =>
      _firebaseAuthAPI.register(email, password);

  Future<User> singInGoogle() => _firebaseAuthAPI.signInGoogle();

  Future<User> singInFacebook() => _firebaseAuthAPI.signInFacebook();

  signOut() async => await _firebaseAuthAPI.signOut();
}
