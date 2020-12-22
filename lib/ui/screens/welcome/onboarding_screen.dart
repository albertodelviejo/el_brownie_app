import 'package:el_brownie_app/ui/screens/auth/login_screen.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;
  List onBoardingData = [
    OnBoardingData(
      title: carrousel_title_0,
      desc: carrousel_text_0,
      imageAssetsPath: "assets/splash1.png",
    ),
    OnBoardingData(
      title: carrousel_title_1,
      desc: carrousel_text_1,
      imageAssetsPath: "assets/splash2.png",
    ),
    OnBoardingData(
      title: carrousel_title_2,
      desc: carrousel_text_2,
      imageAssetsPath: "assets/splash3.png",
    ),
    OnBoardingData(
      title: carrousel_title_3,
      desc: carrousel_text_3,
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
                        height: ScreenUtil().setHeight(350),
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
                child: Container(
                  height: ScreenUtil().setHeight(120),
                  width: _deviceWidth - ScreenUtil().setWidth(400),
                  decoration: Mystyle.cadredec(),
                  child: Center(
                    child: Text(
                      currentIndex == 3 ? carrousel_cta_3 : carrousel_cta_2,
                      style: Mystyle.subtitleTextStyle,
                    ),
                  ),
                ),
              ),
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
