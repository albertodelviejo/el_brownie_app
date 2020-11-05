import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/buttonauth.dart';
import '../../utils/mystyle.dart';

class RequestScreen extends StatefulWidget {
  String postId, price;

  RequestScreen({Key key, this.postId, this.price});
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int _value = 12;
  bool isfirst = false;
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
              "Reclama este local",
              style: Mystyle.titleTextStyle.copyWith(
                fontSize: ScreenUtil().setSp(100),
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ScreenUtil().setHeight(40)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "¿Por qué quieres que den de baja esta publicación?",
                style: Mystyle.regularTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(100)),
            Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Soy propietario del lugar',
                    style: Mystyle.normalTextStyle,
                  ),
                  leading: Radio(
                    value: 0,
                    groupValue: _value,
                    activeColor: Color(0xFF6200EE),
                    onChanged: (v) {
                      setState(() {
                        _value = v;
                        isfirst = true;
                      });
                    },
                  ),
                  trailing: isfirst == false
                      ? null
                      : Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: IconButton(
                            icon: Icon(Icons.keyboard_arrow_down),
                            onPressed: null,
                          ),
                        ),
                ),
                isfirst == false
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: ScreenUtil().setHeight(40)),
                            Padding(
                              padding: EdgeInsets.only(left: 16, right: 72),
                              child: Text(
                                "¿Es este el CIF que tienes registrado con nosotros?",
                                style: Mystyle.smallTextStyle.copyWith(
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(40)),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: ScreenUtil().setHeight(20)),
                                  child: TextFormField(
                                    // controller: test,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: Mystyle.inputWhitebg(
                                      'B-64738219',
                                    ),
                                    textInputAction: TextInputAction.done,
                                    validator: (value) {
                                      if (value.isEmpty) return 'isEmpty';
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: ScreenUtil().setHeight(40)),
                                ButtAuth("Si", () {},
                                    border: true, press: true),
                                SizedBox(height: ScreenUtil().setHeight(40)),
                              ],
                            ),
                          ],
                        ),
                      ),
                ListTile(
                  title: Text(
                    'Soy fan del lugar',
                    style: Mystyle.normalTextStyle,
                  ),
                  leading: Radio(
                    value: 1,
                    groupValue: _value,
                    activeColor: Color(0xFF6200EE),
                    onChanged: (v) {
                      setState(() {
                        _value = v;
                        isfirst = false;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Son mis amiguetes y les quiero',
                    style: Mystyle.normalTextStyle,
                  ),
                  leading: Radio(
                    value: 2,
                    groupValue: _value,
                    activeColor: Color(0xFF6200EE),
                    onChanged: (v) {
                      setState(() {
                        _value = v;
                        isfirst = false;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Por placer',
                    style: Mystyle.normalTextStyle,
                  ),
                  leading: Radio(
                    value: 3,
                    groupValue: _value,
                    activeColor: Color(0xFF6200EE),
                    onChanged: (v) {
                      setState(() {
                        _value = v;
                        isfirst = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(100)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Precio",
                style: Mystyle.subtitleTextStylenoco,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(40)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.price + " €",
                style: Mystyle.titleregularTextStyle.copyWith(
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(60)),
            ButtAuth("Pagar", () {}, border: true, press: true),
            SizedBox(height: ScreenUtil().setHeight(100)),
          ],
        ),
      ),
    );
  }
}