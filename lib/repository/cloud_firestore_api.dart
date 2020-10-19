import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/model/post.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/widgets/card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFirestoreAPI {
  final String POSTS = "posts";
  final String PACIENTES = "pacientes";
  final String USERS = "users";

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateUserData(UserModel user) async {
    DocumentReference ref = _db.collection("users").doc(user.uid);
    return await ref.set({
      'uid': user.uid,
      'username': user.userName,
      'email': user.email,
    });
  }

  List<Post> getAllPosts(List<DocumentSnapshot> postsListSnapshot) {
    List<Post> allPost = List<Post>();
    postsListSnapshot.forEach((element) {
      allPost.add(Post(
          name: element.get('name'),
          address: element.get('address'),
          category: element.get('category'),
          price: element.get('price'),
          status: element.get('status'),
          valoration: element.get('valoration'),
          date: element.get('date'),
          idUser: element.get('id_user'),
          photos: element.get('photos')));
    });
    return allPost;
  }

  List<CitaCard> buildAllPosts(List<DocumentSnapshot> postsListSnapshot) {
    List<CitaCard> allPost = List<CitaCard>();
    postsListSnapshot.forEach((element) {
      allPost.add(CitaCard(
        post: Post(
            name: element.get('name'),
            address: element.get('address'),
            category: element.get('category'),
            price: element.get('price'),
            status: element.get('status'),
            valoration: element.get('valoration'),
            date: element.get('date'),
            idUser: element.get('id_user'),
            photos: element.get('photos')),
      ));
    });
    return allPost;
  }

  Future likePost(Post post, String uid) async {
    await _db.collection("users").doc(uid).get().then((DocumentSnapshot ds) {
      if (ds.get('favorites') != null) {
        _db.collection("users").doc(uid).update({
          'favorites': FieldValue.arrayUnion([post.idPost])
        });
      } else {
        _db.collection("users").doc(uid).set({
          'favorites': FieldValue.arrayUnion([post.idPost])
        });
      }
    });
  }
}
