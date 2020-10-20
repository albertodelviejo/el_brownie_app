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
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    if (userBloc.user.uid == null) {
      userBloc.user = UserModel(uid: userBloc.currentUser.uid);
    }
    return getUserfromDB(userBloc.user.uid);
  }

  Widget getUserfromDB(uid) {
    if (userBloc.user.uid == null) {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
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
                  userName: element.get("username"));
              Stream.empty();
              return getPostsfromDB();
            }
          });
    } else {
      return getPostsfromDB();
    }
  }

  Widget getPostsfromDB() {
    return StreamBuilder(
        stream: userBloc.myPostsListStream(),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return homescreen(userBloc.buildMyPosts(snapshot.data.documents));

            case ConnectionState.active:
              return homescreen(userBloc.buildMyPosts(snapshot.data.documents));

            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            default:
              return homescreen(userBloc.buildMyPosts(snapshot.data.documents));
          }
        });
  }

  Widget homescreen(posts) {
    var postsList = posts;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "ElBrownie",
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
        body: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 25),
              scrollDirection: Axis.vertical,
              reverse: false,
              itemBuilder: (_, int index) => posts[index],
              itemCount: posts.length,
            ),
            GestureDetector(
              onTap: () {
                userBloc.signOut();
              },
              child: Container(
                height: 40,
                width: 80,
                child: Text("SignOut"),
              ),
            )
          ],
        ));
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
