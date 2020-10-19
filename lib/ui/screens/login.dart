import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/screens/home.dart';
import 'package:el_brownie_app/ui/widgets/decoration_layout.dart';
import 'package:el_brownie_app/ui/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class Login extends StatefulWidget {
  State createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  UserBloc userBloc;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    userBloc = BlocProvider.of(context);
    return _handleCurrentSession();
  }

  Widget _handleCurrentSession() {
    return StreamBuilder(
        stream: userBloc.authStatus,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return logInForm(context);
          } else {
            return Home();
          }
        });
  }

  Widget logInForm(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ListView(
              padding: EdgeInsets.only(bottom: 170),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          "¡Bienvenido!",
                          style: TextStyle(color: Colors.black, fontSize: 35.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(
                          "Inicie sesión con sus\ncredenciales de paciente",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          textAlign: TextAlign.center),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: bottomForm(),
    );
  }

  Widget bottomForm() {
    TextEditingController ecMail = new TextEditingController();
    TextEditingController ecPassword = new TextEditingController();

    return Stack(
      children: [
        DecorationLayout(
          height: 180.0,
        ),
        Container(
            padding: EdgeInsets.only(),
            child: Form(
              key: this._formKey,
              child: ListView(
                padding: EdgeInsets.all(9),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                        controller: ecMail,
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.person),
                        ),
                        style: TextStyle(
                            decorationColor: Colors.white, color: Colors.white),
                        cursorColor: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: ecPassword,
                      decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(Icons.vpn_key)),
                      style: TextStyle(
                        decorationColor: Color(0xFF00bcd5),
                        color: Colors.white,
                      ),
                      obscureText: true,
                      cursorColor: Color(0xFF00bcd5),
                    ),
                  ),
                  Container(
                    width: 300,
                    margin: EdgeInsets.only(),
                    child: RoundedButton(
                        buttonText: "Iniciar Sesión",
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          userBloc
                              .signIn(
                                  email: ecMail.text, password: ecPassword.text)
                              .then((User value) {
                            userBloc.user.uid = value.uid;
                            userBloc.updateUserData(UserModel(
                                uid: value.uid,
                                userName: value.displayName,
                                email: value.email));
                          });
                        }),
                  ),
                  Container(
                      width: 300,
                      margin: EdgeInsets.only(),
                      child: RoundedButton(
                          buttonText: "Registrarse",
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () {
                            userBloc
                                .register(
                                    email: ecMail.text,
                                    password: ecPassword.text)
                                .then((User value) {
                              userBloc.user.uid = value.uid;
                              userBloc.updateUserData(UserModel(
                                  uid: value.uid,
                                  userName: value.displayName,
                                  email: value.email));
                            });
                          })),
                  Container(
                    width: 300,
                    margin: EdgeInsets.only(),
                    child: RoundedButton(
                        buttonText: "Log In Google",
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          userBloc.signInGoogle().then((User value) {
                            userBloc.user.uid = value.uid;
                            userBloc.updateUserData(UserModel(
                                uid: value.uid,
                                userName: value.displayName,
                                email: value.email));
                          });
                        }),
                  ),
                  Container(
                    width: 300,
                    margin: EdgeInsets.only(),
                    child: RoundedButton(
                        buttonText: "Log In Facebook",
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          userBloc.signOut();
                          userBloc.signInFacebook().then((User value) {
                            userBloc.user.uid = value.uid;
                            userBloc.updateUserData(UserModel(
                                uid: value.uid,
                                userName: value.displayName,
                                email: value.email));
                          });
                        }),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
