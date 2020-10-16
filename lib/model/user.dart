import 'package:flutter/material.dart';

class UserModel {
  String uid;
  final String id;
  final String userName;
  final String userSurname1;
  final String userSurname2;
  final String email;
  final int idClinica;
  final String paidBalance;
  final String totalBalance;
  final int points;

  UserModel(
      {Key key,
      this.uid,
      this.id,
      this.userName,
      this.userSurname1,
      this.userSurname2,
      this.email,
      this.idClinica,
      this.paidBalance,
      this.totalBalance,
      this.points});
}
