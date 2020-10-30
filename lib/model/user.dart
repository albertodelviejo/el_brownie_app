import 'package:flutter/material.dart';

class UserModel {
  String uid;
  final String userName;
  final String email;
  final int points;
  final String bankAccount;
  final List favourites;
  final String type;
  String restaurantName;
  String location;
  String cif;

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
      this.cif});
}
