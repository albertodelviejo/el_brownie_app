import 'package:el_brownie_app/repository/auth_result_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_exception_handler.dart';

class FirebaseAuthAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();
  AuthResultStatus _status;

  Future<dynamic> signIn(email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User _user = userCredential.user;

      if (_user != null) {
        _status = AuthResultStatus.successful;
        return _user;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }

    return _status;
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<dynamic> register(email, password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        _status = AuthResultStatus.successful;
        return userCredential.user;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }

    return _status;
  }

  Future<dynamic> signInGoogle() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: gSA.accessToken,
      idToken: gSA.idToken,
    );

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    User _user = userCredential.user;

    if (_user != null) {
      _status = AuthResultStatus.successful;
      return _user;
    } else {
      _status = AuthResultStatus.undefined;
    }

    return _status;
  }

  Future<User> signInFacebook() async {
    final result = await facebookLogin.logIn(['email']);

    if (result.status != FacebookLoginStatus.loggedIn) {
      return null;
    }

    final AuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken.token);

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    User _user = userCredential.user;

    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);
    User currentUser = _auth.currentUser;
    assert(_user.uid == currentUser.uid);

    return currentUser;
  }

  signOut() async {
    await _auth.signOut().then((onValue) => print("Sesión cerrada"));
    await googleSignIn
        .signOut()
        .then((value) => print("Sesión cerrada Google"));
    await facebookLogin
        .logOut()
        .then((value) => print("Sesión cerrada Facebook"));
  }
}
