import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/cardlosmas.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/noresutlt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class LosMasScreen extends StatefulWidget {
  @override
  _LosMasScreenState createState() => _LosMasScreenState();
}

class _LosMasScreenState extends State<LosMasScreen> {
  UserBloc userBloc;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    userBloc = BlocProvider.of(context);
    if (userBloc.user.uid == null) {
      userBloc.user = UserModel(uid: userBloc.currentUser.uid);
    }
    return getUserfromDB(userBloc.user.uid);
  }

  Widget getUserfromDB(uid) {
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
                userName: element.get("username"),
                avatarURL: element.get("avatar_url"),
                points: element.get("points"));
            Stream.empty();
            return getPostsfromDB();
          }
        });
  }

  Widget getPostsfromDB() {
    return StreamBuilder(
        stream: userBloc.myMostPostsListStream(),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return todosScreen(
                  userBloc.buildMyMostPosts(snapshot.data.documents));
            case ConnectionState.active:
              return todosScreen(
                  userBloc.buildMyMostPosts(snapshot.data.documents));
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            default:
              return todosScreen(
                  userBloc.buildMyMostPosts(snapshot.data.documents));
          }
        });
  }

  Widget todosScreen(List<CardHome> allPosts) {
    ScreenUtil.init(context);
    bool noresult = false;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      children: <Widget>[
        noresult
            ? NoResult()
            : Column(
                children: [
                  SizedBox(height: ScreenUtil().setHeight(40)),
                  Text(
                    "Todos los Brownies",
                    style: Mystyle.titleTextStyle.copyWith(
                      fontSize: ScreenUtil().setSp(100),
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(20)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 25),
                    scrollDirection: Axis.vertical,
                    reverse: false,
                    itemBuilder: (_, int index) => allPosts[index],
                    itemCount: allPosts.length,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(100)),
                ],
              ),
      ],
    );
  }
}
