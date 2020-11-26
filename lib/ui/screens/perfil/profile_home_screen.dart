import 'package:el_brownie_app/ui/screens/notifications/notifications_screen.dart';
import 'package:el_brownie_app/ui/screens/perfil/brownie_screen.dart';
import 'package:el_brownie_app/ui/screens/perfil/profile_screen.dart';
import 'package:el_brownie_app/ui/screens/perfil/ranking_screen.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileHomeScreen extends StatefulWidget {
  @override
  _ProfileHomeScreenState createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Mystyle.primarycolo,
            elevation: 0,
            title: Container(
              width: ScreenUtil().setHeight(500),
              child: Image.asset("assets/appblogo.png"),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return NotificationsScreen(); //register
                      },
                    ),
                  ),
                  icon: Icon(
                    Icons.notifications_none,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(ScreenUtil().setHeight(130)),
              child: Container(
                color: Colors.white,
                child: TabBar(
                  indicatorColor: Mystyle.secondrycolo,
                  labelColor: Mystyle.secondrycolo,
                  indicatorWeight: 4,
                  unselectedLabelColor: Colors.black87.withOpacity(.5),
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Mystyle.secondrycolo,
                  ),
                  tabs: [
                    Tab(text: 'Mi perfil'),
                    Tab(text: 'Mis brownies'),
                    Tab(text: 'Ranking'),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              ProfileScreen(),
              MiBrownieScreen(),
              RankingScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
