import 'package:flutter/material.dart';

class UserModel {
  String uid;
  final String id;
  final String userName;
  final String email;
  final int points;
  final String bankAccount;
  final List favourites;

  UserModel({
    Key key,
    this.uid,
    this.id,
    this.userName,
    this.email,
    this.bankAccount,
    this.favourites,
    this.points,
  });
}
