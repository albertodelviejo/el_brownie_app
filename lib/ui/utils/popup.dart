import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReportUser {
  static report(
    context,
  ) {
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
                    child: SvgPicture.asset(
                      "assets/svg/close.svg",
                    ),
                  ),
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
                      "Eres menos pobre!",
                      style: Mystyle.titleTextStyle
                          .copyWith(color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      height: ScreenUtil().setWidth(300),
                      width: ScreenUtil().setWidth(300),
                      child: SvgPicture.asset(
                        "assets/svg/notifmoney.svg",
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(40)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "Alguien ha reclamado un local que has subido. En breves recibirás dineritooo!",
                        style: Mystyle.normalTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(60)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 42),
                      child: ButtAuth(
                        "Aceptar",
                        () {},
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
