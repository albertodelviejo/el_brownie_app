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
  bool hasRequestedNotification = false;
  List blockedUsers;

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
      this.hasNotifications,
      this.hasRequestedNotification,
      this.blockedUsers});
}
