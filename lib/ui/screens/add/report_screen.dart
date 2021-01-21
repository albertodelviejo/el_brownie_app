import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/repository/cloud_firestore_api.dart';
import 'package:el_brownie_app/repository/stripe_api.dart';
import 'package:el_brownie_app/ui/screens/notifications/notifications_screen.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../utils/buttonauth.dart';
import '../../utils/mystyle.dart';

class ReportScreen extends StatefulWidget {
  final String idUserPost;
  final String postId;

  ReportScreen({Key key, this.postId = "", this.idUserPost = ""});
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int _value = -1;
  String reason = '';
  bool isEnabled = false;

  UserBloc userBloc;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    userBloc = BlocProvider.of(context);
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: loading,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Mystyle.primarycolo,
            elevation: 0,
            title: Container(
              width: ScreenUtil().setHeight(500),
              child: Image.asset("assets/appblogo.png"),
            ),
            centerTitle: true,
          ),
          body: Builder(
            builder: (context) => ListView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              children: [
                SizedBox(height: ScreenUtil().setHeight(60)),
                Text(
                  "Informar de usuario o publicación",
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
                    "¿Tienes algún problema con esta publicación?",
                    style: Mystyle.regularTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(100)),
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        report_opt_1,
                        style: Mystyle.regularTextStyle
                            .copyWith(fontSize: ScreenUtil().setSp(45)),
                      ),
                      leading: Radio(
                        value: 0,
                        groupValue: _value,
                        activeColor: Colors.black,
                        onChanged: (v) {
                          isEnabled = true;
                          setState(() {
                            _value = v;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        report_opt_2,
                        style: Mystyle.regularTextStyle
                            .copyWith(fontSize: ScreenUtil().setSp(45)),
                      ),
                      leading: Radio(
                        value: 1,
                        groupValue: _value,
                        activeColor: Colors.black,
                        onChanged: (v) {
                          isEnabled = true;
                          setState(() {
                            _value = v;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        report_opt_3,
                        style: Mystyle.regularTextStyle
                            .copyWith(fontSize: ScreenUtil().setSp(45)),
                      ),
                      leading: Radio(
                        value: 2,
                        groupValue: _value,
                        activeColor: Colors.black,
                        onChanged: (v) {
                          isEnabled = true;
                          setState(() {
                            _value = v;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        report_opt_4,
                        style: Mystyle.regularTextStyle
                            .copyWith(fontSize: ScreenUtil().setSp(45)),
                      ),
                      leading: Radio(
                        value: 3,
                        groupValue: _value,
                        activeColor: Colors.black,
                        onChanged: (v) {
                          isEnabled = true;
                          setState(() {
                            _value = v;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(100)),
                ButtAuth(
                    "Report",
                    isEnabled
                        ? () async {
                            setState(() {
                              loading = true;
                            });
                            switch (_value) {
                              case 0:
                                reason = report_opt_1;
                                break;
                              case 1:
                                reason = report_opt_2;
                                break;
                              case 2:
                                reason = report_opt_3;
                                break;
                              case 3:
                                reason = report_opt_4;
                                break;
                            }
                            await userBloc.reportPost({
                              'reported': 'post',
                              'id_post': widget.postId,
                              'reports': [
                                {
                                  'id_user': widget.idUserPost,
                                  'reason': reason,
                                }
                              ],
                            });
                            setState(() {
                              loading = false;
                            });
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Wrap(children: <Widget>[
                                      Stack(children: [
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                height:
                                                    ScreenUtil().setWidth(100),
                                                width:
                                                    ScreenUtil().setWidth(100),
                                                child: SvgPicture.asset("")),
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(60)),
                                            Text(
                                              report_succesfull,
                                              style: Mystyle.titleTextStyle
                                                  .copyWith(
                                                      color: Colors.black87),
                                              textAlign: TextAlign.center,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  height: ScreenUtil()
                                                      .setWidth(330),
                                                  width: ScreenUtil()
                                                      .setWidth(330),
                                                  child: SvgPicture.asset(
                                                      "assets/svg/send.svg")),
                                            ),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(40)),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24),
                                              child: Text(
                                                "¡La publicación ha sido reportada! gracias..",
                                                style: Mystyle.normalTextStyle,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(40)),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24),
                                              child: ButtAuth(
                                                "Aceptar",
                                                () {
                                                  Navigator.of(context)
                                                      .popUntil((route) =>
                                                          route.isFirst);
                                                },
                                                border: true,
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(40)),
                                          ],
                                        ),
                                      ]),
                                    ])));
                          }
                        : null,
                    border: true,
                    press: true),
                SizedBox(height: ScreenUtil().setHeight(300)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
