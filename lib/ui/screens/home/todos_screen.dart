import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/repository/admob_api.dart';
import 'package:el_brownie_app/ui/utils/cardlosmas.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/noresutlt.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class TodosScreen extends StatefulWidget {
  final String search;

  final List<String> categories;

  final String orderPer;

  const TodosScreen({Key key, this.search, this.categories, this.orderPer})
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
    return getPostsfromDB();
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

  filterPosts(List<CardLosmas> posts) {
    List<CardLosmas> filteredPosts = posts;
    if (widget.search != '') {
      posts.removeWhere((post) => !post.name.contains(widget.search));
    }
    if (!widget.categories.isEmpty) {
      widget.categories.forEach((element) {
        posts.removeWhere((post) => !post.category.contains(element));
      });
    }
    if (widget.orderPer == orderOption1) {
      //enable billing
      // GoogleMapsApi().getNearbyPlcaes(filteredPosts);
    }
    return filteredPosts;
  }

  Widget todosScreen(List<CardLosmas> allPosts) {
    ScreenUtil.init(context);
    bool noresult = false;

    List<dynamic> posts = filterPosts(allPosts);
    return Container(
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
                      "Todos los Brownies",
                      style: Mystyle.titleTextStyle.copyWith(
                        fontSize: ScreenUtil().setSp(100),
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    /** 
                    AdmobBanner(
                      adUnitId: admobService.getBannerAdId(),
                      adSize: AdmobBannerSize.FULL_BANNER,
                    ),
                    */
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: .6,
                        crossAxisSpacing: ScreenUtil().setHeight(30),
                        mainAxisSpacing: ScreenUtil().setHeight(60),
                      ),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (_, int index) {
                        return (index % 4 == 3)
                            ? CardLosmas(isAdd: true)
                            : posts[index];
                      },
                      itemCount: posts.length,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(100)),
                  ],
                ),
        ],
      ),
    );
  }
}
