import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/ui/screens/add/add_comment_screen.dart';
import 'package:el_brownie_app/ui/screens/add/report_screen.dart';
import 'package:el_brownie_app/ui/screens/add/request_screen.dart';
import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/commentswidget.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:share/share.dart';

import '../../../model/post.dart';

class PostScreen extends StatefulWidget {
  final String id;
  final CardHome cardHome;
  String notific_id;
  Post post;
  bool isTapped;
  bool isFavorite = false;

  PostScreen({Key key, this.id, this.cardHome});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool noresult = false;
  UserBloc userBloc;
  final db = FirebaseFirestore.instance;

  Icon icon;
  /* = Icon(
    Icons.bookmark_border,
    color: Colors.black87,
  );
*/
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    userBloc = BlocProvider.of(context);
    checkIfFavourite(widget.cardHome.id);
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
            widget.post = Post(
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
    final RenderBox box = context.findRenderObject();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Mystyle.primarycolo,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          width: ScreenUtil().setHeight(500),
          child: Image.asset("assets/appblogo.png"),
        ),
        centerTitle: true,
        actions: [
          /*
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
              icon: Icon(
                Icons.notifications_none,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
          */
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
                  widget.post.name,
                  style: Mystyle.titleTextStyle.copyWith(
                    fontSize: ScreenUtil().setSp(100),
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: widget.cardHome ?? CircularProgressIndicator(),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        return showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Wrap(children: <Widget>[
                                    Stack(children: [
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              alignment: Alignment.bottomRight,
                                              height:
                                                  ScreenUtil().setWidth(100),
                                              width: ScreenUtil().setWidth(100),
                                              child: SvgPicture.asset("")),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                              height:
                                                  ScreenUtil().setHeight(60)),
                                          Text(
                                            share_title_pop,
                                            style: Mystyle.titleTextStyle
                                                .copyWith(
                                                    color: Colors.black87),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                              height:
                                                  ScreenUtil().setHeight(40)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  height: ScreenUtil()
                                                      .setWidth(330),
                                                  width: ScreenUtil()
                                                      .setWidth(330),
                                                  child: SvgPicture.asset(
                                                      "assets/svg/whatsapp.svg"))),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(share_text_pop,
                                                style: Mystyle.normalTextStyle,
                                                textAlign: TextAlign.center),
                                          ),
                                          SizedBox(
                                              height:
                                                  ScreenUtil().setHeight(40)),
                                          ButtAuth(
                                            share_button_pop,
                                            () => Share.share(
                                                'Descárgate la app y no te pierdas este pedazo de brownie que te comparten! http://elbrownie.com/',
                                                subject:
                                                    "No sabes la cantidad de brownies que hay por toda la ciudad...",
                                                sharePositionOrigin:
                                                    box.localToGlobal(
                                                            Offset.zero) &
                                                        box.size),
                                            border: true,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(60)),
                                          ),
                                        ],
                                      ),
                                    ])
                                  ]),
                                )));
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
                              child: SvgPicture.asset("assets/whatsapp.svg"),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(10)),
                            Text(
                              "Comparte",
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
                        if (!widget.isFavorite) {
                          setState(() {
                            widget.cardHome.isMarked = true;
                            widget.cardHome.icon = Icon(
                              Icons.bookmark,
                              color: Colors.black87,
                            );
                            widget.isFavorite = true;
                          });
                          userBloc.likePost(widget.cardHome.id);
                          userBloc
                              .addNotification(
                                  widget.cardHome.idUserPost, "favourite", 10)
                              .then((value) => widget.notific_id = value);
                          userBloc.addPoints(widget.cardHome.idUserPost, 5);
                        } else {
                          setState(() {
                            widget.cardHome.icon = Icon(
                              Icons.bookmark_border,
                              color: Colors.black87,
                            );
                            widget.isFavorite = false;
                          });
                          userBloc.unlikePost(widget.cardHome.id);
                          userBloc.deleteNotification(widget.notific_id);
                          userBloc.deletePoints(widget.id);
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
                            widget.isFavorite
                                ? Icon(
                                    Icons.bookmark,
                                    color: Colors.black87,
                                  )
                                : Icon(
                                    Icons.bookmark_border,
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
                                  price: (double.parse(widget.post.price))
                                      .toStringAsFixed(2),
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
          SizedBox(height: ScreenUtil().setHeight(5)),
          Center(
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ReportScreen(
                          postId: widget.id,
                          idUserPost: widget.cardHome.idUserPost);
                    },
                  ),
                );
              },
              child: Text(
                'Reportar post',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(5)),
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
                  .orderBy('date', descending: true)
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
                              image: comments[index].get('photo_url'),
                              likes: comments[index].get('likes'),
                              name: comments[index].get('username'),
                              valoration:
                                  int.parse(comments[index].get('valoration')),
                              time: "",
                              avatarUrl: comments[index].get('avatar_url'),
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

  void checkIfFavourite(String idPost) {
    Stream stream = FirebaseFirestore.instance
        .collection("users")
        .doc(userBloc.user.uid)
        .snapshots();

    stream.listen((event) {
      if (event.data != null) {
        List favoritesID = event.data()['favorites'];
        if (favoritesID.contains(idPost)) {
          setState(() {
            widget.isFavorite = true;
            widget.cardHome.isMarked = widget.isFavorite;
          });
        } else {
          setState(() {
            widget.isFavorite = false;
            widget.cardHome.isMarked = widget.isFavorite;
          });
        }
      }
    });
  }
}
