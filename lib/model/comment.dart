import 'package:flutter/material.dart';

class Comment {
  String idUsuario;
  String photoUrl;
  int likes;
  String text;
  String valoration;

  Comment(
      {Key key,
      this.idUsuario,
      this.photoUrl,
      this.likes,
      this.text,
      this.valoration});
}
