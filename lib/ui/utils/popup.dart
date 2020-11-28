import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PopUp {
  String type;
  String title;
  String text;
  var icon;

  PopUp({this.type});

  report(
    context,
  ) {
    switch (type) {
      case "reclamation":
        icon = SvgPicture.asset("assets/svg/notifmoney.svg");
        text = notification_pop_text_reclamation;
        title = notification_pop_title_reclamation;
        break;
      case "favourite":
        icon = SvgPicture.asset("assets/svg/favorito.svg");
        text = notification_pop_text_favourite;
        title = notification_pop_title_favourite;
        break;
      case "top":
        icon = SvgPicture.asset("assets/svg/top.svg");
        text = notification_pop_text_top;
        title = notification_pop_title_top;
        break;
      case "welcome":
        icon = Image.asset("assets/ifull.png");
        text = notification_pop_text_welcome;
        title = notification_pop_title_welcome;
        break;
      case "comment":
        icon = SvgPicture.asset("assets/svg/descanso.svg");
        text = notification_pop_text_comment;
        title = notification_pop_title_comment;
        break;
      case "added":
        icon = Image.asset("assets/ifull.png");
        text = notification_pop_text_added;
        title = notification_pop_title_added;
        break;
      default:
        icon = Image.asset("assets/ifull.png");
        text = notification_pop_text_welcome;
        title = notification_pop_title_welcome;
        break;
    }

    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: ScreenUtil().setHeight(800),
          height: ScreenUtil().setHeight(1000),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      alignment: Alignment.bottomRight,
                      height: ScreenUtil().setWidth(100),
                      width: ScreenUtil().setWidth(100),
                      child: SvgPicture.asset("")),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(60)),
                    Text(
                      title,
                      style: Mystyle.titleTextStyle
                          .copyWith(color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                        alignment: Alignment.center,
                        height: ScreenUtil().setWidth(300),
                        width: ScreenUtil().setWidth(300),
                        child: icon),
                    SizedBox(height: ScreenUtil().setHeight(40)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        text,
                        style: Mystyle.normalTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(60)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 42),
                      child: ButtAuth(
                        "Aceptar",
                        () {
                          Navigator.pop(context);
                        },
                        border: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
