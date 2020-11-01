import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/rankwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool noresult = false;
  List<RankModal> rmodals = [
    RankModal(name: "Usuario", pub: "20 publicaciones", point: "400"),
    RankModal(name: "Usuario", pub: "20 publicaciones", point: "250"),
    RankModal(name: "Usuario", pub: "20 publicaciones", point: "200"),
    RankModal(name: "Usuario", pub: "20 publicaciones", point: "130"),
    RankModal(name: "Usuario", pub: "20 publicaciones", point: "130"),
    RankModal(name: "Usuario", pub: "20 publicaciones", point: "130"),
    RankModal(name: "Usuario", pub: "20 publicaciones", point: "130"),
    RankModal(name: "Usuario", pub: "20 publicaciones", point: "130"),
    RankModal(name: "Usuario", pub: "20 publicaciones", point: "130"),
    RankModal(name: "Usuario", pub: "20 publicaciones", point: "130"),
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: ListView(
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
              rank: 22,
              image:
                  "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png",
              name: "Laia Pons",
              pub: "20 publicaciones",
              point: "130",
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
              itemCount: 10,
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
                    image: rmodals[index].image,
                    name: rmodals[index].name,
                    pub: rmodals[index].pub,
                    point: rmodals[index].point,
                  ),
                );
              },
            ),
            SizedBox(height: ScreenUtil().setHeight(100)),
          ],
        ),
      ),
    );
  }
}

class RankModal {
  int rank;
  String image;
  String name;
  String pub;
  String point;
  RankModal({
    this.rank,
    this.image =
        "https://i.pinimg.com/originals/45/13/23/451323560320fa7639b790ce4b9a13eb.jpg",
    this.name = "Usuario",
    this.pub = "20 publicaciones",
    this.point = "130",
  });
}
