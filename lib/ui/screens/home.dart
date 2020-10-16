import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class Home extends StatefulWidget {
  State createState() {
    return _Home();
  }
}

class _Home extends State<Home> {
  final pathImage = "assets/images/logopcd.png";
  UserBloc userBloc;

  Widget getUserfromDB(uid) {
    if (userBloc.user.uid == null) {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("pacientes")
              .where('uid', isEqualTo: uid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            UserBloc userBloc = BlocProvider.of(context);
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              DocumentSnapshot element = snapshot.data.documents[0];
              userBloc.user = UserModel(
                  email: element.get("email"),
                  uid: element.get("uid"),
                  id: element.get("id"),
                  userName: element.get("name"),
                  userSurname1: element.get("surname1"),
                  userSurname2: element.get("surname2"),
                  paidBalance: element.get("paid_balance"),
                  totalBalance: element.get("total_balance"),
                  points: element.get("points"));
              Stream.empty();
              return homescreen(context);
            }
          });
    } else {
      return homescreen(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return getUserfromDB(userBloc.user.uid);
  }

  Widget homescreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Plan Cobertura Dental",
          style: TextStyle(color: Colors.black, fontFamily: "ProximaNova"),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: Colors.black,
        shadowColor: Colors.transparent,
      ),
      body: Stack(),
    );
  }
}

Widget menuHome(context) {
  return Container(
    padding: EdgeInsets.only(top: 10),
    child: Column(
      children: [],
    ),
  );
}
