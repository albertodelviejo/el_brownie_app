import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  int valoration = 0;
  String idPost;
  String idUserPost;
  bool tapped = false;

  AddPostScreen({Key key, this.idPost, this.idUserPost});
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _value = 12;
  int rating = 0;
  bool filled = false;
  final comentarioController = TextEditingController();
  UserBloc userBloc;
  var imageFile;
  String photoUrl = "";

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    userBloc = BlocProvider.of(context);

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          //automaticallyImplyLeading: false,
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
              child: Icon(
                Icons.notifications_none,
                color: Colors.black,
                size: 28,
              ),
            ),
          ],
        ),
        body: ListView(
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
              style: Mystyle.titleTextStyle.copyWith(
                fontSize: ScreenUtil().setSp(60),
                color: Colors.black54,
              ),
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
              controller: comentarioController,
              maxLines: 4,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  Mystyle.inputregularmaxline('Escribe tu comentario aqui…'),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value.isEmpty) return 'isEmpty';
                return null;
              },
            ),
            SizedBox(height: ScreenUtil().setHeight(40)),
            GestureDetector(
                onTap: () => _showSelectionDialog,
                child: imageFile == null
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        height: ScreenUtil().setHeight(600),
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
                          border: Border.all(color: Colors.black54, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.file(imageFile, fit: BoxFit.cover),
                      )),
            SizedBox(height: ScreenUtil().setHeight(60)),
            ButtAuth("Publicar", () {
              userBloc
                  .addComment(widget.idPost, photoUrl,
                      comentarioController.text, widget.valoration.toString())
                  .whenComplete(() {
                uploadFile();
                userBloc.addNotification(widget.idUserPost, "comment", 10);
                Navigator.pop(context);
              });
            }, border: true, press: true),
            SizedBox(height: ScreenUtil().setHeight(100)),
          ],
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
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
}
