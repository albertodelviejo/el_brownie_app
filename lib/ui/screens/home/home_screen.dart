import 'package:el_brownie_app/ui/screens/home/todos_screen.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                child: Icon(
                  Icons.notifications_none,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(ScreenUtil().setHeight(300)),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Mystyle.secondrycolo,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      height: ScreenUtil().setHeight(170),
                      child: Stack(
                        // alignment: Alignment.centerRight,
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: Mystyle.inputSearch(
                              'Search',
                              icon2: IconButton(
                                  icon: Icon(Icons.search), onPressed: null),
                            ),
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value.isEmpty) return 'isEmpty';
                              return null;
                            },
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: IconButton(
                              icon: Icon(
                                Icons.tune,
                              ),
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                // Your codes...
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return modal();
                                  },
                                  isScrollControlled: true,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      indicatorColor: Mystyle.secondrycolo,
                      labelColor: Mystyle.secondrycolo,
                      indicatorWeight: 4,
                      unselectedLabelColor: Colors.black87.withOpacity(.5),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Mystyle.secondrycolo,
                      ),
                      tabs: [
                        Tab(text: 'Todos'),
                        Tab(text: 'Los más Warros!'),
                        Tab(text: 'Cerca a mi'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            // controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              TodosScreen(),
              Container(),
              Container(),
            ],
          ),
        ),
      ),
    );
  }

  modal() {
    return Container(
      color: Color(0xFF737373),
      // height: 1000,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Ordenar por",
              style: Mystyle.titleTextStyle.copyWith(
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ScreenUtil().setHeight(40)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: ScreenUtil().setWidth(80),
                          width: ScreenUtil().setWidth(80),
                          child: SvgPicture.asset(
                            "assets/svg/send.svg",
                            // color: Colors.red,
                          ),
                        ),
                      ),
                      Text(
                        "Cerca a mi",
                        style: Mystyle.smallTextStyle
                            .copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: ScreenUtil().setWidth(80),
                          width: ScreenUtil().setWidth(80),
                          child: SvgPicture.asset(
                            "assets/svg/brocoli.svg",
                            // color: Colors.red,
                          ),
                        ),
                      ),
                      Text(
                        "Más Warros!",
                        style: Mystyle.smallTextStyle
                            .copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Container(
                    width: ScreenUtil().setHeight(180),
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(40)),
            Text(
              "Categorías",
              style: Mystyle.titleTextStyle.copyWith(
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ScreenUtil().setHeight(40)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: ScreenUtil().setWidth(80),
                          width: ScreenUtil().setWidth(80),
                          child: SvgPicture.asset(
                            "assets/svg/brocoli.svg",
                            // color: Colors.red,
                          ),
                        ),
                      ),
                      Text(
                        "Veggies",
                        style: Mystyle.smallTextStyle
                            .copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: ScreenUtil().setWidth(80),
                          width: ScreenUtil().setWidth(80),
                          child: SvgPicture.asset(
                            "assets/svg/sushi.svg",
                            // color: Colors.red,
                          ),
                        ),
                      ),
                      Text(
                        "Oriental",
                        style: Mystyle.smallTextStyle
                            .copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: ScreenUtil().setWidth(80),
                          width: ScreenUtil().setWidth(80),
                          child: SvgPicture.asset(
                            "assets/svg/occidental.svg",
                            // color: Colors.red,
                          ),
                        ),
                      ),
                      Text(
                        "Occidental",
                        style: Mystyle.smallTextStyle
                            .copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(100)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: ScreenUtil().setWidth(80),
                          width: ScreenUtil().setWidth(80),
                          child: SvgPicture.asset(
                            "assets/svg/hipster.svg",
                            // color: Colors.red,
                          ),
                        ),
                      ),
                      Text(
                        "Hipster",
                        style: Mystyle.smallTextStyle
                            .copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: ScreenUtil().setWidth(80),
                          width: ScreenUtil().setWidth(80),
                          child: SvgPicture.asset(
                            "assets/svg/lujo.svg",
                            // color: Colors.red,
                          ),
                        ),
                      ),
                      Text(
                        "Lujo",
                        style: Mystyle.smallTextStyle
                            .copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: ScreenUtil().setWidth(80),
                          width: ScreenUtil().setWidth(80),
                          child: SvgPicture.asset(
                            "assets/svg/barrio.svg",
                            // color: Colors.red,
                          ),
                        ),
                      ),
                      Text(
                        "De barrio",
                        style: Mystyle.smallTextStyle
                            .copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(100)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: ScreenUtil().setWidth(80),
                          width: ScreenUtil().setWidth(80),
                          child: SvgPicture.asset(
                            "assets/svg/pub.svg",
                            // color: Colors.red,
                          ),
                        ),
                      ),
                      Text(
                        "Pub musical",
                        style: Mystyle.smallTextStyle
                            .copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: ScreenUtil().setWidth(80),
                          width: ScreenUtil().setWidth(80),
                          child: SvgPicture.asset(
                            "assets/svg/sushi.svg",
                            // color: Colors.red,
                          ),
                        ),
                      ),
                      Text(
                        "Fast Food",
                        style: Mystyle.smallTextStyle
                            .copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: ScreenUtil().setWidth(80),
                          width: ScreenUtil().setWidth(80),
                          child: SvgPicture.asset(
                            "assets/svg/fusion.svg",
                            // color: Colors.red,
                          ),
                        ),
                      ),
                      Text(
                        "Fusión",
                        style: Mystyle.smallTextStyle
                            .copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(100)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      height: ScreenUtil().setHeight(120),
                      child: RaisedButton(
                        child: Text(
                          "Eliminar todos",
                          style: Mystyle.normalTextStyle
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        textColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Colors.black),
                        ),
                        color: Colors.white,
                        splashColor: Colors.black87,
                        highlightColor: Colors.black87,
                        onPressed: () {},
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: ScreenUtil().setHeight(120),
                      child: RaisedButton(
                        child: Text(
                          "Aplicar",
                          style: Mystyle.normalTextStyle
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        textColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Colors.black),
                        ),
                        color: Colors.white,
                        splashColor: Colors.black87,
                        highlightColor: Colors.black87,
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(50)),
          ],
        ),
      ),
    );
  }
}
