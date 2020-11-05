import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/model/comment.dart';
import 'package:el_brownie_app/model/post.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/commentswidget.dart';
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

  List<CardHome> buildFavouritesPosts(List<Post> favouritesListSnapshot) =>
      _cloudFirestoreAPI.buildFavouritesPosts(favouritesListSnapshot);

  Future<List<dynamic>> getFavouritesPostFromString(String uid) =>
      _cloudFirestoreAPI.getFavouritesPostFromString(uid);

  Future likePost(String idPost, String uid) =>
      _cloudFirestoreAPI.likePost(idPost, uid);

  Future unlikePost(String idPost, String uid) =>
      _cloudFirestoreAPI.unlikePost(idPost, uid);

  Future<String> createPost(
          String idPost,
          String uid,
          String address,
          String category,
          String name,
          String comentary,
          double price,
          bool status,
          String photoUrl,
          int valoration) =>
      _cloudFirestoreAPI.createPost(idPost, uid, address, category, name,
          comentary, price, status, photoUrl, valoration);

  // void addPhotoToPost(String idPost, String imageUrl) =>
  //     _cloudFirestoreAPI.addPhotoToPost(idPost, imageUrl);

  Post getPost(String idPost) => _cloudFirestoreAPI.getPost(idPost);

  List<CardHome> buildMyBrownies(List<DocumentSnapshot> postsListSnapshot) =>
      _cloudFirestoreAPI.buildMyBrownies(postsListSnapshot);

  Future<String> addComment(String idPost, String idUser, String photoURL,
          String text, String valoration) =>
      _cloudFirestoreAPI.addComment(idPost, idUser, photoURL, text, valoration);

  List<CommentsW> buildComments(List<DocumentSnapshot> commentsListSnapshot) =>
      _cloudFirestoreAPI.buildComments(commentsListSnapshot);
}
