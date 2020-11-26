import 'package:flutter/material.dart';

class UserModel {
  String uid = "";
  String userName = "";
  String email = "";
  int points = 0;
  String bankAccount = "";
  List favourites;
  String type = "";
  String restaurantName = "";
  String location = "";
  String cif = "";
  String avatarURL = "";
  bool hasNotifications = false;

  UserModel(
      {Key key,
      this.uid,
      this.userName,
      this.email,
      this.bankAccount,
      this.favourites,
      this.points,
      this.type,
      this.restaurantName,
      this.location,
      this.cif,
      this.avatarURL,
      this.hasNotifications});
}
