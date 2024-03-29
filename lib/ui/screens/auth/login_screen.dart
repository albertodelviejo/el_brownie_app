import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/repository/auth_exception_handler.dart';
import 'package:el_brownie_app/ui/screens/home/bottom_tab.dart';
import 'package:el_brownie_app/ui/screens/auth/register_screen.dart';
import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  PageController controller = PageController();
  UserBloc userBloc;

  int currentIndex = 0;
  bool pressAttention = false;
  bool pressAttention2 = false;
  bool acceder = false;

  bool _obscureText = true;
  bool _autoValidate = false;
  bool applesignin = false;

  var _emailconfirmation;
  bool _validate = false;

  final contrasenaController = TextEditingController();
  final usernameController = TextEditingController();
  final recoverControler = TextEditingController();

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _useAppleSignIn();
  }

// here we verify if the device support SignIn with apple if yes we show SignIn with apple button
  _useAppleSignIn() async {
    if (Platform.isIOS) {
      var deviceInfo = await DeviceInfoPlugin().iosInfo;
      var version = deviceInfo.systemVersion;

      if (double.parse(version) >= 13) {
        setState(() {
          applesignin = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    //userBloc.signOut();
    return _handleCurrentSession();
  }

  Widget _handleCurrentSession() {
    return StreamBuilder(
        stream: userBloc.authStatus,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //userBloc = BlocProvider.of(context);
          if (!snapshot.hasData ||
              snapshot.hasError ||
              userBloc.currentUser == null) {
            return loginScreen(context);
          } else {
            userBloc.user = UserModel(uid: snapshot.data.uid);
            return BottomTabBarr();
          }
        });
  }

  Widget loginScreen(BuildContext context) {
    ScreenUtil.init(context);

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (controller.page == 1) {
            controller.animateToPage(
              currentIndex - 1,
              duration: Duration(seconds: 2),
              curve: Curves.ease,
            );
            setState(() {
              pressAttention = false;
              pressAttention2 = false;
            });
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Mystyle.primarycolo,
          body: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              children: <Widget>[
                SizedBox(height: ScreenUtil().setHeight(100)),
                Image(
                  height: ScreenUtil().setHeight(400),
                  image: AssetImage("assets/Logo.png"),
                ),
                Container(
                  height: ScreenUtil().setHeight(900),
                  width: double.infinity,
                  child: PageView(
                    controller: controller,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (val) {
                      setState(() {
                        currentIndex = val;
                      });
                    },
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            welcome_titulo,
                            style: Mystyle.titleTextStyle.copyWith(
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          Text(
                            welcome_text,
                            textAlign: TextAlign.center,
                            style: Mystyle.regularTextStyle,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(50)),
                          ButtAuth(welcome_login, () {
                            setState(() {
                              pressAttention2 = !pressAttention2;
                              pressAttention = false;
                              controller.animateToPage(
                                currentIndex + 1,
                                duration: Duration(seconds: 2),
                                curve: Curves.ease,
                              );
                            });
                          }),
                          SizedBox(height: ScreenUtil().setHeight(50)),
                          ButtAuth(welcome_register, () {
                            setState(() {
                              pressAttention = !pressAttention;
                              pressAttention2 = false;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return RegisterScreen(); //register
                                  },
                                ),
                              );
                            });
                          }),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "¡Qué bien que estés aquí!",
                            style: Mystyle.titleTextStyle.copyWith(
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Introduce tus credenciales para acceder",
                            textAlign: TextAlign.center,
                            style: Mystyle.regularTextStyle,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(50)),
                          Container(
                            child: TextFormField(
                              controller: usernameController,
                              decoration:
                                  Mystyle.inputregular(login_form_usuario),
                              textInputAction: TextInputAction.done,
                              validator: validateEmail,
                              onSaved: (String val) {
                                _emailconfirmation = val;
                              },
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(40)),
                          Container(
                            child: TextFormField(
                              obscureText: _obscureText,
                              textInputAction: TextInputAction.done,
                              controller: contrasenaController,
                              decoration: Mystyle.inputregular(
                                login_form_password,
                                icon: IconButton(
                                  onPressed: _toggle,
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                              /*
                              validator: (value) {
                                if (value.isEmpty) return 'isEmpty';
                                return null;
                              },
                              */
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 5),
                              alignment: Alignment.centerRight,
                              child: RichText(
                                  text: TextSpan(
                                      style: Mystyle.normalTextStyle,
                                      children: <TextSpan>[
                                    TextSpan(
                                        text: login_password_recover,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            return showDialog(
                                                context: context,
                                                builder: (context) => Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16),
                                                      child: Wrap(
                                                          children: <Widget>[
                                                            Stack(children: [
                                                              Positioned(
                                                                  right: 0,
                                                                  top: 0,
                                                                  child:
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Container(
                                                                              alignment: Alignment.bottomRight,
                                                                              width: ScreenUtil().setHeight(100),
                                                                              height: ScreenUtil().setHeight(100),
                                                                              child: SvgPicture.asset("")))),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  SizedBox(
                                                                      height: ScreenUtil()
                                                                          .setHeight(
                                                                              60)),
                                                                  Text(
                                                                    recover_password_title,
                                                                    style: Mystyle
                                                                        .titleTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.black87),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  SizedBox(
                                                                      height: ScreenUtil()
                                                                          .setHeight(
                                                                              40)),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            5),
                                                                    child: Text(
                                                                      recover_text_model,
                                                                      /*
                                                                      style: Mystyle
                                                                          .subtitleTextStyle
                                                                          .copyWith(
                                                                              fontSize: ScreenUtil().setSp(40)),
                                                                              */
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height: ScreenUtil()
                                                                          .setHeight(
                                                                              40)),
                                                                  Form(
                                                                    key:
                                                                        _form2Key,
                                                                    child:
                                                                        TextFormField(
                                                                      textInputAction:
                                                                          TextInputAction
                                                                              .done,
                                                                      decoration:
                                                                          Mystyle.inputWhitebg(
                                                                              'Email'),
                                                                      validator:
                                                                          validateEmail,
                                                                      onSaved:
                                                                          (String
                                                                              val) {
                                                                        _emailconfirmation =
                                                                            val;
                                                                      },
                                                                      controller:
                                                                          recoverControler,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height: ScreenUtil()
                                                                          .setHeight(
                                                                              40)),
                                                                  ButtAuth(
                                                                      "Enviar enlace de Acceso",
                                                                      () {
                                                                    if (_form2Key
                                                                        .currentState
                                                                        .validate()) {
                                                                      _form2Key
                                                                          .currentState
                                                                          .save();
                                                                      userBloc.resetPassword(
                                                                          recoverControler
                                                                              .text);
                                                                      Navigator.pop(
                                                                          context);
                                                                      _showPasswordRecoveryDialog();
                                                                    } else {
                                                                      _validate =
                                                                          true;
                                                                    }
                                                                  },
                                                                      border:
                                                                          true),
                                                                  SizedBox(
                                                                      height: ScreenUtil()
                                                                          .setHeight(
                                                                              60)),
                                                                ],
                                                              ),
                                                            ])
                                                          ]),
                                                    )));
                                          })
                                  ]))),
                          SizedBox(height: ScreenUtil().setHeight(30)),
                          ButtAuth("Acceder", () {
                            setState(() {
                              acceder = false;
                              //
                            });

                            userBloc
                                .signIn(
                                    email: usernameController.text,
                                    password: contrasenaController.text)
                                .then((value) {
                              if (value is User) {
                                userBloc.user.uid = value.uid;
                                userBloc.updateUserData(UserModel(
                                    uid: value.uid, email: value.email));
                              } else {
                                final errorMsg = AuthExceptionHandler
                                    .generateExceptionMessage(value);
                                _showAlertDialog(errorMsg);
                              }
                            });
                          }),
                          Container(
                              padding: EdgeInsets.only(top: 9),
                              alignment: Alignment.center,
                              child: RichText(
                                  text: TextSpan(
                                      style: Mystyle.normalTextStyle,
                                      children: <TextSpan>[
                                    TextSpan(text: '¿No tienes una cuenta? '),
                                    TextSpan(
                                        text: 'Regístrate',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return RegisterScreen(); //register
                                                },
                                              ),
                                            );
                                          })
                                  ]))),
                          SizedBox(height: ScreenUtil().setHeight(50)),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  "O accede mediante Redes Sociales",
                  style: Mystyle.normalTextStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ScreenUtil().setHeight(50)),
                SignInButton(
                  Buttons.Facebook,
                  padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16),
                  onPressed: () {
                    userBloc.signOut();
                    userBloc.signInFacebook().then((value) {
                      if (value is User) {
                        userBloc.user = UserModel(
                            uid: value.uid,
                            email: value.email,
                            userName: value.displayName);
                        userBloc.updateUserData(UserModel(
                            uid: value.uid,
                            email: value.email,
                            userName: value.displayName));
                      } else {
                        final errorMsg =
                            AuthExceptionHandler.generateExceptionMessage(
                                value);
                        _showAlertDialog(errorMsg);
                      }
                    });
                  },
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(30)),
                SignInButton(
                  Buttons.Google,
                  padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
                  onPressed: () {
                    userBloc.signInGoogle().then((value) {
                      if (value is User) {
                        userBloc.user = UserModel(
                            uid: value.uid,
                            email: value.email,
                            userName: value.displayName);
                        userBloc.updateUserData(UserModel(
                            uid: value.uid,
                            userName: value.displayName,
                            email: value.email));
                      } else {
                        final errorMsg =
                            AuthExceptionHandler.generateExceptionMessage(
                                value);
                        _showAlertDialog(errorMsg);
                      }
                    });
                  },
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(30)),
                applesignin == true
                    ? SignInButton(
                        Buttons.Apple,
                        padding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                        onPressed: () {
                          userBloc.signInApple().then((value) {
                            if (value is User) {
                              userBloc.user = UserModel(
                                  uid: value.uid,
                                  email: value.email,
                                  userName: value.displayName);
                              userBloc.updateUserData(UserModel(
                                  uid: value.uid,
                                  userName: value.displayName,
                                  email: value.email));
                            } else {
                              final errorMsg =
                                  AuthExceptionHandler.generateExceptionMessage(
                                      value);
                              _showAlertDialog(errorMsg);
                            }
                          });
                        },
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(height: ScreenUtil().setHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showAlertDialog(errorMsg) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Login fallido',
              style: Mystyle.titleTextStyle.copyWith(color: Colors.black87),
            ),
            content: Text("Credenciales incorrectas"),
          );
        });
  }

  _showPasswordRecoveryDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Recuperar contraseña',
              style: Mystyle.titleTextStyle.copyWith(color: Colors.black87),
            ),
            content: Text(recover_text_instruction),
          );
        });
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Entre un email válido';
    else
      return null;
  }
}
