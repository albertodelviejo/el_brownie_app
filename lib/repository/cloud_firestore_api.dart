import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/model/notification.dart';
import 'package:el_brownie_app/model/post.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/cardnotification.dart';
import 'package:el_brownie_app/ui/utils/commentswidget.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                'email': user.email,
                'bank_account': user.bankAccount,
                'type': user.type,
                'points': user.points,
                'avatar_url': user.avatarURL
              })
            }
          else
            {
              await ref.set({
                'uid': user.uid,
                'username': user.userName,
                'email': user.email,
                'points': 10,
                'bank_account': "",
                'cif': "",
                'location': "",
                'restaurant_name': "",
                'type': "default",
                'favorites': {},
                'notifications': {},
                'avatar_url': ""
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
          photoUrl: element.get('photo')));
    });
    return allPost;
  }

  // List<CardHome> buildFavouritesPosts(List<Post> postListsSnapshot) {
  //   List<CardHome> favouritesPosts = List<CardHome>();
  //   postListsSnapshot.forEach((element) {
  //     favouritesPosts.add(CardHome(
  //       name: element.name,
  //       valo: "1700 valoraciones",
  //       place: element.address,
  //       reclam: element.status.toString() == "true" ? true : false,
  //       view: "1700 views",
  //       hace: "Hace 2 dias",
  //       myindex: element.valoration,
  //       id: element.idPost,
  //       imageUrl: element.photoUrl,
  //     ));
  //   });

  //   return favouritesPosts;
  // }

  // Future<List<dynamic>> getFavouritesPostFromString(String uid) async {
  //   DocumentReference ref = _db.collection("users").doc(uid);
  //   List<dynamic> favoritesPost = new List<String>();
  //   await ref.get().then((value) {
  //     favoritesPost = value.get('favorites');
  //     return favoritesPost;
  //   });
  // }

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
        imageUrl: element.get('photo'),
        myindex: element.get('valoration').toString(),
        idUserPost: element.get('id_user'),
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
      int valoration) async {
    DocumentReference ref = _db.collection("posts").doc();
    ref.set({
      'address': address,
      'category': category,
      'comentary': comentary,
      'date': Timestamp.now(),
      'id_post': idPost,
      'id_user': uid,
      'name': name,
      'price': price,
      'status': status,
      'valoration': valoration,
      'photo': photoUrl
    });
  }

  // void addPhotoToPost(String idPost, String imageUrl) async {
  //   await _db.collection("posts").doc(idPost).update({'photo': imageUrl.toString()});
  // }

  Post getPost(String idPost) {
    DocumentReference ref = _db.collection("posts").doc(idPost);
    Post aux;
    ref.get().then((value) => {
          aux = new Post(
              address: value.get('address'),
              category: value.get('category'),
              date: value.get('date'),
              idPost: value.get('id_post'),
              idUser: value.get('id_user'),
              name: value.get('name'),
              price: value.get('price'),
              status: value.get('status'),
              photoUrl: value.get('photo'),
              valoration: value.get('valoration'))
        });
    return aux;
  }

  List<CardHome> buildMyBrownies(List<DocumentSnapshot> postsListSnapshot) {
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
        imageUrl: element.get('photo'),
        id: element.id,
        idUserPost: element.get('id_user'),
      ));
    });
    return allPost;
  }

  Future<String> addComment(String idPost, String id_user, String username,
      String avatarURL, String photoURL, String text, String valoration) {
    DocumentReference ref = _db.collection("comments").doc();
    ref.set({
      'id_post': idPost,
      'id_user': id_user,
      'username': username,
      'avatar_url': avatarURL,
      'likes': 0,
      'photo_url': photoURL,
      'text': text,
      'valoration': valoration,
      'date': Timestamp.now()
    });
  }

  List<CommentsW> buildComments(List<DocumentSnapshot> commentsListSnapshot) {
    List<CommentsW> allComments = List<CommentsW>();
    commentsListSnapshot.forEach((element) {
      allComments.add(CommentsW(
        comment: element.get('text'),
        image: element.get('photo_url'),
        likes: element.get('likes'),
        valoration: int.parse(element.get('valoration')),
        name: element.get('username'),
        time: "",
      ));
    });
    return allComments;
  }

  Future<String> addNotification(
      String idUser, String notificationType, int points) {
    DocumentReference ref = _db.collection("notifications").doc();
    ref.set({
      'id_user': idUser,
      'notification_type': notificationType,
      'points': points
    }).then((value) => ref.id);
  }

  void deleteNotification(String idNotification) {
    DocumentReference ref = _db.collection("notifications").doc(idNotification);
    ref.delete();
  }

  List<CardNotification> buildNotifications(
      List<DocumentSnapshot> notificationsListSnapshot) {
    String icon = "";
    String text = "";
    int points = 0;
    List<CardNotification> allNotifications = List<CardNotification>();
    notificationsListSnapshot.forEach((element) {
      String notificationType = element.get('notification_type');
      switch (notificationType) {
        case "reclamation":
          icon = "";
          text = notification_tile_reclamation;
          points = element.get('points');
          break;
        case "favourite":
          icon = "";
          text = notification_tile_favourite;
          points = element.get('points');
          break;
        case "top":
          icon = "";
          text = notification_tile_top;
          points = element.get('points');
          break;
        case "welcome":
          icon = "";
          text = notification_tile_welcome;
          points = element.get('points');
          break;
        case "comment":
          icon = "";
          text = notification_tile_comment;
          points = element.get('points');
          break;
      }
      allNotifications.add(CardNotification(
        icon: Icon(Icons.ac_unit),
        points: points,
        text: text,
      ));
    });
    return allNotifications;
  }
}
