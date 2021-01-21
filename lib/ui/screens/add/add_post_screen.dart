import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/repository/google_maps_api.dart';
import 'package:el_brownie_app/ui/screens/home/bottom_tab.dart';
import 'package:el_brownie_app/ui/screens/notifications/notifications_screen.dart';
import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';

class AddCommentScreen extends StatefulWidget {
  int valoration = 0;
  String idPost;
  bool tapped = false;
  bool isFirstTimeAdded;
  @override
  _AddCommentScreen createState() => _AddCommentScreen();
}

class _AddCommentScreen extends State<AddCommentScreen> {
  final _formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _value = 5;
  final nombre = TextEditingController();
  final direccion = TextEditingController();
  final comentario = TextEditingController();
  bool filled = false;
  String _uploadedFileURL;
  var _name;
  var _address;
  var _comment;
  String _retrieveDataError;

  bool _validate = false;
  final _picker = ImagePicker();

  UserBloc userBloc;
  var imageFile;

  bool loading = false;
  final googleMapsApi = GoogleMapsApi();

  var _dropdownvalue;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    userBloc = BlocProvider.of(context);

    retrieveLostData();
    return getUserfromDB(userBloc.user.uid);
  }

  Widget getUserfromDB(uid) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          UserBloc userBloc = BlocProvider.of(context);
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            DocumentSnapshot element = snapshot.data.documents[0];
            userBloc.user = UserModel(
                email: element.get("email"),
                uid: element.get("uid"),
                userName: element.get("username"),
                avatarURL: element.get("avatar_url"),
                points: element.get("points"),
                hasNotifications: element.get("hasNotifications"),
                hasRequestedNotification:
                    element.get("hasRequestedNotification"));
            Stream.empty();
          }
          return addPostScreen(context);
        });
  }

  Widget addPostScreen(context) {
    _showAlertDialog(errorMsg) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text(
                  'Complete el formulario',
                  style: TextStyle(color: Colors.black),
                ),
                content: Text(errorMsg));
          });
    }

    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: loading,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Mystyle.primarycolo,
            elevation: 0,
            title: Container(
              width: ScreenUtil().setHeight(500),
              child: Image.asset("assets/appblogo.png"),
            ),
            centerTitle: true,
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
                    icon: (userBloc.user.hasNotifications == null)
                        ? Icon(
                            Icons.notifications_none,
                            color: Colors.black,
                            size: 28,
                          )
                        : (userBloc.user.hasNotifications)
                            ? SvgPicture.asset(
                                "assets/svg/notification.svg",
                                height: 28,
                                width: 28,
                              )
                            : Icon(
                                Icons.notifications_none,
                                color: Colors.black,
                                size: 28,
                              )),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              children: [
                SizedBox(height: ScreenUtil().setHeight(60)),
                Text(
                  add_post_title,
                  style: Mystyle.titleTextStyle.copyWith(
                    fontSize: ScreenUtil().setSp(90),
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Text(
                  add_post_text,
                  style: Mystyle.regularTextStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ScreenUtil().setHeight(40)),
                GestureDetector(
                    onTap: () {
                      _showSelectionDialog(context);
                    },
                    child: imageFile == null
                        ? Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black54, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: double.infinity,
                            height: ScreenUtil().setHeight(350),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _showSelectionDialog(context);
                                  },
                                  child: Container(
                                    height: ScreenUtil().setWidth(160),
                                    width: ScreenUtil().setWidth(160),
                                    child: SvgPicture.asset(
                                      "assets/svg/camera.svg",
                                      // color: Colors.red,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Sube una foto",
                                  style: Mystyle.smallTextStyle.copyWith(
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: 80,
                            height: 250,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black54, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.file(imageFile, fit: BoxFit.cover),
                          )),
                SizedBox(height: ScreenUtil().setHeight(40)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "¿Cuán mierdolo consideras que está el baño?",
                    style: Mystyle.regularTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.valoration = index;
                          filled = true;
                          widget.tapped = true;
                        });
                      },
                      child: Container(
                          height: ScreenUtil().setWidth(140),
                          width: ScreenUtil().setWidth(140),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          alignment: Alignment.center,
                          child: (index <= widget.valoration && widget.tapped)
                              ? Image.asset("assets/ifull.png")
                              : Image.asset("assets/iempty.png")),
                    );
                  }),
                ),
                SizedBox(height: ScreenUtil().setHeight(60)),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0, vertical: ScreenUtil().setHeight(20)),
                  child: TextFormField(
                    controller: nombre,
                    keyboardType: TextInputType.emailAddress,
                    decoration: Mystyle.inputWhitebg('Nombre del restaurante'),
                    textInputAction: TextInputAction.done,
                    validator: validateNotEmpty,
                    onSaved: (String val) {
                      _name = val;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0, vertical: ScreenUtil().setHeight(20)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField(
                      decoration: Mystyle.inputWhitebg(add_post_category_hint),
                      value: _dropdownvalue,
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            category_list[0],
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8b8b8b),
                            ),
                          ),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            category_list[1],
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8b8b8b),
                            ),
                          ),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            category_list[2],
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8b8b8b),
                            ),
                          ),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            category_list[3],
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8b8b8b),
                            ),
                          ),
                          value: 3,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            category_list[4],
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8b8b8b),
                            ),
                          ),
                          value: 4,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            category_list[5],
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8b8b8b),
                            ),
                          ),
                          value: 5,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            category_list[6],
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8b8b8b),
                            ),
                          ),
                          value: 6,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            category_list[7],
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8b8b8b),
                            ),
                          ),
                          value: 7,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            category_list[8],
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8b8b8b),
                            ),
                          ),
                          value: 8,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _dropdownvalue = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Seleccione una categoría' : null,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0, vertical: ScreenUtil().setHeight(20)),
                  child: TextFormField(
                    controller: direccion,
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
                        startText: direccion.text,
                        onError: (onError) {
                          //the error will be showen is enable billing
                          print(onError.errorMessage);
                        },
                      );
                      googleMapsApi
                          .displayPrediction(p)
                          .then((value) => direccion.text = value);
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
                    validator: validateNotEmpty,
                    onSaved: (String val) {
                      _address = val;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0, vertical: ScreenUtil().setHeight(20)),
                  child: TextFormField(
                    controller: comentario,
                    maxLines: 8,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        Mystyle.inputregularmaxline(addvaloration_form_comment),
                    textInputAction: TextInputAction.done,
                    validator: validateNotEmpty,
                    onSaved: (String val) {
                      _comment = val;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 24, vertical: ScreenUtil().setHeight(20)),
                  child: Text(
                    add_post_pretext,
                    style: Mystyle.regularTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    _value.toStringAsFixed(2) + " €",
                    style: Mystyle.titleregularTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "1 €",
                      style: Mystyle.subtitleTextStyle
                          .copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 16.0,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        ),
                        child: Slider(
                          min: 1,
                          max: 7,
                          activeColor: Mystyle.secondrycolo,
                          inactiveColor: Colors.grey[300],
                          value: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Text(
                      "7 €",
                      style: Mystyle.subtitleTextStyle
                          .copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(60)),
                DottedBorder(
                  color: Mystyle.secondrycolo,
                  dashPattern: [10, 11],
                  strokeWidth: 4,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    child: Text(
                      add_post_description,
                      style: Mystyle.regularTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(60)),
                ButtAuth(
                  "Publicar el desastre",
                  () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      if (imageFile == null) {
                        print("Show alert : picture required");
                        _showAlertDialog("Por favor, añade una foto!");
                      } else if (!widget.tapped) {
                        print("Show alert: Tap valorate");
                        _showAlertDialog("Por favor, valore su foto!");
                      } else if (_dropdownvalue == null) {
                        _showAlertDialog(
                            "Seleccione una categoría de restaurante");
                      } else {
                        setState(() {
                          loading = true;
                        });
                        widget.idPost = nombre.text.hashCode.toString();
                        File compressedFile = new File(imageFile.path
                                .substring(0, imageFile.path.length - 4) +
                            "-.jpg");

                        testCompressAndGetFile(imageFile, compressedFile.path)
                            .then((value) {
                          compressedFile = value;

                          var name = '${DateTime.now()}' +
                              basenameWithoutExtension(
                                  compressedFile.toString());
                          StorageReference storageReference = FirebaseStorage
                              .instance
                              .ref()
                              .child('posts/$name');
                          StorageUploadTask uploadTask =
                              storageReference.putFile(compressedFile);
                          userBloc.addNotification(
                              userBloc.user.uid, "added", 5);
                          userBloc.addPoints(userBloc.user.uid, 5);
                          Stream stream =
                              userBloc.myBrowniesListStream(userBloc.user.uid);
                          stream.length == 0
                              ? widget.isFirstTimeAdded = false
                              : widget.isFirstTimeAdded = true;
                          uploadTask.onComplete.then((snapshot) {
                            snapshot.ref.getDownloadURL().then((url) {
                              userBloc
                                  .createPost(
                                      nombre.text.hashCode.toString(),
                                      direccion.text,
                                      category_list[_dropdownvalue],
                                      nombre.text,
                                      comentario.text,
                                      _value + 2,
                                      false,
                                      url.toString(),
                                      widget.valoration + 1)
                                  .whenComplete(() {
                                setState(() {
                                  nombre.clear();
                                  _dropdownvalue = null;
                                  direccion.clear();
                                  comentario.clear();
                                  widget.tapped = false;
                                  imageFile = null;
                                  loading = false;
                                  widget.valoration = 0;
                                });
                              });
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomTabBarr(
                                        isFirstTimeAdded:
                                            widget.isFirstTimeAdded,
                                      )),
                            );
                          }).catchError((onError) {
                            setState(() {
                              loading = false;
                            });
                            print(onError.message.toString());
                          });
                        });
                      }
                    } else {
                      //validation error
                      _validate = true;
                    }
                  },
                  border: true,
                ),
                SizedBox(height: ScreenUtil().setHeight(100)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.video) {
          //_handleVideo(response.file);
        } else {
          final File file = File(response.file.path);
          imageFile = file;
        }
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  void _openGallery(BuildContext context) async {
    PickedFile picture = await _picker.getImage(source: ImageSource.gallery);
    final File file = File(picture.path);
    this.setState(() {
      imageFile = file;
    });
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    PickedFile picture = await _picker.getImage(source: ImageSource.camera);
    final File file = File(picture.path);
    this.setState(() {
      imageFile = file;
    });
    Navigator.of(context).pop();
  }

  Widget _setImageView() {
    if (imageFile != null) {
      return Image.file(imageFile, width: 500, height: 500);
    } else {
      return Text("Please select an image");
    }
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Elija una opción..."),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Galería"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camara"),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 40,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }
}

String validateNotEmpty(String value) {
  if (value.isEmpty) {
    return 'Los campos no pueden estar vacios';
  } else {
    return null;
  }
}
