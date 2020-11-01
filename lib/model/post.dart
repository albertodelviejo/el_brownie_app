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
  List photos;
  Timestamp date;
  String idPost;

  Post(
      {Key key,
      this.name,
      this.address,
      this.category,
      this.status,
      this.price,
      this.idUser,
      this.valoration,
      this.photos,
      this.date,
      this.idPost});
}
