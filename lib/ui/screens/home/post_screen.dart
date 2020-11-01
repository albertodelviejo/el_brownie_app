import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/commentswidget.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool noresult = false;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
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
                  "Taska Church",
                  style: Mystyle.titleTextStyle.copyWith(
                    fontSize: ScreenUtil().setSp(100),
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                CardHome(
                  name: "Taska Church",
                  place: "Calle Aragón, Vigo, España ",
                  view: "1700 views  l",
                  valo: " 1000 valoraciones",
                  hace: "Hace 2 dias",
                  reclam: true,
                  myindex: "3",
                  pagename: "post",
                ),
                SizedBox(height: ScreenUtil().setHeight(40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {},
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
                      onTap: () {},
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
                            Icon(Icons.bookmark_border),
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
                      onTap: () {},
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
                      onTap: () {},
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
              "Taska Church",
              style: Mystyle.titleTextStyle.copyWith(
                fontSize: ScreenUtil().setSp(80),
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          ListView.builder(
            itemCount: 7,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: CommentsW(
                  image:
                      "https://i.pinimg.com/originals/45/13/23/451323560320fa7639b790ce4b9a13eb.jpg",
                  name: "Nombre Usuario",
                  elbr: 3,
                  comment: "“Más warros imposible!”",
                  likes: 1,
                  time: "Hace 2 días ",
                ),
              );
            },
          ),
          // SizedBox(height: ScreenUtil().setHeight(100)),
        ],
      ),
    );
  }
}
