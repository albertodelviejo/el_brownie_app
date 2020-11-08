import 'dart:ui';

import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardNotification extends StatefulWidget {
  Icon icon;
  String text;
  int points = 10;

  CardNotification({this.icon, this.text, this.points});
  @override
  _CardNotificationState createState() => _CardNotificationState();
}

class _CardNotificationState extends State<CardNotification> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Container(
      child: Column(children: [
        Stack(children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                "assets/svg/delete_icon.svg",
                width: 90,
                height: 90,
              ),
            ),
          ),
          Dismissible(
            key: Key("1"),
            child: Container(
              decoration: Mystyle.cadredec2().copyWith(
                borderRadius: BorderRadius.circular(10),
              ),
              width: ScreenUtil().setWidth(1000),
              height: ScreenUtil().setHeight(250),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SvgPicture.asset(
                      "assets/svg/notifmoney.svg",
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(10)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SizedBox(
                      width: 160,
                      child: Text(
                        widget.text,
                        style: Mystyle.normalTextStyle,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                  Text(
                    "+" + widget.points.toString() + "\npuntos",
                    style: TextStyle(
                        color: Color(0xFFD16061),
                        fontSize: 15,
                        fontFamily: Mystyle.openS),
                  )
                ],
              ),
            ),
          ),
        ]),
        Container(
          height: 10,
        )
      ]),
    );
  }
}
