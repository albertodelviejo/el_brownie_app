import 'package:admob_flutter/admob_flutter.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/repository/admob_api.dart';
import 'package:el_brownie_app/ui/screens/home/cerca_screen.dart';
import 'package:el_brownie_app/ui/screens/home/losmas_screen.dart';
import 'package:el_brownie_app/ui/utils/cardlosmas.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/noresutlt.dart';
import 'package:el_brownie_app/ui/utils/popup.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class TodosScreen extends StatefulWidget {
  final String search;

  final String category;

  final String orderPer;

  final bool isFirstTime;

  bool isAddShown = false;

  TodosScreen(
      {Key key, this.search, this.category, this.orderPer, this.isFirstTime})
      : super(key: key);
  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  UserBloc userBloc;

  final admobService = AdmobService();
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;

  @override
  void initState() {
    super.initState();
    //initialize intertitial ad
    interstitialAd = AdmobInterstitial(
      adUnitId: admobService.getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
    //initialize video ad
    rewardAd = AdmobReward(
      adUnitId: admobService.getRewardBasedVideoAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
      },
    );
    interstitialAd.load();
    rewardAd.load();
  }

  @override
  void dispose() {
    super.dispose();
    interstitialAd.dispose();
    rewardAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    if (userBloc.user.uid == null) {
      userBloc.user = UserModel(uid: userBloc.currentUser.uid);
    }

    return (widget.orderPer == orderOption2)
        ? getPostsfromDBmas()
        : getPostsfromDB();
  }

  Widget getPostsfromDB() {
    return StreamBuilder(
        stream: userBloc.myPostsListStream(),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());

            case ConnectionState.done:
              return todosScreen(
                  userBloc.buildMyPosts(snapshot.data.documents));

            case ConnectionState.active:
              return todosScreen(
                  userBloc.buildMyPosts(snapshot.data.documents));

            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());

            default:
              return todosScreen(
                  userBloc.buildMyPosts(snapshot.data.documents));
          }
        });
  }

  Widget getPostsfromDBmas() {
    return StreamBuilder(
        stream: userBloc.myMostPostsListStream(),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return todosScreen(
                  userBloc.buildMyMostPosts(snapshot.data.documents));
            case ConnectionState.active:
              return todosScreen(
                  userBloc.buildMyMostPosts(snapshot.data.documents));
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            default:
              return todosScreen(
                  userBloc.buildMyMostPosts(snapshot.data.documents));
          }
        });
  }

  filterPosts(List<CardLosmas> posts) {
    List<CardLosmas> filteredPosts = posts;
    if (widget.search != '') {
      posts.removeWhere((post) =>
          !post.name.toLowerCase().contains(widget.search.toLowerCase()));
    }
    if (widget.category != '') {
      posts.removeWhere((post) => !post.category.contains(widget.category));
    }
    if (widget.orderPer == orderOption1) {
      //return CercaScreen(); //register

    }
    if (widget.orderPer == orderOption2) {
      /*
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return LosMasScreen(); //register
          },
        ),
      );
      */
    }
    return filteredPosts;
  }

  Widget todosScreen(List<CardLosmas> allPosts) {
    ScreenUtil.init(context);
    bool noresult = false;
    int finalLength = 0;
    int sumaOno = 0;

    List<dynamic> posts = filterPosts(allPosts);
    (posts.length == 0) ? noresult = true : noresult = false;
    (posts.length % 4) >= 0.5 ? sumaOno = 1 : sumaOno = 0;
    finalLength = posts.length + (posts.length ~/ 4) + sumaOno;
    return (widget.orderPer == orderOption1)
        ? CercaScreen(currentCategory: widget.category)
        : Container(
            width: ScreenUtil().scaleWidth,
            height: ScreenUtil().screenHeight,
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 2),
              children: <Widget>[
                noresult
                    ? NoResult()
                    : Column(
                        children: [
                          SizedBox(height: ScreenUtil().setHeight(40)),
                          Text(
                            todos_title,
                            style: Mystyle.titleTextStyle.copyWith(
                              fontSize: ScreenUtil().setSp(90),
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(20)),
                          GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
<<<<<<< HEAD
                                childAspectRatio: (57 / 100),
=======
                                childAspectRatio: (54 / 100),
>>>>>>> reportFunctions
                                crossAxisSpacing: ScreenUtil().setHeight(30),
                                mainAxisSpacing: ScreenUtil().setHeight(30),
                              ),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (_, int index) {
                                return posts[index];
                              },
                              itemCount: posts.length),
                          SizedBox(height: ScreenUtil().setHeight(100)),
                        ],
                      ),
              ],
            ),
          );
  }

  Widget welcomeNotification() {
    PopUp popUp = PopUp(type: "welcome");
    return popUp.report(context);
  }
}
