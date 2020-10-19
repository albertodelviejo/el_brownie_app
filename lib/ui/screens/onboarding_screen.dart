import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'login.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;
  List onBoardingData = [
    OnBoardingData(
      title: " ¡Quéjate!",
      desc:
          "El estado de los baños indica cómo está la cocina así que, valora los restaurantes por la MIERDA y no por lo que comes.",
      imageAssetsPath: "assets/splash1.png",
    ),
    OnBoardingData(
      title: "¡Saca foto y comparte!",
      desc:
          "No pierdas tiempo en aplicar filtros, la mierda es mierda y no hay que camuflarla. Además de pasártelo genial, con elBrownie ganarás pasta!",
      imageAssetsPath: "assets/splash2.png",
    ),
    OnBoardingData(
      title: "¡Ponle precio al desastre!",
      desc:
          "Deberán pagarte por dar de baja tu publicación; así que, incluso puedes ganar algo de dinerito. ¿Qué esperas?",
      imageAssetsPath: "assets/splash3.png",
    ),
    OnBoardingData(
      title: "¡No te quedes igual, queremos un mundo mejor!",
      desc:
          "Suena a anuncio de televisión, pero ¡co** es lo que queremos en nuestro plato!",
      imageAssetsPath: "assets/splash4.png",
    )
  ];

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final _deviceHeight = SizeConfig.screenHeight;
    final _deviceWidth = SizeConfig.screenWidth;
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mystyle.primarycolo,
        body: PageView.builder(
            controller: controller,
            // physics: NeverScrollableScrollPhysics(),
            onPageChanged: (val) {
              setState(() {
                currentIndex = val;
              });
            },
            itemCount: onBoardingData.length,
            itemBuilder: (ctx, index) => Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setHeight(100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: _deviceHeight * 0.2,
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              '${onBoardingData[index].imageAssetsPath}'),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(100),
                      ),
                      Text(
                        '${onBoardingData[index].title}',
                        style: Mystyle.titleTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(50),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(100),
                        ),
                        height: ScreenUtil().setHeight(250),
                        alignment: Alignment.topCenter,
                        child: Text(
                          '${onBoardingData[index].desc}',
                          style: Mystyle.regularTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(450),
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: List.generate(4, (index) {
                      return Container(
                        height: 12,
                        width: 12,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: index == currentIndex
                              ? Mystyle.secondrycolo
                              : Colors.white,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(100),
              ),
              GestureDetector(
                onTap: () {
                  // if (currentIndex == 3) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Login();
                      },
                    ),
                  );
                  // } else {
                  //   print("after then :" + currentIndex.toString());
                  //   controller
                  //       .animateToPage(
                  //     currentIndex + 1,
                  //     duration: Duration(seconds: 1),
                  //     curve: Curves.ease,
                  //   )
                  //       .then((_) {
                  //     print("after then :" + currentIndex.toString());
                  //   });
                  // }
                },
                child: Container(
                  height: ScreenUtil().setHeight(120),
                  width: _deviceWidth - ScreenUtil().setWidth(400),
                  decoration: Mystyle.cadredec(),
                  child: Center(
                    child: Text(
                      currentIndex == 3 ? "Empezar" : 'Skip',
                      style: Mystyle.subtitleTextStyle,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: _deviceHeight * 0.02,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     // Navigator.pushNamed(context, LoginScreen.nameRoute);
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(
              //         builder: (BuildContext context) {
              //           // return LoginScreen();
              //         },
              //       ),
              //     );
              //   },
              //   child: Container(
              //     height: ScreenUtil().setHeight(130),
              //     width: _deviceWidth - ScreenUtil().setWidth(200),
              //     decoration: BoxDecoration(color: Colors.white),
              //     child: Center(
              //       child: Text(
              //         '${onBoardingData[currentIndex].secondContainer}',
              //         style: TextStyle(
              //             fontSize: ScreenUtil().setSp(48),
              //             fontWeight: FontWeight.normal,
              //             color: Colors.grey),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class OnBoardingData with ChangeNotifier {
  String imageAssetsPath;
  String title;
  String desc;
  String firstContainer;
  String secondContainer;

  OnBoardingData(
      {this.title,
      this.desc,
      this.firstContainer,
      this.imageAssetsPath,
      this.secondContainer});
}
