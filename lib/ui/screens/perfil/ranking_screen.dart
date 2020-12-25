import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/rankwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool noresult = false;

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    userBloc = BlocProvider.of(context);

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: StreamBuilder(
            stream: _db.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                List users = snapshot.data.docs ?? [];
                users.sort(
                    (b, a) => a.data()['points'].compareTo(b.data()['points']));
                List top10Users = users.take(10).toList();
                var currentUser = users
                    .firstWhere((user) => _auth.currentUser.uid == user.id);
                return StreamBuilder(
                    stream: _db.collection('posts').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List posts = snapshot.data.docs;
                        (getRank(_auth.currentUser.uid, users) <= 3)
                            ? userBloc.updateAddTop3Notification(true)
                            : userBloc.updateAddTop3Notification(false);
                        return ListView(
                          children: [
                            SizedBox(height: ScreenUtil().setHeight(60)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                "Tu posición (puntos)",
                                style: Mystyle.titleTextStyle.copyWith(
                                  fontSize: ScreenUtil().setSp(100),
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(30)),
                            RankTile(
                              rank: getRank(_auth.currentUser.uid, users),
                              image: currentUser.data()['avatar_url'] == null
                                  ? "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"
                                  : currentUser.data()['avatar_url'],
                              name:
                                  currentUser.data()['username'] ?? 'username',
                              pub:
                                  "${getPostsCount(_auth.currentUser.uid, posts)} publicaciones",
                              point: currentUser.data()['points'].toString(),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(50)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                "Ranking Global",
                                style: Mystyle.titleTextStyle.copyWith(
                                  fontSize: ScreenUtil().setSp(100),
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(30)),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: top10Users.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    child: RankTile(
                                      rank: index + 1,
                                      image: top10Users[index]
                                                  .data()['avatar_url'] ==
                                              null
                                          ? "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"
                                          : top10Users[index]
                                              .data()['avatar_url'],
                                      name: top10Users[index]
                                              .data()['username'] ??
                                          'Usuario',
                                      pub: getPostsCount(
                                                  top10Users[index].id, posts)
                                              .toString() +
                                          " publicaciones",
                                      point: top10Users[index]
                                              .data()['points']
                                              .toString() ??
                                          '0',
                                    ),
                                  );
                                }),
                            SizedBox(height: ScreenUtil().setHeight(100)),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    });
              } else {
                return Center(
                    child: Container(
                  child: Text('Something were worng..'),
                ));
              }
            }),
      ),
    );
  }
}

int getPostsCount(String uid, List posts) {
  int sum = 0;
  posts.forEach((post) {
    if (post.data()['id_user'] == uid) sum++;
  });
  return sum;
}

int getRank(String uid, List users) {
  int rank = users.length;
  for (var i = 0; i < users.length; i++) {
    if (users[i].id == uid) {
      rank = i + 1;
      break;
    }
  }
  return rank;
}
