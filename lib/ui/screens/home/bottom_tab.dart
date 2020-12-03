import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:el_brownie_app/ui/screens/add/add_post_screen.dart';
import 'package:el_brownie_app/ui/screens/fav/fav_screen.dart';
import 'package:el_brownie_app/ui/screens/perfil/profile_home_screen.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:el_brownie_app/ui/utils/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import 'home_screen.dart';

class BottomTabBarr extends StatefulWidget {
  Widget widgetoutside;
  bool isFirstTime;
  bool isFirstTimeAdded;
  bool isRequested;
  BottomTabBarr(
      {this.widgetoutside,
      this.isFirstTime = false,
      this.isFirstTimeAdded = false,
      this.isRequested = false});

  @override
  _BottomTabBarrState createState() => _BottomTabBarrState();
}

class _BottomTabBarrState extends State<BottomTabBarr> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List _widgetOptions = [
    HomeScreen(),
    AddCommentScreen(),
    FavScreen(),
    ProfileHomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of(context);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.isFirstTime) {
        welcomeNotification();
      }
      if (widget.isFirstTimeAdded) {
        widget.isFirstTimeAdded = false;
        addPostNotification();
      }
    });
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            widget.widgetoutside ?? _widgetOptions.elementAt(_selectedIndex),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 30,
          backgroundColor: Mystyle.primarycolo,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black38,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text('Buscar'),
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              title: Text('Añadir'),
              icon: Icon(Icons.add_circle_outline),
            ),
            BottomNavigationBarItem(
              title: Text('Favoritos'),
              icon: Icon(Icons.bookmark_border),
            ),
            BottomNavigationBarItem(
              title: Text('Perfil'),
              icon: Icon(Icons.person_outline),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget welcomeNotification() {
    PopUp popUp = PopUp(type: "welcome");
    widget.isFirstTime = false;
    return popUp.report(context);
  }

  Widget addPostNotification() {
    PopUp popUp = PopUp(type: "added");
    return popUp.report(context);
  }
}
