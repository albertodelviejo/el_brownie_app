import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/model/post.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
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
    ref.get().then((value) async => {
          if (value.exists)
            {
              await ref.update({
                'uid': user.uid,
                'username': user.userName,
                'email': user.email,
              })
            }
          else
            {
              await ref.set({
                'uid': user.uid,
                'username': user.userName,
                'email': user.email,
              })
            }
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
          idPost: element.get('idPost'),
          photos: element.get('photos')));
    });
    return allPost;
  }

  List<CitaCard> buildFavouritesPosts(
      List<DocumentSnapshot> postListsSnapshot) {
    List<CitaCard> favouritesPosts = List<CitaCard>();
    postListsSnapshot.forEach((element) {
      favouritesPosts.add(CitaCard(
          post: Post(
              name: element.get('name'),
              address: element.get('address'),
              category: element.get('category'),
              price: element.get('price'),
              status: element.get('status'),
              valoration: element.get('valoration'),
              date: element.get('date'),
              idUser: element.get('id_user'),
              idPost: element.get('idPost'),
              photos: element.get('photos'))));
    });

    return favouritesPosts;
  }

  List<CardHome> buildAllPosts(List<DocumentSnapshot> postsListSnapshot) {
    List<CardHome> allPost = List<CardHome>();
    postsListSnapshot.forEach((element) {
      allPost.add(CardHome(
        name: element.get('name'),
        valo: "1700 valoraciones",
        place: element.get('address'),
        reclam: element.get('status'),
        view: "1700 views",
        hace: "Hace 2 dias",
        myindex: element.get('valoration').toString(),
        id: element.id,
      ));
    });
    return allPost;
  }

  Future likePost(String idPost, String uid) async {
    DocumentReference ref = _db.collection("users").doc(uid);
    ref.get().then((value) => {
          if (value.exists)
            {
              ref.update({
                'favorites': FieldValue.arrayUnion([idPost])
              })
            }
          else
            {
              ref.set({
                'favorites': FieldValue.arrayUnion([idPost])
              })
            }
        });
  }

  Future unlikePost(String idPost, String uid) async {
    DocumentReference ref = _db.collection("users").doc(uid);
    ref.get().then((value) => {
          if (value.exists)
            {
              ref.update({
                'favorites': FieldValue.arrayRemove([idPost])
              })
            }
        });
  }

  void createPost(String uid, String address, String category, String name,
      double price, bool status, int valoration, String url) async {
    DocumentReference ref = _db.collection("posts").doc();
    ref.set({
      'address': address,
      'category': category,
      'date': Timestamp.now(),
      'id_post': ref.id,
      'id_user': uid,
      'name': name,
      'price': price,
      'status': status,
      'valoration': valoration,
      'photos': FieldValue.arrayUnion([url])
    });
  }
}
