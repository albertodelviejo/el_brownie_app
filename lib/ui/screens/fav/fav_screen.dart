import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/screens/notifications/notifications_screen.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';

class FavScreen extends StatefulWidget {
  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _value = 12;
  bool noresult = false;
  UserBloc userBloc;

  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
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
                points: element.get("points"),
                hasNotifications: element.get("hasNotifications"),
                hasRequestedNotification:
                    element.get("hasRequestedNotification"));
            Stream.empty();
          }
          return favscreen();
        });
  }

  Widget favscreen() {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Mystyle.primarycolo,
          elevation: 0,
          title: Container(
            width: ScreenUtil().setHeight(500),
            child: Image.asset("assets/appblogo.png"),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return NotificationsScreen(); //register
                          },
                        ),
                      ),
                  icon: (userBloc.user.hasNotifications == null)
                      ? Icon(
                          Icons.notifications_none,
                          color: Colors.black,
                          size: 28,
                        )
                      : (userBloc.user.hasNotifications)
                          ? SvgPicture.asset(
                              "assets/svg/notification.svg",
                              height: 28,
                              width: 28,
                            )
                          : Icon(
                              Icons.notifications_none,
                              color: Colors.black,
                              size: 28,
                            )),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: [
            SizedBox(height: ScreenUtil().setHeight(60)),
            Text(
              "Mis favoritos",
              style: Mystyle.titleTextStyle.copyWith(
                fontSize: ScreenUtil().setSp(90),
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                fav_screen_title,
                style: Mystyle.regularTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(40)),
            StreamBuilder(
                stream: db.collection('posts').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    List posts = snapshot.data.docs ?? [];
                    return StreamBuilder(
                        stream: db
                            .collection('users')
                            .doc(auth.currentUser.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            List favoritesID =
                                snapshot.data.data()['favorites'];
                            List cards = [];
                            favoritesID.forEach((favoriteID) {
                              posts.forEach((post) {
                                if (post.id.toString() == favoriteID) {
                                  cards.add(post);
                                }
                              });
                            });
                            return (cards.length == 0)
                                ? Column(
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 30.0, bottom: 10),
                                          child: Container(
                                            height: 70,
                                            width: 70,
                                            child: Image.asset(
                                                "assets/splash4.png"),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        empty_list,
                                        textAlign: TextAlign.center,
                                        style: Mystyle.regularTextStyle,
                                      ),
                                    ],
                                  )
                                : Container(
                                    height: cards.length *
                                        ScreenUtil().setHeight(1500),
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: cards.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            child: CardHome(
                                              name:
                                                  '${cards[index].data()['name']}',
                                              valo: 'string',
                                              place:
                                                  '${cards[index].data()['address']}',
                                              reclam:
                                                  cards[index].data()['status'],
                                              view: "1700 views",
                                              hace: "Hace 2 dias",
                                              myindex:
                                                  '${cards[index].data()['valoration']}',
                                              id: cards[index].id,
                                              idUserPost: cards[index]
                                                  .data()['id_user'],
                                              imageUrl:
                                                  '${cards[index].data()['photo']}',
                                              isMarked: true,
                                            ),
                                          );
                                        }),
                                  );
                          } else {
                            return Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      child: Image.asset("assets/splash4.png"),
                                    ),
                                  ),
                                ),
                                Text(
                                  empty_list,
                                  textAlign: TextAlign.center,
                                  style: Mystyle.regularTextStyle,
                                ),
                              ],
                            );
                          }
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
