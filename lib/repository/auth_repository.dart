import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_auth_api.dart';

class AuthRepository {
  final _firebaseAuthAPI = FirebaseAuthAPI();

  Future<dynamic> signInFirebase(email, password) =>
      _firebaseAuthAPI.signIn(email, password);

  Future<void> resetPassword(email) => _firebaseAuthAPI.resetPassword(email);

  Future<dynamic> registerFirebase(email, password) =>
      _firebaseAuthAPI.register(email, password);

  Future<dynamic> singInGoogle() => _firebaseAuthAPI.signInGoogle();

  Future<dynamic> singInFacebook() => _firebaseAuthAPI.signInFacebook();
  Future<dynamic> singInApple() => _firebaseAuthAPI.signInApple();

  signOut() => _firebaseAuthAPI.signOut();
}
