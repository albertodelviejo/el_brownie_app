import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/ui/screens/add/add_comment_screen.dart';
import 'package:el_brownie_app/ui/screens/add/request_screen.dart';
import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/commentswidget.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/popup.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '../../../model/post.dart';

class PostScreen extends StatefulWidget {
  final String id;
  bool isTapped = false;
  Icon icon = Icon(
    Icons.bookmark_border,
    color: Colors.black87,
  );
  final CardHome cardHome;

  PostScreen({Key key, this.id, this.cardHome});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Post post;
  bool noresult = false;
  UserBloc userBloc;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    userBloc = BlocProvider.of(context);
    return getPostfromDB(widget.id);
  }

  Widget getPostfromDB(id) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .where('id_post', isEqualTo: id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            DocumentSnapshot element = snapshot.data.documents[0];
            post = Post(
                name: element.get('name'),
                address: element.get('address'),
                category: element.get('category'),
                status: element.get('status'),
                price: element.get('price').toString(),
                idUser: element.get('id_user'),
                idPost: widget.id,
                photoUrl: element.get('photo'),
                valoration: element.get('valoration').toString());
            Stream.empty();
            return postScreen();
            //return getComments();
          }
        });
  }

  // Widget getComments() {
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance
  //           .collection("comments")
  //           .where('id_post', isEqualTo: widget.id)
  //           .snapshots(),
  //       builder: (BuildContext context, AsyncSnapshot snapshot) {
  //         if (!snapshot.hasData) {
  //           return Center(child: CircularProgressIndicator());
  //         } else {
  //           List<CommentsW> list = new List<CommentsW>();
  //           snapshot.data.documents.forEach((element) {
  //             list.add(CommentsW(
  //               comment: element.get('text'),
  //               image: "",
  //               likes: element.get('likes'),
  //               name: "",
  //               valoration: int.parse(element.get('valoration')),
  //               time: "",
  //             ));
  //           });
  //           Stream.empty();
  //           return postScreen();
  //           //return getComments();
  //         }
  //       });
  // }

  Widget getComments1() {
    return StreamBuilder(
        stream: userBloc.commentsListStream(widget.id),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return comments(null);

            case ConnectionState.done:
              return comments(userBloc.buildComments(snapshot.data.documents));

            case ConnectionState.active:
              return comments(userBloc.buildComments(snapshot.data.documents));

            case ConnectionState.none:
              return comments(null);

            default:
              return comments(userBloc.buildComments(snapshot.data.documents));
          }
        });
  }

  Widget postScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Mystyle.primarycolo,
        elevation: 0,
        //automaticallyImplyLeading: false,
        title: Container(
          width: ScreenUtil().setHeight(500),
          child: Image.asset("assets/appblogo.png"),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(
              Icons.notifications_none,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(height: ScreenUtil().setHeight(40)),
                Text(
                  post.name,
                  style: Mystyle.titleTextStyle.copyWith(
                    fontSize: ScreenUtil().setSp(100),
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                widget.cardHome ?? CircularProgressIndicator(),
                SizedBox(height: ScreenUtil().setHeight(40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        PopUp;
                      },
                      child: Container(
                        decoration: Mystyle.cadredec().copyWith(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: ScreenUtil().setWidth(200),
                        height: ScreenUtil().setHeight(190),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.share),
                            SizedBox(height: ScreenUtil().setHeight(10)),
                            Text(
                              "Share",
                              style: Mystyle.smallTextStyle
                                  .copyWith(color: Colors.black87),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (!widget.cardHome.isMarked) {
                          setState(() {
                            widget.cardHome.isMarked = true;
                            widget.cardHome.icon = Icon(
                              Icons.bookmark,
                              color: Colors.black87,
                            );
                            widget.icon = widget.cardHome.icon;
                          });
                          userBloc.likePost(widget.id);
                          widget.isTapped = true;
                        } else {
                          setState(() {
                            widget.cardHome.isMarked = false;
                            widget.cardHome.icon = Icon(
                              Icons.bookmark_border,
                              color: Colors.black87,
                            );

                            widget.icon = widget.cardHome.icon;
                          });
                          userBloc.unlikePost(widget.id);
                          widget.isTapped = false;
                        }
                      },
                      child: Container(
                        decoration: Mystyle.cadredec().copyWith(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: ScreenUtil().setWidth(200),
                        height: ScreenUtil().setHeight(190),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            !widget.cardHome.isMarked
                                ? widget.icon
                                : Icon(
                                    Icons.bookmark,
                                    color: Colors.black87,
                                  ),
                            SizedBox(height: ScreenUtil().setHeight(10)),
                            Flexible(
                              child: Text(
                                "Favoritos",
                                style: Mystyle.smallTextStyle
                                    .copyWith(color: Colors.black87),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return AddPostScreen(
                                idPost: widget.id,
                                idUserPost: widget.cardHome.idUserPost,
                              ); //register
                            },
                          ),
                        );
                      },
                      child: Container(
                        decoration: Mystyle.cadredec().copyWith(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: ScreenUtil().setWidth(200),
                        height: ScreenUtil().setHeight(190),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: ScreenUtil().setHeight(70),
                              width: ScreenUtil().setHeight(70),
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              child: Image.asset("assets/iempty.png"),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(10)),
                            Text(
                              "Valorar",
                              style: Mystyle.smallTextStyle
                                  .copyWith(color: Colors.black87),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return RequestScreen(
                                  postId: widget.id,
                                  price: (double.parse(post.price))
                                      .toStringAsFixed(0),
                                  idUserPost:
                                      widget.cardHome.idUserPost); //register
                            },
                          ),
                        );
                      },
                      child: Container(
                        decoration: Mystyle.cadredec().copyWith(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: ScreenUtil().setWidth(200),
                        height: ScreenUtil().setHeight(190),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: ScreenUtil().setHeight(70),
                              width: ScreenUtil().setHeight(70),
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              child: Image.asset("assets/money.png"),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(10)),
                            Text(
                              "Reclamar",
                              style: Mystyle.smallTextStyle
                                  .copyWith(color: Colors.black87),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(40)),
          Divider(color: Colors.black87),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
            child: Text(
              "Comentarios",
              style: Mystyle.titleTextStyle.copyWith(
                fontSize: ScreenUtil().setSp(80),
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("comments")
                  .where('id_post', isEqualTo: widget.id)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  List comments = snapshot.data.docs;
                  if (comments.length == 0) {
                    return Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 24),
                              child: Text(
                                no_comments_subtitle,
                                style: Mystyle.normalTextStyle,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 10),
                          child: ButtAuth("Añadir valoración", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return AddPostScreen(
                                    idPost: widget.id,
                                    idUserPost: widget.cardHome.idUserPost,
                                  ); //register
                                },
                              ),
                            );
                          }, border: true),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      height: comments.length * 150.0,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return CommentsW(
                              comment: comments[index].get('text'),
                              image: "",
                              likes: comments[index].get('likes'),
                              name: comments[index].get('username'),
                              valoration:
                                  int.parse(comments[index].get('valoration')),
                              time: "",
                            );
                          }),
                    );
                  }
                }
              }),
          SizedBox(height: ScreenUtil().setHeight(200)),
        ],
      ),
    );
  }

  Widget comments(List<CommentsW> commentsList) {
    List<CommentsW> list = commentsList;
    return list == null
        ? Container(child: Center(child: CircularProgressIndicator()))
        : SizedBox(
            width: 200.0,
            height: 300.0,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 25),
              scrollDirection: Axis.vertical,
              reverse: false,
              itemBuilder: (_, int index) => commentsList[index],
              itemCount: commentsList.length,
            ),
          );
  }
}
