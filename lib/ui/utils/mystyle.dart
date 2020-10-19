import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Mystyle {
  static const Color primarycolo = Color(0xFFfde34e);
  static const Color secondrycolo = Color(0xFF25bbee);
  // static const Color lightercolo = Color(0xFFbfecff);
  // static const Color redcolo = Color(0xFFeb6468);
  // static const Color bodycolo = Color(0xFFfbfbfb);
  // static const Color txtcolo = Color(0xFF455590);

  static String tragickmarker = "TragicMarker";
  static String openS = "OpenSansRegular";

  static TextStyle titleTextStyle = TextStyle(
    color: secondrycolo,
    fontFamily: tragickmarker,
    fontSize: ScreenUtil().setSp(82),
  );

  static TextStyle subtitleTextStyle = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w800,
    fontFamily: openS,
    fontSize: ScreenUtil().setSp(48),
  );

  static TextStyle regularTextStyle = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.normal,
    fontFamily: openS,
    fontSize: ScreenUtil().setSp(48),
  );

  static TextStyle smallTextStyle = TextStyle(
    color: primarycolo,
    fontWeight: FontWeight.normal,
    fontFamily: openS,
    fontSize: ScreenUtil().setSp(32),
  );

  //---------------

  static cardhome() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.grey[200],
          spreadRadius: 3,
          blurRadius: 4,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    );
  }

  static cadredec() {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(50),
      border: Border.all(
        color: Colors.black87,
      ),
    );
  }

  static inputregular(hint, {icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14,
      ),
      fillColor: Colors.white,

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.withOpacity(.2), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.withOpacity(.2), width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.withOpacity(.2), width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.withOpacity(.2), width: 1.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.withOpacity(.2), width: 1.0),
      ),
      // bo
      suffixIcon: icon,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      labelStyle: TextStyle(
        fontSize: 14,
      ),
    );
  }

  // -------------
  static bool isNullEmptyOrFalse(Object o) =>
      o == null || false == o || "" == o;

  static bool isNullEmptyFalseOrZero(Object o) =>
      o == null || false == o || 0 == o || "" == o;
}
