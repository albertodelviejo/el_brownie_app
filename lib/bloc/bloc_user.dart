import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/repository/auth_repository.dart';
import 'package:el_brownie_app/repository/cloud_firestore_api.dart';
import 'package:el_brownie_app/repository/cloud_firestore_repository.dart';
import 'package:el_brownie_app/repository/google_maps_api.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/cardlosmas.dart';
import 'package:el_brownie_app/ui/utils/cardnotification.dart';
import 'package:el_brownie_app/ui/utils/commentswidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class UserBloc implements Bloc {
  final _authRepository = AuthRepository();
  final _cloudFirestoreRepository = CloudFirestoreRepository();
  final _googleMapsApi = GoogleMapsApi();
  var user = UserModel();

//Streams
  Stream<User> streamFirebase = FirebaseAuth.instance.authStateChanges();
  Stream<User> get authStatus => streamFirebase;
  User get currentUser => FirebaseAuth.instance.currentUser;

//Casos de Uso

//1. Login en firebase
  Future<dynamic> signIn({email, password}) =>
      _authRepository.signInFirebase(email, password);

  void updateUserData(UserModel user) =>
      _cloudFirestoreRepository.updateUserDataFirestore(user);

//2. Register in firebase
  Future<dynamic> register({email, password}) =>
      _authRepository.registerFirebase(email, password);

//3. Log in Google
  Future<dynamic> signInGoogle() => _authRepository.singInGoogle();

//4. Log in Facebook
  Future<dynamic> signInFacebook() => _authRepository.singInFacebook();

//5. Get posts
  Stream<QuerySnapshot> myPostsListStream() => FirebaseFirestore.instance
      .collection(CloudFirestoreAPI().POSTS)
      .where('status', isEqualTo: false)
      .orderBy('date', descending: true)
      .snapshots();

//With CardLosMas
  List<CardLosmas> buildMyPosts(List<DocumentSnapshot> ticketsListSnapshot) =>
      _cloudFirestoreRepository.buildAllPosts(ticketsListSnapshot);

  //With CardLosMas
  List<CardLosmas> buildCercaPosts(
          List<DocumentSnapshot> ticketsListSnapshot) =>
      _cloudFirestoreRepository.buildCercaPosts(ticketsListSnapshot);

//With CardHome
  List<CardHome> buildMyPostsCardHome(
          List<DocumentSnapshot> ticketsListSnapshot) =>
      _cloudFirestoreRepository.buildMyPostsCardHome(ticketsListSnapshot);

// 7. Set post as favourite

  Future likePost(String idPost) =>
      _cloudFirestoreRepository.likePost(idPost, user.uid);

// 8. Remove a post from favourite

  Future unlikePost(String idPost) =>
      _cloudFirestoreRepository.unlikePost(idPost, user.uid);

//9. Create new post

  Future<String> createPost(
          String idPost,
          String address,
          String category,
          String name,
          String comentary,
          double price,
          bool status,
          String photoUrl,
          int valoration) =>
      _cloudFirestoreRepository.createPost(idPost, currentUser.uid, address,
          category, name, comentary, price, status, photoUrl, valoration);

//10. Get my brownies
  Stream<QuerySnapshot> myBrowniesListStream(uid) => FirebaseFirestore.instance
      .collection(CloudFirestoreAPI().POSTS)
      .where("id_user", isEqualTo: uid)
      .orderBy('date', descending: true)
      .snapshots();

  List<CardHome> buildMyBrownies(List<DocumentSnapshot> ticketsListSnapshot) =>
      _cloudFirestoreRepository.buildMyBrownies(ticketsListSnapshot);

  //11. Add comment

  Future<String> addComment(String idPost, String uid, String userName,
          String avatarURL, String photoUrl, String text, String valoration) =>
      _cloudFirestoreRepository.addComment(
          idPost, uid, userName, avatarURL, photoUrl, text, valoration);

  //12. Build comments
  List<CommentsW> buildComments(List<DocumentSnapshot> ticketsListSnapshot) =>
      _cloudFirestoreRepository.buildComments(ticketsListSnapshot);

  Stream<QuerySnapshot> commentsListStream(idPost) => FirebaseFirestore.instance
      .collection("comments")
      .where("id_post", isEqualTo: idPost)
      .snapshots();

  //13. Reset password
  Future<void> resetPassword(email) => _authRepository.resetPassword(email);

  signOut() => _authRepository.signOut();

  //14.Add a notification
  Future<String> addNotification(
          String idUser, String notificationType, int points) async =>
      await _cloudFirestoreRepository.addNotification(
          idUser, notificationType, points);

  //15. Delete a notification
  void deleteNotification(String idNotification) =>
      _cloudFirestoreRepository.deleteNotification(idNotification);

  //16. Set no notification
  void setNoNotifications(String idUser) =>
      _cloudFirestoreRepository.setNoNotifications(idUser);

  //17. Set no request notification
  void setNoRequestNotifications(String idUser) =>
      _cloudFirestoreRepository.setNoRequestNotifications(idUser);

  //16. Build Notification
  Stream<QuerySnapshot> notificationsListStream() => FirebaseFirestore.instance
      .collection("notifications")
      .where("id_user", isEqualTo: currentUser.uid)
      .orderBy("date", descending: true)
      .snapshots();

  List<CardNotification> buildNotifications(
          List<DocumentSnapshot> notificationsListSnapshot) =>
      _cloudFirestoreRepository.buildNotifications(notificationsListSnapshot);

//17. Actualizar perfil
  void updateUserProfile(UserModel user) =>
      _cloudFirestoreRepository.updateUserProfileFirestore(user);

  void updateCommentsPhoto(UserModel user, String id) =>
      _cloudFirestoreRepository.updateCommentsPhoto(user, id);

//18. Add and Delete points

  void addPoints(String idUser, int value) =>
      _cloudFirestoreRepository.addPoints(idUser, value);

  void deletePoints(String idUser) =>
      _cloudFirestoreRepository.deletePoints(idUser);

//19. Get los mas guarros posts
  Stream<QuerySnapshot> myMostPostsListStream() => FirebaseFirestore.instance
      .collection(CloudFirestoreAPI().POSTS)
      .where('status', isEqualTo: false)
      .orderBy('valoration', descending: true)
      .snapshots();

  List<CardLosmas> buildMyMostPosts(
          List<DocumentSnapshot> ticketsListSnapshot) =>
      _cloudFirestoreRepository.buildMyMostPosts(ticketsListSnapshot);

  //20. Top 3 notification
  void updateAddTop3Notification(bool isTop3) =>
      _cloudFirestoreRepository.updateAddTop3Notification(user.uid, isTop3);
  //21. Log in Apple
  Future<dynamic> signInApple() => _authRepository.singInApple();

  Future<void> reautenticate() async {
// Reauthenticate
    await FirebaseAuth.instance.currentUser.reload();
  }

  reportPost(Map<String, dynamic> data) =>
      _cloudFirestoreRepository.reportPost(data);

  reportUser(Map<String, dynamic> data) =>
      _cloudFirestoreRepository.reportUser(data);

  blockUser(String blockedUser) =>
      _cloudFirestoreRepository.blockUser(user.uid, blockedUser);

  @override
  void dispose() {}
}
