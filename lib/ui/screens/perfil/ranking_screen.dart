import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/rankwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool noresult = false;

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

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
                var currentUser = users
                    .firstWhere((user) => _auth.currentUser.uid == user.id);
                return StreamBuilder(
                    stream: _db.collection('posts').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List posts = snapshot.data.docs;
                        return ListView(
                          children: [
                            SizedBox(height: ScreenUtil().setHeight(60)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                "Tu posición",
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
                              image: _auth.currentUser.photoURL ??
                                  "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png",
                              name: currentUser.data()['username'],
                              pub:
                                  "${getPostsCount(_auth.currentUser.uid, posts)} publicaciones",
                              point: currentUser.data()['points'].toString(),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(50)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                "Tu posición",
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
                                itemCount: users.length,
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
                                      image:
                                          "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png",
                                      name: users[index].data()['username'] ??
                                          'Usuario',
                                      pub: getPostsCount(users[index].id, posts)
                                          .toString() + " publicaciones",
                                      point: users[index]
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
    if(post.data()['id_user'] == uid) sum++;
  });
  return sum;
}

int getRank(String uid, List users) {
  int rank = users.length;
  for (var i = 1; i <= users.length; i++) {
    if (users[i].id == uid) {
      rank = i+1;
      break;
    }
  }
  return rank;
}
