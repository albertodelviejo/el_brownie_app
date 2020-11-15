import 'package:el_brownie_app/ui/utils/cardlosmas.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LosMasScreen extends StatefulWidget {
  @override
  _LosMasScreenState createState() => _LosMasScreenState();
}

class _LosMasScreenState extends State<LosMasScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Container(
      width: ScreenUtil().scaleWidth,
      height: ScreenUtil().screenHeight,
      child: ListView(
        children: [
          SizedBox(height: ScreenUtil().setHeight(40)),
          Text(
            "Brownies más warros",
            style: Mystyle.titleTextStyle.copyWith(
              fontSize: ScreenUtil().setSp(100),
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: .6,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16),
            crossAxisSpacing: ScreenUtil().setHeight(30),
            mainAxisSpacing: ScreenUtil().setHeight(60),
            children: <Widget>[
              CardLosmas(
                name: "Taska Church",
                place: "Calle Aragón, Vigo, España ",
                myindex: "3",
              ),
              CardLosmas(
                name: "Taska Church",
                place: "Calle Aragón, Vigo, España ",
                myindex: "3",
              ),
              CardLosmas(
                name: "Taska Church",
                place: "Calle Aragón, Vigo, España ",
                myindex: "3",
              ),
              CardLosmas(
                name: "Taska Church",
                place: "Calle Aragón, Vigo, España ",
                myindex: "3",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
