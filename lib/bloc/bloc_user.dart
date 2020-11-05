import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/model/comment.dart';
import 'package:el_brownie_app/model/post.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/repository/auth_repository.dart';
import 'package:el_brownie_app/repository/cloud_firestore_api.dart';
import 'package:el_brownie_app/repository/cloud_firestore_repository.dart';
import 'package:el_brownie_app/repository/google_maps_api.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/commentswidget.dart';
import 'package:el_brownie_app/ui/widgets/card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_maps_webservice/places.dart';

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
  Future<User> signInGoogle() => _authRepository.singInGoogle();

//4. Log in Facebook
  Future<User> signInFacebook() => _authRepository.singInFacebook();

//5. Get posts
  Stream<QuerySnapshot> myPostsListStream() => FirebaseFirestore.instance
      .collection(CloudFirestoreAPI().POSTS)
      .snapshots();

  List<CardHome> buildMyPosts(List<DocumentSnapshot> ticketsListSnapshot) =>
      _cloudFirestoreRepository.buildAllPosts(ticketsListSnapshot);

//6. Get favourites posts
  Future<List<Post>> myFavouritesPostsList() async {
    List<String> list = new List<String>();
    list =
        await _cloudFirestoreRepository.getFavouritesPostFromString(user.uid);

    List<Post> posts = new List<Post>();
    list.forEach((element) {
      posts.add(_cloudFirestoreRepository.getPost(element));
    });
    return posts;
  }

  List<CardHome> buildMyFavouritesPosts(List<Post> favouritesPostsSnapshot) =>
      _cloudFirestoreRepository.buildFavouritesPosts(favouritesPostsSnapshot);

//3. Get Tickets from DB

  Future<Location> getSearchLocation(text) =>
      _googleMapsApi.getSearchLocation(text);

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
          int valoration) =>
      _cloudFirestoreRepository.createPost(idPost, currentUser.uid, address,
          category, name, comentary, price, status, valoration);

  void addPhotoToPost(String idPost, String imageUrl) =>
      _cloudFirestoreRepository.addPhotoToPost(idPost, imageUrl);

//10. Get my brownies
  Stream<QuerySnapshot> myBrowniesListStream(uid) => FirebaseFirestore.instance
      .collection(CloudFirestoreAPI().POSTS)
      .where("id_user", isEqualTo: uid)
      .snapshots();

  List<CardHome> buildMyBrownies(List<DocumentSnapshot> ticketsListSnapshot) =>
      _cloudFirestoreRepository.buildMyBrownies(ticketsListSnapshot);

  //11. Add comment

  Future<String> addComment(
          String idPost, String photoUrl, String text, String valoration) =>
      _cloudFirestoreRepository.addComment(
          idPost, user.uid, photoUrl, text, valoration);

  //12. Build comments
  List<CommentsW> buildComments(List<DocumentSnapshot> ticketsListSnapshot) =>
      _cloudFirestoreRepository.buildComments(ticketsListSnapshot);

  Stream<QuerySnapshot> commentsListStream(idPost) => FirebaseFirestore.instance
      .collection("comments")
      .where("id_post", isEqualTo: idPost)
      .snapshots();

  //13. Reset password
  Future<void> resetPassword(email) => _authRepository.resetPassword(email);

  void signOut() {
    _authRepository.signOut();
  }

  @override
  void dispose() {}
}
