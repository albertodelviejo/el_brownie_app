import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/model/post.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/widgets/card.dart';

import 'cloud_firestore_api.dart';

class CloudFirestoreRepository {
  final _cloudFirestoreAPI = CloudFirestoreAPI();

  void updateUserDataFirestore(UserModel user) =>
      _cloudFirestoreAPI.updateUserData(user);

  List<Post> getAllPosts(List<DocumentSnapshot> postsListSnapshot) =>
      _cloudFirestoreAPI.getAllPosts(postsListSnapshot);

  List<CardHome> buildAllPosts(List<DocumentSnapshot> postsListSnapshot) =>
      _cloudFirestoreAPI.buildAllPosts(postsListSnapshot);

  List<CitaCard> buildFavouritesPosts(
          List<DocumentSnapshot> favouritesListSnapshot) =>
      _cloudFirestoreAPI.buildFavouritesPosts(favouritesListSnapshot);

  Future likePost(String idPost, String uid) =>
      _cloudFirestoreAPI.likePost(idPost, uid);

  Future unlikePost(String idPost, String uid) =>
      _cloudFirestoreAPI.unlikePost(idPost, uid);

  void createPost(String uid, String address, String category, String name,
          double price, bool status, int valoration, String url) =>
      _cloudFirestoreAPI.createPost(
          uid, address, category, name, price, status, valoration, url);
}
