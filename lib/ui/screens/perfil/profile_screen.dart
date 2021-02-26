import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/repository/google_maps_api.dart';
import 'package:el_brownie_app/ui/screens/auth/login_screen.dart';
import 'package:el_brownie_app/ui/screens/welcome/splash_screen.dart';
import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  bool showhidden = false;
  dynamic imageProfile = ExactAssetImage('assets/avatars/default.png');
  int imageIndex = 1;
  String imagePath = 'assets/avatars/default.png';
  bool imgChanged = false;
  bool isTappedYes = false;
  bool isTappedNo = false;
  var imagesUrls = [
    'https://firebasestorage.googleapis.com/v0/b/elbrownie-baf68.appspot.com/o/avatars%2Fdefault.png?alt=media&token=f2afa6be-730c-46b1-81c0-b80da431a8af',
    'https://firebasestorage.googleapis.com/v0/b/elbrownie-baf68.appspot.com/o/avatars%2Favatar1.png?alt=media&token=4e353287-5dbf-4389-8dfb-642d981af388',
    'https://firebasestorage.googleapis.com/v0/b/elbrownie-baf68.appspot.com/o/avatars%2Favatar2.png?alt=media&token=3425acfd-e209-41e5-90fa-81e2c6f88b35',
    'https://firebasestorage.googleapis.com/v0/b/elbrownie-baf68.appspot.com/o/avatars%2Favatar3.png?alt=media&token=8efd02eb-fa7c-44f0-a617-6e85b0717823',
    'https://firebasestorage.googleapis.com/v0/b/elbrownie-baf68.appspot.com/o/avatars%2Favatar4.png?alt=media&token=b6466a43-3669-4a9a-a27a-ed76dc93b8ea',
    'https://firebasestorage.googleapis.com/v0/b/elbrownie-baf68.appspot.com/o/avatars%2Favatar5.png?alt=media&token=aa011726-6a4a-470c-8c30-dd68ff713910',
    'https://firebasestorage.googleapis.com/v0/b/elbrownie-baf68.appspot.com/o/avatars%2Favatar6.png?alt=media&token=0828c30c-2cf2-48e7-9f34-dd7b75e07e12'
  ];

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool noresult = false;

  UserBloc userBloc;
  final _reportFormKey = GlobalKey<FormState>();
  String _reportedUsername = '';
  String _reportedUReason = '';

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    ScreenUtil.init(context);
    return getUserfromDB(userBloc.user.uid);
  }

  Widget getUserfromDB(uid) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          UserBloc userBloc = BlocProvider.of(context);
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            DocumentSnapshot element = snapshot.data.documents[0];
            if (element.get("uid") == uid) {
              userBloc.user = UserModel(
                  email: element.get("email"),
                  uid: element.get("uid"),
                  userName: element.get("username"),
                  points: element.get("points"),
                  bankAccount: element.get("bank_account"),
                  type: element.get("type"),
                  avatarURL: (widget.imgChanged)
                      ? widget.imagePath
                      : element.get("avatar_url"));

              if (userBloc.user.type == "owner") {
                userBloc.user.restaurantName = element.get("restaurant_name");
                userBloc.user.location = element.get("location");
                userBloc.user.cif = element.get("cif");
              }

              if (!widget.isTappedYes && !widget.isTappedNo) {
                (userBloc.user.type == "default")
                    ? {widget.showhidden = false, widget.isTappedNo = true}
                    : {widget.showhidden = true, widget.isTappedYes = true};
              }

              Stream.empty();
              return profileScreen(userBloc.user);
            }
          }
        });
  }

  Widget profileScreen(UserModel user) {
    final usuarioController = TextEditingController();
    final nombreController = TextEditingController();
    final emailController = TextEditingController();
    final bankaccountController = TextEditingController();
    final nombreRestauranteController = TextEditingController();
    final ubicacionRestauranteController = TextEditingController();
    final cifController = TextEditingController();

    usuarioController.text = user.userName;
    nombreController.text = user.userName;
    emailController.text = user.email;
    bankaccountController.text = user.bankAccount;
    nombreRestauranteController.text = user.restaurantName;
    ubicacionRestauranteController.text = user.location;
    cifController.text = user.cif;

    final googleMapsApi = GoogleMapsApi();

    (user.avatarURL != "")
        ? widget.imageProfile = NetworkImage(user.avatarURL)
        : widget.imageProfile = widget.imageProfile;

    userBloc.reautenticate();

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      children: <Widget>[
        SizedBox(height: ScreenUtil().setHeight(100)),
        Text(
          user.userName,
          style: Mystyle.titleTextStyle.copyWith(
            fontSize: ScreenUtil().setSp(100),
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ScreenUtil().setHeight(40)),
        Column(
          children: [
            GestureDetector(
              onTap: () => popAvatar(),
              child: Container(
                width: ScreenUtil().setHeight(250),
                height: ScreenUtil().setHeight(250),
                decoration: BoxDecoration(
                  color: Mystyle.primarycolo,
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    image: widget.imageProfile,
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            Text(
              user.points.toString() + " puntos",
              style: Mystyle.smallTextStyle.copyWith(
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(60)),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 2, vertical: ScreenUtil().setHeight(20)),
          child: TextFormField(
            style: TextStyle(color: Colors.black),
            controller: nombreController,
            keyboardType: TextInputType.emailAddress,
            decoration: Mystyle.inputDisabledWhitebg('Usuario'),
            textInputAction: TextInputAction.done,
            enabled: true,
            validator: (value) {
              if (value.isEmpty) return 'isEmpty';
              return null;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 2, vertical: ScreenUtil().setHeight(20)),
          child: TextFormField(
            style: TextStyle(color: Colors.black),
            controller: nombreController,
            keyboardType: TextInputType.emailAddress,
            decoration: Mystyle.inputDisabledWhitebg('Nombre'),
            textInputAction: TextInputAction.done,
            enabled: true,
            validator: (value) {
              if (value.isEmpty) return 'isEmpty';
              return null;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 2, vertical: ScreenUtil().setHeight(20)),
          child: TextFormField(
            style: TextStyle(color: Colors.grey),
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: Mystyle.inputDisabledWhitebg('Email'),
            textInputAction: TextInputAction.done,
            enabled: false,
            validator: (value) {
              if (value.isEmpty) return 'isEmpty';
              return null;
            },
          ),
        ),
        /*
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 2, vertical: ScreenUtil().setHeight(20)),
          child: TextFormField(
            controller: passwordController,
            keyboardType: TextInputType.emailAddress,
            decoration: Mystyle.inputWhitebg('Password'),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value.isEmpty) return 'isEmpty';
              return null;
            },
          ),
        ),
        */
        Padding(
          padding: EdgeInsets.only(left: 8, right: 36, top: 12, bottom: 12),
          child: Text(
            "Pedimos estos datos por si, en un futuro se cobra recompensa, contactar contigo.",
            style: Mystyle.normalTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 2, vertical: ScreenUtil().setHeight(20)),
          child: TextFormField(
            controller: bankaccountController,
            keyboardType: TextInputType.emailAddress,
            decoration: Mystyle.inputWhitebg('Cuenta Bancaria'),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value.isEmpty) return 'isEmpty';
              return null;
            },
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(60)),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile_screen_owner,
                style: Mystyle.smallTextStyle.copyWith(
                  color: Colors.black87,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: ScreenUtil().setHeight(60)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            user.type = "owner";
                            widget.showhidden = true;
                            widget.isTappedYes = true;
                            widget.isTappedNo = false;
                          });
                        },
                        child: Container(
                          height: ScreenUtil().setWidth(90),
                          width: ScreenUtil().setWidth(180),
                          decoration: widget.isTappedYes
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  color: Colors.black)
                              : BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  color: Colors.white),
                          alignment: Alignment.center,
                          child: Text(
                            "Si",
                            style: widget.isTappedYes
                                ? Mystyle.normalTextStyle
                                    .copyWith(color: Colors.white)
                                : Mystyle.normalTextStyle,
                          ),
                        ),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(30)),
                      InkWell(
                        onTap: () {
                          setState(() {
                            user.type = "default";

                            widget.showhidden = false;
                            widget.isTappedYes = false;
                            widget.isTappedNo = true;
                          });
                        },
                        child: Container(
                          height: ScreenUtil().setWidth(90),
                          width: ScreenUtil().setWidth(180),
                          decoration: widget.isTappedNo
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  color: Colors.black)
                              : BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  color: Colors.white),
                          alignment: Alignment.center,
                          child: Text(
                            "No",
                            style: widget.isTappedNo
                                ? Mystyle.normalTextStyle
                                    .copyWith(color: Colors.white)
                                : Mystyle.normalTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //
                  IconButton(
                    icon: Icon(
                      widget.showhidden
                          ? Icons.keyboard_arrow_down
                          : Icons.chevron_right,
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.showhidden = !widget.showhidden;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              widget.showhidden
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: ScreenUtil().setHeight(20)),
                          child: TextFormField(
                            controller: nombreRestauranteController,
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                Mystyle.inputWhitebg('Nombre del local'),
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value.isEmpty) return 'isEmpty';
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: ScreenUtil().setHeight(20)),
                          child: TextFormField(
                            controller: ubicacionRestauranteController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (text) async {
                              //you can discover other features like components
                              Prediction p = await PlacesAutocomplete.show(
                                context: context,
                                apiKey: googleMapsApi.apiKey,
                                //you can choose full scren or overlay
                                mode: Mode.overlay,
                                //you can set spain language
                                language: 'es',
                                //you can set here what user wrote in textfield
                                startText: ubicacionRestauranteController.text,
                                onError: (onError) {
                                  //the error will be showen is enable billing
                                  print(onError.errorMessage);
                                },
                              );
                              googleMapsApi.displayPrediction(p).then((value) =>
                                  ubicacionRestauranteController.text = value);
                            },
                            decoration: Mystyle.inputWhitebg(
                              'Dirección',
                              icon: IconButton(
                                icon: Container(
                                  height: ScreenUtil().setWidth(50),
                                  width: ScreenUtil().setWidth(50),
                                  child: SvgPicture.asset(
                                    "assets/svg/send.svg",
                                    color: Colors.black54,
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value.isEmpty) return 'isEmpty';
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: ScreenUtil().setHeight(20)),
                          child: TextFormField(
                            controller: cifController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: Mystyle.inputWhitebg('CIF propiedad'),
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value.isEmpty) return 'isEmpty';
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(50)),
        ButtAuth(profile_edit_button, () {
          var avatarUrl = widget.imagesUrls[widget.imageIndex];
          userBloc.updateUserProfile(UserModel(
              uid: user.uid,
              userName: nombreController.text,
              email: emailController.text,
              bankAccount: bankaccountController.text,
              avatarURL: avatarUrl,
              type: widget.showhidden ? "owner" : "default",
              cif: cifController.text,
              location: ubicacionRestauranteController.text,
              restaurantName: nombreRestauranteController.text));
          // getUserComments(user.uid);
        }, border: true),
        SizedBox(height: ScreenUtil().setHeight(50)),
        ButtAuth("Cerrar Sesión", () async {
          userBloc.signOut();

          sleep(const Duration(seconds: 2));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return LoginScreen(); //register
              },
            ),
          );

          userBloc.user = null;
        }, border: true),
        SizedBox(height: ScreenUtil().setHeight(50)),
        Divider(color: Colors.black),
        SizedBox(height: ScreenUtil().setHeight(50)),
        RichText(
            text: TextSpan(
                text: profile_screen_report,
                style: Mystyle.smallTextStyle.copyWith(color: Colors.black87),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _reportUserModal();
                  })),
        SizedBox(height: ScreenUtil().setHeight(30)),
        RichText(
            text: TextSpan(
                text: profile_screen_help,
                style: Mystyle.smallTextStyle.copyWith(color: Colors.black87),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _launchURLHelp();
                  })),
        SizedBox(height: ScreenUtil().setHeight(30)),
        RichText(
            text: TextSpan(
                text: profile_screen_privacy,
                style: Mystyle.smallTextStyle.copyWith(color: Colors.black87),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _launchURLTerms();
                  })),
        SizedBox(height: ScreenUtil().setHeight(100)),
      ],
    );
  }

  popAvatar() {
    const images = [
      'assets/avatars/default.png',
      'assets/avatars/avatar1.png',
      'assets/avatars/avatar2.png',
      'assets/avatars/avatar3.png',
      'assets/avatars/avatar4.png',
      'assets/avatars/avatar5.png',
      'assets/avatars/avatar6.png',
    ];

    return showDialog(
        context: context,
        builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: ScreenUtil().setHeight(800),
              height: ScreenUtil().setHeight(1000),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(7, (index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            userBloc.user.avatarURL = images[index];
                            widget.imageProfile =
                                ExactAssetImage(images[index]);

                            widget.imageIndex = index;
                            widget.imgChanged = true;
                            widget.imagePath = widget.imagesUrls[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Center(child: Image.asset(images[index])));
                  })),
            )));
  }

  _launchURLHelp() async {
    const url = 'https://elbrownie.com/index.php#funciona';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURLTerms() async {
    const url = 'https://elbrownie.com/terms.php';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _reportUserModal() {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
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
                              alignment: Alignment.bottomRight,
                              width: ScreenUtil().setHeight(100),
                              height: ScreenUtil().setHeight(100),
                              child: SvgPicture.asset("")))),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: ScreenUtil().setHeight(60)),
                      Text(
                        report_user_title,
                        style: Mystyle.titleTextStyle
                            .copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          report_user_body,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40)),
                      Form(
                        key: _reportFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              decoration:
                                  Mystyle.inputWhitebg('Usuario a reportar'),
                              validator: (String value) {
                                if (value == '') {
                                  return 'Introduzca el usuario a reportar';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (String val) {
                                _reportedUsername = val;
                              },
                            ),
                            SizedBox(height: ScreenUtil().setHeight(40)),
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              decoration: Mystyle.inputWhitebg('Razón'),
                              validator: (value) {
                                if (value == '') {
                                  return 'Introduzca una razón válida';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (String val) {
                                _reportedUReason = val;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40)),
                      ButtAuth("Reportar", () async {
                        if (_reportFormKey.currentState.validate()) {
                          _reportFormKey.currentState.save();
                          await userBloc.reportUser({
                            'reported': 'user',
                            'username': _reportedUsername,
                            'reports': [
                              {
                                'id_user': userBloc.currentUser.uid,
                                'reason': _reportedUReason,
                              }
                            ],
                          });
                          Navigator.pop(context);
                        }
                      }, border: true),
                      SizedBox(height: ScreenUtil().setHeight(60)),
                    ],
                  ),
                ])
              ]),
            )));
  }
}
