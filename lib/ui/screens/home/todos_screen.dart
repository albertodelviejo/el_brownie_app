
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/repository/admob_api.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/noresutlt.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class TodosScreen extends StatefulWidget {
  final String search;
  final String category;
  final String orderPer;

  const TodosScreen({Key key, this.search, this.category, this.orderPer}) : super(key: key);
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
    return getUserfromDB(userBloc.user.uid);
  }

  Widget getUserfromDB(uid) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          UserBloc userBloc = BlocProvider.of(context);
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            DocumentSnapshot element = snapshot.data.documents[0];
            userBloc.user = UserModel(
                email: element.get("email"),
                uid: element.get("uid"),
                userName: element.get("username"),
                avatarURL: element.get("avatar_url"),
                points: element.get("points"));
            Stream.empty();
            return getPostsfromDB();
          }
        });
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

  filterPosts(List<CardHome> posts) {
    List<CardHome> filteredPosts = posts;
    if(widget.search != '') {
      posts.removeWhere((post) => !post.name.contains(widget.search));
    }
    if(widget.category != '') {
      posts.removeWhere((post) => !post.category.contains(widget.category));
    }
    if(widget.orderPer == orderOption1) {
      //enable billing
      // GoogleMapsApi().getNearbyPlcaes(filteredPosts);
    }
    return filteredPosts;
  }

  Widget todosScreen(List<CardHome> allPosts) {
    ScreenUtil.init(context);
    bool noresult = false;
    List<CardHome> posts = filterPosts(allPosts);
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24),
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
                  AdmobBanner(
                    adUnitId: admobService.getBannerAdId(),
                    adSize: AdmobBannerSize.FULL_BANNER,
                  ),
                  FlatButton(
                    color: Colors.blue,
                    onPressed: () async {
                      if (await interstitialAd.isLoaded) {
                        interstitialAd.show();
                      } else {
                        print('Interstitial ad is still loading...');
                      }
                    },
                    child: Text('Click me to see ads'),
                  ),
                  FlatButton(
                    color: Colors.blue,
                    onPressed: () async {
                      if (await rewardAd.isLoaded) {
                        rewardAd.show();
                      } else {
                        print('reward video Ad is still loading...');
                      }
                    },
                    child: Text('Click me to see video ads'),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 25),
                    scrollDirection: Axis.vertical,
                    reverse: false,
                    itemBuilder: (_, int index) => posts[index],
                    itemCount: posts.length,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(100)),
                ],
              ),
      ],
    );
  }
}
