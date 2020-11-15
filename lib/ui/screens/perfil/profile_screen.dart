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
  dynamic imageProfile = ExactAssetImage('assets/avatars/avatar1.png');
  int imageIndex = 1;
  var imagesUrls = [
    'https://firebasestorage.googleapis.com/v0/b/elbrownie-baf68.appspot.com/o/avatars%2Favatar1.png?alt=media&token=805ef59a-a620-41d2-9257-7e47c56a3e94',
    'https://firebasestorage.googleapis.com/v0/b/elbrownie-baf68.appspot.com/o/avatars%2Favatar2.png?alt=media&token=40f7abdb-1e3c-4ec0-8f29-9c1edf06fcd3',
    'https://firebasestorage.googleapis.com/v0/b/elbrownie-baf68.appspot.com/o/avatars%2Favatar3.png?alt=media&token=46e4fe12-2882-47bf-a33b-fa69241593e0',
    'https://firebasestorage.googleapis.com/v0/b/elbrownie-baf68.appspot.com/o/avatars%2Favatar4.png?alt=media&token=3275e9e8-d4c7-4372-b87a-4336acb6153c',
    'https://firebasestorage.googleapis.com/v0/b/elbrownie-baf68.appspot.com/o/avatars%2Favatar5.png?alt=media&token=e949f8fc-67c9-4e74-be27-a6d0e4dac8f7',
    'https://firebasestorage.googleapis.com/v0/b/elbrownie-baf68.appspot.com/o/avatars%2Favatar6.png?alt=media&token=14e2a2ff-ef66-4a2e-a677-4ea0473fe37b'
  ];

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
                type: element.get("type"),
                avatarURL: element.get("avatar_url"));
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

    (user.avatarURL != "")
        ? widget.imageProfile = NetworkImage(user.avatarURL)
        : widget.imageProfile = widget.imageProfile;

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
          var avatarUrl = widget.imagesUrls[widget.imageIndex];
          userBloc.updateUserProfile(UserModel(
              uid: user.uid,
              userName: nombreController.text,
              email: emailController.text,
              bankAccount: bankaccountController.text,
              avatarURL: avatarUrl));
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

  popAvatar() {
    const images = [
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
                  children: List.generate(6, (index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            userBloc.user.avatarURL = images[index];
                            widget.imageProfile =
                                ExactAssetImage(images[index]);

                            widget.imageIndex = index;
                          });
                          Navigator.pop(context);
                        },
                        child: Center(child: Image.asset(images[index])));
                  })),
            )));
  }
}
