import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/screens/home.dart';
import 'package:el_brownie_app/ui/screens/register_screen.dart';
import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final username = TextEditingController();
  final password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  PageController controller = PageController();
  UserBloc userBloc;

  int currentIndex = 0;
  bool pressAttention = false;
  bool pressAttention2 = false;
  bool acceder = false;
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
            return Home();
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
                          ButtAuth.buttonauth("Acceder", pressAttention2, () {
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
                          ButtAuth.buttonauth("Registrarse", pressAttention,
                              () {
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
                            width: ScreenUtil().screenWidth -
                                ScreenUtil().setWidth(300),
                            child: TextFormField(
                              controller: username,
                              decoration: Mystyle.inputregular('Usuario'),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value.isEmpty) return 'isEmpty';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(50)),
                          Container(
                            width: ScreenUtil().screenWidth -
                                ScreenUtil().setWidth(300),
                            child: TextFormField(
                              controller: password,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              decoration: Mystyle.inputregular(
                                'Contraseña',
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey[400],
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
                            child: Text("Olvidaste tu contraseña?"),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(50)),
                          ButtAuth.buttonauth("Acceder", acceder, () {
                            setState(() {
                              acceder = false;
                              //
                            });

                            userBloc
                                .signIn(
                                    email: username.text,
                                    password: password.text)
                                .then((User value) {
                              userBloc.user.uid = value.uid;
                              userBloc.updateUserData(UserModel(
                                  uid: value.uid, email: value.email));

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return Home(); //register
                                  },
                                ),
                              );
                            });
                          }),
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            alignment: Alignment.center,
                            child: Text("¿No tienes una cuenta? Registrate"),
                          ),
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
}
