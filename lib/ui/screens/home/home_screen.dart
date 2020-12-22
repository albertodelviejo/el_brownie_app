import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/bloc/orderByModel.dart';
import 'package:el_brownie_app/model/categoryModel.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/screens/home/todos_screen.dart';
import 'package:el_brownie_app/ui/screens/notifications/notifications_screen.dart';
import 'package:el_brownie_app/ui/utils/category.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/orderBy.dart';
import 'package:el_brownie_app/ui/utils/popup.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import 'cerca_screen.dart';

class HomeScreen extends StatefulWidget {
  bool isFirstTime;
  HomeScreen({this.isFirstTime});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  String currentCategory = '';
  //List<String> selectedCategories = [];
  String orderPer = '';
  UserBloc userBloc;

  List<CategoryModel> categories = [
    CategoryModel("Veggies", "assets/svg/brocoli.svg", false),
    CategoryModel("Oriental", "assets/svg/sushi.svg", false),
    CategoryModel("Occidental", "assets/svg/occidental.svg", false),
    CategoryModel("Hipster", "assets/svg/hipster.svg", false),
    CategoryModel("Lujo", "assets/svg/lujo.svg", false),
    CategoryModel("De barrio", "assets/svg/barrio.svg", false),
    CategoryModel("Pub musical", "assets/svg/pub.svg", false),
    CategoryModel("Comida rápida", "assets/svg/fastfood.svg", false),
    CategoryModel("Fusión", "assets/svg/fusion.svg", false),
  ];

  List<OrderBy> orderByList = [
    OrderBy("Cerca de mi", "assets/svg/send.svg", false),
    OrderBy("Más Warros!", "assets/svg/brocoli.svg", false),
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    userBloc = BlocProvider.of(context);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (userBloc.user.hasRequestedNotification) {
        userBloc.user.hasRequestedNotification = false;
        userBloc.setNoRequestNotifications(userBloc.user.uid);
        addRequestNotification();
      }
    });
    if (userBloc.user.uid == null) {
      userBloc.user = UserModel(uid: userBloc.currentUser.uid);
    }

    return getUserfromDB(userBloc.user.uid);
  }

  Widget homeScreen() {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
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
                    icon: (userBloc.user.hasNotifications)
                        ? SvgPicture.asset(
                            "assets/svg/notification.svg",
                            height: 28,
                            width: 28,
                          )
                        : Icon(
                            Icons.notifications_none,
                            color: Colors.black,
                            size: 28,
                          )),
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
                              todos_search_text,
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
                                // FocusScope.of(context)
                                //     .requestFocus(FocusNode());
                                // Your codes...
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return modal(() {
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      });
                                    },
                                    isScrollControlled: true);
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Mystyle.secondrycolo,
                      ),
                      tabs: [
                        Tab(text: 'Todos'),
                        // Tab(text: 'Los más Warros!'),
                        Tab(text: 'Cerca de mi'),
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
                  orderPer: orderPer,
                  isFirstTime: widget.isFirstTime),
              //LosMasScreen(),
              CercaScreen(),
            ],
          ),
        ),
      ),
    );
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
                points: element.get("points"),
                hasNotifications: element.get("hasNotifications"),
                hasRequestedNotification:
                    element.get("hasRequestedNotification"));
            Stream.empty();
          }
          return homeScreen();
        });
  }

  modal(Function onPressed) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
      return Container(
        color: Color(0xFF737373),
        // height: 1000,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
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
                child: Container(
                  height: ScreenUtil().setWidth(180),
                  child: GridView.builder(
                    itemCount: orderByList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 40,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return OrderByUi(
                        title: orderByList[index].orderBy,
                        image: orderByList[index].image,
                        selected: orderByList[index].isChecked,
                        onOrderByPressed: () {
                          if (orderByList[index].isChecked) {
                            setModalState(() {
                              orderByList[index].isChecked = false;
                              orderPer = '';
                            });
                          } else {
                            setModalState(() {
                              orderByList.forEach(
                                  (orderBy) => orderBy.isChecked = false);
                              orderByList[index].isChecked = true;
                              orderPer = orderByList[index].orderBy;
                              categories.forEach((element) {
                                if (element.isChecked) {
                                  currentCategory = element.category;
                                }
                              });
                            });
                          }
                        },
                      );
                    },
                  ),
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
                        crossAxisSpacing: 40,
                        mainAxisSpacing: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return Category(
                        title: categories[index].category,
                        image: categories[index].image,
                        selected: categories[index].isChecked,
                        onCategoryPressed: () {
                          if (categories[index].isChecked) {
                            setModalState(() {
                              categories[index].isChecked = false;
                              currentCategory = '';
                            });
                          } else {
                            setModalState(() {
                              categories.forEach(
                                  (category) => category.isChecked = false);
                              categories[index].isChecked = true;
                              currentCategory = categories[index].category;
                              orderByList.forEach((element) {
                                if (element.isChecked) {
                                  orderPer = element.orderBy;
                                }
                              });
                            });
                          }
                        },
                      );
                    },
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
              ),
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
                          onPressed: () {
                            setModalState(() {
                              categories.forEach(
                                  (category) => category.isChecked = false);
                              currentCategory = '';
                              orderByList.forEach(
                                  (element) => element.isChecked = false);
                              orderPer = '';
                            });

                            setState(() {
                              Navigator.pop(context);
                            });
                          },
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
                          onPressed: onPressed,
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
    });
  }

  Widget addRequestNotification() {
    PopUp popUp = PopUp(type: "reclamation");
    return popUp.report(context);
  }
}
