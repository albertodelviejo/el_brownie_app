import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            "“No hay resultados\naplicando estos filtros”",
            style: Mystyle.titleTextStyle.copyWith(
              fontSize: ScreenUtil().setSp(80),
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ScreenUtil().setHeight(50)),
          Container(
            width: ScreenUtil().setWidth(600),
            height: ScreenUtil().setHeight(600),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(
                  "assets/noresult.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.topCenter,
          ),
        ],
      ),
    );
  }
}
