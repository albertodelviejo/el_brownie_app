import 'dart:io';

import 'package:el_brownie_app/ui/utils/size_config.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

class ImageFrame extends StatefulWidget {
  int i;
  ImageFrame({this.i});
  @override
  _ImageFrameState createState() => _ImageFrameState();
}

class _ImageFrameState extends State<ImageFrame> {
  File _image;
  // final picker = ImagePicker();

  Future getImage() async {
    // final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      // if (pickedFile != null) {
      //   _image = File(pickedFile.path);
      // } else {
      //   print('No image selected.');
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return InkWell(
      onTap: getImage,
      child: Container(
        width: SizeConfig.screenWidth / 4,
        height: SizeConfig.screenWidth / 4,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: _image == null
            ? Center(
                child: Icon(Icons.photo_camera),
              )
            : Image.file(
                _image,
                fit: BoxFit.fill,
              ),
      ),
    );
  }
}
