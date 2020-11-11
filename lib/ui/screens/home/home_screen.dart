import 'package:el_brownie_app/model/categoryModel.dart';
import 'package:el_brownie_app/repository/google_maps_api.dart';
import 'package:el_brownie_app/ui/screens/home/losmas_screen.dart';
import 'package:el_brownie_app/ui/screens/home/todos_screen.dart';
import 'package:el_brownie_app/ui/screens/notifications/notifications_screen.dart';
import 'package:el_brownie_app/ui/utils/category.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  String currentCategory = '';
  String orderPer = '';

  bool orderCercaSelected = false;
  bool orderMasSelected = false;

  List<CategoryModel> categories = [
    CategoryModel("Veggies", "assets/svg/brocoli.svg", false),
    CategoryModel("Oriental", "assets/svg/sushi.svg", false),
    CategoryModel("Occidental", "assets/svg/occidental.svg", false),
    CategoryModel("Hipster", "assets/svg/hipster.svg", false),
    CategoryModel("Lujo", "assets/svg/lujo.svg", false),
    CategoryModel("De barrio", "assets/svg/barrio.svg", false),
    CategoryModel("Pub musical", "assets/svg/pub.svg", false),
    CategoryModel("Fast Food", "assets/svg/sushi.svg", false),
    CategoryModel("Fusión", "assets/svg/fusion.svg", false),
  ];

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
                            onChanged: (value) {
                              setState(() {
                                searchController.text = value;
                              });
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
              TodosScreen(
                  search: searchController.text,
                  category: currentCategory,
                  orderPer: orderPer),
              LosMasScreen(),
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
                        onTap: () {
                          if (orderPer == '') {
                            setState(() {
                              orderPer = orderOption1;
                              orderCercaSelected = true;
                            });
                          } else {
                            setState(() {
                              orderPer = '';
                              orderCercaSelected = false;
                            });
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: ScreenUtil().setWidth(80),
                          width: ScreenUtil().setWidth(80),
                          child: SvgPicture.asset(
                            "assets/svg/send.svg",
                            color : orderCercaSelected==true ? Color(0xFF25bbee) : Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        "Cerca a mi",
                        style: Mystyle.smallTextStyle
                            .copyWith(color: orderCercaSelected==true ? Color(0xFF25bbee) : Colors.black87,),
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
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
              child: Container(
                height: ScreenUtil().setWidth(750),
                child: GridView.builder(
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 50,
                      mainAxisSpacing: 10),
                  itemBuilder: (BuildContext context, int index) {
                    return Category(
                      title: categories[index].category,
                      image: categories[index].image,
                      selected: categories[index].isChecked,
                      onCategoryPressed: () {
                        if (categories[index].isChecked) {
                          setState(() {
                            categories[index].isChecked = false;
                            currentCategory = '';
                          });
                        } else {
                          setState(() {
                            categories.forEach(
                                (category) => category.isChecked = false);
                            categories[index].isChecked = true;
                            currentCategory = categories[index].category;
                          });
                        }
                        Navigator.pop(context);
                      },
                    );
                  },
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 17),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Expanded(
            //         child: Container(
            //           height: ScreenUtil().setHeight(120),
            //           child: RaisedButton(
            //             child: Text(
            //               "Eliminar todos",
            //               style: Mystyle.normalTextStyle
            //                   .copyWith(fontWeight: FontWeight.w600),
            //             ),
            //             textColor: Colors.black,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(50),
            //               side: BorderSide(color: Colors.black),
            //             ),
            //             color: Colors.white,
            //             splashColor: Colors.black87,
            //             highlightColor: Colors.black87,
            //             onPressed: () {},
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 10),
            //       Expanded(
            //         child: Container(
            //           height: ScreenUtil().setHeight(120),
            //           child: RaisedButton(
            //             child: Text(
            //               "Aplicar",
            //               style: Mystyle.normalTextStyle
            //                   .copyWith(fontWeight: FontWeight.w600),
            //             ),
            //             textColor: Colors.black,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(50),
            //               side: BorderSide(color: Colors.black),
            //             ),
            //             color: Colors.white,
            //             splashColor: Colors.black87,
            //             highlightColor: Colors.black87,
            //             onPressed: () {},
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: ScreenUtil().setHeight(50)),
          ],
        ),
      ),
    );
  }
}
