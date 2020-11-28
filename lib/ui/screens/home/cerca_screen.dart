import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/repository/google_maps_api.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/noresutlt.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class CercaScreen extends StatefulWidget {
  final String orderPer = "";

  @override
  _CercaScreenState createState() => _CercaScreenState();
}

class _CercaScreenState extends State<CercaScreen> {
  UserBloc userBloc;
  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
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
              return cercaScreen(
                  userBloc.buildMyPostsCardHome(snapshot.data.documents));

            case ConnectionState.active:
              return cercaScreen(
                  userBloc.buildMyPostsCardHome(snapshot.data.documents));

            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            default:
              return cercaScreen(
                  userBloc.buildMyPostsCardHome(snapshot.data.documents));
          }
        });
  }

  filterPosts(List<CardHome> posts) {
    List<CardHome> filteredPosts = posts;
    //enable billing
    GoogleMapsApi().getNearbyPlaces(filteredPosts);
    return filteredPosts;
  }

  Widget cercaScreen(List<CardHome> allPosts) {
    List<CardHome> posts = filterPosts(allPosts);

    ScreenUtil.init(context);
    bool noresult = false;
    (allPosts.length == 0) ? noresult = true : noresult = false;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      children: <Widget>[
        noresult
            ? NoResult()
            : Column(
                children: [
                  SizedBox(height: ScreenUtil().setHeight(40)),
                  Text(
                    "Cerca de mi",
                    style: Mystyle.titleTextStyle.copyWith(
                      fontSize: ScreenUtil().setSp(100),
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(20)),
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
