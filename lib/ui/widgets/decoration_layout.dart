<<<<<<< HEAD
import 'package:flutter/material.dart';

class DecorationLayout extends StatelessWidget {
  final height;

  DecorationLayout({Key key, this.height});

  @override
  Widget build(BuildContext context) {
    double screenWidht = MediaQuery.of(context).size.width;
    return Container(
        height: height,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
        ));
  }
}
=======
import 'package:flutter/material.dart';

class DecorationLayout extends StatelessWidget {
  final height;

  DecorationLayout({Key key, this.height});

  @override
  Widget build(BuildContext context) {
    double screenWidht = MediaQuery.of(context).size.width;
    return Container(
        height: height,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
        ));
  }
}
>>>>>>> reportFunctions
