import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/ui/screens/add/add_comment_screen.dart';
import 'package:el_brownie_app/ui/screens/add/request_screen.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/commentswidget.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '../../../model/post.dart';

class PostScreen extends StatefulWidget {
  String id;
  bool isTapped = false;
  Icon icon = Icon(
    Icons.bookmark_border,
    color: Colors.black87,
  );

  PostScreen({Key key, this.id});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Post post;
  bool noresult = false;
  UserBloc userBloc;

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
                photo: element.get('photo'),
                valoration: element.get('valoration').toString());
            Stream.empty();
            return postScreen();
            //return getComments();
          }
        });
  }

  Widget getComments() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("comments")
            .where('id_post', isEqualTo: widget.id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<CommentsW> list = new List<CommentsW>();
            snapshot.data.documents.forEach((element) {
              list.add(CommentsW(
                comment: element.get('text'),
                image: "",
                likes: element.get('likes'),
                name: "",
                valoration: int.parse(element.get('valoration')),
                time: "",
              ));
            });
            Stream.empty();
            return postScreen();
            //return getComments();
          }
        });
  }

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
                CardHome(
                  name: post.name,
                  place: post.address,
                  view: "",
                  valo: "",
                  hace: "",
                  reclam: post.status,
                  myindex: "3",
                  pagename: "post",
                  imageUrl: post.photo,
                ),
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
                              "share",
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
                        if (!widget.isTapped) {
                          setState(() {
                            widget.icon = Icon(
                              Icons.bookmark,
                              color: Colors.black87,
                            );
                          });
                          userBloc.likePost(widget.id);
                          widget.isTapped = true;
                        } else {
                          setState(() {
                            widget.icon = Icon(
                              Icons.bookmark_border,
                              color: Colors.black87,
                            );
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
                            widget.icon,
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
                                price: post.price,
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
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Comentarios",
              style: Mystyle.titleTextStyle.copyWith(
                fontSize: ScreenUtil().setSp(80),
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          getComments()
          // SizedBox(height: ScreenUtil().setHeight(100)),
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
