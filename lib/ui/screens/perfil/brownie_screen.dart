import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class MiBrownieScreen extends StatefulWidget {
  @override
  _MiBrownieScreenState createState() => _MiBrownieScreenState();
}

class _MiBrownieScreenState extends State<MiBrownieScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _value = 12;
  bool noresult = false;
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    userBloc = BlocProvider.of(context);
    return getMisBrownies();
  }

  Widget getMisBrownies() {
    return StreamBuilder(
        stream: userBloc.myBrowniesListStream(userBloc.currentUser.uid),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return misBrownies(
                  userBloc.buildMyBrownies(snapshot.data.documents));

            case ConnectionState.active:
              return misBrownies(
                  userBloc.buildMyBrownies(snapshot.data.documents));

            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            default:
              return misBrownies(
                  userBloc.buildMyBrownies(snapshot.data.documents));
          }
        });
  }

  Widget misBrownies(List<CardHome> listaBrownies) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: [
            SizedBox(height: ScreenUtil().setHeight(60)),
            Text(
              "Mis Brownies",
              style: Mystyle.titleTextStyle.copyWith(
                fontSize: ScreenUtil().setSp(100),
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "B-r-a-v-o!. Aquí están tus locales. Ahora a por tu recompensa!!!!",
                style: Mystyle.regularTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(40)),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 25),
              scrollDirection: Axis.vertical,
              reverse: false,
              itemBuilder: (_, int index) => listaBrownies[index],
              itemCount: listaBrownies.length,
            ),
            SizedBox(height: ScreenUtil().setHeight(100)),
          ],
        ),
      ),
    );
  }
}