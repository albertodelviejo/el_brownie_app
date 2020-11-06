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
  String photo;
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
      this.photo,
      this.date,
      this.idPost});
}
