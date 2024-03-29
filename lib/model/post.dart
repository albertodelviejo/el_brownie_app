import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  String name;
  String address;
  String category;
  bool status;
  String price;
  String idUser;
  String valoration;
  String photoUrl;
  Timestamp date;
  String idPost;
  double longitude;
  double latitude;

  Post(
      {Key key,
      this.name,
      this.address,
      this.category,
      this.status,
      this.price,
      this.idUser,
      this.valoration,
      this.photoUrl,
      this.date,
      this.idPost,
      this.latitude,
      this.longitude});
}
