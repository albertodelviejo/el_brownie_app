import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class NotificationsScreen extends StatefulWidget {
  int valoration = 0;
  String idPost;
  bool tapped = false;

  NotificationsScreen({Key key, this.idPost});
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    userBloc = BlocProvider.of(context);
    return getNotificationsfromDB();
  }

  Widget getNotificationsfromDB() {
    return StreamBuilder(
        stream: userBloc.notificationsListStream(),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return notificationScreen(
                  userBloc.buildNotifications(snapshot.data.documents));

            case ConnectionState.active:
              return notificationScreen(
                  userBloc.buildNotifications(snapshot.data.documents));

            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            default:
              return notificationScreen(
                  userBloc.buildNotifications(snapshot.data.documents));
          }
        });
  }

  Widget notificationScreen(List list) {
    if (list.length == 0) userBloc.setNoNotifications(userBloc.user.uid);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
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
              child: Icon(
                Icons.notifications_none,
                color: Colors.black,
                size: 28,
              ),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: [
            SizedBox(height: ScreenUtil().setHeight(30)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                notification_screen_title,
                style: Mystyle.titleTextStyle.copyWith(
                  fontSize: ScreenUtil().setSp(100),
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                notification_screen_subtitle,
                textAlign: TextAlign.center,
                style: Mystyle.regularTextStyle,
              ),
            ),
            (list.length == 0)
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      child: Column(children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 70,
                              width: 70,
                              child: SvgPicture.asset("assets/svg/chat.svg"),
                            ),
                          ),
                        ),
                        Text(
                          notification_screen_empty,
                          textAlign: TextAlign.center,
                          style: Mystyle.regularGrayTextStyle,
                        ),
                        Text(
                          notification_screen_no_message,
                          textAlign: TextAlign.center,
                          style: Mystyle.regularGrayTextStyle,
                        ),
                      ]),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 25),
                    scrollDirection: Axis.vertical,
                    reverse: false,
                    itemBuilder: (_, int index) => list[index],
                    itemCount: list.length,
                  ),
          ],
        ),
      ),
    );
  }
}
