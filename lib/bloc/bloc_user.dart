import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/model/post.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/repository/auth_repository.dart';
import 'package:el_brownie_app/repository/cloud_firestore_api.dart';
import 'package:el_brownie_app/repository/cloud_firestore_repository.dart';
import 'package:el_brownie_app/repository/google_maps_api.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
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
  Future<User> signIn({email, password}) =>
      _authRepository.signInFirebase(email, password);

  void updateUserData(UserModel user) =>
      _cloudFirestoreRepository.updateUserDataFirestore(user);

//2. Register in firebase
  Future<User> register({email, password}) =>
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
  Stream<QuerySnapshot> myFavouritesPostsListStream() =>
      FirebaseFirestore.instance
          .collection(CloudFirestoreAPI().USERS)
          .where('uid', isEqualTo: user.uid)
          .snapshots();

  List<CitaCard> buildMyFavouritesPosts(
          List<DocumentSnapshot> favouritesPostsSnapshot) =>
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

  void createPost(String address, String category, String name, double price,
          bool status, int valoration, String url) =>
      _cloudFirestoreRepository.createPost(
          user.uid, address, category, name, price, status, valoration, url);

  signOut() {
    _authRepository.signOut();
  }

  @override
  void dispose() {}
}
