import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  Future<User> signIn(email, password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  Future<User> register(email, password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    return userCredential.user;
  }

  Future<User> signInGoogle() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: gSA.accessToken,
      idToken: gSA.idToken,
    );

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    User _user = userCredential.user;

    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);
    User currentUser = _auth.currentUser;
    assert(_user.uid == currentUser.uid);

    return currentUser;
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
    print("Sesiones cerradas");
  }
}
