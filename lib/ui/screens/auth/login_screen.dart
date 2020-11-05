import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/repository/auth_exception_handler.dart';
import 'package:el_brownie_app/ui/screens/home/bottom_tab.dart';
import 'package:el_brownie_app/ui/screens/home/home_screen.dart';
import 'package:el_brownie_app/ui/screens/auth/register_screen.dart';
import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  PageController controller = PageController();
  UserBloc userBloc;

  int currentIndex = 0;
  bool pressAttention = false;
  bool pressAttention2 = false;
  bool acceder = false;

  bool _obscureText = true;
  bool _autoValidate = false;

  final contrasenaController = TextEditingController();
  final usernameController = TextEditingController();

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return _handleCurrentSession();
  }

  Widget _handleCurrentSession() {
    return StreamBuilder(
        stream: userBloc.authStatus,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return loginScreen(context);
          } else {
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
                            'Bienvenido!',
                            style: Mystyle.titleTextStyle.copyWith(
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          Text(
                            'Vamos a pasarlo genial.',
                            style: Mystyle.titleTextStyle.copyWith(
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(50)),
                          ButtAuth("Acceder", () {
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
                          ButtAuth("Registrarse", () {
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
                            '¡Qué bien que estés aquí!',
                            style: Mystyle.titleTextStyle.copyWith(
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(50)),
                          Container(
                            child: TextFormField(
                              controller: usernameController,
                              decoration: Mystyle.inputregular('Usuario'),
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(50)),
                          Container(
                            child: TextFormField(
                              obscureText: _obscureText,
                              textInputAction: TextInputAction.done,
                              controller: contrasenaController,
                              decoration: Mystyle.inputregular(
                                'Contraseña',
                                icon: IconButton(
                                  onPressed: _toggle,
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) return 'isEmpty';
                                return null;
                              },
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
                                        text: 'Olvidaste tu contraseña?',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            userBloc.resetPassword(
                                                usernameController.text);
                                          })
                                  ]))),
                          SizedBox(height: ScreenUtil().setHeight(50)),
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
                              padding: EdgeInsets.only(top: 15),
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
                  "O utiliza tu perfil de Social Media",
                  style: Mystyle.normalTextStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ScreenUtil().setHeight(50)),
                SignInButton(
                  Buttons.Facebook,
                  padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16),
                  onPressed: () {
                    userBloc.signOut();
                    userBloc.signInFacebook().then((User value) {
                      userBloc.user.uid = value.uid;
                      userBloc.updateUserData(UserModel(
                          uid: value.uid,
                          userName: value.displayName,
                          email: value.email));
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
                    userBloc.signInGoogle().then((User value) {
                      userBloc.user.uid = value.uid;
                      userBloc.updateUserData(UserModel(
                          uid: value.uid,
                          userName: value.displayName,
                          email: value.email));
                    });
                  },
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
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
              'Login Failed',
              style: TextStyle(color: Colors.black),
            ),
            content: Text("Credenciales incorrectas"),
          );
        });
  }
}