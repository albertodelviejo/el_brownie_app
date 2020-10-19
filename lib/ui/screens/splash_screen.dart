import 'dart:io';

import 'package:el_brownie_app/ui/screens/onboarding_screen.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/size_config.dart';
import 'package:flutter/material.dart';

class SplashScreena extends StatefulWidget {
  @override
  _SplashScreenaState createState() => _SplashScreenaState();
}

class _SplashScreenaState extends State<SplashScreena> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(
      seconds: 4,
    )).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoarding()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Mystyle.primarycolo,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Container(
                alignment: Alignment.center,
                width: SizeConfig.screenWidth * 0.5,
                height: SizeConfig.screenWidth * 0.5,
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/Logo.png"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
