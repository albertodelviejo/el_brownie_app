import 'package:el_brownie_app/bloc/bloc_user.dart';
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

class RequestScreen extends StatefulWidget {
  String price, idUserPost;
  String postId = "";
  bool isEnabled = false;

  RequestScreen({Key key, this.postId, this.price, this.idUserPost});
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int _value = 12;
  bool isfirst = false;
  String reason = '';
  final cifController = TextEditingController();

  UserBloc userBloc;

  final _stripeService = StripeService();
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
            /*
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return NotificationsScreen(); //register
                      },
                    ),
                  ),
                  icon: Icon(
                    Icons.notifications_none,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ],
            */
          ),
          body: Builder(
            builder: (context) => ListView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              children: [
                SizedBox(height: ScreenUtil().setHeight(60)),
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
                        claim_opt_1,
                        style: Mystyle.regularTextStyle,
                      ),
                      leading: Radio(
                        value: 0,
                        groupValue: _value,
                        activeColor: Colors.black,
                        onChanged: (v) {
                          widget.isEnabled = true;
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
                              border:
                                  Border.all(color: Colors.black54, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
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
                                        controller: cifController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: Mystyle.inputWhitebg(
                                          'B-64738219',
                                        ),
                                        textInputAction: TextInputAction.done,
                                      ),
                                    ),
                                    SizedBox(
                                        height: ScreenUtil().setHeight(40)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    ListTile(
                      title: Text(
                        claim_opt_2,
                        style: Mystyle.regularTextStyle,
                      ),
                      leading: Radio(
                        value: 1,
                        groupValue: _value,
                        activeColor: Colors.black,
                        onChanged: (v) {
                          widget.isEnabled = true;
                          setState(() {
                            _value = v;
                            isfirst = false;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        claim_opt_3,
                        style: Mystyle.regularTextStyle,
                      ),
                      leading: Radio(
                        value: 2,
                        groupValue: _value,
                        activeColor: Colors.black,
                        onChanged: (v) {
                          widget.isEnabled = true;
                          setState(() {
                            _value = v;
                            isfirst = false;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        claim_opt_4,
                        style: Mystyle.regularTextStyle,
                      ),
                      leading: Radio(
                        value: 3,
                        groupValue: _value,
                        activeColor: Colors.black,
                        onChanged: (v) {
                          widget.isEnabled = true;
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
                    "Precio requerido",
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
                ButtAuth(
                    "Pagar",
                    widget.isEnabled
                        ? () async {
                            if (_value == 0 && cifController.text == '') {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Must fill CIF field!'),
                                  duration: Duration(seconds: 5)));
                            } else {
                              setState(() {
                                loading = true;
                              });

                              String cif = cifController.text;
                              double price = double.parse(widget.price) * 100;
                              String finalPrice = price.toStringAsFixed(0);
                              var response = await StripeService.payWithNewCard(
                                  amount: finalPrice, currency: 'EUR');

                              switch (_value) {
                                case 0:
                                  reason = claim_opt_1;
                                  break;
                                case 1:
                                  reason = claim_opt_2;
                                  break;
                                case 2:
                                  reason = claim_opt_3;
                                  break;
                                case 3:
                                  reason = claim_opt_4;
                                  break;
                              }
                              if (response.success) {
                                await _stripeService.createClaim(
                                    widget.price,
                                    widget.postId,
                                    cif,
                                    reason,
                                    'Card',
                                    response.paymentId);
                                userBloc.addNotification(
                                    widget.idUserPost, "reclamation", 10);
                                userBloc.addPoints(widget.idUserPost, 10);
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(response.message),
                                  duration: Duration(seconds: 5),
                                ));
                                Navigator.pop(context);
                                return showDialog(
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
                                                    height: ScreenUtil()
                                                        .setWidth(100),
                                                    width: ScreenUtil()
                                                        .setWidth(100),
                                                    child:
                                                        SvgPicture.asset("")),
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                    height: ScreenUtil()
                                                        .setHeight(60)),
                                                Text(
                                                  transference_succesfull,
                                                  style: Mystyle.titleTextStyle
                                                      .copyWith(
                                                          color:
                                                              Colors.black87),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 15),
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: ScreenUtil()
                                                          .setWidth(330),
                                                      width: ScreenUtil()
                                                          .setWidth(330),
                                                      child: SvgPicture.asset(
                                                          "assets/svg/tarjeta-de-credito-ok.svg")),
                                                ),
                                                SizedBox(
                                                    height: ScreenUtil()
                                                        .setHeight(40)),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 24),
                                                  child: Text(
                                                    "Gracias por su pago.\nSu transacción ha terminado y recibirá un correo electrónico confirmando la operación.",
                                                    style:
                                                        Mystyle.normalTextStyle,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: ScreenUtil()
                                                        .setHeight(40)),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
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
                                                    height: ScreenUtil()
                                                        .setHeight(40)),
                                              ],
                                            ),
                                          ]),
                                        ])));
                              } else {
                                return showDialog(
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
                                                    height: ScreenUtil()
                                                        .setWidth(100),
                                                    width: ScreenUtil()
                                                        .setWidth(100),
                                                    child:
                                                        SvgPicture.asset("")),
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                    height: ScreenUtil()
                                                        .setHeight(60)),
                                                Text(
                                                  "Pago cancelado",
                                                  style: Mystyle.titleTextStyle
                                                      .copyWith(
                                                          color:
                                                              Colors.black87),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 15),
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: ScreenUtil()
                                                          .setWidth(330),
                                                      width: ScreenUtil()
                                                          .setWidth(330),
                                                      child: SvgPicture.asset(
                                                          "assets/svg/tarjeta-de-credito-nok.svg")),
                                                ),
                                                SizedBox(
                                                    height: ScreenUtil()
                                                        .setHeight(40)),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 24),
                                                  child: Text(
                                                    "Se ha cancelado el pago.\nPor favor, revise los datos e inténtelo de nuevo. Gracias",
                                                    style:
                                                        Mystyle.normalTextStyle,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: ScreenUtil()
                                                        .setHeight(40)),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
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
                                                    height: ScreenUtil()
                                                        .setHeight(40)),
                                              ],
                                            ),
                                          ]),
                                        ])));
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(response.message),
                                  duration: Duration(seconds: 5),
                                ));
                              }
                              setState(() {
                                loading = false;
                              });
                            }
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
