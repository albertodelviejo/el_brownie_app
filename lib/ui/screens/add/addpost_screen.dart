import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _value = 12;
  int rating = 3;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

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
              child: Icon(
                Icons.notifications_none,
                color: Colors.black,
                size: 28,
              ),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: [
            SizedBox(height: ScreenUtil().setHeight(30)),
            InkWell(
              onTap: () {},
              child: Container(
                alignment: Alignment.bottomRight,
                height: ScreenUtil().setWidth(100),
                width: ScreenUtil().setWidth(100),
                child: SvgPicture.asset(
                  "assets/svg/close.svg",
                ),
              ),
            ),
            Text(
              "Añade tu valoración",
              style: Mystyle.titleTextStyle.copyWith(
                fontSize: ScreenUtil().setSp(100),
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ScreenUtil().setHeight(40)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      rating = index + 1;
                      // print(index);
                    });
                  },
                  child: Container(
                    height: ScreenUtil().setWidth(140),
                    width: ScreenUtil().setWidth(140),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    alignment: Alignment.center,
                    child: index >= rating
                        ? Image.asset("assets/iempty.png")
                        : Image.asset("assets/ifull.png"),
                  ),
                );
              }),
            ),
            SizedBox(height: ScreenUtil().setHeight(60)),
            TextFormField(
              // controller: test,
              maxLines: 4,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  Mystyle.inputregularmaxline('Escribe tu comentario aqui…'),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value.isEmpty) return 'isEmpty';
                return null;
              },
            ),
            SizedBox(height: ScreenUtil().setHeight(40)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              height: ScreenUtil().setHeight(600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: ScreenUtil().setWidth(160),
                      width: ScreenUtil().setWidth(160),
                      child: SvgPicture.asset(
                        "assets/svg/camera.svg",
                      ),
                    ),
                  ),
                  Text(
                    "Sube una foto",
                    style: Mystyle.smallTextStyle.copyWith(
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(60)),
            ButtAuth("Publicar", () {}, border: true, press: true),
            SizedBox(height: ScreenUtil().setHeight(100)),
          ],
        ),
      ),
    );
  }
}
