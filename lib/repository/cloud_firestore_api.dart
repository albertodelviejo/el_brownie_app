import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/model/notification.dart';
import 'package:el_brownie_app/model/post.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/cardlosmas.dart';
import 'package:el_brownie_app/ui/utils/cardnotification.dart';
import 'package:el_brownie_app/ui/utils/commentswidget.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'google_maps_api.dart';

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
                'favorites': [],
                'notifications': {},
                'blocked_users': [],
                'avatar_url':
                    "https://firebasestorage.googleapis.com/v0/b/elbrownie-baf68.appspot.com/o/avatars%2Fdefault.png?alt=media&token=f2afa6be-730c-46b1-81c0-b80da431a8af",
                'number_of_posts': 0,
                'createdAt': Timestamp.now(),
                'hasNotifications': true,
                'hasRequestedNotification': false,
                'isTop3': false
              }),
              addNotification(user.uid, "welcome", 10),
              //addPoints(user.uid, 10)
            }
        });
  }

  void updateUserProfile(UserModel user) {
    DocumentReference ref = _db.collection("users").doc(user.uid);
    ref.get().then((value) async => {
          if (value.exists)
            {
              user.type.contains("default")
                  ? await ref.update({
                      'uid': user.uid,
                      'username': user.userName,
                      'email': user.email,
                      'bank_account': user.bankAccount,
                      'avatar_url': user.avatarURL,
                      'type': user.type
                    })
                  : await ref.update({
                      'uid': user.uid,
                      'username': user.userName,
                      'email': user.email,
                      'bank_account': user.bankAccount,
                      'avatar_url': user.avatarURL,
                      'type': user.type,
                      'restaurant_name': user.restaurantName,
                      'cif': user.cif,
                      'location': user.location
                    })
            }
        });
  }

  void updateCommentsPhoto(UserModel user, String id) {
    DocumentReference ref = _db.collection("comments").doc(id);
    ref.get().then((value) async => {
          if (value.exists)
            {
              await ref.update({'avatar_url': user.avatarURL})
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

  List<CardLosmas> buildAllPosts(List<DocumentSnapshot> postsListSnapshot) {
    List<CardLosmas> allPost = List<CardLosmas>();
    int index = 0;

    postsListSnapshot.forEach((element) {
      if (index % 4 == 3) {
        allPost.add(CardLosmas(isAdd: true, name: ""));
        index++;
      }
      allPost.add(CardLosmas(
        name: element.get('name'),
        valo: "1700 valoraciones",
        category: element.get('category'),
        place: element.get('address'),
        reclam: element.get('status'),
        view: "1700 views",
        hace: "Hace 2 dias",
        imageUrl: element.get('photo'),
        myindex: element.get('valoration').toString(),
        idUserPost: element.get('id_user'),
        id: element.id,
        longitude: element.get('longitude'),
        latitude: element.get('latitude'),
      ));
      index++;
    });
    return allPost;
  }

  List<CardLosmas> buildCercaPosts(List<DocumentSnapshot> postsListSnapshot) {
    List<CardLosmas> allPost = List<CardLosmas>();

    postsListSnapshot.forEach((element) {
      allPost.add(CardLosmas(
        name: element.get('name'),
        valo: "1700 valoraciones",
        category: element.get('category'),
        place: element.get('address'),
        reclam: element.get('status'),
        view: "1700 views",
        hace: "Hace 2 dias",
        imageUrl: element.get('photo'),
        myindex: element.get('valoration').toString(),
        idUserPost: element.get('id_user'),
        id: element.id,
        longitude: element.get('longitude'),
        latitude: element.get('latitude'),
      ));
    });
    return allPost;
  }

  List<CardHome> buildMyPostsCardHome(
      List<DocumentSnapshot> postsListSnapshot) {
    List<CardHome> allPost = List<CardHome>();
    postsListSnapshot.forEach((element) {
      allPost.add(CardHome(
        name: element.get('name'),
        valo: "1700 valoraciones",
        category: element.get('category'),
        place: element.get('address'),
        reclam: element.get('status'),
        view: "1700 views",
        hace: "Hace 2 dias",
        imageUrl: element.get('photo'),
        myindex: element.get('valoration').toString(),
        idUserPost: element.get('id_user'),
        id: element.id,
        longitude: element.get('longitude'),
        latitude: element.get('latitude'),
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
    GoogleMapsApi().getLatitudeAndLongitude(address).then((value) {
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
        'photo': photoUrl,
        'latitude': value.results[0].geometry.location.lat,
        'longitude': value.results[0].geometry.location.lng
      });
    });
  }

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
      String idUser, String notificationType, int points) async {
    var notificationdoc = await _db.collection("notifications").add({
      'id_user': idUser,
      'notification_type': notificationType,
      'points': points,
      'date': Timestamp.now()
    });
    var user = await _db.collection("users").doc(idUser);
    if (notificationType == "requested") {
      user.update({'hasNotifications': true, 'hasRequestedNotification': true});
    } else {
      user.update({'hasNotifications': true});
    }
    return notificationdoc.id;
  }

  void deleteNotification(String idNotification) {
    DocumentReference ref = _db.collection("notifications").doc(idNotification);
    ref.delete();
  }

  void setNoNotifications(String idUser) {
    DocumentReference ref = _db.collection("users").doc(idUser);
    ref.update({'hasNotifications': false});
  }

  void setNoRequestNotifications(String idUser) {
    DocumentReference ref = _db.collection("users").doc(idUser);
    ref.update({'hasRequestedNotification': false});
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
          icon = "assets/svg/notifmoney.svg";
          text = notification_tile_reclamation;
          points = element.get('points');
          break;
        case "favourite":
          icon = "assets/svg/favorito.svg";
          text = notification_tile_favourite;
          points = element.get('points');
          break;
        case "top":
          icon = "assets/svg/top.svg";
          text = notification_tile_top;
          points = element.get('points');
          break;
        case "welcome":
          icon = "assets/ifull.png";
          text = notification_tile_welcome;
          points = element.get('points');
          break;
        case "comment":
          icon = "assets/svg/descanso.svg";
          text = notification_tile_comment;
          points = element.get('points');
          break;
        case "added":
          icon = "assets/ifull.png";
          text = notification_tile_added;
          points = element.get('points');
      }
      allNotifications.add(CardNotification(
        icon: (icon.substring(icon.length - 3, icon.length) == "svg")
            ? SvgPicture.asset(icon)
            : Image.asset(icon),
        points: points,
        text: text,
        idNotification: element.id,
        type: notificationType,
        index: allNotifications.length.toString(),
      ));
    });
    return allNotifications;
  }

  void addPoints(String userId, int addPoints) {
    DocumentReference docRef = _db.collection("users").doc(userId);
    int points = 0;
    docRef.get().then((value) => {
          if (value.exists)
            {
              points = value.get('points') + addPoints,
              docRef.update({'points': points})
            }
        });
  }

  void deletePoints(String userId) {
    DocumentReference docRef = _db.collection("users").doc(userId);
    int points = 0;
    docRef.get().then((value) => {
          if (value.exists)
            {
              points = value.get('points') - 10,
              docRef.update({'points': points})
            }
        });
  }

  List<CardLosmas> buildMyMostBrownies(
      List<DocumentSnapshot> postsListSnapshot) {
    List<CardLosmas> allPost = List<CardLosmas>();
    int index = 0;
    postsListSnapshot.forEach((element) {
      if (index % 4 == 3) {
        allPost.add(CardLosmas(isAdd: true, name: ""));
        index++;
      }
      allPost.add(CardLosmas(
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
        category: element.get('category'),
      ));
      index++;
    });
    return allPost;
  }

  void updateAddTop3Notification(String uid, bool isTop3) {
    DocumentReference docRef = _db.collection("users").doc(uid);
    bool isTop3db;
    docRef.get().then((value) => {
          if (value.exists)
            {
              isTop3db = value.get('isTop3'),
              if (isTop3db && !isTop3)
                {
                  docRef.update({'isTop3': false})
                },
              if (!isTop3db && isTop3)
                {
                  docRef.update({'isTop3': true}),
                  addNotification(uid, "top", 10),
                  addPoints(uid, 10)
                }
            }
        });
  }

  //  each post will have all reasons of reports
  void reportPost(Map<String, dynamic> data) async {
    QuerySnapshot snapshot = await _db
        .collection('reports')
        .where('id_post', isEqualTo: data['id_post'])
        .where('reported', isEqualTo: 'post')
        .get();
    if (snapshot.docs.length == 0) {
      await _db.collection('reports').add(data);
    } else {
      var doc = snapshot.docs[0];
      List reports = doc.data()['reports'];
      reports.add(data['reports'][0]);
      data['reports'] = reports;
      await _db.collection('reports').doc(doc.id).update(data);
    }
  }

  void reportUser(Map<String, dynamic> data) async {
    QuerySnapshot snapshot = await _db
        .collection('reports')
        .where('username', isEqualTo: data['username'])
        .where('reported', isEqualTo: 'user')
        .get();
    if (snapshot.docs.length == 0) {
      await _db.collection('reports').add(data);
    } else {
      var doc = snapshot.docs[0];
      List reports = doc.data()['reports'];
      reports.add(data['reports'][0]);
      data['reports'] = reports;
      await _db.collection('reports').doc(doc.id).update(data);
    }
  }

  Future<void> addBlockedUser(uid, uid_blocked) async {
    DocumentReference docRef = _db.collection("users").doc(uid);
    await docRef.update({
      'blocked_users': FieldValue.arrayUnion([uid_blocked])
    });
  }
}
