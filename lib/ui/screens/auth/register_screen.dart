import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/notification.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/screens/auth/login_screen.dart';
import 'package:el_brownie_app/ui/screens/home/bottom_tab.dart';
import 'package:el_brownie_app/ui/screens/home/home_screen.dart';
import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;
  bool pressAttention = false;

  bool accepted = false;

  UserBloc userBloc;

  bool _obscureText = true;

  var _email;
  var _emailconfirmation;
  var _password;
  var _username;

  bool _validate = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    userBloc = BlocProvider.of(context);

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Mystyle.primarycolo,
          elevation: 0,
          title: Container(
            width: ScreenUtil().setHeight(500),
            child: Image.asset("assets/appblogo.png"),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(50)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Regístrate',
                    style: Mystyle.titleTextStyle.copyWith(
                      color: Colors.black87, // normalTextStyle
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(50)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Completa este formulario para formar parte de nuestra comunidad.',
                      style: Mystyle.regularTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(50)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: Mystyle.inputWhitebg('Usuario'),
                  textInputAction: TextInputAction.done,
                  validator: validateNotEmpty,
                  onSaved: (String val) {
                    _username = val;
                  },
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: Mystyle.inputWhitebg('Email'),
                  textInputAction: TextInputAction.done,
                  validator: validateEmail,
                  onSaved: (String val) {
                    _email = val;
                  },
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: Mystyle.inputWhitebg('Confirmar email'),
                  textInputAction: TextInputAction.done,
                  validator: validateEmail,
                  onSaved: (String val) {
                    _emailconfirmation = val;
                  },
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: TextFormField(
                  obscureText: _obscureText,
                  textInputAction: TextInputAction.done,
                  decoration: Mystyle.inputWhitebg(
                    'Contraseña',
                    icon: IconButton(
                      onPressed: _toggle,
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  validator: validatePassword,
                  onSaved: (String val) {
                    _password = val;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: accepted,
                      onChanged: (t) {
                        setState(() {
                          accepted = t;
                        });
                      },
                    ),
                    RichText(
                        text: TextSpan(
                            style: Mystyle.normalTextStyle,
                            children: <TextSpan>[
                          TextSpan(text: 'Aceptar '),
                          TextSpan(
                              text: 'términos y condiciones',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _launchURL();
                                })
                        ]))
                  ],
                ),
              ),
              !accepted
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: Text(
                          "Acepte los términos para registrarse",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: ButtAuth(
                  "Registrarse",
                  () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      if (accepted) {
                        setState(() {
                          pressAttention = false;
                          //
                        });
                        userBloc
                            .register(email: _email, password: _password)
                            .then((value) {
                          if (value is User) {
                            userBloc.updateUserData(UserModel(
                              uid: value.uid,
                              userName: _username,
                              email: value.email,
                            ));
                            userBloc.addNotification(value.uid, "Register", 10);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return BottomTabBarr(); //register
                                },
                              ),
                            );
                          } else {
                            _showAlertDialog("");
                          }
                        });
                      } else {}
                    } else {
                      //validation error
                      _validate = true;
                    }
                  },
                  border: true,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                alignment: Alignment.center,
                child: RichText(
                    text: TextSpan(
                        style: Mystyle.normalTextStyle,
                        children: <TextSpan>[
                      TextSpan(text: '¿Tienes una cuenta? '),
                      TextSpan(
                          text: 'Accede ahora',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return LoginScreen(); //register
                                  },
                                ),
                              );
                            })
                    ])),
                //child: Text("¿Tienes una cuenta? Accede ahora"),
              ),
              SizedBox(height: ScreenUtil().setHeight(150)),
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
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(50)),
            ],
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
              'Fallo de registro',
              style: TextStyle(color: Colors.black),
            ),
            content: Text("El mail ya está en uso"),
          );
        });
  }
}

_launchURL() async {
  const url = 'http://elbrownie.com/terms.php';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Entre un mail válido';
  else
    return null;
}

String validatePassword(String value) {
  if (value.length < 8)
    return 'Contraseña necesita ser mayor a 8 caracteres';
  else
    return null;
}

String validateNotEmpty(String value) {
  if (value.isEmpty) {
    return 'Los campos no pueden estar vacios';
  } else {
    return null;
  }
}
