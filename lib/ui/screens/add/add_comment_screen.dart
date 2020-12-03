import 'dart:io';

import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/ui/screens/notifications/notifications_screen.dart';
import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddPostScreen extends StatefulWidget {
  int valoration = 0;
  String idPost;
  String idUserPost;
  bool tapped = false;
  String idComment;

  AddPostScreen({Key key, this.idPost, this.idUserPost});
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  double _value = 12;
  int rating = 0;
  bool filled = false;
  final comentarioController = TextEditingController();
  final _picker = ImagePicker();
  UserBloc userBloc;
  var imageFile;
  String photoUrl = "";
  String _comment;
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    userBloc = BlocProvider.of(context);

    return SafeArea(
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
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            children: [
              SizedBox(height: ScreenUtil().setHeight(30)),
              InkWell(
                onTap: () {},
                child: Container(
                  alignment: Alignment.bottomRight,
                  height: ScreenUtil().setWidth(100),
                  width: ScreenUtil().setWidth(100),
                  child: SvgPicture.asset(
                    "assets/svg/close.svg",
                  ),
                ),
              ),
              Text(
                "Añade tu valoración",
                style: Mystyle.titleTextStyle.copyWith(
                  fontSize: ScreenUtil().setSp(100),
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Text(
                "Te has ganado tu minuto de gloria, te gusta el show y el aplauso.\n Añade tu comentario",
                style: Mystyle.regularTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ScreenUtil().setHeight(40)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return InkWell(
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
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      child: (index <= widget.valoration && widget.tapped)
                          ? Image.asset("assets/ifull.png")
                          : Image.asset("assets/iempty.png"),
                    ),
                  );
                }),
              ),
              SizedBox(height: ScreenUtil().setHeight(60)),
              TextFormField(
                maxLines: 4,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    Mystyle.inputregularmaxline('Escribe tu comentario aqui…'),
                textInputAction: TextInputAction.done,
                validator: validateNotEmpty,
                onSaved: (String val) {
                  _comment = val;
                },
              ),
              SizedBox(height: ScreenUtil().setHeight(40)),
              GestureDetector(
                  onTap: () => _showSelectionDialog,
                  child: imageFile == null
                      ? GestureDetector(
                          onTap: () => _showSelectionDialog(context),
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black54, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: double.infinity,
                            height: ScreenUtil().setHeight(600),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  child: Container(
                                    height: ScreenUtil().setWidth(160),
                                    width: ScreenUtil().setWidth(160),
                                    child: SvgPicture.asset(
                                      "assets/svg/camera.svg",
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
                          ),
                        )
                      : Container(
                          width: 80,
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.file(imageFile, fit: BoxFit.cover),
                        )),
              SizedBox(height: ScreenUtil().setHeight(60)),
              ButtAuth("Publicar", () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  widget.idComment =
                      comentarioController.text.hashCode.toStringAsFixed(15);

                  if (imageFile != null) {
                    File compressedFile = new File(
                        imageFile.path.substring(0, imageFile.path.length - 4) +
                            "-.jpg");

                    testCompressAndGetFile(imageFile, compressedFile.path)
                        .then((value) {
                      compressedFile = value;

                      var name = '${DateTime.now()}' +
                          basenameWithoutExtension(imageFile.toString());
                      StorageReference storageReference = FirebaseStorage
                          .instance
                          .ref()
                          .child('comments/$name');
                      StorageUploadTask uploadTask =
                          storageReference.putFile(imageFile);
                      uploadTask.onComplete.then((snapshot) {
                        snapshot.ref.getDownloadURL().then((url) {
                          userBloc
                              .addComment(widget.idPost, url, _comment,
                                  (widget.valoration + 1).toString())
                              .whenComplete(() {
                            comentarioController.clear();
                            imageFile = null;
                          });
                        });
                      });
                    });
                  } else {
                    userBloc.addComment(widget.idPost, "", _comment,
                        widget.valoration.toString());
                  }

                  userBloc.addNotification(widget.idUserPost, "comment", 10);
                  userBloc.addPoints(widget.idUserPost);
                  Navigator.pop(context);
                } else {
                  _validate = true;
                }
              }, border: true, press: true),
              SizedBox(height: ScreenUtil().setHeight(100)),
            ],
          ),
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) async {
    PickedFile picture = await _picker.getImage(source: ImageSource.gallery);
    final File file = File(picture.path);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    PickedFile picture = await _picker.getImage(source: ImageSource.camera);
    final File file = File(picture.path);
    this.setState(() {
      imageFile = picture;
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

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('comments/${widget.idPost}/${imageFile.hashCode}');
    StorageUploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      // userBloc.addPhotoToPost(widget.idPost, fileURL);
    });
  }

  String validateNotEmpty(String value) {
    if (value.isEmpty) {
      return 'Los campos no pueden estar vacios';
    } else {
      return null;
    }
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
