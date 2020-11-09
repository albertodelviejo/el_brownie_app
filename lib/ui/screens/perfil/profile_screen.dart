import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class ProfileScreen extends StatefulWidget {
  bool showhidden = false;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool noresult = false;

  UserBloc userBloc;

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
            userBloc.user = UserModel(
                email: element.get("email"),
                uid: element.get("uid"),
                userName: element.get("username"),
                points: element.get("points"),
                bankAccount: element.get("bank_account"),
                type: element.get("type"));

            if (userBloc.user.type == "owner") {
              userBloc.user.restaurantName = element.get("restaurant_name");
              userBloc.user.location = element.get("location");
              userBloc.user.cif = element.get("cif");
            }

            Stream.empty();
            return profileScreen(userBloc.user);
          }
        });
  }

  Widget profileScreen(UserModel user) {
    final usuarioController = TextEditingController();
    final nombreController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
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

    (user.type == "default")
        ? widget.showhidden = false
        : widget.showhidden = true;

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
            Container(
              width: ScreenUtil().setHeight(250),
              height: ScreenUtil().setHeight(250),
              decoration: BoxDecoration(
                color: Mystyle.primarycolo,
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: NetworkImage(
                      "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            Text(
              user.points.toString(),
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
            controller: usuarioController,
            keyboardType: TextInputType.emailAddress,
            decoration: Mystyle.inputWhitebg('Usuario'),
            textInputAction: TextInputAction.done,
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
            controller: nombreController,
            keyboardType: TextInputType.emailAddress,
            decoration: Mystyle.inputWhitebg('Nombre'),
            textInputAction: TextInputAction.done,
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
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: Mystyle.inputWhitebg('Email'),
            textInputAction: TextInputAction.done,
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
            "Esto lo pedimos para que puedas cobrar tu recompensa!",
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
                "Eres propietario de un restaurante?",
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
                          });
                        },
                        child: Container(
                          height: ScreenUtil().setWidth(90),
                          width: ScreenUtil().setWidth(180),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Si",
                            style: Mystyle.normalTextStyle,
                          ),
                        ),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(30)),
                      InkWell(
                        onTap: () {
                          setState(() {
                            user.type = "default";
                            widget.showhidden = false;
                          });
                        },
                        child: Container(
                          height: ScreenUtil().setWidth(90),
                          width: ScreenUtil().setWidth(180),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "No",
                            style: Mystyle.normalTextStyle,
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
                                Mystyle.inputWhitebg('Nombre del restaurante'),
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
                            decoration: Mystyle.inputWhitebg(
                              'Ubicación',
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
                            decoration: Mystyle.inputWhitebg('CIF'),
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
        ButtAuth("Editar perfil", () {
          userBloc.updateUserData(UserModel(
            uid: user.uid,
            userName: nombreController.text,
            email: emailController.text,
            bankAccount: bankaccountController.text,
          ));
        }, border: true),
        SizedBox(height: ScreenUtil().setHeight(50)),
        ButtAuth("Cerrar Sesión", () {
          userBloc.signOut();
        }, border: true),
        SizedBox(height: ScreenUtil().setHeight(50)),
        Divider(color: Colors.black),
        SizedBox(height: ScreenUtil().setHeight(50)),
        Text(
          "Ayuda?",
          style: Mystyle.smallTextStyle.copyWith(color: Colors.black87),
          textAlign: TextAlign.left,
        ),
        Text(
          "Politica de privacidad",
          style: Mystyle.smallTextStyle.copyWith(color: Colors.black87),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: ScreenUtil().setHeight(100)),
      ],
    );
  }
}
