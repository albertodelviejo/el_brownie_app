import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:flutter_svg/svg.dart';

class NoResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      // color: Colors.brown,
      height: ScreenUtil().screenHeight / 1.5,
      width: ScreenUtil().scaleWidth,
      alignment: Alignment.center,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: ScreenUtil().setHeight(130)),
          Text(
            todos_empty_title,
            style: Mystyle.titleTextStyle.copyWith(
              fontSize: ScreenUtil().setSp(80),
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            todos_empty_text,
            style: Mystyle.titleTextStyle.copyWith(
              fontSize: ScreenUtil().setSp(60),
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ScreenUtil().setHeight(50)),
          Container(
            width: ScreenUtil().setWidth(600),
            height: ScreenUtil().setHeight(600),
            child: SvgPicture.asset("assets/noresult.svg"),
            alignment: Alignment.topCenter,
          ),
        ],
      ),
    );
  }
}
