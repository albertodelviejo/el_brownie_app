import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  Color backgroundColor = Color(0xFF00bcd5);
  Color textColor = Color(0xFFFFFFFF);

  RoundedButton(
      {Key key,
      @required this.buttonText,
      @required this.onPressed,
      this.backgroundColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    double screenWidht = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        height: 45.0,
        width: screenWidht - 30.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            gradient: LinearGradient(
              colors: [backgroundColor, backgroundColor],
              begin: FractionalOffset(0.2, 0.0),
              end: FractionalOffset(1.0, 0.6),
            )),
        //stops: [0.0, 0.6],
        //tileMode: TileMode.clamp)),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 18.0, color: textColor),
          ),
        ),
      ),
    );
  }
}
