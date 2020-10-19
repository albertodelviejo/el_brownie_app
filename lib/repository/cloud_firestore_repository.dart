import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/model/post.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/widgets/card.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cloud_firestore_api.dart';

class CloudFirestoreRepository {
  final _cloudFirestoreAPI = CloudFirestoreAPI();

  void updateUserDataFirestore(UserModel user) =>
      _cloudFirestoreAPI.updateUserData(user);

  List<Post> getAllPosts(List<DocumentSnapshot> postsListSnapshot) =>
      _cloudFirestoreAPI.getAllPosts(postsListSnapshot);

  List<CitaCard> buildAllPosts(List<DocumentSnapshot> postsListSnapshot) =>
      _cloudFirestoreAPI.buildAllPosts(postsListSnapshot);

  Future likePost(Post post, String uid) =>
      _cloudFirestoreAPI.likePost(post, uid);
}
