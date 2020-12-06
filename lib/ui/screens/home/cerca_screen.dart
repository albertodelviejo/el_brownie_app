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
  bool noresult = false;
  List<CardHome> finalPosts;

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

  Future<List<CardHome>> filterPosts(List<CardHome> posts) async {
    //enable billing
    //List<CardHome> filteredPosts;
    return await GoogleMapsApi().getNearbyPlaces(posts).then((value) => value);
  }

  Widget cercaScreen(List<CardHome> allPosts) {
    List<CardHome> posts;
    if (widget.finalPosts == null) {
      filterPosts(allPosts).then((value) {
        setState(() {
          widget.finalPosts = value;
          ScreenUtil.init(context);
          (widget.finalPosts.length == 0)
              ? widget.noresult = true
              : widget.noresult = false;
        });
      });
    }

    return widget.finalPosts == null
        ? Center(child: CircularProgressIndicator())
        : ListView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            children: <Widget>[
              widget.noresult
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
                          itemBuilder: (_, int index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: widget.finalPosts[index],
                          ),
                          itemCount: widget.finalPosts.length,
                        ),
                        SizedBox(height: ScreenUtil().setHeight(100)),
                      ],
                    ),
            ],
          );
  }
}
