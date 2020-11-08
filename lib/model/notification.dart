import 'package:flutter/material.dart';

class Notification {
  NotificationNum notificationType;
  int points;
  String idUser;

  Notification({Key key, this.notificationType, this.idUser, this.points});
}

enum NotificationNum { reclamation, favourite, top, welcome, comment }
