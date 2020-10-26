import 'package:dotted_border/dotted_border.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/ui/screens/photo_preview_screen.dart';
import 'package:el_brownie_app/ui/utils/buttonauth.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';

class AddScreen extends StatefulWidget {
  int valoration = 0;
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _value = 12;
  final nombre = TextEditingController();
  final categoria = TextEditingController();
  final direccion = TextEditingController();
  final comentario = TextEditingController();
  bool filled = false;
  String _uploadedFileURL;

  UserBloc userBloc;
  var imageFile;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    userBloc = BlocProvider.of(context);
    return SafeArea(
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
            SizedBox(height: ScreenUtil().setHeight(60)),
            Text(
              "Sube tu foto!",
              style: Mystyle.titleTextStyle.copyWith(
                fontSize: ScreenUtil().setSp(100),
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            Text(
              "Muéstranos lo que ves…",
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
                          border: Border.all(color: Colors.black54, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        height: ScreenUtil().setHeight(350),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {},
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
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.file(imageFile),
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      child: (index <= widget.valoration)
                          ? Image.asset("assets/ifull.png")
                          : Image.asset("assets/iempty.png")),
                );
              }),
            ),
            SizedBox(height: ScreenUtil().setHeight(60)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 24, vertical: ScreenUtil().setHeight(20)),
              child: TextFormField(
                controller: nombre,
                keyboardType: TextInputType.emailAddress,
                decoration: Mystyle.inputWhitebg('Nombre del restaurante'),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty) return 'isEmpty';
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 24, vertical: ScreenUtil().setHeight(20)),
              child: TextFormField(
                controller: categoria,
                keyboardType: TextInputType.emailAddress,
                decoration: Mystyle.inputWhitebg(
                  'Categoría',
                  icon: IconButton(
                    icon: Icon(Icons.chevron_right),
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
                  horizontal: 24, vertical: ScreenUtil().setHeight(20)),
              child: TextFormField(
                controller: direccion,
                keyboardType: TextInputType.emailAddress,
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
                  horizontal: 24, vertical: ScreenUtil().setHeight(20)),
              child: TextFormField(
                controller: comentario,
                maxLines: 8,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    Mystyle.inputregularmaxline('Escribe tu comentario aqui…'),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty) return 'isEmpty';
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 24, vertical: ScreenUtil().setHeight(20)),
              child: Text(
                "Precio a cobrar, te recomendamos la mejor opción.",
                style: Mystyle.regularTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                "7 €",
                style: Mystyle.titleregularTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "5 €",
                  style:
                      Mystyle.subtitleTextStyle.copyWith(color: Colors.black),
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
                      min: 5,
                      max: 25,
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
                  "25 €",
                  style:
                      Mystyle.subtitleTextStyle.copyWith(color: Colors.black),
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
                  "*Recuerda incluir tu tarjeta bancaria en tu perfil si quieres recibir tu dinerito!",
                  style: Mystyle.regularTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(60)),
            ButtAuth.buttonauth("Publicar", false, () {
              uploadFile().then((value) => userBloc.createPost(
                  direccion.text,
                  categoria.text,
                  nombre.text,
                  _value,
                  false,
                  widget.valoration,
                  _uploadedFileURL));
            }, border: true),
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
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
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
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('${nombre}/${imageFile.path}}');
    StorageUploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }
}
