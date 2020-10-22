import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtAuth {
  static buttonauth(text, pressAttention2, fun, {bool border = false}) {
    return Container(
      height: ScreenUtil().setHeight(120),
      width: ScreenUtil().screenWidth - ScreenUtil().setWidth(300),
      child: RaisedButton(
        child: Text(
          text,
          style: Mystyle.regularTextStyle.copyWith(fontWeight: FontWeight.w600),
        ),
        textColor: pressAttention2 ? Colors.white : Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: border ? BorderSide(color: Colors.black) : BorderSide.none,
        ),
        color: pressAttention2 ? Colors.black87 : Colors.white,
        splashColor: Colors.black87,
        highlightColor: Colors.black87,
        onPressed: fun,
      ),
    );
  }
}